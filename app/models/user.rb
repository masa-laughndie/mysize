class User < ApplicationRecord
  extend Search

  attr_accessor :validate_name, :validate_password, :validate_shoesize,
                :remember_token, :reset_token
  
  search_fields :name, :mysize_id, :content, size_field: :size

  before_save :downcase_email
  before_save :downcase_mysizeid

  has_many :kicksposts, dependent: :destroy
  has_many :comments,   dependent: :destroy
  has_many :notices,    dependent: :destroy

  has_many :active_relationships,  class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy
  has_many :following,             through: :active_relationships,
                                   source: :followed

  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers,             through: :passive_relationships,
                                   source: :follower

  #active_goods = goods
  has_many :active_goods,          class_name: "Good",
                                   foreign_key: "gooder_id",
                                   dependent: :destroy
  has_many :goodings,              through: :active_goods,
                                   source: :gooded

  has_many :passive_goods,         class_name: "Good",
                                   foreign_key: "gooded_id",
                                   dependent: :destroy
  has_many :gooders,               through: :passive_goods,
                                   source: :gooder

  has_many :good_posts,            class_name: "Kickspost",
                                   through:   :goods,
                                   source: :post,
                                   source_type: "Kickspost"
  has_many :good_comments,         class_name: "Comment",
                                   through:   :goods,
                                   source: :post,
                                   source_type: "Comment"

  mount_uploader :image, ImageUploader

  validates :name, presence: { message: "名前を入力してください",
                               if: :validate_name? },
                   length:   { maximum: 50,
                               message: "名前は50文字以内まで有効です",
                               allow_blank: true }

  VALID_MYSIZE_ID_REGIX = /\A[a-zA-Z0-9_]+\z/
  validates :mysize_id, presence:   { message: "MysizeIDを入力してください" },
                        length:     { maximum: 15,
                                      message: "MysizeIDは15文字以内まで有効です" },
                        format:     { with: VALID_MYSIZE_ID_REGIX,
                                      message: "MysizeIDは英数字,_(アンダーバー)のみ使用できます",
                                      allow_blank: true },
                        uniqueness: { case_sensitive: false,
                                      message: "そのMysizeIDは既に使われています" }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   { message: "メールアドレスを入力してください" },
                    length:     { maximum: 255,
                                  message: "メールアドレスは255文字以内まで有効です" },
                    format:     { with: VALID_EMAIL_REGEX,
                                  message: "そのメールアドレスは不正な値を含んでいます",
                                  allow_blank: true },
                    uniqueness: { case_sensitive: false,
                                  message: "そのメールアドレスは既に登録されています" }

  has_secure_password validations: false

  with_options if: :validate_password? do
    validates :password, presence:     { message: "Passwordを入力してください" },
                         length:       { minimum: 6,
                                         message: "Passwordは6文字以上で入力してください",
                                         allow_blank: true },
                         confirmation: { message: "PasswordとPassword確認が不一致です",
                                         allow_blank: true }
    validates :password_confirmation,  presence: { message: "Password確認を入力してください" }
  end

  validates :content, length: { maximum: 160,
                                massage: "プロフィールは160字以内で入力してください" }

  validates :size, presence: { message: "スニーカーのサイズを選択してください",
                               if: :validate_shoesize? }

  validate :image_size
  
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def new_reset_token
      SecureRandom.uuid
    end

    def find_or_create_from_auth(auth)
      provider  = auth[:provider]
      uid       = auth[:uid]
      name      = auth[:info][:name]
      mysizeid  = auth[:info][:nickname]
      email     = User.dummy_email(auth)
      image     = auth[:info][:image].sub("_normal", "")

      find_or_create_by(provider: provider, uid: uid) do |user|
        user.name  = name
        user.email = email
        user.remote_image_url = image
        user.size = 27.0
        user.mysize_id = user.set_mysize_id(mysizeid)
      end
    end

    def all_format_gon_params
      self.all.map do |user|
        map_gon_hah(user)
      end
    end

    def find_format_gon_params(ids)
      self.find(ids).map do |user|
        map_gon_hah(user)
      end
    end

    def find_format_gon_params_by(id)
      map_gon_hah(self.find_by(id: id))
    end

    private

    def extract_params_for_gon
      [:id, :name, :mysize_id, :image_url, :size, :content]
    end

    def map_gon_hah(user)
      return if user.blank?
      Hash[
        extract_params_for_gon.map do |ep|
          [ep, user.send(ep)]
        end
      ]
    end
  end

  def set_mysize_id(mysize_id)
    return mysize_id if User.find_by(mysize_id: mysize_id).nil?
    while true
      num = SecureRandom.urlsafe_base64(10)
      return num if User.find_by(mysize_id: num).nil?
    end
  end

  def to_param
    mysize_id
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #tokenがdigestと一致 => true
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def send_email(subject)
    mail = UserMailer.send("#{subject}", self)
    mail.transport_encoding = "8bit"
    mail.deliver_now
  end

  def create_reset_digest_and_e_token
    self.reset_token = User.new_reset_token
    update_columns(reset_digest: User.digest(reset_token),
                   e_token: User.digest(email),
                   reset_sent_at: Time.zone.now)
  end

  ["name", "shoesize", "password"].each do |param|
    class_eval <<-EOS
      def validate_#{param}?
        validate_#{param}.in?(['true', true])
      end
    EOS
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Kickspost.where("kicksposts.user_id IN (#{following_ids}) OR kicksposts.user_id = :user_id", user_id: id)
  end

  def password_reset_expired?
    return true if self.reset_sent_at.nil?
    reset_sent_at < 2.hours.ago
  end

  def follow(other)
    active_relationships.create(followed_id: other.id)
  end

  def unfollow(other)
    active_relationships.find_by(followed_id: other.id).destroy
  end

  def following?(other)
    following.include?(other)
  end

  def receive_notice_of(type, kind)
    notices.create(kind_type: type, kind_id: kind.id)
  end

  def lose_notice_of(type, kind)
    post_notices = self.notices.where(kind_type: type, kind_id: kind.id)
    post_notices.destroy_all if post_notices.any?
  end

  def create_or_update_follow_notice
    if notice = self.follow_notice_for(this_week)
      notice.add_unread_count!
    else
      self.create_follow_notice(follow_notice_kind_id)
    end
  end

  def follow_notice_for(period)
    notices.find_by(kind_type: "Follow", created_at: period)
  end

  def latest_follow_notice
    notices.where(kind_type: "Follow").first
  end

  def create_follow_notice(kind_id)
    notices.create(kind_type: "Follow", kind_id: kind_id)
  end

  #フォロー通知のチェックと削除
  def check_or_delete_follow_notice(period)
    return unless self.followed_while(period)
    if follow_notice = self.follow_notice_for(period)
      follow_notice.destroy
    end
  end

  def followed_while(period)
    self.passive_relationships.where(created_at: period).present?
  end

  def good(type, post)
    active_goods.create(post_type: type, post_id: post.id, gooded_id: post.user.id)
  end

  def ungood(type, post)
    active_goods.find_by(post_type: type, post_id: post.id).destroy
  end

  def good?(type, post)
    active_goods.where(post_type: type).pluck(:post_id).include?(post.id)
  end

  def delete_past_notices_already_read(notices)
    #[dev,test]1.day.ago => [production]10.weeks.ago
    deleteline = Time.new(2000,1,1)..10.weeks.ago
    notices.where(unread_count: 0, updated_at: deleteline).destroy_all
  end

  private

    def downcase_email
      email.downcase!
    end

    def downcase_mysizeid
      mysize_id.downcase!
    end

    def image_size
      error.add(:image, "画像サイズは最大5MBまで設定できます") if image.size > 5.megabytes
    end

    def self.dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end

    def this_week
      Time.zone.now.beginning_of_week..Time.zone.now.end_of_week
    end

    def follow_notice_kind_id
      latest_notice = self.latest_follow_notice
      latest_notice.present? ? latest_notice.kind_id + 1 : 1
    end

end

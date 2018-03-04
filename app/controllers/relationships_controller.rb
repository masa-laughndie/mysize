class RelationshipsController < ApplicationController

  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    @relation = current_user.follow(@user)

    #通知アクション
    @user.notice_from(params[:kind], @relation)
    @user.increment!(:notice_count, by = 1)
    @user.week_notice_list("follow_list", @relation)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @relation = Relationship.find(params[:id])
    @user = @relation.followed
    current_user.unfollow(@user)

    #通知アクション
    @user.notice_delete("follow", @relation)
    @user.week_notice_list_delete("follow", that_day(Time.zone.now))

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end

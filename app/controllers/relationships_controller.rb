class RelationshipsController < ApplicationController

  before_action :logged_in_user
  before_action :no_name

  def create
    @user = User.find(params[:followed_id])
    @relation = current_user.follow(@user)
=begin
    #通知アクション
    @user.create_or_update_follow_notice
=end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @relation = Relationship.find(params[:id])
    @user = @relation.followed
    #通知アクション
    # @user.notice_delete("follow", @relation)
    # @user.delete_follow_notice("follow_list", that_day(@relation.created_at))
    current_user.unfollow(@user)
    

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end

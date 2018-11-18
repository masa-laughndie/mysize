class RelationshipsController < ApplicationController

  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    relationship = current_user.follow(@user)

    @user.create_or_update_follow_notice

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
      format.json { render :json => relationship }
    end
  end

  def destroy
    @relation = Relationship.find(params[:id])
    @user = @relation.followed
    
    current_user.unfollow(@user)
    @user.check_or_delete_follow_notice(that_week(@relation.created_at))
    

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end

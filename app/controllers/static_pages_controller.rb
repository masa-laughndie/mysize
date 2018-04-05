class StaticPagesController < ApplicationController

  before_action :logged_in_user, only: :follow

  def home
    if logged_in?
      redirect_to latest_path
    end
  end

  def latest
    if logged_in?
      @user = current_user
    else
      @user = nil
    end
    @kicksposts = Kickspost.includes(:user, {comments: :user}, {goods: :gooder}).reorder(updated_at: :desc)
    @text = "short"
  end

  def follow
    if logged_in?
      @user = current_user
      @kicksposts = current_user.feed.includes(:user, {comments: :user}, {goods: :gooder}).reorder(updated_at: :desc)
      @text = "short"
    end
  end

  def help
  end

  def about
    if !logged_in? && params[:about].in?(['on1', 'on2', 'on3'])
      flash.now[:danger] = "ログインまたは登録をお願いします。"
    end
  end

  def terms
  end

  def privacy
  end

end

class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @kicksposts = current_user.feed
    end
  end

  def help
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def contact
  end
end

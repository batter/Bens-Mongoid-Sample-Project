class PagesController < ApplicationController
  def home
    @title = "Home"
    if user_signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.page(params[:page])
    end
  end

  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end
end

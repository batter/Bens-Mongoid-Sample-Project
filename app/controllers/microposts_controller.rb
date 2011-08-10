class MicropostsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end
  
  private

    def authorized_user
      # @micropost = current_user.microposts.where(:_id => params[:id]).first
      # redirect_to root_path if @micropost.nil?
      # We can just use the code below if we are comfortable with exceptions in ruby
      @micropost = current_user.microposts.find(params[:id])
    rescue
      redirect_to root_path
    end
end

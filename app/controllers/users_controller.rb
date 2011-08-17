class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :admin_user, :only => [:destroy, :edit, :update]
  
  # GET /users
  # GET /users.xml
  def index
    @title = "User List"
    @users = User.order_by([:created_at, :asc]).page(params[:page]) # Order by created at date

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @feed_items = @user.feed.page(params[:page])
    @title = @user.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  # GET /users/1/following
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end
  
  # GET /users/1/followers
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @title = "Edit #{@user.name}"
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    User.find(params[:id]).destroy

    respond_to do |format|
      flash[:success] = "User deleted."
      format.html { redirect_to(users_path) }
      # format.html { redirect_to(users_path, :notice => "User deleted.") }
      format.xml  { head :ok }
    end
  end
  
  private
  
    def admin_user # Method to ensure that a user is an admin
      redirect_to(root_path) unless current_user.admin?
    end
end

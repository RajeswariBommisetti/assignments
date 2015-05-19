class UsersController < ApplicationController
  require 'actionpack/action_caching'
  require 'actionpack/page_caching'
  before_filter :logged_in_user, only: [:index,:edit, :update, :destroy, :following, :following]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  caches_action :edit
  caches_page :index
    
  def new
    @user=User.new
   
  end

  def index
    @users= User.paginate(page: params[:page])
    
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    expire_page :action => :index
    if @user.save
      #@user.send_activation_email
              flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

   def edit
    @user = User.find(params[:id])
   end
   def update
     @user = User.find(params[:id])
     if @user.update_attributes(user_params)
     flash[:success]= "Profile updated"
     redirect_to @user
     else
       render 'edit'
     end
   end

   def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
   end

   def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end  
    end

    def correct_user
      @user =User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def admin_user
      redirect_to(root_url) unless current_user.admin?
  end
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  
    

end

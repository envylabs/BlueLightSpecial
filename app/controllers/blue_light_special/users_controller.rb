class BlueLightSpecial::UsersController < ApplicationController
  unloadable

  skip_before_filter :authenticate, :only => [:new, :create]
  before_filter :redirect_to_root,  :only => [:new, :create], :if => :signed_in?
  filter_parameter_logging :password

  def show
    @user = current_user
    render :template => 'users/show'
  end

  def new
    @user = ::User.new(params[:user])
    render :template => 'users/new'
  end

  def create
    @user = ::User.new params[:user]
    if @user.save
      sign_in(@user)
      redirect_to(url_after_create)
    else
      render :template => 'users/new'
    end
  end
  
  def edit
    @user = current_user
    render :template => 'users/edit'
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:success] = 'Your profile has been updated.'
      redirect_to user_path(@user)
    else
      render :template => 'users/edit'
    end
  end

  private

  def url_after_create
    root_url
  end
end

class BlueLightSpecial::SessionsController < ApplicationController
  unloadable

  skip_before_filter :authenticate, :only => [:new, :create, :destroy]
  protect_from_forgery :except => :create
  filter_parameter_logging :password

  def new
    render :template => 'sessions/new'
  end

  def create
    @user = if params[:session]
      ::User.authenticate(params[:session][:email], params[:session][:password])
    else
      ::User.find_facebook_user(cookies[BlueLightSpecial.configuration.facebook_api_key + "_session_key"],
                                cookies[BlueLightSpecial.configuration.facebook_api_key + "_user"])
    end
      
    if @user.nil?
      flash_failure_after_create
      render :template => 'sessions/new', :status => :unauthorized
    else
      sign_in(@user)
      flash_success_after_create
      redirect_back_or(url_after_create)
    end
  end

  def destroy
    cookies[BlueLightSpecial.configuration.facebook_api_key + "_user"] = nil
    cookies[BlueLightSpecial.configuration.facebook_api_key + "_session_key"] = nil
    sign_out
    flash_success_after_destroy
    redirect_to(url_after_destroy)
  end

  private

  def flash_failure_after_create
    flash.now[:failure] = translate(:bad_email_or_password,
      :scope   => [:blue_light_special, :controllers, :sessions],
      :default => "Bad email or password.")
  end

  def flash_success_after_create
    flash[:success] = translate(:signed_in, :default =>  "Signed in.")
  end

  def flash_notice_after_create
    flash[:notice] = translate(:unconfirmed_email,
      :scope   => [:blue_light_special, :controllers, :sessions],
      :default => "User has not confirmed email. " <<
                  "Confirmation email will be resent.")
  end

  def url_after_create
    '/'
  end

  def flash_success_after_destroy
    flash[:success] = translate(:signed_out, :default =>  "Signed out.")
  end

  def url_after_destroy
    sign_in_url
  end
end

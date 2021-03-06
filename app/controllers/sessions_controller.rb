class SessionsController < ApplicationController
  skip_before_action :authorize_user

  def new
    check_admin
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"],
                                         auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    flash[:success] = "Signed in!"
    if user.admin?
      redirect_to admin_slides_path
    else
      redirect_to new_slide_path
    end
  end


  def destroy
    session[:user_id] = nil
    flash[:success] = "Signed out!"
    redirect_to root_path
  end

  private
  def check_admin
    if current_user && current_user.admin?
      redirect_to admin_slides_path
    elsif current_user
      redirect_to new_slide_path
    end
  end
end

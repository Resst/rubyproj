class SessionsController < ApplicationController
  def new
  end

  def login

  end
  def logout
    sign_out
    redirect_to root_path(locale: I18n.locale)
  end
  def register
  end

  def new_user
    I18n.locale = params["locale"] || I18n.default_locale
    unless params.blank?
      user = User.find_by(email: params[:email].downcase)
      if !user
        User.create!(
          name: params[:name],
          email: params[:email],
          password: params[:password], # This will be automatically encrypted
          password_confirmation: params[:password_confirmation],
          )
        # Sign the user in and redirect to the user's show page.
        sign_in user
        redirect_to root_path
      else
        redirect_to signup_path(locale: I18n.locale), error: "user_exists"
      end
    end
  end
  def create

    I18n.locale = params["locale"] || I18n.default_locale

    unless params.blank?
      user = User.find_by(email: params[:email].downcase)
      if user && user.authenticate(params[:password])
        # Sign the user in and redirect to the user's show page.
        sign_in user
        redirect_to root_path
        print("Log in")
      else
          print("Login failed!")
        # Create an error message and re-render the signin form.
        flash.now[:alert] = 'Login failed. Invalid email/password
combination. Repeat'
          redirect_to signin_path(locale: I18n.locale), error: "login_failed"
      end
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end

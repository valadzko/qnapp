class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authenticate

  def facebook
  end

  def twitter
  end

  private

  def authenticate
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    elsif @user.email.blank?
      session['omniauth.data'] = {
        provider: auth.provider,
        uid: auth.uid.to_i,
        user_password: @user.password
      }
      render template: 'devise/registrations/email_required'
    end
  end
end

class UsersController < ApplicationController
  def require_email_for_auth
    auth = session['omniauth.data']

    @user = User.build_by_omniauth_params(params['user']['email'], auth)
    if @user.persisted? && !@user.email.blank?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Successfully authenticated from #{auth["provider"].capitalize} account."
    else
      redirect_to :new_user_registration
    end
  end
end

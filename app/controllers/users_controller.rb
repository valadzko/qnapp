class UsersController < ApplicationController
  def require_email_for_auth
    auth = session['devise.omiauth.auth']

    @user = User.build_by_omniauth_params(users_params['email'], auth)
    if @user.confirmed_at
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Successfully authenticated from #{auth["provider"].capitalize} account."
    else
      redirect_to :new_user_registration
    end
  end

  private

  def users_params
    params.require(:user).permit(:email)
  end
end

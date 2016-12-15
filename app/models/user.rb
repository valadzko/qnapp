class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations

  def author_of?(obj)
    obj.user_id == id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first if email
    if user.nil?
      password = Devise.friendly_token[0, 20]
      if email # if email present - save user in database
        user = User.create!(password:password, email: email, password_confirmation:password)
      else # just create temporary user with authentication, but save in db nothing
        user = User.new(password:password, email: '', password_confirmation:password)
        user.authorizations.build(provider: auth.provider, uid: auth.uid)
        return user
      end
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def self.build_by_omniauth_params(email, auth)
    user = User.where(email: email).first
    user = User.create!(email: email, password: auth['user_password'], password_confirmation: auth['user_password']) unless user
    user.authorizations.create(provider: auth["provider"], uid: auth["uid"].to_s)
    user
  end
end

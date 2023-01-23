class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    return if email.nil?

    user = User.where(email: email).first || User.create_with_email(email)
    user.create_authorization(auth)

    user
  end
end

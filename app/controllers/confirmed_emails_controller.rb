class ConfirmedEmailsController < ApplicationController
  def new
    @provider = params[:provider]
    @uid = params[:uid]
    @confirmed_email = ConfirmedEmail.new
  end

  def create
    existing_confirmed_email = ConfirmedEmail.find(confirmed_email_params)
    @confirmed_email = existing_confirmed_email || ConfirmedEmail.new(confirmed_email_params.merge(confirmation_token: Devise.friendly_token(50)))

    if @confirmed_email.save
      EmailConfirmationMailer.email_confirmation(@confirmed_email).deliver_now
      redirect_to new_user_session_path, notice: 'A confirmation link has been sent to your email.'
    else
      @provider = @confirmed_email.provider
      @uid = @confirmed_email.uid
      render :new
    end
  end

  def confirm
    confirmation_token = params[:confirmation_token]
    confirmed_email = ConfirmedEmail.where(confirmation_token: confirmation_token).first

    if confirmed_email.present?
      auth = OmniAuth::AuthHash.new(provider: confirmed_email.provider, uid: confirmed_email.uid)

      user = User.where(email: confirmed_email.email).first || User.create_with_email(confirmed_email.email)
      user.create_authorization(auth)

      confirmed_email.destroy

      redirect_to new_user_session_path, notice: 'Email is confirmed. Now you can sign in via Telegram.'
    else
      redirect_to new_user_session_path, alert: 'Not valid confirmation token.'
    end
  end

  private

  def create_user

  end

  def confirmed_email_params
    params.require(:confirmed_email).permit(:email, :uid, :provider)
  end
end

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def telegram
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Telegram') if is_navigational_format?
    else
      redirect_to new_confirmed_email_path(provider: auth.provider, uid: auth.uid), notice: 'Confirm your email'
    end
=begin
{
  "provider":"telegram",
  "uid":"1846861338",
  "info": {
    "name":"Роман Иванов",
    "nickname":"romatoom",
    "first_name":"Роман",
    "last_name":"Иванов",
    "image":"https://t.me/i/userpic/320/k-keR44znWC4E7P7GUVDfLEokTtxoU4VmmlkpYT2i1k.jpg"},
    "credentials":{},
    "extra":{
      "auth_date":"2023-01-19T20:19:37.000+05:00"
    }
}
=end
  end
end

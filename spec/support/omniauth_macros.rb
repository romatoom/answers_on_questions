module OmniauthMacros
  # The mock_auth configuration allows you to set per-provider (or default)
  # authentication hashes to return during integration testing.

  def github_mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '12345',
      'info' => {
        'name' => 'Mockuser',
        'email' => 'mockuser@example.com'
      }
    })
  end

  def telegram_mock_auth_hash
    OmniAuth.config.mock_auth[:telegram] = OmniAuth::AuthHash.new({
      'provider' => 'telegram',
      'uid' => '12345',
      'info' => {
        'nickname' => 'Mockuser',
      }
    })
  end
end

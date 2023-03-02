server "194.58.109.215", user: "deployer", roles: %w{app db web}, primary: true
set :rails_env, :production

set :ssh_options, {
  keys: %w(/Users/romanivanov/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 2222
}

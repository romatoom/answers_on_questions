lock "~> 3.17.2"

set :application, "qna"
set :repo_url, "git@github.com:romatoom/answers_on_questions.git"

set :deploy_to, "/home/deployer/qna"
set :deploy_user, "deployer"

set :sidekiq_enable_lingering, false

set :pty, true

append :linked_files, "config/database.yml", "config/master.key", "config/storage.yml"

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

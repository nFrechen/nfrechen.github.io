system("bundle install --path=vendor")

servr::jekyll(command="bundle exec jekyll build")
servr::jekyll()
servr::daemon_stop(1)

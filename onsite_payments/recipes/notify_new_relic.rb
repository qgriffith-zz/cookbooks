node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "Notify New Relic" do
    # TODO: add newrelic gem and config to payments repo
    command "bundle exec newrelic deployments -r `git log --pretty=format:'%h' -n 1`"
    user deploy[:user]
    group deploy[:group]
    cwd "#{deploy[:deploy_to]}/current"
    environment({'RAILS_ENV' => deploy[:rails_env]})
  end

end

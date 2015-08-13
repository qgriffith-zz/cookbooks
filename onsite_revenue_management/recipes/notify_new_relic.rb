node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "Notify New Relic" do
    command "bundle exec newrelic deployments -r `git log --pretty=format:'%h' -n 1`"
    user deploy[:user]
    group deploy[:group]
    pwd "#{deploy[:deploy_to]}/current"
    environment({'RAILS_ENV' => deploy[:rails_env]})
  end

end

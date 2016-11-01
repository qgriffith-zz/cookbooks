node[:deploy].each do |application, deploy|
  template "/etc/profile.d/#{application}.sh" do
    variables ({
      :env => deploy[:environment_variables]
    })
    owner 'root'
    group 'root'
    mode  '0755'
    source 'environment.sh.erb'
  end

  template "/etc/init/sidekiq.conf" do
    source "sidekiq.conf.erb"
    variables(
      redis_server: deploy[:environment_variables]['REDIS_HOST'],
      app_path: app_path,
      user: deploy[:user]
    )
  end
end


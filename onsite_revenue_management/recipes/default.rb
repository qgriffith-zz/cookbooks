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
  app_path = File.join(deploy[:deploy_to], 'current')

  template "/etc/init/sidekiq.conf" do
    source "sidekiq.conf.erb"
    variables(
      environment_vars: deploy[:environment_variables],
      app_path: app_path,
      user: deploy[:user]
    )
  end
end


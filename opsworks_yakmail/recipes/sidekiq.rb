
node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  app_path = File.join(deploy[:deploy_to], 'current')

  template "/etc/init/sidekiq.conf" do
    source "sidekiq.conf.erb"
    variables(
      redis_server: deploy[:environment_variables]['REDIS_HOST'],
      AWS_REGION: deploy[:environment_variables]['AWS_REGION'],
      AWS_ACCESS_KEY_ID: deploy[:environment_variables]['AWS_ACCESS_KEY_ID'],
      AWS_SECRET_ACCESS_KEY: deploy[:environment_variables]['AWS_SECRET_ACCESS_KEY'],
      app_path: app_path,
      user: deploy[:user]
    )
  end
end

service "sidekiq" do
  provider Chef::Provider::Service::Upstart
  subscribes :restart, "template[/etc/init/sidekiq.conf]", :delayed
  action [:enable, :start]
end

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  app_path = File.join(deploy[:deploy_to], 'current')

  template "/etc/init/sidekiq.conf" do
    source "sidekiq.conf.erb"

    variables(thread_count:
                deploy[:environment_variables]['ILS_WORKER_THREADS'],
              ils_env:  deploy[:environment_variables]['ILS_ENV'],
              redis_server: deploy[:environment_variables]['ILS_REDIS'],
              vpn_server: deploy[:environment_variables]['ILS_VPN'],
              rm_uri: deploy[:environment_variables]['RM_URI'],
              rm_api_token: deploy[:environment_variables]['RM_API_TOKEN'],
              app_path: app_path,
              user: deploy[:user])
  end


  template "/etc/init/workers.conf" do
    source "workers.conf.erb"
    variables(worker_count: deploy[:environment_variables]['ILS_WORKER_COUNT'])
  end

  # FHK - These need to subscribe to a deployment resource!!
  service "workers" do
    provider Chef::Provider::Service::Upstart
    subscribes :restart, "template[/etc/init/sidekiq.conf]", :delayed
    subscribes :restart, "template[/etc/init/workers.conf]", :delayed
    action [:enable, :start]
  end

end

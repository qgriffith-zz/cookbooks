node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  app_path = File.join(deploy[:deploy_to], 'current')
  crontab_path = File.join(deploy[:home], 'crontab')

  template crontab_path do
    source "#{application}.crontab.erb"
    mode '0644'
    owner deploy[:user]
    group deploy[:group]
    variables(
      schedule: deploy[:environment_variables]['ILS_SCHEDULE'],
      environment: deploy[:environment_variables]['ILS_ENV'],
      app_path: app_path,
      sites: deploy[:environment_variables]['ILS_SITES'],
      redis_server: deploy[:environment_variables]['ILS_REDIS'],
      vpn_server: deploy[:environment_variables]['ILS_VPN'],
      rm_uri: deploy[:environment_variables]['RM_URI'],
      rm_api_token: deploy[:environment_variables]['RM_API_TOKEN'],
    )
  end

  execute "crontab #{crontab_path}" do
    command "crontab -u #{deploy[:user]} #{crontab_path}"
    not_if do
      if ! File.exists?(crontab_path)
        true
      else
        current = `crontab -u #{deploy[:user]}`
        desired = File.read(crontab_path)
        current == desired
      end
    end
  end

end

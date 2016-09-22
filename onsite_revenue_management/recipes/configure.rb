node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  if deploy['rails_env'] == 'production'
    include_recipe 'opsworks_datadog'
  end

  secrets_file = File.join(deploy[:current_path], 'config', 'secrets.yml')
  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    mode '0644'
    owner deploy[:user]
    group deploy[:group]
    source 'secrets.yml.erb'
    variables(
      environment: deploy[:rails_env],
      secrets: deploy[:environment_variables]
    )
    only_if do
      deploy[:database][:host].present? &&
        File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

  rx_api_file = File.join(deploy[:current_path], 'config', 'rx.yml')
  template "#{deploy[:deploy_to]}/shared/config/rx.yml" do
    mode '0644'
    owner deploy[:user]
    group deploy[:group]
    source 'rx.yml.erb'
    variables(
      environment: deploy[:rails_env],
      site: deploy[:environment_variables]['RX_API_SITE']
    )
    only_if do
      deploy[:database][:host].present? &&
        File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

  honeybadger_file = File.join(deploy[:current_path], 'config', 'honeybadger.yml')
  template "#{deploy[:deploy_to]}/shared/config/honeybadger.yml" do
    mode '0644'
    owner deploy[:user]
    group deploy[:group]
    source 'honeybadger.yml.erb'
    variables(secret: deploy[:environment_variables]['HONEYBADGER_API_SECRET'])
    only_if do
      deploy[:database][:host].present? &&
        File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

  application_file = File.join(deploy[:current_path], 'config', 'application.yml')
  template "#{deploy[:deploy_to]}/shared/config/application.yml" do
    mode  '0644'
    owner deploy[:user]
    group deploy[:group]
    source 'application.yml.erb'
    variables(
      microbunny_host: deploy[:environment_variables]['MICROBUNNY_HOST'],
      microbunny_username: deploy[:environment_variables]['MICROBUNNY_HOST'],
      microbunny_vhost: deploy[:environment_variables]['MICROBUNNY_VHOST'],
      microbunny_password: deploy[:environment_variables]['MICROBUNNY_PASSWORD']
    )
    only_if do
      deploy[:database][:host].present? &&
        File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end

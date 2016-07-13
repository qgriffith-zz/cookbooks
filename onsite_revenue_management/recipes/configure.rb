node.set[:datadog][:tags][:env] = node[:deploy][application][:environment_variables]['RAILS_ENV']
node.set[:datadog][:api_key] = node[:deploy][application][:environment_variables]['DATDOG_KEY']
include_recipe 'datadog::dd-agent'

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

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
end

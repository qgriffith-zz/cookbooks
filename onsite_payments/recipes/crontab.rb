node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  rails_path = File.join(deploy[:deploy_to], 'current')
  crontab_path = File.join(deploy[:home], 'crontab')

  template crontab_path do
    source "#{application}.crontab.erb"
    mode '0644'
    owner deploy[:user]
    group deploy[:group]
    variables(
      environment: deploy[:rails_env],
      rails_path: rails_path
    )
  end

  execute "crontab #{crontab_path}" do
    command "crontab -u #{deploy[:user]} #{crontab_path}"
    not_if do
      if ! File.exists?(crontab_path)
        true
      else
        current = `crontab -u #{deploy[:user]} -l`
        desired = File.read(crontab_path)
        current == desired
      end
    end
  end

end

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  crontab_path = File.join(deploy[:deploy_to], 'config', 'crontab')

  execute "install #{application} crontab #{crontab_path}" do
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

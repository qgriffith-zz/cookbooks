
node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  test_file = File.join(deploy[:current_path], 'config', 'fhk_test')
  file test_file do
    content deploy[:symlink_before_migrate]
    user "deploy"
  end


  secrets_file = File.join(deploy[:current_path], 'config', 'secrets.yml')
  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    mode '0644'
    owner deploy[:user]
    group deploy[:group]
    source 'secrets.yml.erb'
    variables(
      environment: deploy[:rails_env],
      secrets:
        OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
    )

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:database][:host].present? &&
        File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

end

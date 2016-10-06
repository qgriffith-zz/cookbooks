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

  if deploy['rails_env'] == 'production'
    include_recipe 'opsworks_datadog'
  end
end

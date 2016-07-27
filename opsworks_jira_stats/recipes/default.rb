include_recipe 's3_file'



node[:deploy].each do |application, deploy|

  s3_file "#{node["deploy"]["jira_stats"]["deploy_to"]}/jira_private_key.pem" do
    bucket 'osm-opsworks-secrets'
    remote_path 'jira_private_key.pem'
    s3_url "https://s3-us-west-2.amazonaws.com/osm-opsworks-secrets"
    mode "0644"
    aws_access_key_id     deploy[:environment_variables]['AWS_ACCESS_KEY_ID']
    aws_secret_access_key deploy[:environment_variables]['AWS_SECRET_ACCESS_KEY']
  end

  template "/etc/profile.d/#{application}.sh" do
    variables ({
      :env => deploy[:environment_variables]
    })
    owner 'root'
    group 'root'
    mode  '0755'
    source 'environment.sh.erb'
  end

end

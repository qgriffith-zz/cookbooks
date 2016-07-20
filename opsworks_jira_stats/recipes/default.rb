include_recipe 's3_file'

s3_file "#{node["deploy"]["jira_stats"]["deploy_to"]}/jira_private_key.pem" do
  bucket 'osm-opsworks-secrets'
  remote_path 'jira_private_key.pem'
  mode "0644"
end
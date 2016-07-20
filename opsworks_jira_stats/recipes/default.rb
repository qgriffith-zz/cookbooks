include_recipe 's3_file'

s3_file "#{node["deploy"]["jira_stats"]["deploy_to"]}/jira_private_key.pem" do
  bucket 'osm-opsworks-secrets'
  remote_path 'jira_private_key.pem'
  s3_url "https://s3-us-west-2.amazonaws.com/osm-opsworks-secrets"
  mode "0644"
end
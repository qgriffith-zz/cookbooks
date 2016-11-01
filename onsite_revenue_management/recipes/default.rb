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
end


cookbook_file '/etc/init/sidekiq.conf' do
  source 'sidekiq.conf'
  owner  'root'
  group  'root'
  mode   '0644'
end


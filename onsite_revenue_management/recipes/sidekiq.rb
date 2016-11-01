service 'sidekiq' do
  provider Chef::Provider::Service::Upstart
  action [ :enable, :restart ]
end
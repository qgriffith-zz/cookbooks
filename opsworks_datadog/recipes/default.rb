#
# Cookbook Name:: opsworks_datadog
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  node.set[:datadog][:tags][:env] = deploy['rails_env']
  node.set[:datadog][:api_key] = deploy[:environment_variables]['DATADOG_KEY']
  #This is to ensure dd gets unique hostnames
  node.set[:datadog][:hostname] = "#{application}.#{deploy['rails_env']}.#{node["opsworks"]["instance"]["hostname"]}"
  include_recipe 'datadog::dd-agent'

end

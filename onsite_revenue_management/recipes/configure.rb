
node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  test_file = File.join(deploy[:current_path], 'config', 'fhk_test')
  file test_file do
    content "Just a test: #{application} #{ENV['RX_API_SITE']}"
    user "deploy"
  end
end

node[:deploy].each do |application, deploy|
  package "apache2" do
    action :remove
  end
end
class ::Chef::Recipe
  include ::Opscode::ChefClient::Helpers
end

# libraries/helpers.rb method to DRY directory creation resources
client_bin = find_chef_client
log "Found chef-client in #{client_bin}"
node.default["chef_client"]["bin"] = client_bin
create_directories

log "Using winsw_service on this Chef version is deprecated; use windows_service" do
  level :warn
  only_if { Gem::Requirement.new(">= 11.5").satisfied_by?(Gem::Version.new(::Chef::VERSION)) }
end

directory node["chef_client"]["winsw_dir"] do
  action :create
end

template "#{node["chef_client"]["winsw_dir"]}/chef-client.xml" do
  source "chef-client.xml.erb"
  notifies :run, "execute[restart chef-client using winsw wrapper]", :delayed
end

winsw_path = ::File.join(node["chef_client"]["winsw_dir"], node["chef_client"]["winsw_exe"])
remote_file winsw_path do
  source node["chef_client"]["winsw_url"]
  not_if { ::File.exists?(winsw_path) }
end

# Work-around for CHEF-2541
# Should be replaced by a service :restart action
# in Chef 0.10.6
execute "restart chef-client using winsw wrapper" do
  command "#{winsw_path} restart"
  not_if { WMI::Win32_Service.find(:first, :conditions => {:name => "chef-client"}).nil? }
  action :nothing
end

execute "Install chef-client service using winsw" do
  command "#{winsw_path} install"
  only_if { WMI::Win32_Service.find(:first, :conditions => {:name => "chef-client"}).nil? }
end

service "chef-client" do
  action :start
end

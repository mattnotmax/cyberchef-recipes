class ::Chef::Recipe
  include ::Opscode::ChefClient::Helpers
end

# libraries/helpers.rb method to DRY directory creation resources
client_bin = find_chef_client
log "Found chef-client in #{client_bin}"
node.default["chef_client"]["bin"] = client_bin
create_directories

directory node['chef_client']['method_dir'] do
  action :create
  owner "root"
  group "bin"
  mode "0644"
  recursive true
end

local_path = ::File.join(Chef::Config[:file_cache_path], "/")
template "#{node['chef_client']['method_dir']}/chef-client" do
  source "solaris/chef-client.erb"
  owner "root"
  group "root"
  mode "0777"
  notifies :restart, "service[chef-client]"
end

template(local_path + "chef-client.xml") do
  source "solaris/manifest.xml.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, "execute[load chef-client manifest]", :immediately
end

execute "load chef-client manifest" do
  action :nothing
  command "svccfg import #{local_path}chef-client.xml"
  notifies :restart, "service[chef-client]"
end

service "chef-client" do
  action [:enable, :start]
  provider Chef::Provider::Service::Solaris
end

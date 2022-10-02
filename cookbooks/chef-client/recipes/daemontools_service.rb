class ::Chef::Recipe
  include ::Opscode::ChefClient::Helpers
end

# libraries/helpers.rb method to DRY directory creation resources
client_bin = find_chef_client
log "Found chef-client in #{client_bin}"
node.default["chef_client"]["bin"] = client_bin
create_directories

group = root_group

include_recipe "daemontools"

directory "/etc/sv/chef-client" do
  recursive true
  owner "root"
  group group
  mode 0755
end

daemontools_service "chef-client" do
  directory "/etc/sv/chef-client"
  template "chef-client"
  action [:enable,:start]
  log true
end

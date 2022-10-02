class ::Chef::Recipe
  include ::Opscode::ChefClient::Helpers
end

# libraries/helpers.rb method to DRY directory creation resources
client_bin = find_chef_client
log "Found chef-client in #{client_bin}"
node.default["chef_client"]["bin"] = client_bin
create_directories

group = root_group

directory node["chef_client"]["run_path"] do
  recursive true
  owner "root"
  group group
  mode 0755
end

include_recipe "bluepill"

template "#{node["bluepill"]["conf_dir"]}/chef-client.pill" do
  source "chef-client.pill.erb"
  mode 0644
  notifies :restart, "bluepill_service[chef-client]", :delayed
end

bluepill_service "chef-client" do
  action [:enable,:load,:start]
end

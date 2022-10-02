class ::Chef::Recipe
  include ::Opscode::ChefClient::Helpers
end

# libraries/helpers.rb method to DRY directory creation resources
client_bin = find_chef_client
log "Found chef-client in #{client_bin}"
node.set["chef_client"]["bin"] = client_bin
create_directories

template "/etc/rc.d/chef-client" do
  source "rc.d/chef-client.erb"
  mode 0755
  variables :client_bin => client_bin
  notifies :restart, "service[chef-client]", :delayed
end

template "/etc/conf.d/chef-client.conf" do
  source "conf.d/chef-client.conf.erb"
  mode 0644
  notifies :restart, "service[chef-client]", :delayed
end

service "chef-client" do
  action [:enable, :start]
end

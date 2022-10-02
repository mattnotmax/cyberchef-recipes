class ::Chef::Recipe
  include ::Opscode::ChefClient::Helpers
end

# libraries/helpers.rb method to DRY directory creation resources
client_bin = find_chef_client
log "Found chef-client in #{client_bin}"
node.default["chef_client"]["bin"] = client_bin
create_directories

log "You specified service style 'bsd'. You will need to set up your rc.local file."
log "Hint: chef-client -i #{node["chef_client"]["client_interval"]} -s #{node["chef_client"]["client_splay"]}"

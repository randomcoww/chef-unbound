execute "pkg_update" do
  command node['unbound']['pkg_update_command']
  action :run
end

package node['unbound']['pkg_names'] do
  action :upgrade
  notifies :stop, "service[unbound]", :immediately
end

remote_file '/etc/unbound/root-hints.conf' do
  source 'https://www.internic.net/domain/named.cache'
  action :create
  notifies :reload, "service[unbound]", :delayed
end

unbound_config 'sample' do
  config node['unbound']['sample']['config']
  action :create
  notifies :reload, "service[unbound]", :delayed
end

include_recipe "unbound::init_service"

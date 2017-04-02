package 'procps' do
  action :upgrade
end

service 'unbound' do
  # provider Chef::Provider::Service::Init
  start_command "/etc/init.d/unbound start"
  stop_command "/etc/init.d/unbound stop"
  restart_command "/etc/init.d/unbound restart"
  reload_command "/etc/init.d/unbound start && /usr/sbin/unbound-control reload"
  status_command "/etc/init.d/unbound status"
  action [:start]
end

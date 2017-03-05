class Chef
  class Provider
    class Unbound < Chef::Provider
      include ConfigGenerator

      provides :unbound, os: "linux"

      def load_current_resource
        @current_resource = Chef::Resource::Unbound.new(new_resource.name)
        current_resource
      end

      def action_deploy
        converge_by("Deploy unbound: #{new_resource.name}") do
          unbound_config.run_action(:create)
          unbound_service.run_action(:start)

          if unbound_config.updated_by_last_action? && !unbound_service.updated_by_last_action?
            unbound_service.run_action(:restart)
          end
        end
      end


      private

      def unbound_service
        @unbound_service ||= Chef::Resource::Service.new('unbound', run_context).tap do |r|
          r.provider Chef::Provider::Service::Systemd
        end
      end

      def unbound_config
        @unbound_config ||= Chef::Resource::File.new('/etc/unbound/unbound.conf', run_context).tap do |r|
          r.content UnboundConfig.generate(new_resource.config)
        end
      end
    end
  end
end

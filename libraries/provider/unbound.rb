class Chef
  class Provider
    class Unbound < Chef::Provider
      include ConfigGenerator

      provides :nsd, os: "linux"

      def load_current_resource
        @current_resource = Chef::Resource::Nsd.new(new_resource.name)
        current_resource
      end

      def action_deploy
        converge_by("Deploy nsd: #{new_resource.name}") do
          nsd_config.run_action(:create)
          nsd_service.run_action(:start)

          if nsd_config.updated_by_last_action? && !nsd_service.updated_by_last_action?
            nsd_service.run_action(:restart)
          end
        end
      end


      private

      def unbound_service
        @nsd_service ||= Chef::Resource::Service.new('unbound', run_context).tap do |r|
          r.provider Chef::Provider::Service::Systemd
        end
      end

      def unbound_config
        @nsd_config ||= Chef::Resource::File.new('/etc/unbound/unbound.conf', run_context).tap do |r|
          r.content UnboundConfig.generate(new_resource.config)
        end
      end
    end
  end
end

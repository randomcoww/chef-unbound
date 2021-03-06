class ChefUnbound
  class Provider
    class Config < Chef::Provider
      provides :unbound_config, os: "linux"

      def load_current_resource
        @current_resource = ChefUnbound::Resource::Config.new(new_resource.name)

        if ::File.exist?(new_resource.path)
          current_resource.content(::File.read(new_resource.path).chomp)
        else
          current_resource.content(nil)
        end

        current_resource
      end

      def action_create
        converge_by("Create unbound config: #{new_resource}") do
          unbound_config.run_action(:create)
        end if current_resource.content.nil? || current_resource.content != new_resource.content
      end

      def action_delete
        converge_by("Delete unbound config: #{new_resource}") do
          unbound_config.run_action(:delete)
        end if !current_resource.content.nil?
      end

      private

      def unbound_config
        @unbound_config ||= Chef::Resource::File.new(new_resource.path, run_context).tap do |r|
          r.path new_resource.path
          r.content new_resource.content
        end
      end
    end
  end
end

class ChefUnbound
  class Resource
    class Config < Chef::Resource
      include Unbound
      include ConfigGenerator

      resource_name :unbound_config

      default_action :create
      allowed_actions :create, :delete

      property :exists, [TrueClass, FalseClass]
      property :path, String, desired_state: false,
                              default: lazy { Unbound::CONFIG_PATH }

      def config(arg = nil)
        set_or_return(
          :config,
          arg,
          :kind_of => [ Hash ])
      end

      def content
        generate_config(config)
      end
    end
  end
end

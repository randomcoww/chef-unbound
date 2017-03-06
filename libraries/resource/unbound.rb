class ChefUnbound
  class Resource
    class Config < Chef::Resource          
      resource_name :unbound_config

      default_action :create
      allowed_actions :create, :delete

      property :exists, [TrueClass, FalseClass]
      property :content, String, default: lazy { generate_config(config) }
      property :path, String, desired_state: false,
                              default: lazy { Unbound::CONFIG_PATH }

      private

      def config(arg = nil)
        set_or_return(
          :config,
          arg,
          :kind_of => [ Hash ])
      end
    end
  end
end

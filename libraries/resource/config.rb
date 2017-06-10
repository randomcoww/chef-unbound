class ChefUnbound
  class Resource
    class Config < Chef::Resource
      include NsdConfigGenerator

      resource_name :unbound_config

      default_action :create
      allowed_actions :create, :delete

      property :config, Hash
      property :content, [String,NilClass], default: lazy { to_conf }
      property :path, String, desired_state: false,
                              default: lazy { Unbound::CONFIG_PATH }

      private

      def to_conf
        generate_config(config)
      end
    end
  end
end

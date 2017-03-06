require 'chef/resource'

require_relative '../unbound'
require_relative '../config_generator'

class ChefUnbound
  class Resource
    class Config < Chef::Resource
      include ConfigGenerator

      resource_name :unbound_config

      default_action :create
      allowed_actions :create, :delete

      property :exists, [TrueClass, FalseClass]
      property :config, Hash
      property :content, String, default: lazy { to_conf }
      property :path, String, desired_state: false,
                              default: lazy { Unbound::CONFIG_PATH }

      # def config(arg = nil)
      #   set_or_return(
      #     :config,
      #     arg,
      #     :kind_of => [ Hash ])
      # end

      private

      def to_conf
        generate_config(config)
      end
    end
  end
end

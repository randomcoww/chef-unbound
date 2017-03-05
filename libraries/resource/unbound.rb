class Chef
  class Resource
    class Unbound < Chef::Resource
      resource_name :unbound

      default_action :deploy
      allowed_actions :deploy

      property :config, Hash
    end
  end
end

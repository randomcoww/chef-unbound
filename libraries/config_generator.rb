module ConfigGenerator
  class UnboundConfig

    ## gererate yaml like config that unbound uses from hash
    ## sample source config

    # {
    #   :server => {
    #     :k1 => 'v1',
    #     :k2 => 'v2'
    #   },
    #   'remote-control' => {
    #     'control-enanled' => true
    #   },
    #   :zone => [
    #     {
    #       :name => 'z1',
    #       :zonefile => 'z1file'
    #     },
    #     {
    #       :name => 'z2',
    #       :zonefile => 'z2file'
    #     },
    #     {
    #       :name => 'z3',
    #       :zonefile => 'z3file'
    #     }
    #   ]
    # }

    def self.generate(config_hash)
      f.parse_hash([], config_hash, '')
    end

    def self.parse_hash(out, c, prefix)
      if c.is_a?(Hash)
        c.each do |k, v|
          if v.is_a?(Array)
            v.each do |e|
              out << [prefix, k, ':'].join('')
              parse_hash(out, e, prefix + '  ')
            end
          elsif v.is_a?(Hash)
            out << [prefix, k, ':'].join('')
            parse_hash(out, v, prefix + '  ')
          elsif v.is_a?(String) || v.is_a?(Integer)
            out << [prefix, k, ': ', v].join('')
          elsif v.is_a?(TrueClass)
            out << [prefix, k, ': ', 'yes'].join('')
          elsif v.is_a?(FalseClass)
            out << [prefix, k, ': ', 'no'].join('')
          end
        end
      end
      return out.join($/)
    end
  end
end

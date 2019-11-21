require 'yaml'
require 'json'

class ConfigError < StandardError
end

# Config loads the config.yaml file into settings
module Config
  extend self

  @_config = {}
  attr_reader :_config

  # load! reads the yaml file into module attributes.
  # must be an absolute path to the file
  def load!(filename)
    config_file = File.open(filename).read
    config = YAML.load(config_file)
    raise ConfigError("unable to load config file #{filename}") unless config
    @_config = config
  end

  def _access(name, *args)
    return @_config[args[0]] ||
           raise(ConfigError, "unknown configuration option #{name}", caller) unless args.empty?
    @_config[name.to_s] ||
      raise(ConfigError, "unknown configuration option #{name}", caller)
  end

  def method_missing(name, *args)
    res = _access(name, *args)
    res = ConfigHash[res] if res.is_a?(Hash)
    res = ConfigArray[*res] if res.is_a?(Array)
    res
  end
end

# ConfigHash is a hash but allows dot notation access and throws ConfigError for missing items
class ConfigHash < Hash
  def method_missing(name, *args)
    return self.[]([args[0]]) ||
           raise(ConfigError, "unknown configuration option #{name}", caller) unless args.empty?
    self.[](name.to_s) ||
      raise(ConfigError, "unknown configuration option #{name}", caller)
  end

  def [](key)
    res = super(key)
    res = ConfigHash[res] if res.is_a?(Hash)
    res = ConfigArray[*res] if res.is_a?(Array)
    raise(ConfigError, "unknown configuration option #{key}") if res.nil?
    res
  end
end

# ConfigArray is an array but returns ConfigHash if the array item is a hash
# so dot notation access works
class ConfigArray < Array
  def [](key)
    res = super(key)
    res = ConfigHash[res] if res.is_a?(Hash)
    res = ConfigArray[*res] if res.is_a?(Array)
    return res
  rescue IndexError
    raise(ConfigError, "no item at index #{key}")
  end
end

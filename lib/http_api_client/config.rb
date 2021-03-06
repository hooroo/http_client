# coding: utf-8

require 'erb'
require 'yaml'
require 'ostruct'
require 'http_api_client'

module HttpApiClient
  class Config

    DEFAULT_CONFIG_FILE_LOCATION = 'config/http_api_clients.yml'

    def initialize(config_file = DEFAULT_CONFIG_FILE_LOCATION)
      if File.exists?(config_file)
        @config = symbolize_keys(config_for(config_file, HttpApiClient.env))
      else
        raise "Could not load config file: #{config_file}"
      end
    end

    private

    attr_reader :config

    def method_missing(method, *args, &block)
      if config[method]
        OpenStruct.new(config[method])
      else
        super
      end
    end

    def config_for(config_file, environment)
      loaded_file = ERB.new(File.read(config_file)).result
      all_config = YAML.load(loaded_file)
      env_config = all_config[environment]
      if env_config
        env_config
      else
        raise "You must supply a http config for the '#{environment}' environment in '#{config_file}'."
      end
    end

    def symbolize_keys(hash)
      hash.inject({}) do |result, (key, value)|
        new_key = case key
              when String then key.to_sym
              else key
              end
        new_value = case value
                    when Hash then symbolize_keys(value)
                    else value
                    end
        result[new_key] = new_value
        result
      end
    end

  end
end

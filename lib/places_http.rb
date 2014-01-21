require "places_http/version"
require "places_http/errors"
require "places_http/config"
require "places_http/client"

module PlacesHttp

  def self.logger
    @logger || create_logger
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.env
    if rails_loaded?
      Rails.env
    else
      "test"
    end
  end

  private

  def self.create_logger
    if rails_loaded?
      Rails.logger
    else
      puts 'Logger not defined, using stub logger that does nothing. Set logger via PlacesHttp.logger = my_logger'
      StubLogger.new
    end
  end

  def self.rails_loaded?
    Module.const_get('Rails')
    true
  rescue NameError
    false
  end

  class StubLogger

    def info(message)
      #Stub implementation
    end

    def debug(message)
      #Stub implementation
    end

    def warn(message)
      #Stub implementation
    end

    def error(message)
      #Stub implementation
    end

  end
end
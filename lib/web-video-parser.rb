require 'net/http'
require "active_support/core_ext"
require "nokogiri"
require "json"
require "request"
require "youku"
require "sina"
require "youku_list"
require "tudou_list"

module VideoParser
  class Parser
    attr_reader :url, :error, :request, :data

    def initialize(url, format)
      @url     = url
      @format  = format
      @request = Request.new(@url)
    end

    def raw
      @raw ||= self.request.response
      @error = self.request.error
      @raw
    end

    def data
      return if !self.raw
      case @format
      when :json
        @data ||= JSON::parse(self.raw)
      when :xml, :html
        @data ||= Nokogiri::XML(self.raw)
      end
    rescue Exception => ex
      @error = ex
    ensure
      raise InvalidFormat.new if ![:json, :xml, :html].include?(@format)
    end

    class InvalidFormat < Exception;end
  end

  class VideoFile
    attr_reader :url, :seconds, :size

    def initialize(url, seconds, size=nil)
      @url = url
      @seconds = seconds
      @size = size
    end
  end
end

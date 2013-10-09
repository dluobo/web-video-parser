module VideoParser
  class Request
    attr_reader :url, :error, :task, :response

    def initialize(url)
      @url  = URI(url)
      @task = Net::HTTP::Get.new @url
    end

    def headers(options = {})
      if options.class != Hash      
        @error = InvalidHeaders.new
        raise @error
      end

      options.each do |key, value|
        @task[key.to_s] = value
      end

      self
    end

    def response
      @error = nil
      @response ||= Net::HTTP.start(@url.hostname, @url.port) do |http|
        http.request(@task)
      end.body
    rescue Exception => ex
      @error = ex
      nil
    end

    class InvalidHeaders < Exception;end
  end
end

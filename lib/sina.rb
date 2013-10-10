module VideoParser
  class Sina
    API_URL = 'http://v.iask.com/v_play.php?vid='

    def _request_url
      "#{API_URL}#{self.uid}"
    end

    attr_reader :parser

    def initialize(url)
      @url = url # like http://video.sina.com.cn/v/b/96748194-1418521581.html
      @parser = Parser.new _request_url, :xml
    end

    # 96748194
    def uid
      @uid ||= @url.split('/').last.split('-').first
    end

    def files
      xml = @parser.data

      files = []
      xml.css('durl').each do |durl|
        seconds = durl.css('length').text.to_i / 1000.0
        url = durl.css('url').text
        vf = VideoFile.new url, seconds
        files << vf
      end

      return files
    end
  end
end

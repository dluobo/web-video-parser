# -*- coding: utf-8 -*-
module VideoParser
  class Tudou
    class Parser
      # API_URL = 'http://v2.tudou.com/v2/cdn?id='
      # API_URL = 'http://v2.tudou.com/v?it='
      API_URL = 'http://v2.tudou.com/v?vn=02&st=3&it='
      # API_URL = 'http://v2.tudou.com/v.action?vn=02&pw=&ui=0&st=3&hd=1&sid=11000&retc=1&mt=0&it=141661957'

      def initialize(video)
        @video = video
      end

      def get_page
        @page ||= get_response(@video.url).body
      end

      def get_xml
        @xml ||= Nokogiri::XML get_response(_request_url).body
      end

      def get_response(url)
        begin
          uri = URI.parse url
          site = Net::HTTP.new(uri.host, uri.port)
          site.open_timeout = 20
          site.read_timeout = 20

          path = uri.query.nil? ? uri.path : "#{uri.path}?#{uri.query}"
          req  = Net::HTTP::Get.new(path, {
                                      'User-Agent' => @video.user_agent,
                                      'X-Forwarded-For' => @video.x_forwarded_for_ip
                                    })
          
          response = site.request(req)
        rescue Exception => ex
          p ex
        end
      end

      private

      def _request_url
        p "#{API_URL}#{@video.uid}"
      end
    end

    class TudouVideoFile
      attr_reader :url, :seconds
      def initialize(url, seconds)
        @url = url
        @seconds = seconds
      end
    end

    attr_reader :url, :user_agent, :x_forwarded_for_ip
    attr_reader :parser

    DEFAULT_USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.172 Safari/537.22'

    # 土豆的视频解析是区分user_agent的，所以需要从浏览器把user_agent传过来
    def initialize(url, user_agent = Tudou::DEFAULT_USER_AGENT)
      @url = url 
      @user_agent = user_agent
      # like http://www.tudou.com/albumplay/4NP7mtf2VYg/yqM7MXyWjPc.html
      # or   http://www.tudou.com/programs/view/c7Yv5D7kZew/
      # or   http://www.tudou.com/listplay/y_WvP2J5LuM.html
      # 好几种风格的地址

      @parser = Parser.new self
      @x_forwarded_for_ip = ''
    end

    def set_x_forwarded_for_ip(ip)
      @x_forwarded_for_ip = ip
    end

    def cover_url
      @cover_url ||= begin
                             match = @parser.get_page.match(/pic:(.+)/)
                             match = match[1].match /(http:\/\/[^"']+)/
                             return match[0]
                           rescue Exception => e
                             p "cover_url 解析错误"
                             ''
                           end
    end

    def title
      @title ||= begin
                             match = @parser.get_page.match(/kw:(.+)/)
                             str = match[1].gsub('"', '').gsub("'", '').strip
                             return str
                           rescue Exception => e
                             p "title 解析错误"
                             ''
                           end
    end

    def uid
      @uid ||= begin
                 match = @parser.get_page.match(/uid:.+/)
                 match[0].split(':').last.strip
               end
    end

    def vcode
      @vcode ||= begin
                   match = @parser.get_page.match /vcode:(.+)/
                   match = match[1].match /\w+/
                   return match[0]
                 rescue
                   p "vcode 解析错误"
                   ''
                 end
    end

    # 有些土豆的视频是来源于youku的，变态呀
    # 比如
    # http://www.tudou.com/albumplay/4NP7mtf2VYg/yqM7MXyWjPc.html
    # http://v.youku.com/v_show/id_XNTQ2OTc0OTAw.html
    # ↑ 这两个
    # 它们实际请求的是同样的真实视频文件
    def is_from_youku?
      p vcode
      vcode.present?
    end

    def files
      if is_from_youku?
        youku_url = "http://v.youku.com/v_show/id_#{vcode}.html"
        return Youku.new(youku_url).files
      end

      xml = @parser.get_xml
      seconds = xml.at_css('v')['tm'].to_i / 1000.0
      f = xml.at_css('f').text

      return [TudouVideoFile.new(f, seconds)]
    rescue
      return []
    end
  end
end

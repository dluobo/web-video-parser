# -*- coding: utf-8 -*-
module VideoParser
  require 'open-uri'

  class YoukuList
    attr_reader :list

    def initialize(url)
      if url.match(OldPlaylist.url_pattern)
        @list = OldPlaylist.new(url)
      else
        @list = Playlist.new(url)
      end
    end

    delegate :parse, :to => :list
    delegate :lid, :to => :list

    class Playlist
      def initialize(url)
        @url = url
        
        # url like
        # page_url
        # http://www.youku.com/show_page/id_zbd8216202dfa11e2b2ac.html
        # point_url
        # http://www.youku.com/show_point_id_zbd8216202dfa11e2b2ac.html?dt=json&__rt=1&__ro=reload_point
        # tab_url
        # http://www.youku.com/show_point/id_zbd8216202dfa11e2b2ac.html?dt=json&divid=point_reload_201305&tab=0&__rt=1&__ro=point_reload_201305
      end
      
      def lid
        @url.split('id_')[1].split('.')[0]
      end
      
      def show_point_url
        "http://www.youku.com/show_point_id_#{lid}.html?dt=json&__rt=1&__ro=reload_point"
      end
      
      def get_tab_urls
        tab_urls = []
        doc = Parser.new(show_point_url, :xml).data
        
        tabs = doc.css('#zySeriesTab li')
        if tabs.blank?
          return [show_point_url]
        end
        
        tabs.map do |el|
          tab = el.attributes['data'].value
          tab_urls << "http://www.youku.com/show_point/id_#{lid}.html?dt=json&divid=#{tab}&tab=0&__rt=1&__ro=#{tab}"
        end
        
        tab_urls
      end
      
      def parse
        chapters = []
        
        doc_0 = Parser.new(@url, :xml).data
        course_name = doc_0.at_css('.base .title .name').content.strip
        course_desc = doc_0.at_css('.aspect_con .detail').content.strip
        
        get_tab_urls.each do |tab_url|
          doc = Parser.new(tab_url, :xml).data
          
          c = doc.css('.item .title a').map { |el|
            attr_title = el.attributes['title']
            attr_href = el.attributes['href']
            
            next if attr_title.nil? || attr_href.nil?
            
            title = attr_title.value
            url = attr_href.value
            
            { :title => title, :url => url }
          }
          
          chapters += c
        end
        chapters.delete_if {|x| x == nil}
        
        return { :name => course_name, :desc => course_desc, :chapters => chapters }
        
      end

      def videos
        @videos ||= self.parse
      end
    end

    class OldPlaylist
      attr_reader :lid, :url

      def self.url_pattern
        /http:\/\/www.youku.com\/playlist_show\/id_(?<lid>\d+).html/
      end
      
      def initialize(url)
        @url = url
        @lid = self.class.url_pattern.match(url)[:lid]
      end

      def count
        @count ||= course_info(".stat .num")[0].content.to_i
      end

      def pages
        @pages ||= (count / 50.0).ceil
      end

      def name
        @course_title ||= course_info(".title .name")[0].content
      end

      def desc
        @course_name ||= course_info("#long.info .item")[0].content
      end

      def videos
        @videos ||= (1..pages).map do |page|
          Parser.new(api_url(page), :xml).data.css(".item a").map do |el|
            {:title => el.attributes["title"].value, :url => el.attributes["href"].value}
          end
        end.flatten
      end

      def parse
        {:name => course_name, :desc => course_desc, :chapters => items }
      end

      private

      def course_info(selector)
        @course_info ||= Parser.new(url, :xml).data
        @course_info.css(selector)
      end

      def api_url(page)
        "http://v.youku.com/v_vpvideoplaylistv5?f=#{lid}&pl=50&pn=#{page}"
      end

      def request(url)
        Net::HTTP.get(URI url)
      end
    end
  end
end

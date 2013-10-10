# -*- coding: utf-8 -*-
module VideoParser
  class TudouList
    class Item
      attr_reader :meta

      def initialize(meta)
        @meta = meta
        define_methods
      end

      def desc
        # @desc ||= desc_json["message"]["description"]
        # 0718 性能过低。暂时先不使用
        ""
      end
      
      def url
        "http://www.tudou.com/programs/view/#{code}/"
      end

      def cover_url
        self.picUrl
      end

      private

      def desc_json
        url = "http://www.tudou.com/playlist/service/getItemDetail.html?code=#{code}"
        @desc_json ||= Parser.new(url, :json).data
      end

      def define_methods
        meta.each do |key, value|
          define_singleton_method key.underscore do
            meta[key]
          end
        end
      end
    end

    class List
      attr_reader :url

      def initialize(url)
        @url = url
        @meta_parser = Parser.new(@url, :xml)
      end

      def meta
        @response ||= @meta_parser.data
      end

      def title
        @title ||= meta.at_css('.sec_2 .caption').content
      end

      def lid
        @lid ||= @meta_parser.raw.match(/var\slid\s=\s'(\d*)';/)[1].to_i
      end

      def count
        @count ||= meta.css('.mod_box_bd .summary.fix')[1].css('i')[0].content.to_i
      end

      def videos
        @videos ||= list_json['message']['items'].map do |data|
          Item.new(data)
        end
      end

      private

      def list_json
        @list_json ||= Parser.new(list_json_url, :json).data
      end

      def list_json_url
        "http://www.tudou.com/plcover/coverPage/getIndexItems.html?lid=#{lid}&pageSize=#{count}"
      end
    end

    def initialize(url)
      @url = url
      # url like
      # http://www.tudou.com/plcover/M9ovmjs6fkw/
    end

    def parse
      list = List.new(@url)

      title = list.title

      videos = list.items.map {|item|
        { :title => item.title, :url => item.url }
      }

      return {
        :name => title,
        :videos => videos
      }
    end
  end
end

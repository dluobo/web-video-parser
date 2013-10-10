# -*- coding: utf-8 -*-
module VideoParser
  class TudouList
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
        {title: data["title"], cover_url: data["picUrl"], url: "http://www.tudou.com/programs/view/#{data["code"]}/"}
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
end

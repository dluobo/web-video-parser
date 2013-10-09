module VideoParser
  class Youku
    API_URL = 'http://v.youku.com/player/getPlaylist/VideoIDS/'

    def _request_url
      "#{API_URL}#{self.uid}"
    end

    attr_reader :parser

    def get_mix_string(seed)
      mixed  = ''
      source = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/\:._-1234567890'

      source.length.times do 
        seed = (seed * 211 + 30031) % 65536
        index = (seed.to_f / 65536 * source.length)
        c = source[index]
        mixed = mixed + c
        source.sub! c, ''
      end

      return mixed
    end

    def get_file_id(streamfileid, seed)
      mixed = get_mix_string(seed)
      ids = streamfileid.split('*')

      real_id = ''
      ids.each do |x|
        real_id = real_id + mixed[x.to_i]
      end

      return real_id
    end

    def initialize(url)
      @url         = url # like http://v.youku.com/v_show/id_XNTQ0MDM5NTY4.html
      @parser      = Parser.new _request_url, :json
      @desc_parser = Parser.new @url, :xml
    end

    def uid
      @uid ||= @url.split('id_').last.split('.').first
    end

    def cover_url
      @cover_url ||= @parser.data['data'][0]['logo']
    end

    def title
      @title ||= @parser.data['data'][0]['title']
    end

    def desc
      @desc ||= @desc_parser.data.css("#vpvideoinfov5 .con #text_short").text
    end

    def files
      json = @parser.data

      seed         = json['data'][0]['seed']
      streamfileid = json['data'][0]['streamfileids']['flv']
      segs         = json['data'][0]['segs']['flv']

      fid0 = get_file_id(streamfileid, seed)
      fid1 = fid0[0...8]
      fid2 = fid0[10..-1]

      i = 0
      files = []
      segs.map do |x|
        aa = i.to_s(16).upcase
        aa = ('0' + aa)[-2..-1]
        fid = fid1 + aa + fid2
        k1 = x['k']
        k2 = x['k2']
        size = x['size']
        seconds = x['seconds']

        vf = VideoFile.new "http://f.youku.com/player/getFlvPath/sid/00_00/st/flv/fileid/#{fid}?K=#{k1}", seconds, size
        files << vf
        i = i + 1
      end

      return files
    end
  end
end

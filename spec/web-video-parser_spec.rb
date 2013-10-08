# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VideoParser do
  describe VideoParser::Youku do
    before {
      @youku_video = VideoParser::Youku.new 'http://v.youku.com/v_show/id_XNTQ0MDM5NTY4.html'
    }

    it { @youku_video.uid.should == 'XNTQ0MDM5NTY4' }
    it { 
      url = @youku_video.cover_url
      url.should_not be_nil
      @youku_video.files
      @youku_video.title.should eq "中国海军在马关条约签署纪念日巡航钓岛"
      @youku_video.desc.should include "在钓鱼岛海域进行巡航"
      @youku_video.files.count.should be 1
    }

    describe VideoParser::Youku::Parser do
      it {
        json = @youku_video.parser.get_json
        json.should_not be_nil
      }
    end
  end

  describe VideoParser::Tudou do
    before {
      @video1 = VideoParser::Tudou.new 'http://www.tudou.com/albumplay/4NP7mtf2VYg/yqM7MXyWjPc.html'
      @video2 = VideoParser::Tudou.new 'http://www.tudou.com/programs/view/c7Yv5D7kZew/'
      @video3 = VideoParser::Tudou.new 'http://www.tudou.com/listplay/y_WvP2J5LuM.html'
    }

    it {
      p "视频一 uid: #{uid = @video1.uid}"
      uid.should_not be_blank
      @video1.title.should_not be_blank
      @video1.cover_url.should_not be_blank
      @video1.files.should_not be_blank
    }

    it {
      p "视频二 uid: #{uid = @video2.uid}"
      uid.should_not be_blank
      @video2.title.should_not be_blank
      @video2.cover_url.should_not be_blank
      @video2.files.should_not be_blank
    }

    it {
      p "视频三 uid: #{uid = @video3.uid}"
      uid.should_not be_blank
      @video3.title.should_not be_blank
      @video3.cover_url.should_not be_blank
      @video3.files.should_not be_blank
    }
  end
end

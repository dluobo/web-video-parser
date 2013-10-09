# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
end

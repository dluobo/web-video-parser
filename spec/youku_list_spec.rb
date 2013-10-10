# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VideoParser::YoukuList do
  describe VideoParser::YoukuList::Playlist do
    before {
      @v = VideoParser::YoukuList::Playlist.new 'http://www.youku.com/show_page/id_z7a3c4ddaaed011e1b52a.html'
    }

    it "id 正确" do
      @v.lid.should == "z7a3c4ddaaed011e1b52a"
    end


    it "point url 正确" do
      @v.show_point_url.should == "http://www.youku.com/show_point_id_z7a3c4ddaaed011e1b52a.html?dt=json&__rt=1&__ro=reload_point"
    end

    it "tab urls 正确" do
      @v.get_tab_urls.should == ["http://www.youku.com/show_point_id_z7a3c4ddaaed011e1b52a.html?dt=json&__rt=1&__ro=reload_point"]
    end
  end

  describe VideoParser::YoukuList::OldPlaylist do
    let(:url) {"http://www.youku.com/playlist_show/id_623203.html"}
    let(:list) {VideoParser::YoukuList::OldPlaylist.new url}
    let(:item) {
      {
        :title => "Photoshop从头学起第01集",
        :url => "http://v.youku.com/v_show/id_XODM3NTQ2MA==.html?f=623203"
      }
    }
    subject {list}

    its(:lid)    {should eq "623203"}
    its(:count)  {should be 84}
    its(:pages)  {should be 2}
    its(:videos) {should include item}

    its(:name) {should include "Photoshop视频教程全集"}
    its(:desc) {should include "大量Photoshop视频教程"}
  end
end

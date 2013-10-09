require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VideoParser::Sina do
  before {
    @sina_video = VideoParser::Sina.new 'http://video.sina.com.cn/v/b/96748194-1418521581.html'
  }

  it { @sina_video.uid.should == '96748194' }

  it {
    files = @sina_video.files
    files.count.should > 0 
  }

  describe VideoParser::Sina::Parser do
    it {
      xml = @sina_video.parser.get_xml
      xml.should be_present
    }
  end
end

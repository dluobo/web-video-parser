require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VideoParser::Sina do
  before {
    @sina_video = VideoParser::Sina.new 'http://video.sina.com.cn/v/b/96748194-1418521581.html'
  }

  it { @sina_video.uid.should == '96748194' }

  it { @sina_video.title.should be_present}

  it {
    files = @sina_video.files
    files.count.should > 0 
  }

end

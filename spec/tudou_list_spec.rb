# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VideoParser::TudouList do
  describe VideoParser::TudouList do
    let(:list_url) {"http://www.tudou.com/plcover/M9ovmjs6fkw/"}
    let(:lid) {15632178}

    let(:parser) {VideoParser::TudouList.new(list_url)}
    subject {parser}

    its(:title) {should eq "法语公开课"}
    its(:lid) {should be lid}

    describe "#videos" do
      let(:items) {parser.videos}
      subject {items}

      it {should be_an Array}
      its(:first) {should be_an Hash}

      it "has a url" do
        items.first[:url].should be_present
      end
      # its(:desc) {should include "一口好听的法语"}
    end
  end
end

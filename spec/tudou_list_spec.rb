# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VideoParser::TudouList do
  describe VideoParser::TudouList do
    let(:list_url) {"http://www.tudou.com/plcover/M9ovmjs6fkw/"}
    let(:lid) {15632178}

    describe VideoParser::TudouList::List do
      let(:parser) {VideoParser::TudouList::List.new(list_url)}
      subject {parser}

      its(:title) {should eq "法语公开课"}
      its(:lid) {should be lid}

      describe "#videos" do
        let(:items) {parser.videos}
        subject {items}

        it {should be_an Array}
        its(:first) {should be_an VideoParser::TudouList::Item}

        describe VideoParser::TudouList::Item do
          subject {items.first}
          
          its(:code) {should eq "bOcUBCwbpbs"}
          # its(:desc) {should include "一口好听的法语"}
        end
      end
    end
  end
end

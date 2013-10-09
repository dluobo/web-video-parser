require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require 'webmock/rspec'

describe VideoParser::Parser do
  let(:url)  {"http://fakehost"}
  let(:xml)  {%Q[<field>value</field>]}
  let(:json) {%Q[{"field": "value"}]}
  after      {WebMock.reset!}
  
  describe "#data" do
    context "xml data" do
      before  {stub_request(:get, url).to_return(body: xml)}
      subject {VideoParser::Parser.new(url, :xml).data}
      
      it {should be_an Nokogiri::XML::Document}
    end

    context "json data" do
      before  {stub_request(:get, url).to_return(body: json)}
      subject {VideoParser::Parser.new(url, :json).data}

      it {should be_an Hash}
    end
  end
end

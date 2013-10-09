require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VideoParser::Request do
  let(:url)         {"http://www.baidu.com/"}
  let(:bad_url)     {"http://some.bad.url"}
  let(:bad_request) {VideoParser::Request.new(bad_url)}

  context "normal request" do
    let(:request) {VideoParser::Request.new(url)}
    
    describe "#headers(options)" do
      let(:headers) {{"Header-A" => "A", "Header-B" => "B"}}
      let(:result)  {{"header-a" => ["A"], "header-b" => ["B"]}}
      subject {request.headers(headers).task}

      its(:to_hash) {should include result}
    end

    describe "#response" do
      subject {request}
      before  {request.response}

      its(:response) {should be_present}
      its(:error)    {should be_nil}
    end
  end

  context "bad request" do
    let(:request) {VideoParser::Request.new(bad_url)}
    subject       {request}
    before        {request.response}

    its(:response) {should be_nil}
    its(:error)    {should be_present}
    its(:error)    {should be_an Exception}
  end
end

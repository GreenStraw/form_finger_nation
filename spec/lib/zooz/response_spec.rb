require 'spec_helper'

describe Zooz::Response do
  before(:each) do
    @request = Zooz::Response.new
  end
  
  describe "get_parsed_singular" do
    it "should return nil" do
      @request.should_receive(:parsed_response).and_return([])
      expect(@request.get_parsed_singular(0)).to eq(nil)
    end
  end

  describe "parsed_response" do
    it "should call CGI.parse ont the http_body" do
      @request.stub(:http_response).and_return(double(:http_response, :body=>'http_body'))
      CGI.should_receive(:parse).with('http_body').and_return('http_body')
      expect(@request.parsed_response).to eq('http_body')
    end
  end

  describe "parsed_json_response" do
    it "should call JSON.parse on the http body" do
      @request.stub(:http_response).and_return(double(:http_response, :body=>'http_body'))
      JSON.should_receive(:parse).with('http_body').and_return('http_body')
      expect(@request.parsed_json_response).to eq('http_body')
    end
  end

  describe "status_code" do
    describe "when json_response is blank" do
      it "calls get parsed singular for the status code" do
        @request.stub_chain(:json_response, :blank?).and_return(true)
        @request.should_receive(:get_parsed_singular).with('statusCode').and_return('200OK')
        expect(@request.status_code).to eq('200OK')
      end
    end
    describe "when json_response is not blank" do
      it "should return the json response ResponseStatus" do
        @request.stub_chain(:json_response, :blank?).and_return(false)
        @request.stub(:json_response).and_return({'ResponseStatus'=>'200OK'})
        expect(@request.status_code).to eq('200OK')
      end
    end
  end

  describe "error_message" do
    it "should return the json response errorMessage" do
      @request.stub(:json_response).and_return({'ResponseObject'=>{'errorMessage'=>'ERROR'}})
      expect(@request.error_message).to eq('ERROR')
    end
  end

  describe "success?" do
    before(:each) do
      @request.should_receive(:parsed_json_response).and_return(nil)
    end
    describe "when successful" do
      it "should return true" do
        @request.stub(:http_code).and_return('200 OK')
        @request.stub(:status_code).and_return('0')
        expect(@request.success?).to eq(true)
      end
    end
    describe "when unsuccessful" do
      describe "when http code is not 200" do
        it "should return false" do
          @request.stub(:http_code).and_return('422 Unprocessible entity')
          @request.stub(:http_message).and_return('Unprocessible entity')
          @request.stub(:status_code).and_return('0')
          expect(@request.success?).to eq(false)
        end
      end
      describe "when status code is nil" do
        it "should return false" do
          @request.stub(:http_code).and_return('200 OK')
          @request.stub(:status_code).and_return(nil)
          @request.stub(:error_message).and_return(nil)
          expect(@request.success?).to eq(false)
        end
      end
      describe "when status code is a zooz error" do
        it "should return false" do
          @request.stub(:http_code).and_return('200 OK')
          @request.stub(:status_code).and_return('101')
          @request.stub(:error_message).and_return('Zooz Error')
          expect(@request.success?).to eq(false)
        end
      end
    end
  end
  
end

require 'spec_helper'

describe Zooz::Request do
  before(:each) do
    @request = Zooz::Request.new
  end
  
  describe "set_param" do
    it "sets param" do
      @request.set_param(:sandbox, true)
      expect(@request.get_param(:sandbox)).to eq(true)
    end
  end
  
  describe "get_param" do
    it "returns set param" do
      @request.set_param(:sandbox, true)
      expect(@request.get_param(:sandbox)).to eq(true)
    end
  end
  
  describe "set_header" do
    it "sets header" do
      @request.set_header(:value, 'string')
      expect(@request.get_header(:value)).to eq('string')
    end
  end

  describe "get_header" do
    it "returns set header" do
      @request.set_header(:value, 'string')
      expect(@request.get_header(:value)).to eq('string')
    end
  end
  
  describe "is_sandbox?" do
    it "returns false" do
      expect(@request.is_sandbox?).to eq(true)
    end
  end
  
  describe "url" do
    describe "when response type is NVP" do
      before(:each) do
        @request.response_type="NVP"
      end
      describe "when is_sandbox? returns true" do
        before(:each) do
          @request.stub(:is_sandbox?).and_return(true)
        end
        it "returns proper url" do
          expect(@request.url).to eq('https://sandbox.zooz.co/mobile/SecuredWebServlet')
        end
      end
      describe "when is_sandbox? returns false" do
        before(:each) do
          @request.stub(:is_sandbox?).and_return(false)
        end
        it "returns proper url" do
          expect(@request.url).to eq('https://app.zooz.com/mobile/SecuredWebServlet')
        end
      end
    end
    describe "when response type is JSON" do
      describe "when is_sandbox? returns true" do
        before(:each) do
          @request.stub(:is_sandbox?).and_return(true)
        end
        it "returns proper url" do
          expect(@request.url).to eq('https://sandbox.zooz.co/mobile/ExtendedServerAPI')
        end
      end
      describe "when is_sandbox? returns false" do
        before(:each) do
          @request.stub(:is_sandbox?).and_return(false)
        end
        it "returns proper url" do
          expect(@request.url).to eq('https://app.zooz.com/mobile/ExtendedServerAPI')
        end
      end
    end
  end
  
  describe "valid?" do
    describe "when response type is NVP" do
      before(:each) do
        @request.response_type="NVP"
      end
      it "returns false" do
        expect(@request.valid?).to eq(false)
      end
    end
    describe "when response type is JSON" do
      it "returns false" do
        expect(@request.valid?).to eq(false)
      end
    end
  end

  describe "request" do
    describe "when valid? returns false" do
      before(:each) do
        @request.stub(:valid?).and_return(false)
      end
      it "returns false" do
        expect(@request.request).to eq(false)
      end
    end
    describe "when valid? returns true" do
      before(:each) do
        @request.stub(:valid?).and_return(true)
      end
      describe "when response type is NVP" do
        before(:each) do
          @request.response_type="NVP"
        end
        it "sends request via HTTParty" do
          HTTParty.should_receive(:post).with("https://sandbox.zooz.co/mobile/SecuredWebServlet", {:format=>:plain, :query=>{:cmd=>nil}, :headers=>{"ZooZ-Unique-ID"=>"zooz_unique_id", "ZooZ-App-Key"=>'zooz_app_key', "ZooZ-Response-Type"=>"NVP"}}).and_return('response')
          response = double(:response)
          response.should_receive(:request=).with(@request)
          response.should_receive(:http_response=).with('response')
          response.stub(:success?).and_return(true)
          Zooz::Response.should_receive(:new).and_return(response)
          expect(@request.request).to eq(response)
        end
      end
      describe "when response type is JSON" do
        it "sends request via HTTParty" do
          HTTParty.should_receive(:post).with("https://sandbox.zooz.co/mobile/ExtendedServerAPI", {:format=>:json, :body=>{:cmd=>nil}, :headers=>{"ZooZDeveloperId"=>"zooz_developer_id", "ZooZServerAPIKey"=>"zooz_app_key"}}).and_return('response')
          response = double(:response)
          response.should_receive(:request=).with(@request)
          response.should_receive(:http_response=).with('response')
          response.stub(:success?).and_return(true)
          Zooz::Response.should_receive(:new).and_return(response)
          expect(@request.request).to eq(response)
        end
      end      
    end
  end
  
end

require 'spec_helper'

describe Api::V1::VouchersController do
  render_views

  before do
    create_new_tenant
    login(:admin)
    @voucher = Fabricate(:voucher)
    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  let(:valid_attributes) { Fabricate.attributes_for(:voucher) }

  describe 'GET index' do
    context 'index' do
      before do
        get :index, format: :json
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'GET show' do
    context 'show' do
      before do
        get :show, id: @voucher.id, format: :json
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before(:each) do
        post :create, :voucher => valid_attributes, format: :json
      end
      it "assigns a newly created voucher as @voucher" do
        assigns(:voucher).should be_a(Voucher)
      end
      it "creates a new Voucher" do
        assigns(:voucher).should be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
      it "responds with json" do
        expect(JSON.parse(response.body)).to have_key('voucher')
      end
    end

    describe "with invalid params" do
      before(:each) do
        post :create, :voucher => { "user_id" => "" }, :format => :json
      end
      it "assigns a newly created but unsaved activity as @voucher" do
        assigns(:voucher).should be_a_new(Voucher)
      end
      it "dos not persist the voucher" do
        assigns(:voucher).should_not be_persisted
      end
      it "responds with status 422" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PUT redeem" do
    context "not already redeemed" do
      before(:each) do
        Voucher.should_receive(:find).and_return(@voucher)
      end
      it "returns 200" do
        put :redeem, id: @voucher.id, format: :json
        expect(response.status).to eq(204)
      end
      it "sets redeemed_at to DateTime.now" do
        expect {
          put :redeem, id: @voucher.id, format: :json
        }.to change{@voucher.redeemed_at}.from(nil)
      end
    end
    context "already redeemed" do
      before {
        @voucher.should_receive(:redeemed_at).and_return(DateTime.now - 1.hour)
        Voucher.should_receive(:find).and_return(@voucher)
        put :redeem, id: @voucher.id, format: :json
      }
      it "returns 422" do
        expect(response.status).to eq(422)
      end
      it "returns errors" do
        response.body.should eq("{\"errors\":{\"base\":[\"has already been redeemed\"]}}")
      end
    end
    context "transaction_id nil" do
      before {
        @voucher.stub(:transaction_id).and_return(nil)
      }
      it "returns 422" do
        @voucher.should_receive(:redeemed_at).and_return(nil)
        Voucher.should_receive(:find).and_return(@voucher)
        put :redeem, id: @voucher.id, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET by_user' do
    before do
      get :by_user, user_id: @current_user.id, format: :json
    end

    it "should return 200" do
      response.status.should eq(200)
    end
  end
end

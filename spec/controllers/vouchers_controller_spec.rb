require 'spec_helper'

describe VouchersController do
  
  before(:each) do
    @voucher = Fabricate(:voucher)
  end
  
  let(:valid_attributes) { Fabricate.attributes_for(:voucher) }
  
  describe "GET index" do
    it "assigns all vouchers as @vouchers" do
      get :index, {}
      assigns(:redeemable_vouchers ).should eq([@voucher])
    end
  end

  describe "GET show" do
    it "assigns the requested voucher as @voucher" do
      get :show, {:id => @voucher.to_param}
      assigns(:voucher).should eq(@voucher)
    end
  end

  describe "GET new" do
    it "assigns a new voucher as @voucher" do
      get :new, {}
      assigns(:voucher).should be_a_new(Voucher)
    end
  end

  describe "GET edit" do
    it "assigns the requested voucher as @voucher" do
      get :edit, {:id => @voucher.to_param}
      assigns(:voucher).should eq(@voucher)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Voucher" do
        expect {
          post :create, {:voucher => valid_attributes}
        }.to change(Voucher, :count).by(1)
      end

      it "assigns a newly created voucher as @voucher" do
        post :create, {:voucher => valid_attributes}
        assigns(:voucher).should be_a(Voucher)
        assigns(:voucher).should be_persisted
      end

      it "redirects to the created voucher" do
        post :create, {:voucher => valid_attributes}
        response.should redirect_to(Voucher.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved voucher as @voucher" do
        # Trigger the behavior that occurs when invalid params are submitted
        Voucher.any_instance.stub(:save).and_return(false)
        post :create, {:voucher => { "redeemed_at" => "invalid value" }}
        assigns(:voucher).should be_a_new(Voucher)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Voucher.any_instance.stub(:save).and_return(false)
        post :create, {:voucher => { "redeemed_at" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested voucher" do
        # Assuming there are no other vouchers in the database, this
        # specifies that the Voucher created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Voucher.any_instance.should_receive(:update).with({ "redeemed_at" => "false" })
        put :update, {:id => @voucher.to_param, :voucher => { "redeemed_at" => "false" }}
      end

      it "assigns the requested voucher as @voucher" do
        put :update, {:id => @voucher.to_param, :voucher => valid_attributes}
        assigns(:voucher).should eq(@voucher)
      end

      it "redirects to the voucher" do
        put :update, {:id => @voucher.to_param, :voucher => valid_attributes}
        response.should redirect_to(@voucher)
      end
    end

    describe "with invalid params" do
      it "assigns the voucher as @voucher" do
        # Trigger the behavior that occurs when invalid params are submitted
        Voucher.any_instance.stub(:save).and_return(false)
        put :update, {:id => @voucher.to_param, :voucher => { "redeemed_at" => "invalid value" }}
        assigns(:voucher).should eq(@voucher)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Voucher.any_instance.stub(:save).and_return(false)
        put :update, {:id => @voucher.to_param, :voucher => { "redeemed_at" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested voucher" do
      expect {
        delete :destroy, {:id => @voucher.to_param}
      }.to change(Voucher, :count).by(-1)
    end

    it "redirects to the vouchers list" do
      delete :destroy, {:id => @voucher.to_param}
      response.should redirect_to(vouchers_url)
    end
  end

end

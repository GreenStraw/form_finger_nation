require 'spec_helper'
require 'stripe_mock'

describe Api::V1::ChargesController do
  let(:user) { Fabricate(:user) }
  let(:package) { Fabricate(:package) }
  let(:party) { Fabricate(:party) }
  before { StripeMock.start }
  after { StripeMock.stop }
  before(:each) do
    create_new_tenant
    party
    package
    user
    @single_package_purchase = {user_id: user.id, amount: 500.00, purchases: [
                                {package_id: package.id, party_id: party.id}
                                ]}
    @single_package_purchase_low_amount = {user_id: user.id, amount: 50.00, purchases: [
                                {package_id: package.id, party_id: party.id}
                                ]}
    @stripe_customer = {
              "id"=> "test_cus_1",
              "email"=> "foo24@example.com",
              "description"=> "an auto-generated stripe customer data mock",
              "object"=> "customer",
              "created"=> 1372126710,
              "livemode"=> false,
              "delinquent"=> false,
              "discount"=> nil,
              "account_balance"=> 0,
              "cards"=> {"object"=>"list","count"=>0,"url"=>"/v1/customers/test_cus_1/cards","data"=>[]},
              "subscriptions"=> {"object"=>"list","count"=>0,"url"=>"/v1/customers/test_cus_1/subscriptions","data"=>[]},
              "default_card"=> nil,
              "card"=> nil
            }
    @stripe_charge = {
            "id"=> "test_ch_1",
            "object"=> "charge",
            "created"=> 1366194027,
            "livemode"=> false,
            "paid"=> true,
            "amount"=> "500.0",
            "currency"=> "usd",
            "refunded"=> false,
            "fee"=> 0,
            "fee_details"=> [

            ],
            "card"=> {"object"=>"card","last4"=>"4242","type"=>"Visa","exp_month"=>12,"exp_year"=>2013,"fingerprint"=>"3TQGpK9JoY1GgXPw","country"=>"US","name"=>"name","address_line1"=>nil,"address_line2"=>nil,"address_city"=>nil,"address_state"=>nil,"address_zip"=>nil,"address_country"=>nil,"cvc_check"=>nil,"address_line1_check"=>nil,"address_zip_check"=>nil},
            "captured"=> true,
            "failure_message"=> nil,
            "amount_refunded"=> 0,
            "customer"=> "test_cus_1",
            "invoice"=> nil,
            "description"=> "Foam Finger Nation",
            "dispute"=> nil
          }
  end

  describe "build_user_purchased_packages(user, purchases)" do
    before {
      user.ensure_authentication_token!
      @purchases = [{package_id: package.id, party_id: party.id}, {package_id: '5', party_id: '6'}]
    }
    it "should call UserPurchasedPackage for each purchase" do
      UserPurchasedPackage.should_receive(:new).with(:user_id=>user.id, :package_id=>@purchases.first[:package_id], :party_id=>@purchases.first[:party_id])
      UserPurchasedPackage.should_receive(:new).with(:user_id=>user.id, :package_id=>'5', :party_id=>'6')
      subject.send(:build_user_purchased_packages, user, @purchases)
    end
  end

  describe "POST create" do
    context 'user not authenticated' do
      before {
        user.ensure_authentication_token!
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :charge => @single_package_purchase
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'user is authorized' do
      before(:each) do
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
      end
      context 'user is not current_user' do
        before {
          another_user = Fabricate(:user)
          subject.stub(:current_user).and_return(another_user)
          xhr :post, :create, :charge => @single_package_purchase
        }

        it 'returns http 422' do
          response.response_code.should == 422
        end
      end
      context 'amount is less than 1 dollar' do
        before {
          subject.stub(:current_user).and_return(user)
          xhr :post, :create, :charge => @single_package_purchase_low_amount
        }

        it 'returns http 422' do
          response.response_code.should == 422
        end
      end
      context 'purchases are empty' do
        before {
          subject.stub(:current_user).and_return(user)
          xhr :post, :create, :charge => {user_id: user.id, amount: 50, purchases: []}
        }

        it 'should not call build_user_package_purchases' do
          subject.should_not_receive(:build_user_package_purchases)
        end
        it 'returns http 422' do
          response.response_code.should == 422
        end
      end
      context 'user, amount, purchases ok' do
        context 'user customer_id is empty' do
          it "calls Stripe::Customer.create and creates the user's customer_id" do
            subject.stub(:current_user).and_return(user)
            User.should_receive(:find_by_id).with(user.id.to_s).and_return(user)
            user.update_attribute(:customer_id, nil)
            Stripe::Customer.should_receive(:create).and_return(@stripe_customer)
            user.should_receive(:update_attribute).with(:customer_id, "test_cus_1")
            xhr :post, :create, :charge => @single_package_purchase
          end

          it "calls Stripe::Charge.create with the correct stuff" do
            subject.stub(:current_user).and_return(user)
            User.should_receive(:find_by_id).with(user.id.to_s).and_return(user)
            Stripe::Charge.should_receive(:create).with(customer: "test_cus_1",
                                                        amount: "500.0",
                                                        description: 'Foam Finger Nation',
                                                        currency: 'usd').and_return(@stripe_charge)
            xhr :post, :create, :charge => @single_package_purchase
          end
        end
        context 'user customer_id exists' do
          it 'should call Stripe::Customer.retrieve' do
            subject.stub(:current_user).and_return(user)
            user.update_attribute(:customer_id, "test_cus_1")
            Stripe::Customer.should_receive(:retrieve).with("test_cus_1").and_return(@stripe_customer)
            xhr :post, :create, :charge => @single_package_purchase
          end
        end

        context 'customer not created is declined' do
          it 'returns card_declined error' do
            # Prepares an error for the next create charge request
            StripeMock.prepare_card_error(:card_declined)

            expect { Stripe::Charge.create }.to raise_error {|e|
              expect(e).to be_a Stripe::CardError
              expect(e.http_status).to eq(402)
              expect(e.code).to eq('card_declined')
            }
            xhr :post, :create, :charge => @single_package_purchase
          end
        end

        context 'card is declined' do
          it 'returns card_declined error' do
            # Prepares an error for the next create charge request
            StripeMock.prepare_card_error(:card_declined)

            expect { Stripe::Charge.create }.to raise_error {|e|
              expect(e).to be_a Stripe::CardError
              expect(e.http_status).to eq(402)
              expect(e.code).to eq('card_declined')
            }
            xhr :post, :create, :charge => @single_package_purchase
          end
        end
      end
    end
  end
end

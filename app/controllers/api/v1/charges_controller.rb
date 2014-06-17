class Api::V1::ChargesController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!

  def new
  end

  def create
    @user = current_user
    # Amount in cents
    @amount = charge_params[:amount]
    @user = User.find_by_id(charge_params[:user_id])
    purchases = charge_params[:purchases]

    if @user.blank? || @user != current_user || @amount.to_i < 100 || purchases.blank?
      return render json: {}, status: 422
    end

    @purchased_packages = build_user_purchased_packages(@user, purchases)

    if @user.customer_id.blank?
      customer = Stripe::Customer.create(
        :email => @user.email,
        :card  => charge_params[:stripeToken]
      )
      @user.update_attribute(:customer_id, customer["id"])
    else
      customer = Stripe::Customer.retrieve(@user.customer_id)
    end

    charge = Stripe::Charge.create(
      :customer    => customer["id"],
      :amount      => @amount,
      :description => 'Foam Finger Nation',
      :currency    => 'usd'
    )

    @purchased_packages.each do |purchased_package|
      purchased_package.charge_id = charge["id"]
      purchased_package.save
    end

    return render json: {}

  rescue Stripe::CardError, Stripe::ApiError => e
    return render json: { :errors => [@e.message] }, status: 422
  end

  private

  def build_user_purchased_packages(user, purchases)
    purchased_packages = []
    purchases.each do |purchase|
      purchased_packages << UserPurchasedPackage.new(
        user_id: user.id,
        package_id: purchase[:package_id],
        party_id: purchase[:party_id] || nil
      )
    end
    purchased_packages
  end

  def charge_params
    params.require(:charge).permit(:amount, :user_id, :stripeToken, { :purchases=>[{}] })
  end

end

class VoucherSerializer < BaseSerializer
  attributes :redeemed_at, :transaction_display_id, :transaction_id
  has_one :user, embed: :ids
  has_one :package, embed: :ids

  private

  def redeemed_at
    if object.redeemed_at.present?
      object.redeemed_at.to_i
    else
      nil
    end
  end
end

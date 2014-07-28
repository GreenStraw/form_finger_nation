class PackageSerializer < ImageSerializer
  attributes :name, :description, :price, :is_public, :voucher_count
  has_many :parties, embed: :ids
  has_many :vouchers, embed: :ids
  has_one :venue, embed: :ids

  private

  def voucher_count
    object.vouchers.count
  end
end

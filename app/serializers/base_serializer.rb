class BaseSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object
  attributes :id, :created_at, :updated_at

  private

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end

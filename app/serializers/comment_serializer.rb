class CommentSerializer < ActiveModel::Serializer
  attributes :id, :title, :subject, :body, :parent_id, :created_at, :commenter_name
  has_many :children, key: :children, root: :children
  has_one :commentable, key: :commentable, root: :commentable
  has_one :commenter, key: :commenter, root: :commenter

  def commenter_name
    case object.commenter_type
    when 'User'
      return User.find_by_id(object.commenter_id).username
    when 'Venue'
      return Venue.find_by_id(object.commenter_id).name
    end
  end
end

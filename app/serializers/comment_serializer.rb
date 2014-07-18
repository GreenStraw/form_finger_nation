class CommentSerializer < BaseSerializer
  attributes :title, :subject, :body, :parent_id, :created_at, :commenter_name
  has_many :children, embed: :ids
  has_one :commentable, embed: :ids
  has_one :commenter, embed: :ids

  private

  def commenter_name
    case object.commenter_type
    when 'User'
      return User.find_by_id(object.commenter_id).username
    when 'Venue'
      return Venue.find_by_id(object.commenter_id).name
    end
  end
end

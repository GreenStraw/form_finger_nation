Fabricator(:comment) do
  title { sequence(:title) { |i| "Comment Title #{i}"} }
  body { sequence(:body) { |i| "Comment Body #{i}"} }
  subject { sequence(:subject) { |i| "Comment Subject #{i}"} }
end

Fabricator(:party_comment, from: :comment) do
  commentable { Fabricate(:party) }
end

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer
#  commentable_type :string(255)
#  commenter_id     :integer
#  commenter_type   :string(255)
#  title            :string(255)
#  body             :text
#  subject          :string(255)
#  parent_id        :integer
#  lft              :integer
#  rgt              :integer
#  created_at       :datetime
#  updated_at       :datetime
#

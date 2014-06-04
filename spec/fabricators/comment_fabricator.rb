Fabricator(:comment) do
  title { sequence(:title) { |i| "Comment Title #{i}"} }
  body { sequence(:body) { |i| "Comment Body #{i}"} }
  subject { sequence(:subject) { |i| "Comment Subject #{i}"} }
end

Fabricator(:party_comment, from: :comment) do
  commentable_type 'Party'
end

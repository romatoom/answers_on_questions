class QuestionSerializer < ActiveModel::Serializer
  include ListOfFiles
  include ListOfLinks

  attributes :id, :title, :body, :created_at, :updated_at
  has_many :comments, each_serializer: CommentSerializer
  belongs_to :author, serializer: UserSerializer
end

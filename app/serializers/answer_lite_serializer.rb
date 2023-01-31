class AnswerLiteSerializer < ActiveModel::Serializer
  include ListOfLinks

  attributes :id, :body, :created_at, :updated_at
end


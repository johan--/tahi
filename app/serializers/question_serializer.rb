class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :ident, :question, :answer, :additional_data
  has_one :question_attachment, embed: :id, include: true
  has_one :task, embed: :id, polymorphic: true
end

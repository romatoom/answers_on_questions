module CommenteableHelper
  def link_for_commenteable(commenteable_type:, commenteable_id:, comment_id:)
    #resource_name = commenteable_type.downcase
    question = commenteable_type == "Question" ?
      Question.find(commenteable_id) :
      Answer.find(commenteable_id).question

    link_to "Show comment", "#{question_path(question)}#comment_#{comment_id}", target: 'blank'
  end
end

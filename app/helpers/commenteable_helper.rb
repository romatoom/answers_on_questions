module CommenteableHelper
  def link_for_commenteable(commenteable_type:, commenteable_id:)
    resource_name = commenteable_type.downcase

    link_to "Open #{resource_name}", send("#{resource_name}_path", commenteable_id)
  end
end

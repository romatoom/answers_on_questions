module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commenteable
  end

  def add_comment
    ###
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def voteable_path
    send("#{controller_name.singularize}_path".to_sym, @commenteable)
  end

  def set_voteable
    @commenteable = model_klass.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", @commenteable)
  end
end

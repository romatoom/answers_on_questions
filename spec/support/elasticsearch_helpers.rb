module ElasticsearchHelpers
  def models_import
    SearchService::MODELS.each do |model|
      model.import
      model.__elasticsearch__.refresh_index!
    end
  end
end


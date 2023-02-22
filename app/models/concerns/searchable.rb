module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    before_save :force_index

    index_name [Rails.env, model_name.collection].join('_')

    def force_index
      __elasticsearch__.instance_variable_set(:@__changed_model_attributes, nil)
    end
  end
end



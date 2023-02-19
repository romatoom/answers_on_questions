module Searchable
  module Users
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks

      before_save :force_index

      settings index: { number_of_shards: 1 } do
        mapping dynamic: false do
          indexes :id, type: :integer
          indexes :email, type: :text
        end
      end

      def as_indexed_json(options = {})
        self.as_json(
          only: [:id, :email],
        )
      end

      def force_index
        __elasticsearch__.instance_variable_set(:@__changed_model_attributes, nil)
      end
    end
  end
end



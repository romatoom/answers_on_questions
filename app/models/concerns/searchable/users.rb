module Searchable
  module Users
    extend ActiveSupport::Concern

    included do
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
    end
  end
end



module Searchable
  module Answers
    extend ActiveSupport::Concern

    included do
      settings index: { number_of_shards: 1 } do
        mapping dynamic: false do
          indexes :id, type: :integer
          indexes :body, type: :text
          indexes :author do
            indexes :id, type: :integer
            indexes :email, type: :text
          end
        end
      end

      def as_indexed_json(options = {})
        self.as_json(
          only: [:id, :body],
          include: {
            author: {
              only: [:email]
            },
            question: {
              only: [:id]
            }
          }
        )
      end
    end
  end
end



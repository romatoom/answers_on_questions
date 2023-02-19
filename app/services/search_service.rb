class SearchService
  MODELS = [
    User,
    Question,
    Answer,
    Comment
  ]

  RESULT_LIMIT = 10000
  BOOST = 5
  FIELDS = [
    'title',
    'body',
    'email',
    'author.email'
  ]

  attr_reader :search_params

  def self.call(search_params)
    service = new(search_params)
    pp service.models_for_search
    Elasticsearch::Model.search(service.search_settings, service.models_for_search)
  end

  def initialize(search_params)
    @search_params = search_params
  end

  def search_settings
    fuzziness = search_params['fuzziness'] ? "AUTO" : 0
    query_str = search_params['query'] || ''

    {
      size: RESULT_LIMIT,

      query: {
        multi_match: {
          query: query_str,
          boost: BOOST,
          fuzziness: fuzziness,
          fields: FIELDS,
          operator: 'and'
        }
      },

      highlight: {
        pre_tags: ['<em class="highlight">'],
        post_tags: ['</em>'],
        fields: highlight_fields
      }
    }
  end

  def models_for_search
    MODELS.filter do |model|
      search_params["search_#{model.to_s.downcase.pluralize}"] == '1'
    end
  end

  private

  def highlight_fields
    FIELDS.each_with_object({}) { |k, h| h[k] = {} }
  end
end

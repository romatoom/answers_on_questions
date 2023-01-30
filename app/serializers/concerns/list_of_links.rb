module ListOfLinks
  extend ActiveSupport::Concern

  included do
    attributes :list_of_links
  end

  def list_of_links
    object.links.map { |f| { name: f.name, url: f.url } }
  end
end

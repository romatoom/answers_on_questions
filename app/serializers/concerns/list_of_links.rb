module ListOfLinks
  extend ActiveSupport::Concern

  included do
    attributes :list_of_links
  end

  def list_of_links
    object.links.map { |l| { id: l.id, name: l.name, url: l.url } }
  end
end

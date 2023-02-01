module ListOfFiles
  extend ActiveSupport::Concern

  included do
    attributes :list_of_files
  end

  def list_of_files
    object.files.map { |f| { name: f.filename.to_s, url: f.url } }
  end
end

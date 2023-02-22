module SearchHelper
  def search_chechbox_checked?(search_params, search_key, default: true)
    search_params['query'].nil? || (search_params[search_key.to_s].present? == default) ? default : !default
  end

  def search_template_by_index(index = "development_users")
    index.split('_').last
  end
end

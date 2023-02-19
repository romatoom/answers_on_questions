module SearchHelper
  def search_chechbox_checked?(search_params, search_key)
    search_params['query'].empty? || search_params[search_key.to_s]
  end
end

class RedirectRoutingController < ActionController::Base
  def redirect
    options = params[:args].extract_options!
    status = options.delete(:permanent) == true ? :moved_permanently : :found
    url_options = params[:args].first || options
    
    if path_to_keep = options[:keep_path] and params[path_to_keep].present?
      raise ArgumentError, "Redirect target should be a String when using the :keep_path option" unless url_options.is_a?(String)
      parsed_url = URI.parse url_options
      parsed_url.path = ([parsed_url.path] + params[path_to_keep]).join '/'
      url_options = parsed_url.to_s
    end
    
    if params[:format].present?
      case url_options
      when String
        url_options << ".#{params[:format]}"
      when Hash
        url_options[:format] = params[:format]
      end
    end
    
    redirect_to url_options, :status => status
  end
end

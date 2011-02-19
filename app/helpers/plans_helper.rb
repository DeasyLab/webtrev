module PlansHelper
  def pagination_links_remote(paginator, action)
    page_options = {:window_size => 1}
    pagination_links_each(paginator, page_options) do |n|
      options = {
        :url => {:action => 'list', :params => @params.merge({:page => n})},
        :update => 'planList',
        :before => "Element.show('spinnerLM')",
        :success => "Element.hide('spinnerLM')"
      }
      html_options = {:href => url_for(:action => '#{action}', :params => @params.merge({:page => n}))}
      link_to_remote(n.to_s, options, html_options)
    end
  end
  
  def sort_td_class_helper(param)
    result = 'class="sortup"' if @params[:sort] == param
    result = 'class="sortdown"' if @params[:sort] == param + "_reverse"
    return result
  end
  
  def sort_link_helper(text, param, action)
    key = param
    key += "_reverse" if @params[:sort] == param
    options = {
      :url => {:action => 'list', :params => @params.merge({:sort => key, :page => nil})},
      :update => 'planList',
      :before => "Element.show('spinnerLM')",
      :success => "Element.hide('spinnerLM')"
    }
    html_options = {
      :title => "Sort by this field",
      :href => url_for(:action => '#{action}', :params => @params.merge({:sort => key, :page => nil}))
    }
    link_to_remote(text, options, html_options)
  end
end

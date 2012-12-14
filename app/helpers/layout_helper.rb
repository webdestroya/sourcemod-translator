module LayoutHelper
  
  def page_heading(heading, tagline=nil)
    @g_page_heading = heading
    @g_page_tagline = tagline
  end
  
  def title(page_title)
    content_for(:title) { h(page_title.to_s) }
  end
  
  
  def icon_button(icon, text)
    content_tag(:i, nil, class: "icon #{icon}")+" #{text}".html_safe
  end
  
  
  # Only need this helper once, it will provide an interface to convert a block into a partial.
    # 1. Capture is a Rails helper which will 'capture' the output of a block into a variable
    # 2. Merge the 'body' variable into our options hash
    # 3. Render the partial with the given options hash. Just like calling the partial directly.
  def block_to_partial(partial_name, options = {}, &block)
    options.merge!(:body => capture(&block))
    #concat(render(:partial => partial_name, :locals => options), block.binding)
    #puts block.binding.to_s
    render(:partial => partial_name, :locals => options)
  end
  
  def error_box(options = {}, &block)
    block_to_partial('bootstrap/alert', options.merge(:css_class => "alert-error"), &block)
  end
  def success_box(options = {}, &block)
    block_to_partial('bootstrap/alert', options.merge(:css_class => "alert-success"), &block)
  end
  def warning_box(options = {}, &block)
    block_to_partial('bootstrap/alert', options.merge(:css_class => "alert-warning"), &block)
  end
  def info_box(options = {}, &block)
    block_to_partial('bootstrap/alert', options.merge(:css_class => "alert-info"), &block)
  end
  
  
end
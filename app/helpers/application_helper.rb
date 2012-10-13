module ApplicationHelper

  def body_class
    classes = []
    classes << params[:controller].parameterize
    classes << params[:action].parameterize
    classes << @body_class if @body_class
    classes.join(' ')
  end

  def title(text, options = {})
    content_for(:title, text)
    "<h1 class='main-heading'>#{text}</h1>".html_safe unless options[:visible] == false
  end

  def error_messages_for(object)
    render(partial: 'shared/error_messages', locals: { object: object })
  end

  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    syntax_highlighter(Redcarpet.new(text, *options).to_html).html_safe
  end

end

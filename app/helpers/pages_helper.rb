module PagesHelper
  def conditional_nav_tag(&block)
    classes = %w(navbar navbar-fixed-top)
    classes << "home" if params[:controller] == "pages" && params[:action] == "home"
    content_tag :div, {class: classes, role: "navigation"}, &block
  end
end

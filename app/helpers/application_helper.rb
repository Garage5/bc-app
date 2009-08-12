# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def button_link_to(text, href, icon = '', options = {})
    link_to("<span class='icon'></span><span>#{text}</span>", href, {:class => 'btn'}.merge(options))
  end

end

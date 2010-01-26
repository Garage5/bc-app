# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def button_link_to(text, href, icon = '', options = {})
    link_to("#{text}", href, {:class => 'modal_btn'}.merge(options))
  end

  def flash_notices
    [:notice, :error].collect {|type| content_tag('div', flash[type], :id => type) if flash[type] }
  end
  
  # Render a submit button and cancel link
  def submit_or_cancel(cancel_url = session[:return_to] ? session[:return_to] : url_for(:action => 'index'), label = 'Save Changes')
    content_tag(:div, submit_tag(label) + ' or ' +
      link_to('Cancel', cancel_url), :id => 'submit_or_cancel', :class => 'submit')
  end

  def discount_label(discount)
    (discount.percent? ? number_to_percentage(discount.amount * 100, :precision => 0) : number_to_currency(discount.amount)) + ' off'
  end
  
  def relative_date_or_formatted(date)
    return 'Today' if date.to_date == Date.today
    return 'Yesterday' if date.to_date == Date.today - 1
    return date.strftime('%B %e, %Y')
  end
end

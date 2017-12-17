module ApplicationHelper
  def nav_link(link_text, link_path)
    class_name = "nav-item #{current_page?(link_path) ? 'active ' : ''}"

    content_tag(:li, class: class_name) do
      link_to link_text, link_path, class: 'nav-link'
    end
  end

  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
    when :success
      'alert-success'
    when :error
      'alert-error'
    when :alert
      'alert-danger'
    when :notice
      'alert-info'
    else
      flash_type.to_s
    end
  end

  def age(d)
    now = Time.now.utc.to_date
    # d = friend.birthday
    now.year - d.year - (now.month > d.month || (now.month == d.month && now.day >= d.day) ? 0 : 1)
  end

  def errors_for(object)
    if object.errors.any?
      content_tag(:div, class: 'alert alert-danger') do
        concat(content_tag(:h4, class: 'alert-heading') do
          concat "#{pluralize(object.errors.count, 'erreur')} à corriger:"
        end)
        object.errors.full_messages.each do |msg|
          concat content_tag(:p, msg, class: 'm-0')
        end
      end
    end
  end
end

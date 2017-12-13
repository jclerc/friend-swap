module ApplicationHelper
  def nav_link(link_text, link_path)
    class_name = "nav-item #{current_page?(link_path) ? 'active ' : ''}"

    content_tag(:li, class: class_name) do
      link_to link_text, link_path, class: 'nav-link'
    end
  end

  def bootstrap_class_for flash_type
    case flash_type.to_sym
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end
end

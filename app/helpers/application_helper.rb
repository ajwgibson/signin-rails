module ApplicationHelper

  def yes_no_icon(value)
    if value then
      content_tag(:span, " ", class: ["fa", "fa-check", "text-success"])
    else
      content_tag(:span, " ", class: ["fa", "fa-times", "text-danger"])
    end
  end


  def import_status(value)
    style = 'default'
    style = 'info'    if value.running?
    style = 'success' if value.complete? && value.error_count == 0
    style = 'danger'  if value.complete? && value.error_count > 0
    content_tag(:span, value.status.titlecase, class: ["label", "label-#{style}"])
  end


  #
  # Toastr messages used for application flashes
  #
  ALERT_TYPES = [:success, :info, :warning, :error] unless const_defined?(:ALERT_TYPES)

  def toastr_flash(options = {})

    flash_messages = []

    flash.each do |type, message|

      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :info    if type == :alert
      type = :error   if type == :error
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div, msg, "data-toastr-type" => type, :class => "toastr-message hidden")
        flash_messages << text if msg
      end
    end

    flash_messages.join("\n").html_safe
  end

end

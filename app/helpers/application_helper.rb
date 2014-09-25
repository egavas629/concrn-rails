module ApplicationHelper
  def row_style(status)
    case status
    when 'rejected'
      'danger'
    when 'pending'
      'warning'
    when 'archived'
      'info'
    when 'completed'
      'success'
    when 'unassigned'
      'warning'
    end
  end

  def urgency_label(urgency)
    Report::URGENCY_LABELS[urgency.to_i + 1]
  end

  def google_maps(address)
    "https://maps.google.com/?q=#{address}"
  end

end

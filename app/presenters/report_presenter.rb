class ReportPresenter < BasePresenter
  presents :report

  def freshness
    minutes_ago = ((Time.now - report.created_at) / 60).round
    case minutes_ago
    when 0..2
      'fresh'
    when 3..4
      'semi-fresh'
    when 5..9
      'stale'
    else
      'old'
    end
  end

  def google_maps_address
    "https://maps.google.com/?q=#{report.address}"
  end
end

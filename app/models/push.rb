class Push
  def self.refresh
    Pusher.trigger('reports-responders' , "refresh", {})
  end

  def self.update_transcript(report_id, log)
    Pusher.trigger("report-#{report_id}", "message", {'inner_html' => LogPresenter.new(log).inner_html, 'id' => log.id})
  end
end

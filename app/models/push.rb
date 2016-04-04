class Push
  def self.refresh
    return Rails.logger.info("skipping pusher refresh") if Rails.env.test?

    Pusher.trigger('reports-responders' , "refresh", {})
  end

  def self.update_transcript(report_id, log)
    return Rails.logger.info("skipping pusher update_transcript(#{report_id}, '#{log.inspect}')") if Rails.env.test?

    Pusher.trigger("report-#{report_id}", "message", {'inner_html' => LogPresenter.new(log).inner_html, 'id' => log.id})
  end
end

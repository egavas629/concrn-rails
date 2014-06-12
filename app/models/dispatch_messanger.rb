class DispatchMessanger

  def initialize(responder, body=nil)
    @responder = responder
    @body      = body
    @dispatch  = responder.latest_dispatch
    @report    = @dispatch.report
  end

  def notify_responder
    responder_synopses.each { |snippet| Telephony.send(body: snippet, to: @responder.phone) }
  end

  def respond
    give_feedback
    if @dispatch.pending? && @body.match(/no/i)
      reject!
    elsif @dispatch.accepted? && @body.match(/done/i)
      complete!
    elsif !@dispatch.accepted? && !@dispatch.completed?
      accept!
    end
    update_dispatch
  end

private

  def acknowledge_acceptance
    Telephony.send(body: "You have been assigned to an incident at #{@report.address}.", to: @responder.phone)
  end

  def acknowledge_rejection
    Telephony.send(body: "We appreciate your timely rejection. Your report is being re-submitted.", to: @responder.phone)
  end

  def accept_feedback(opts={})
    @report.logs.create!(author: opts[:from], body: opts[:body])
  end

  def give_feedback
    accept_feedback(from: @responder, body: @body)
  end

  def accept!
    @dispatch.update_attributes!(status: 'accepted')
    acknowledge_acceptance
    notify_reporter
  end

  def complete!
    @dispatch.update_attributes!(status: 'completed')
    @report.complete!
    thank_responder
    thank_reporter
  end

  def reject!
    @dispatch.update_attributes!(status: 'rejected')
    acknowledge_rejection
  end

  def notify_reporter
    Telephony.send(body: reporter_synopsis, to: @report.phone)
  end

  def responder_synopses
    [
      report.address,
      "Reporter: #{[@report.name, @report.phone].delete_if(&:empty?).join(', ')}",
      "#{[@report.race, @report.gender, @report.age].delete_if(&:empty?).join('/')}",
      @report.setting,
      @report.nature
    ]
  end

  def reporter_synopsis
    <<-SMS
    INCIDENT RESPONSE:
    #{@responder.name} is on the way.
    #{@responder.phone}
    SMS
  end

  def thank_responder
    Telephony.send(body: "Thanks for your help. You are now available to be dispatched.", to: @responder.phone)
  end

  def thank_reporter
    Telephony.send(body: "Report resolved, thanks for being concrned!", to: @report.phone)
  end

  def update_dispatch
    Pusher.trigger("reports" , "refresh", @report)
  end
end

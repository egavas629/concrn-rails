class DispatchMessanger

  def initialize(responder)
    @responder = responder
    @dispatch  = responder.dispatches.latest
    @report    = @dispatch.report if @dispatch.present? && !@dispatch.completed?
  end

  def respond(body)
    if defined?(@report)
      give_feedback(body)
      if @dispatch.pending? && body.match(/no/i)
        @dispatch.update_attributes!(status: 'rejected')
      elsif @dispatch.accepted? && body.match(/done/i)
        @dispatch.update_attributes!(status: 'completed')
      elsif @responder.available && body.match(/break/i)
        @responder.update_attributes!(availability: false)
      elsif !@responder.available && body.match(/on/i)
        @responder.update_attributes!(availability: true)
      elsif !@dispatch.accepted? && !@dispatch.completed?
        @dispatch.update_attributes!(status: 'accepted')
      end
    else
      if @responder.available && body.match(/break/i)
        @responder.update_attributes!(availability: false)
      elsif !@responder.available && body.match(/on/i)
        @responder.update_attributes!(availability: true)
      end
    end
  end

  def accept!
    acknowledge_acceptance
    notify_reporter
    update_dispatch
  end

  def complete!
    @report.complete!
    thank_responder
    thank_reporter
    update_dispatch
  end

  def pending!
    responder_synopses.each { |snippet| Telephony.send(snippet, @responder.phone) }
  end

  def reject!
    acknowledge_rejection
    update_dispatch
  end

private

  def acknowledge_acceptance
    Telephony.send("You have been assigned to an incident at #{@report.address}.", @responder.phone)
  end

  def acknowledge_rejection
    Telephony.send("We appreciate your timely rejection. Your report is being re-submitted.", @responder.phone)
  end

  def give_feedback(body)
    @report.logs.create!(author: @responder, body: body)
  end

  def notify_reporter
    Telephony.send(reporter_synopsis, @report.phone)
  end

  def reporter_synopsis
    <<-SMS
    INCIDENT RESPONSE:
    #{@responder.name} is on the way.
    #{@responder.phone}
    SMS
  end

  def responder_synopses
    [
      @report.address,
      "Reporter: #{[@report.name, @report.phone].delete_blank * ', '}",
      "#{[@report.race, @report.gender, @report.age].delete_blank * '/'}",
      @report.setting,
      @report.nature
    ].delete_blank
  end

  def thank_responder
    Telephony.send("Thanks for your help. You are now available to be dispatched.", @responder.phone)
  end

  def thank_reporter
    Telephony.send("Report resolved, thanks for being concrned!", @report.phone)
  end

  def update_dispatch
    Pusher.trigger("reports" , "refresh", @report)
  end
end

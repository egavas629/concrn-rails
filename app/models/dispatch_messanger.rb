class DispatchMessanger

  def initialize(responder)
    @responder = responder
    @dispatch  = responder.dispatches.latest
    @report    = @dispatch.report unless @dispatch.nil?
  end

  def respond(body)
    feedback = true
    if @responder.on_shift? && body.match(/break/i)

      if @dispatch.nil? || @dispatch.completed? || @dispatch.pending?
        @responder.shifts.end!('sms')
        feedback = false
      end
      @dispatch.update_attributes!(status: 'rejected') if @dispatch && @dispatch.pending?

    elsif !@responder.on_shift? && body.match(/on/i)
      @responder.shifts.start!('sms')
      feedback = false
    elsif @dispatch.pending? && body.match(/no/i)
      @dispatch.update_attributes!(status: 'rejected')
    elsif @dispatch.accepted? && body.match(/done/i)
      @dispatch.update_attributes!(status: 'completed')
    elsif !@dispatch.accepted? && !@dispatch.completed?
      @dispatch.update_attributes!(status: 'accepted')
    end
    give_feedback(body) if feedback
  end

  def accept!
    acknowledge_acceptance
    notify_reporter
  end

  def complete!
    @report.complete!
    thank_responder
    thank_reporter
  end

  def pending!
    responder_synopses.each { |snippet| Telephony.send(snippet, @responder.phone) }
  end

  def reject!
    acknowledge_rejection
  end

private

  def acknowledge_acceptance
    Telephony.send("You have been assigned to an incident at #{@report.address}.", @responder.phone)
  end

  def acknowledge_rejection
    Telephony.send("You have been removed from this incident at #{@report.address}. You are now available to be dispatched.", @responder.phone)
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
    Telephony.send("The report is now completed, thanks for your help! You are now available to be dispatched.", @responder.phone)
  end

  def thank_reporter
    Telephony.send("Report resolved, thanks for being concrned!", @report.phone)
  end
end
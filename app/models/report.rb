class Report < ActiveRecord::Base
  belongs_to :responder
  has_one :dispatch

  def self.pending
    joins("left join dispatches d on d.report_id = reports.id").where("d.id is null").order("created_at desc")
  end

  def self.dispatched
    joins(:dispatch).order("created_at desc")
  end

  def responder_synopsis
    <<-SMS
    CRISIS REPORT:
    #{location}
    #{name}
    #{phone}
    SMS
  end


  def reporter_synopsis
    <<-SMS
    CRISIS RESPONSE:
    #{responder.name} is on the way.
    #{responder.phone}
    SMS
  end

  private

  def location
    '265 Dolores Street, San Francisco 94043'
  end


  def dispatched?
    dispatch.present?
  end
end

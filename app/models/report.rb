class Report < ActiveRecord::Base
  belongs_to :responder
  has_one :dispatch

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
    HELP is ON the WAY!
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

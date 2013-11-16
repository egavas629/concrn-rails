class Report < ActiveRecord::Base
  belongs_to :responder

  def synopsis
    <<-SMS
    CRISIS REPORT:
    #{location};
    #{name}:
    #{phone}
    SMS
  end

  private

  def location
    '265 Dolores Street, San Francisco 94043'
  end
end

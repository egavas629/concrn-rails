class Presenter::Report
  attr_reader :report

  def initialize(report)
    @report = report
  end

  def to_h
    report.attributes.merge({
      agency: agency_attributes.slice("name")
    })
  end

  def agency_attributes
    report.agency.try(:attributes) || {}
  end

  def self.present(*args)
    new(*args).to_h
  end
end

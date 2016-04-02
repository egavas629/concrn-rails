class Presenter::Report
  attr_reader :report

  def initialize(report)
    @report = report
  end

  def to_h
    report.attributes
  end

  def self.present(*args)
    new(*args).to_h
  end
end

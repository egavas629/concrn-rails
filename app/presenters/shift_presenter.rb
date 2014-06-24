class ShiftPresenter < BasePresenter
  presents :shift

  def date
    "#{start_day} #{'to ' + end_day if end_day}"
  end

  def time
    "#{shift.start_time.localtime.strftime('%H:%M')} to #{end_time}"
  end

private

  def start_day
    shift.start_time.localtime.strftime('%-m-%-d-%y')
  end

  def end_day
    shift.end_time.localtime.strftime('%-m-%-d-%y') if shift.end_time? && !shift.same_day?
  end

  def end_time
    shift.end_time ? shift.end_time.localtime.strftime('%H:%M') : 'now'
  end
end

# Get internal/external hour split for a given week
class WeeklyTimeReport
  def initialize(date_in_week=Time.zone.now, partial_week=false)
    @date = date_in_week
    @partial_week = partial_week
  end

  def run
    get_weekly_hours(@date)
  end

  def sum_hours(method, hours)
    hours.select{|wu| wu.send(method) }.sum(&:hours)
  end

  def get_weekly_hours(date)
    start_date = date.beginning_of_week.to_date
    if @partial_week
      end_date = date
    else
      end_date = date.end_of_week.to_date
    end
    work_units = WorkUnit.scheduled_between(start_date, end_date)
    { external: sum_hours(:external?, work_units).to_i, internal: sum_hours(:internal?, work_units).to_i }
  end
end

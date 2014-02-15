class Payment < ActiveRecord::Base
  RECURRING = ["Fixed", "Hourly", "Monthly"]
  belongs_to :project

  validates :recurring, inclusion: { in: RECURRING }
  validates :rate, :recurring, :start_date, presence: true #:completed
                                                           #validates :number_of_hours,  uniqueness: true, if: lambda { |p| p.recurring == 'Hourly' }
                                                           #validates :number_of_months, uniqueness: true, if: lambda { |p| p.recurring == 'Monthly' }

  attr_accessible :id, :rate, :recurring, :type, :start_date, :completed, :completed_date, :description, :number_of_hours, :number_of_months, :project_id

  before_save :set_billed_at

  scope :unpaid,  where(completed: false)
  scope :paid,    where(completed: true)
  scope :upcoming_today,     -> { unpaid.where(:start_date => DateTime.now.all_day) }
  scope :upcoming_tomorrow,  -> { unpaid.where(:start_date => (DateTime.now + 1.days).all_day) }
  scope :upcoming_next_week, -> { unpaid.where(:start_date => (DateTime.now + 1.weeks).all_week) }
  scope :sidebar_overdue, unpaid.where(['payments.start_date < ?', DateTime.now.to_s(:db)]).order('start_date DESC').limit(5)

  def total_value
    return rate if recurring == "Fixed"
    return rate * number_of_hours if recurring == "Hourly"
    return rate if recurring == "Monthly"
  end

  def billed_value
    completed ? total_value : 0
  end

  def remaining_value
    completed ? 0 : total_value
  end

  def set_billed_at
    self.billed_at = completed ? Time.now : nil
  end

  class << self
    # Scopes
    def this_month_payments(year, month)
      where(['payments.start_date BETWEEN date(?) and date(?)', DateTime.new(year, month).beginning_of_month.to_s(:db), DateTime.new(year, month).end_of_month.to_s(:db)])
      .order('start_date ASC')
    end

    def next_month_payments(year, month)
      where(['payments.start_date BETWEEN date(?) and date(?)', (DateTime.new(year, month) + 1.months).beginning_of_month.to_s(:db), (DateTime.new(year, month) + 1.months).end_of_month.to_s(:db)])
      .order('start_date ASC')
    end

    def last_5_months_payments(year, month)
      where(['payments.start_date BETWEEN date(?) and date(?)', ((DateTime.new(year, month) - 3.months).beginning_of_month).to_s(:db), ((DateTime.new(year, month) + 1.months).end_of_month).to_s(:db)])
    end

    def filter_by_daterange(r_start, r_end)
      where(['payments.start_date between ? and ?',Date.parse(r_start), Date.parse(r_end)])
    end

    def recent_first
      order('start_date DESC')
    end

    def recent_last
      includes(:project).order('start_date ASC')
    end
  end
end
class PaymentsController < ApplicationController
  inherit_resources
  before_filter :fetch_tabs
  layout 'garden'
  respond_to :js, :html

  def index
    @payments = @organization.payments.recent_last
    filter_payments
  end

  def update
    @is_updated = params[:payment].has_key?(:completed) ? false : true
    @plain = params[:plain_payment]

    if @plain
      filter_payments
    end

    update!
  end

  def create
    @project = @organization.projects.find(params[:project_id])
    if params[:payment][:recurring] == "Monthly"
      payment_data = []
      params[:payment][:number_of_months].to_i.times do |i|
        pdd = params[:payment].dup
        start_date = DateTime.parse(pdd[:start_date]) + i.months
        if pdd[:completed] == '1'
          completed_date = DateTime.parse(pdd[:completed_date]) + i.months
          pdd[:completed_date] = completed_date.to_s
        end
        pdd[:start_date] = start_date.to_s
        payment_data << pdd
      end
      @payments = payment_data.collect{|pd|
        @project.payments.create(pd)
      }
    else
      @payments = [@project.payments.create(params[:payment])]
    end

    @invalid = @payments.select{|x| !x.valid?}
    if @invalid.size > 0
      @errors = @invalid.collect{|x| x.errors.full_messages}.join(",")
    end

    respond_to do |format|
      format.js
    end
  end

  protected
  
    def filter_payments
      @date_range = params[:date_range]
      @status = params[:status]
      
      if @date_range and !@date_range.empty?
        @payments = filter_by_daterange(@date_range)
      else
        @payments = @organization.payments.recent_last
      end
      
      if @status.present?
        st = @status == '1' ? true : false
        @payments = @payments.where(completed: st)
      end
    end
      
    def filter_by_daterange(date_range)
      r_start, r_end = date_range.split(' - ')
      @organization.payments.recent_last.filter_by_daterange(r_start, r_end)
    end
end

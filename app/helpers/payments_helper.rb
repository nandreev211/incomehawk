module PaymentsHelper
  def completed_class(payment)
    payment.completed ? 'payment-completed' : 'payment-not-completed'
  end

  def completed_text(payment)
    payment.completed ? 'Paid' : 'Pending'
  end

  def payment_status_filter_options
    options_for_select([['All', ''], ['Completed', '1'], ['Not completed', '0']])
  end
end
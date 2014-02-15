function changeProjectStatus(projectId, status) {
  var uncompleted = uncompletedPayments()
  if (uncompleted.length != 0) {
    var unvalues = _.map(uncompleted.parent().find('.payment-value'), function(el) {
      return parseInt($(el).html().replace('$',''));
    })
    var valued = _.reduce(unvalues, function(memo, num){ return memo + num; }, 0);
  }

  changingProjectStatus = status;
  if (status == 'Completed' && uncompleted.length != 0) {
    $.fallr('show', {
        buttons : {
            button1 : {text: 'Yes', danger: true, onclick: submitProjectStatus},
            button2 : {text: 'No'},
            button3 : {text: 'Mark all payments as completed', onclick: submitProjectStatusCompletePayments}
        },
        content : '<p>You have '+uncompleted.length+' Uncompleted payments valued at '+valued+' are you sure you want to set project as Completed?</p>',
        icon    : 'error',
        width   : '400'
    });
  } else {
    $.fallr('show', {
        buttons : {
            button1 : {text: 'Yes', danger: true, onclick: submitProjectStatus},
            button2 : {text: 'Cancel'},
        },
        content : '<p>Are you sure?</p>',
        icon    : 'error',
        width   : '400'
    });
  }


}

function submitProjectStatus() {
  $.ajax({
    url: '/projects/'+project_id+'/update_status.js',
    type: 'POST',
    data: {status: changingProjectStatus, update_payments: '0'}
  })
}

function submitProjectStatusCompletePayments() {
  $.ajax({
    url: '/projects/'+project_id+'/update_status.js',
    type: 'POST',
    data: {status: changingProjectStatus, update_payments: '1'}
  })
}

function paymentData() {
  payment = $("#add-payment-type").attr('value')
  paymentType = payment.toLowerCase()

  paymentValue =  $("#input-add-payment-"+paymentType+"-rate-wrapper input").attr('value')
  paymentDateValue = $("#input-add-payment-"+paymentType+"-date-wrapper input").attr('value')
  paymentDescription = $("#input-add-payment-description").attr('value')
  numberOfMonths = $("#input-add-payment-monthly-months-wrapper input").attr('value')
  numberOfHours = $("#input-add-payment-hourly-hours-wrapper input").attr('value')
  paymentCompletedValue = $("#payment-completed-href").is(":checked") ? "1" : "0"

  var data = { project_id: project_id, recurring: payment, rate: paymentValue, start_date: paymentDateValue,
    completed: paymentCompletedValue, description: paymentDescription, number_of_months: numberOfMonths,
    number_of_hours: numberOfHours }

  if (paymentCompletedValue == '1') {
    data['completed_date'] = paymentDateValue
  }

  return data;
}

$(function() {
  blurValidate();
  $("#add-payment-button").die();
  $("#add-payment-button").live('click', function() {
    validatePaymentErrors()
    $('.payment-blur-validate').live({
      blur: function(){ validatePaymentErrors() },
      focus: function(){ validatePaymentErrors() },
      keyup: function(){ validatePaymentErrors() },
      change: function(){ validatePaymentErrors() }
    })
    
    if ($("#add-payment-type").attr('value').length > 0 && $(".field-error").length == 0) {
      data = paymentData()
      $.post("/projects/"+project_id+"/payments",
        {payment: data},
        function (){
          $('.payment-blur-validate').die()
        })
    }
    return false
  })

})
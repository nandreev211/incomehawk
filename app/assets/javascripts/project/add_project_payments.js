$(function() {
  // Functions
  var currentCurrency = function() {
      return $('#organizationCurrency').html();
  }
   
  function hideAllPaymentOptions() {
    $(".fixed-payment-options").hide();
    $(".hourly-payment-options").hide();
    $(".monthly-payment-options").hide();
    $('#input-add-payment-monthly-completed-wrapper').hide();
    $("#input-add-payment-description-wrapper").hide();
    $("#add-payment-button").hide();
  }

  function validatePaymentValues(paymentType, paymentValue, paymentDateValue, numberOfMonths, numberOfHours, paymentDescription) {
    if (paymentValue.length == 0 || !IsNumeric(paymentValue) || paymentDateValue.length == 0)
      return false

    if (paymentType == 'Monthly' && (numberOfMonths.length == 0 || !IsNumeric(numberOfMonths)))
      return false

    if (paymentType == 'Hourly' && (numberOfHours.length == 0 || !IsNumeric(numberOfHours)))
      return false

    return true;
  }

  function addPaymentToList() {
    var newPayment = false
    payment = $("#add-payment-type").attr('value')
    paymentType = payment.toLowerCase()

    paymentValue =  $("#input-add-payment-"+paymentType+"-rate-wrapper input").attr('value')
    paymentDateValue = $("#input-add-payment-"+paymentType+"-date-wrapper input").attr('value')
    paymentDescription = $("#input-add-payment-description").attr('value')
    numberOfMonths = $("#input-add-payment-monthly-months-wrapper input").attr('value')
    numberOfHours = $("#input-add-payment-hourly-hours-wrapper input").attr('value')
    if ($("#payment-completed-href").is(':checked')) {
      paymentCompletedValue = 'payment-completed'
    } else {
      paymentCompletedValue = 'payment-not-completed'
    }

    if (validatePaymentValues(payment, paymentValue, paymentDateValue, numberOfMonths, numberOfHours, paymentDescription)) {
      if (payment == 'Monthly') {
        var currMonth = ''
        for (var i=0; i < numberOfMonths; i++) {
          nextMonth = Date.parse(paymentDateValue).add(i).months().toString("dd MMM yyyy").replace(' ', 'th ')
          nextMonthStr = customFormatString(nextMonth)
          newPayment = createPaymentNode(payment, paymentValue, nextMonthStr, paymentCompletedValue, paymentDescription, paymentDescription)
          $("#payments-list").append(newPayment)
        }
      } else if (payment == "Hourly") {
        newPayment = createPaymentNode(payment, paymentValue, paymentDateValue, paymentCompletedValue, "(" + currentCurrency() + paymentValue+" * "+numberOfHours +") "+ paymentDescription, paymentDescription)
        $("#payments-list").append(newPayment)
      } else {
        newPayment = createPaymentNode(payment, paymentValue, paymentDateValue, paymentCompletedValue, paymentDescription, paymentDescription)
        $("#payments-list").append(newPayment)
      }
        
      clearPaymentValues();
    } else {
      $.ctNotify("Please fill out all the fields", 'error')
    }
  }

  function createPaymentNode(paymentType, paymentRate, paymentDateValue, paymentCompleted, paymentDescription, paymentRealDescription) {
    paymentIterator += 1
    var newPayment = $("<li></li>").addClass("single-payment")
    var paymentTotal = paymentRate

    if (paymentType == "Hourly") {
      var numberOfHours = $("#input-add-payment-hourly-hours-wrapper input").attr('value')
      paymentTotal = paymentRate * numberOfHours
    }

    var timestamp = Date.parse(paymentDateValue).getTime();

    completedIcon = $("<div class='payment-completed-icon'></div>").addClass(paymentCompleted).addClass("input-payment-completed")
    newPayment.append(completedIcon)
    newPayment.append($("<div class='payment-value'></div>").html(currentCurrency() + paymentTotal ))
    newPayment.append($("<div class='payment-name'></div>").html(paymentDescription))
    newPayment.append($("<div class='payment-date'></div>").html(paymentDateValue ))
    newPayment.append($("<div class='payment-type'></div>").html("("+payment+")"))
    newPayment.append($("<a href='#' title='Remove Payment'>Remove Payment</a>").addClass("delete-payment").addClass("delete-button-small"))
    newPayment.append("<div class='sort-order' order='"+timestamp+"'></div>")

    i = paymentIterator
    newPayment.append($("<input type='hidden' name='project[payments_attributes]["+i+"][recurring]' />").attr('value', paymentType))
    newPayment.append($("<input type='hidden' name='project[payments_attributes]["+i+"][rate]' />").attr('value', paymentRate))
    newPayment.append($("<input type='hidden' name='project[payments_attributes]["+i+"][start_date]' />").attr('value', paymentDateValue))
    newPayment.append($("<input type='hidden' name='project[payments_attributes]["+i+"][description]' />").attr('value', paymentRealDescription))
    if (paymentType == "Hourly") {
      var numberOfHours = $("#input-add-payment-hourly-hours-wrapper input").attr('value')
      newPayment.append($("<input type='hidden' name='project[payments_attributes]["+i+"][number_of_hours]' />").attr('value', numberOfHours))
    }

    if (paymentType == "Monthly") {
      var numberOfMonths = $("#input-add-payment-monthly-months-wrapper input").attr('value')
      newPayment.append($("<input type='hidden' name='project[payments_attributes]["+i+"][number_of_months]' />").attr('value', numberOfMonths))
    }

    completed = paymentCompleted == 'payment-completed'
    newPayment.append($("<input type='hidden' name='project[payments_attributes]["+i+"][completed]' />").attr('value', completed ? '1':'0').addClass("payment-completed-value"))
    if (completed)
      newPayment.append($("<input type='hidden' name='project[payments_attributes]["+i+"][completed_date]' />").attr('value', paymentDateValue))

    return newPayment
  }

  function removePaymentFromList(el) {
    el.parent().remove()
  }

  function clearPaymentValues() {
    $("#payment-type").find("input").attr('value', '')
    if ($("#payment-completed-href").is(':checked')) {
      $("#payment-completed-href").attr('checked', false)
    }
  }

  function updatePayment(el) {
    payment_id  = el.parent().attr('payment_id')
    rate        = el.parent().find('.edit-payment-rate').attr('value')
    hours        = el.parent().find('.edit-payment-hours').attr('value')
    description = el.parent().find('.edit-payment-description').attr('value')
    startDate   = el.parent().find('.edit-payment-start_date').attr('value')
    $.ajax({
      url: '/payments/'+payment_id+'.js',
      type: 'PUT',
      data: {payment: {rate: rate, description: description, 'start_date': startDate, number_of_hours: hours}}
    })
  }

  function validatePaymentRow(row) {
    var rate = $(row).find("input[name='payment-rate']")
    var startDate = $(row).find("input[name='payment-start_date']")
    var b = true
    if (rate.val().length == 0 || !/^\d+$/.test(rate.val())) {
      b = false
      rate.addClass('field-error')
      rate.blur(function() {
        if ($(this).val().length > 0)
          $(this).removeClass('field-error')
      })
    } else {
      rate.removeClass('field-error')
    }

    if (startDate.val().length == 0 || !/^(\d){1,2}..\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s(\d){4}/.test(startDate.val())) {
      b = false
      startDate.addClass('field-error')
      startDate.blur(function() {
        if ($(this).val().length > 0)
          $(this).removeClass('field-error')
      })
    } else {
      startDate.removeClass('field-error')
    }

    return b
  }


  // Handlers
  $("#add-payment-button").live('click', function() {
    if ($("#add-payment-type").attr('value').length > 0) {
      addPaymentToList();
      sortPayments();
    }
    return false
  })

  $("#add-project .delete-payment").live('click', function() {
    removePaymentFromList($(this))
    return false
  })

  $("#add-payment-type").live('change', function() {
    hideAllPaymentOptions();
    if ($(this).val() == 'Fixed') {
      $('.fixed-payment-options').show();
    } else if ($(this).val() == 'Hourly') {
      $(".hourly-payment-options").show();
    } else if ($(this).val() == 'Monthly') {
      $(".monthly-payment-options").show();
    }

    if ($(this).val().length > 0) {
      $('#input-add-payment-monthly-completed-wrapper').show();
      $("#input-add-payment-description-wrapper").show();
      $("#add-payment-button").show();
      $("#payments-list").show();
    }
  })

  hideAllPaymentOptions();

  // Select for "Payment type"
  $("#add-payment-type").val('').trigger('change')

  // Checkbox image for "Is Payment Completed"
  $("#payment-completed-href").live('click', function() {
    if ( !$(this).is(':checked') ) {
      $("#new-payment-completed").attr('value', '1')
    } else {
      $("#new-payment-completed").attr('value', '0')
    }
  })

  $(".input-payment-completed").live('click', function() {
    if ($(this).hasClass("payment-not-completed")) {
      $(this).removeClass("payment-not-completed").addClass("payment-completed")
      $(this).parent().find(".payment-completed-value").attr('value', '1')
      $.ctNotify("Payment marked as completed")
    } else {
      $(this).addClass("payment-not-completed").removeClass("payment-completed")
      $(this).parent().find(".payment-completed-value").attr('value', '0')
      $.ctNotify("Payment marked as not completed")
    }
    sortPayments();
  })

  $('#payments-list .edit-link').live('click', function() {
    var el = $(this).parent().parent().parent()
    el.addClass('edit-mode')
    el.find('.update-payment-wrapper').css('display', 'inline-block')
    el.find('.payment-value').hide()
    el.find('.payment-name').hide()
    el.find('.payment-date').hide()
    el.find('.payment-type').hide()
    if (el.find('.payment-type').text().match(/Hourly/) == null) {
      el.find('.edit-payment-hours').hide()
    }
    return false
  })

  $('#payments-list .cancel-link').live('click', function() {
    var el = $(this).parent().parent()
    el.removeClass('edit-mode')
    el.find('.update-payment-wrapper').hide('fast')
    el.find('.payment-value').show('fast')
    el.find('.payment-name').show('fast')
    el.find('.payment-date').show('fast')
    el.find('.payment-type').show('fast')
    return false
  })

  $("#payments-list .save-payment").live('click', function () {
    var el = $(this).parent().parent()
    currentPaymentSave = $(this).parent().parent()
    if (validatePaymentRow(currentPaymentSave)) {
      el.removeClass('edit-mode')
      updatePayment($(this))
      el.find('.update-payment-wrapper').hide('fast')
      el.find('.payment-value').show('fast')
      el.find('.payment-name').show('fast')
      el.find('.payment-date').show('fast')
      el.find('.payment-type').show('fast')
    } else {
      $.ctNotify('Invalid values, check again', 'error')
    }
    return false
  })

  $(".edit-payment-start_date").datepicker({
    dateFormat: 'dth M yy',
    onSelect: function(dateText, inst) {
      this.value = customFormatString(dateText)
    }
  });


  blurValidate()
})

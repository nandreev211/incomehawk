/**
 * jQuery.fn.sortElements
 * --------------
 * @param Function comparator:
 *   Exactly the same behaviour as [1,2,3].sort(comparator)
 *
 * @param Function getSortable
 *   A function that should return the element that is
 *   to be sorted. The comparator will run on the
 *   current collection, but you may want the actual
 *   resulting sort to occur on a parent or another
 *   associated element.
 *
 *   E.g. $('td').sortElements(comparator, function(){
 *      return this.parentNode;
 *   })
 *
 *   The <td>'s parent (<tr>) will be sorted instead
 *   of the <td> itself.
 */
jQuery.fn.sortElements = (function(){
    var sort = [].sort;
    return function(comparator, getSortable) {
        getSortable = getSortable || function(){return this;};
        var placements = this.map(function(){
            var sortElement = getSortable.call(this),
                parentNode = sortElement.parentNode,
            // Since the element itself will change position, we have
            // to have some way of storing its original position in
            // the DOM. The easiest way is to have a 'flag' node:
                nextSibling = parentNode.insertBefore(
                    document.createTextNode(''),
                    sortElement.nextSibling
                );
            return function() {
                if (parentNode === this) {
                    throw new Error(
                        "You can't sort elements if any one is a descendant of another."
                    );
                }
                // Insert before flag:
                parentNode.insertBefore(this, nextSibling);
                // Remove flag:
                parentNode.removeChild(nextSibling);
            };
        });
        return sort.call(this, comparator).each(function(i){
            placements[i].call(getSortable.call(this));
        });
    };
})();
/* end */

jQuery.expr[':'].regex = function(elem, index, match) {
    var matchParams = match[3].split(','),
        validLabels = /^(data|css):/,
        attr = {
            method: matchParams[0].match(validLabels) ?
                matchParams[0].split(':')[0] : 'attr',
            property: matchParams.shift().replace(validLabels,'')
        },
        regexFlags = 'ig',
        regex = new RegExp(matchParams.join('').replace(/^\s+|\s+$/g,''), regexFlags);
    return regex.test(jQuery(elem)[attr.method](attr.property));
}


var paymentsByDate = function(a, b){
    var d1 = $(a).find('.sort-order').attr('order')
    var d2 = $(b).find('.sort-order').attr('order')
    return d1 > d2 ? -1 : 1;
};

var contactsByName = function(a, b){
    var d1 = $(a).find('.contact-name').html()
    var d2 = $(b).find('.contact-name').html()
    return d1 > d2 ? 1 : -1;
};

function IsNumeric(input) {
    return (input - 0) == input && input.length > 0;
}

function IsIncomeDate(d) {
    return /^(\d){1,2}..\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s(\d){4}/.test(d)
}

function updatePaymentCompletedTooltips() {
    $(".payment-completed-icon").each(function() {
        var title = 'Mark as Completed';
        if ($(this).hasClass("payment-completed")) {
            title = 'Mark as Uncompleted';
        }
        $(this).attr('title', title);
    })

    $('[title]').tipTip({defaultPosition: 'top'});
}

function sortPayments() {
    $('#payments-list li').sortElements(paymentsByDate);
    $('#payments-list li').each(function(){
        if (Date.parse($(this).find('.payment-date').html()) >= Date.today()) {
            $(this).addClass('future')
            $(this).removeClass('last')
        } else {
            if ($(this).find('.payment-completed-icon').hasClass('payment-completed')) {
                $(this).removeClass('overdew')
            } else {
                $(this).addClass('overdew')
            }
            $(this).removeClass('future')
        }
    })

    $('#payments-list li.future').last().addClass('last')
    updatePaymentCompletedTooltips()
}


function sortContacts() {
    $('#contacts-list li').sortElements(contactsByName);
}

function customFormatString(dateText) {
    dayStr = dateText
    currentDay = dateText.split(" ")[0].replace('th', '')
    if (currentDay == '1' || currentDay == '01') {
        dayStr = dayStr.replace('th', 'st')
    } else if (currentDay == '2' || currentDay == '02') {
        dayStr = dayStr.replace('th', 'nd')
    } else if (currentDay == '3' || currentDay == '03') {
        dayStr = dayStr.replace('th', 'rd')
    }
    return dayStr;
}


/* related to 'Completed' project */
function addProjectButtonClick() {
    if (projectCompleted()) {
        checkUncompletedPayments()
    } else {
        submitProject()
    }
}

function projectCompleted() {
    return $("#project_status").val() == "Completed"
}

function submitProject() {
    $('#add-project').submit()
}

function uncompletedPayments() {
    return $("#payments-list li .payment-not-completed")
}

function checkUncompletedPayments() {
    var uncompleted = uncompletedPayments()
    if (uncompleted.length != 0) {
        var unvalues = _.map(uncompleted.parent().find('.payment-value'), function(el) {
            return parseInt($(el).html().replace('$',''));
        })
        var valued = _.reduce(unvalues, function(memo, num){ return memo + num; }, 0);

        $.fallr('show', {
            buttons : {
                button1 : {text: 'Yes', danger: true, onclick: submitProject},
                button2 : {text: 'No'},
                button3 : {text: 'Mark all payments as completed', onclick: markAllPaymentsCompleted}
            },
            content : '<p>You have '+uncompleted.length+' Uncompleted payments valued at '+valued+' are you sure you want to set project as Completed?</p>',
            icon    : 'error',
            width   : '400'
        });
    } else {
        submitProject()
    }
}

function markAllPaymentsCompleted() {
    uncompletedPayments().each(function(el) {
        $(this).parent().find('.payment-not-completed').removeClass('payment-not-completed').addClass('payment-completed')
        $(this).parent().find("input:regex(name, .*completed.*)").val('1')
    })
    submitProject()
}

function validatePaymentBlurs() {
    payment = $("#add-payment-type").attr('value')
    paymentType = payment.toLowerCase()

    paymentValue =  $("#input-add-payment-"+paymentType+"-rate-wrapper input").attr('value')
    paymentDateValue = $("#input-add-payment-"+paymentType+"-date-wrapper input").attr('value')
    paymentDescription = $("#input-add-payment-description").attr('value')
    numberOfMonths = $("#input-add-payment-monthly-months-wrapper input").attr('value')
    numberOfHours = $("#input-add-payment-hourly-hours-wrapper input").attr('value')

    if (validatePaymentValues(payment, paymentValue, paymentDateValue, numberOfMonths, numberOfHours, paymentDescription)) {
        $("#add-payment-button").removeClass("disabled")
    } else {
        $("#add-payment-button").addClass("disabled")
    }
}

function validatePaymentValues(paymentType, paymentValue, paymentDateValue, numberOfMonths, numberOfHours, paymentDescription) {
    if (!IsNumeric(paymentValue))
        return false

    if (paymentValue.length == 0 || paymentDateValue.length == 0)
        return false

    if (paymentType == 'Monthly' && (numberOfMonths.length == 0 || !IsNumeric(numberOfMonths)))
        return false

    if (paymentType == 'Hourly' && (numberOfHours.length == 0 || !IsNumeric(numberOfHours)))
        return false

    return true;
}

function validatePaymentErrors() {
    $('.field-error').removeClass('field-error')
    payment = $("#add-payment-type").attr('value')
    paymentType = payment.toLowerCase()

    paymentValue =  $("#input-add-payment-"+paymentType+"-rate-wrapper input")
    if (paymentValue.val().length == 0 || !IsNumeric(paymentValue.val())) {
        paymentValue.addClass('field-error')
    }
    paymentDateValue = $("#input-add-payment-"+paymentType+"-date-wrapper input")
    if (paymentDateValue.val().length == 0 || !IsIncomeDate(paymentDateValue.val())) {
        paymentDateValue.addClass('field-error')
    }
    paymentDescription = $("#input-add-payment-description").attr('value')
    numberOfMonths = $("#input-add-payment-monthly-months-wrapper input")
    if (payment == 'Monthly' && (numberOfMonths.val().length == 0 || !IsNumeric(numberOfMonths.val()))) {
        numberOfMonths.addClass('field-error')
    }
    numberOfHours = $("#input-add-payment-hourly-hours-wrapper input")
    if (payment == 'Hourly' && (numberOfHours.val().length == 0 || !IsNumeric(numberOfHours.val()))) {
        numberOfHours.addClass('field-error')
    }
}

function blurValidate() {
    $('.payment-blur-validate').live({
        blur: function(){ validatePaymentBlurs() },
        focus: function(){ validatePaymentBlurs()},
        keyup: function(){ validatePaymentBlurs() }
    })
}

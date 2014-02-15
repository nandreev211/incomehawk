$(function() {
    if (window.notSortPayments === undefined) {
        sortPayments()
    }

    $(".payment-completed-icon").live('click', function(e) {
        e.preventDefault();

        var msg = ''; var completed = '';
        payment_id = $(this).attr('payment_id')

        if ($(this).hasClass('payment-completed')) {
            msg = "Uncomplete the payment?"
            $(this).removeClass("payment-completed").addClass("payment-not-completed");
            $(this).find('span').text("Paid");
            completed = false
        } else {
            msg = 'Are you sure you completed this payment?'
            completed = true
            $(this).removeClass("payment-not-completed").addClass("payment-completed");
            $(this).find('span').text("Pending");
        }

        data = {payment: {completed: completed}}
        if (window.notSortPayments) {
            data.plain_payment = '1';
            if ($("#payments-range").val().length > 0) {
                data.date_range = $("#payments-range").val();
            }
            data.status = $("#payments-status option:selected").val();
        }

        $.ajax({
            type:'PUT',
            url: '/payments/'+payment_id,
            data: data,
            beforeSend: function(request) { request.setRequestHeader("Accept", "text/javascript"); },
            success: function(res) {}
        })
    })

    var payment_delete = function(){
        $.ajax({
            type:'DELETE',
            url: '/payments/'+payment_id,
            beforeSend: function(request) { request.setRequestHeader("Accept", "text/javascript"); },
            success: function(res) {}
        })
        $.fallr('hide');
    };

    $(".delete-payment").die()
    $('.delete-button-small').die()
    $("#add-project .delete-payment").die()

    $(".delete-payment").live('click', function() {
        payment_id = $(this).attr('payment_id')

        $.fallr('show', {
            buttons : {
                button1 : {text: 'Yes', danger: true, onclick: payment_delete},
                button2 : {text: 'Cancel'}
            },
            content : '<p>Are you sure you want to delete payment?</p>',
            icon    : 'error'
        });
        $(this).show()
        return false
    })
})
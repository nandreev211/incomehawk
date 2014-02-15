$(document).ready(function() {
    $(".update-card-form .cancel-link").click(function(e) {
        e.preventDefault();
        $(".update-card-form").slideUp('fast');
        $(".cc-info #update-button").fadeIn('fast');
    });
    $(".cc-info #update-button").click(function(e) {
        e.preventDefault();
        $(this).hide();
        $(".update-card-form").slideDown("fast");
    });

    $(".plan-selection .radio-button").click(function(e) {
        e.preventDefault();

        if($(".premium-plan .radio-button").hasClass("selected") && ($(this).is($(".free-plan .radio-button")))){
            $.post("/plans", {todo: 'downgrade'}, function(response) {
                alert(response);
            });
            showModal(".downgrade");
        }
        else {
            showModal(".upgrade");
        }
        $(".plan-selection .radio-button").toggleClass("selected");

    });



    $("#cancel-button").click(function(e) {
        e.preventDefault();
        $(".modal-wrapper").fadeOut("fast");
        $(".modalVisible").fadeOut("fast");
        $(".plan-selection .radio-button").toggleClass("selected");
        $(".modal").removeClass("modalVisible");
    });

    //only for testing the blue button should actually redirect to payment page when upgrading, and give info about payment when downgrading
    $(".modal-window .button-blue").click(function(e) {
        e.preventDefault();
        $(".modal-wrapper").fadeOut("fast");
        $(".modalVisible").fadeOut("fast");
        $(".modal").removeClass("modalVisible");
    });

});

$.fn.center = function () {
    this.css("position","absolute");
    this.css("top", Math.max(0, (($(window).height() - this.outerHeight()) / 2)  + $(window).scrollTop()) + "px");
    this.css("left", Math.max(0, (($(window).width() - this.outerWidth()) / 2) + $(window).scrollLeft()) + "px");
    return this;
}

function showModal(modalId) {

    $(".modal-wrapper").show();
    $(modalId).fadeIn("fast").addClass("modalVisible").center();
}


$(document).ready(function () {
    function subs(response){
        if(response.error){
            $(".payment-errors").text(response.error);
        } else {
            alert(response.msg);
            window.location = "/plans";
        }
        
    }
    
    function PaymillResponseHandler(error, result) {
        if (error) {
            $(".payment-errors").text(error.apierror);
        } else {
            $.post("/plans", {token: result.token, todo: 'upgrade'}, subs);
            $(".payment-errors").text("");
        }
    }
    PAYMILL_PUBLIC_KEY = "89385234891a7fe4d2d3d189a68f4382";
    $("#payment-form").submit(function (event) {
        $(".payment-errors").text("");
        paymill.createToken({
            number:$('.card-number').val(),
            exp_month:$('.card-expiry-month').val(),
            exp_year:$('.card-expiry-year').val(),
            cvc:$('.card-cvc').val(),
            currency:'EUR',
            amount:'9'
        }, PaymillResponseHandler);
        return false;
    });
    $('.paymill-key').val(PAYMILL_PUBLIC_KEY);
});


$(document).ready(function() {

	$('input').iCheck({
    	checkboxClass: 'icheckbox_flat-aero',
    	radioClass: 'iradio_flat-aero'
  	});

  	//show hide password 
	$(".show-password").click(function(e) {
		e.preventDefault();
		$(this).closest(".login-field").find("input").toggle();
		if($(this).html() == 'Show') {
            $('#password-text').show();
            $('#password-password').hide();
			$(this).html('Hide');
        }
		else {
            $('#password-text').hide();
            $('#password-password').show();
			$(this).html('Show');
		}
	});

	$(".login-pass-wrapper input").change(function() {
		$(this).closest(".login-pass-wrapper").find("input").val($(this).val());
	})
    $(".signup-pass-wrapper input").change(function() {
        $(this).closest(".signup-pass-wrapper").find("input").val($(this).val());
    })

    //show/hide password text
    $('#password-text').focus(function() {
        $('#password-text').hide();
        $('#password-password').show();
        $('#password-password').focus();
        $(".show-password").html('Show');
    });
    $('#password-password').blur(function() {
        if($('#password-password').val() == '') {
            $('#password-text').show();
            $('#password-password').hide();
        }
    });

}); // end document ready
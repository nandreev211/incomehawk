jQuery(document).ready(function($) {
    var account_delete = function(){
        if ($("#delete-account-confirm").val() == "DELETE") {
            $('#delete-account-link').trigger('click')
        }
    };

    jQuery('#delete-account-link').click( function (e) {
        window.location.href = this.href;
    });

    $("#delete-account-btn").live('click', function() {
        $.fallr('show', {
            buttons : {
                button1 : {text: 'Yes', danger: true, onclick: account_delete},
                button2 : {text: 'Cancel'}
            },
            content : '<p>Are you sure you wish to delete your account? All data will be lost and cannot be recovered. To confirm type DELETE below.</p><input type="text" id="delete-account-confirm">',
            icon    : 'error'
        });
        return false
    })

    var demo_project_delete = function(){
        $('#delete-demo-project-link').trigger('click')
    };

    jQuery('#delete-demo-project-link').click( function (e) {
        window.location.href = this.href;
    });

    $("#delete-demo-project-btn").live('click', function() {
        $.fallr('show', {
            buttons : {
                button1 : {text: 'Yes', danger: true, onclick: demo_project_delete},
                button2 : {text: 'Cancel'}
            },
            content : '<p>Are you sure you want to delete demo projects?</p>',
            icon    : 'error'
        });
        return false
    })
})
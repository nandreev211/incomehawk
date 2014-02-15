jQuery(document).ready(function($) {
  paymentIterator = 1;

  $(".datepick").datepicker({
    dateFormat: 'dth M yy',
    onSelect: function(dateText, inst) {
      this.value = customFormatString(dateText)
      validatePaymentBlurs();
    }
  });
  $(".datepicker").click(function(e) {
    $(this).parent().find('.datepick').datepicker('show')
    e.preventDefault();
  })

  // Functions
  // =================== ======================

  $("#project_status").live('change', function() {
    $("#eva_container").hide();
    $('#payments_container').hide();

    if ($(this).val() == 'Active' || $(this).val() == 'Completed') {
      $('#payments_container').show();
    } else if ($(this).val() == 'Prospective' || $(this).val() == 'Lost') {
      $("#eva_container").show();
    }
  });

  if ($("#project_status").val() == '')
    $("#project_status").val('Active')
  $("#project_status").trigger('change');


  // Colorpicker
  $('.colorpicker').colorPicker();

  // FIXME: datepicker opens up by itself
  $.each(['fixed', 'hourly', 'monthly'], function(index, value) {
    // $('#input-add-payment-'+value+'-date-wrapper').datepicker();
  });

  // Handlers
  $(".close-button, .done").live('click', function() {
    $.facebox.close()
  })

  $('#add-contact-link').live('click', function() {
    var li = $("<li></li>")
    li.html($("#project_contact_id option:selected").text())
    $("#contacts-list").append(li)
    return false
  })

  $("#add-category-button").live('click', function() {
    $("#new_category").submit()
    return false
  })


  $(".contact-card").live('mouseover', function() {
    contact_id = $(this).parent().attr('contact_id')
    $("#contact-hover-"+contact_id).show()
  })

  $(".contact-card").live('mouseout', function() {
    contact_id = $(this).parent().attr('contact_id')
    $("#contact-hover-"+contact_id).hide()
  })



  var project_delete = function(){
    $('#delete-project-link').trigger('click')
  };

  $("#delete-project-btn").live('click', function() {
    $.fallr('show', {
        buttons : {
            button1 : {text: 'Yes', danger: true, onclick: project_delete},
            button2 : {text: 'Cancel'}
        },
        content : '<p>Are you sure you want to delete project?</p>',
        icon    : 'error'
    });
    return false
  })

  $(".project-notes .edit").live('click', function(e) {
    $(this).parent().parent().find('.note').hide();
    $(this).parent().parent().find('.update_form').show().find('form').show();
    e.preventDefault();
  })
})
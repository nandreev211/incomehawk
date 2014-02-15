jQuery(document).ready(function($) {
  $("#search-contact-name").bind('keyup', function() {
    if ($(this).attr('value').length > 3 || $(this).attr('value').length == 0) {
      $("#search-contact-form").submit()
    }
  })

  $('.persistent-contact .remove-contact').die()
  sortContacts()

  $(".remove-contact").die()
})
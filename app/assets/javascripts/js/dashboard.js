String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
}

$(function() {
  $('#dashboard-header .month').live('click', function() {
    if(event.target.id == 'go-to-next-month' || event.target.id == 'go-to-previous-month')
      return
    $(this).toggleClass('visible-payments');
  })

  $('.payments-button').live('click', function() {
    el = $(this).parent('.month')
    $("#dashboard-header .month").removeClass('visible-payments');
    el.addClass('visible-payments');
    $("#header-overlay").show();
  })

  $('#header-overlay').live('click', function() {
    $("#dashboard-header .month").removeClass('visible-payments');
    $("#header-overlay").hide();
  })

  $('.projects-list .collapse').live('click', function() {
    var proj_list = $(this).parent().parent()
    var status = proj_list.attr('id').replace('-projects-list', '').capitalize()

    proj_list.find('ul li').each(function(index) {
      if (index > 4)
        $(this).hide('fast')
    })
    proj_list.attr('page', '1')
    $(this).hide('fast')
    var expand = $(this).parent().find('.expand')
    expand.html(expand.attr('original_text'))
    expand.show('fast')

    return false
  })

  $('.projects-list .expand').live('click', function() {
    var proj_list = $(this).parent().parent()
    var status = proj_list.attr('id').replace('-projects-list', '').capitalize()
    page = proj_list.attr('page')
    $.get('/projects.js', {page: page, status: status})
    return false
  })


  var contact_delete = function(){
    $('#delete-contact-link').trigger('click')
  };

  $("#delete-contact-btn").live('click', function() {
    $.fallr('show', {
        buttons : {
            button1 : {text: 'Yes', danger: true, onclick: contact_delete},
            button2 : {text: 'Cancel'}
        },
        content : '<p>Are you sure you want to delete contact?</p>',
        icon    : 'error'
    });
    return false
  })


})
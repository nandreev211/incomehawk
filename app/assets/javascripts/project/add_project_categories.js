$(function() {

  // Functions
  function updateCategoryColor(el) {
    organization_id = el.parent().parent().parent().attr('organization_id')
    category_id = el.parent().parent().parent().attr('category_id')
    color = el.attr('class').replace('color', '').replace(' ', '')
    $.ajax({
      url: '/categories/'+category_id,
      type: 'PUT',
      data: {category: {color: color}}
    })
  }

  function updateCategoryName(el) {
    organization_id = el.parent().attr('organization_id')
    category_id = el.parent().attr('category_id')
    name = el.parent().find('.edit-category-name').attr('value')
    $.ajax({
      url: '/categories/'+category_id,
      type: 'PUT',
      data: {category: {name: name}}
    })
  }

  // Handlers
  $('#edit-categories .delete-button-small').live('click', function() {
    $(this).parent().find('.are-you-sure-wrapper').show('fast')
    $(this).parent().find('.category-name').hide('fast')
    $(this).parent().find('.delete-button-small').hide()
    $(this).parent().find('.edit-link').hide()
    return false
  })

  $('#edit-categories .edit-link').live('click', function() {
    $(this).parent().find('.update-category-wrapper').show('fast')
    $(this).parent().find('.category-name').hide('fast')
    $(this).parent().find('.delete-button-small').hide()
    $(this).parent().find('.edit-link').hide()
    return false
  })

  $('#edit-categories .cancel-link').live('click', function() {
    $(this).parent().parent().find('.are-you-sure-wrapper').hide('fast')
    $(this).parent().parent().find('.update-category-wrapper').hide('fast')
    $(this).parent().parent().find('.category-name').show('fast')
    $(this).parent().parent().find('.delete-button-small').show()
    $(this).parent().parent().find('.edit-link').show()
    return false
  })

  $("#edit-categories .save-category-name").live('click', function () {
    updateCategoryName($(this))
    $(this).parent().parent().find('.update-category-wrapper').hide('fast')
    $(this).parent().parent().find('.category-name').show('fast')
    $(this).parent().parent().find('.delete-button-small').show()
    $(this).parent().parent().find('.edit-link').show()
    return false
  })

  $('.color').live('click', function() {
    updateCategoryColor($(this))
    return false
  })


})
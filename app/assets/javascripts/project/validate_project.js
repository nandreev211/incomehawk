$(function() {
  $("#add-project").validate({
    rules: {
      "project[name]": "required",
      "project[category_id]": "required",
      "project[status]": "required",
    },
    showErrors: function(errors) {
      for (prop in errors) {
        $("#add-project input[name='"+prop+"']").addClass('field-error')
      }
    }
  });
});

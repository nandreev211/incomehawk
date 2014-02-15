// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function($) {

  $('a[rel*=facebox]').facebox();
  $.facebox.settings.opacity = 0.5

  $(document).ajaxStart(function() {
    $.ctNotify("Loading", {type: "loading", delay:1000})
  })

  $('.message').live('click', function() {
    $(this).hide('fast')
  })

  setTimeout(function() {
    $("#search-bar").append($(".ui-autocomplete"))
  }, 500);

  $('[title]').tipTip({defaultPosition: 'top'});

  // Binding some actions to contacts <select>
  $('#input-project-contact-field').chosen({
      actions_indexes: [0],
      no_results_text: "No such contact",
      actions_handlers: {
        0: function() {
          $('#create_contact_link').trigger('click')
        }
      }
    });

  // Binding some actions to categories <select>
  $('#project-categories').chosen({
      actions_indexes: [0],
      no_results_text: "No such category",
      actions_handlers: {
        0: function() {
          $("#create_category_link").trigger('click')
        }
      }
    });

  $.fn.extend({
    chosen: function(data, options) {
      return $(this).each(function(input_field) {
      if (!($(this)).hasClass("chzn-done")) {
        return new Chosen(this, data, options);
      }
    });
    },
    chosenClass: function() {
      return Chosen;
    }
  });
  (function(Class) {
    Class.prototype.no_results = (function(fnSuper) {
        return function(terms) {
          var no_results_html;
          no_results_html = $('<li class="no-results">' + this.results_none_found + '</li>');
          if (this.container_id == "project-categories_chzn") {
            no_results_html.html(no_results_html.html() + '<br /><a onclick="$(\'.chzn-single\').trigger(\'click\'); $(\'#create_category_link\').trigger(\'click\');" href="#">Create a new Category</a>');
          }
          if (this.container_id == "input-project-contact-field_chzn") {
            no_results_html.html(no_results_html.html() + '<br /><a onclick="$(\'.chzn-single\').trigger(\'click\'); $(\'#create_contact_link\').trigger(\'click\');" href="#">Create new Contact</a>');
          }
          return this.search_results.append(no_results_html);
        };
    })(Class.prototype.no_results);
  })($.fn.chosenClass());

  $('select').chosen();


  // Create the dropdown base
  $("<select />").appendTo("#navigation .inner");

  // Create default option "Go to..."
  $("<option />", {
     "selected": "selected",
     "value"   : "",
     "text"    : "Go to..."
  }).appendTo("#navigation select");

  // Populate dropdown with menu items
  $("#navigation #tabs li a").each(function() {
   var el = $(this);
   $("<option />", {
       "value"   : el.attr("href"),
       "text"    : el.text()
   }).appendTo("#navigation select");
  });

  $("#navigation select").change(function() {
    window.location = $(this).find("option:selected").val();
  });

  // Toggle project listings
  $('.toggle-link').live('click', function(e){
    container = $(this).attr('href');
    $(container+" .projects-list").toggle(500);

    // change class between open and closed
    current_class = $(this).closest('h2').attr('class');
    if(current_class == "open") {
      $(this).closest('h2').attr('class', 'closed');
    }
    else {
      $(this).closest('h2').attr('class', 'open');
    }

    e.preventDefault();
  });

})
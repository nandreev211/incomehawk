$(function() {
  function getContactHover(organization_id, contact_id) {
    $.get('/contacts/'+contact_id+'/hover',
      function(data){
        $('.project-contacts').append(data)
        $("#contact_org_"+contact_id).html($(data).find('.contact-company').html());
      }
    );
  }

  function addContactToList() {
    contactIndex =  $("#input-project-contact-field")[0].selectedIndex;
    contactId = $("#input-project-contact-field option:selected").attr('value')
    contactValue = $("#input-project-contact-field option:selected").html()
    // $("#current_contact").html('')
    if (contactIndex > 2) {
      if ($("#contacts-list input[value='"+contactId+"']").length == 0) {
        newContact = $("<li></li>").addClass("project-added-contact").attr('contact_id', contactId)
        newContact.append($("<a href='#'></a>").addClass('contact-name').html(contactValue))
        newContact.append($("<a class='contact-card' alt='Contact Information' href='#'>Contact Infomration</a>"))
        newContact.append($("<a href='#' title='Remove Contact'>Remove Contact</a>").addClass("remove-contact").addClass("delete-button-small"))

        // hiden fields
        $("<input type='hidden' name='project[contact_ids][]' />").attr("value", contactId).appendTo(newContact)

        // organization name
        newContact.append($("<p class='contact-organization' id='contact_org_"+contactId+"'></p>"));

        $("#contacts-list").append(newContact)
        getContactHover(organization_id, contactId);
      } else {
        $.ctNotify("Contact duplicate detected", 'error')
      }
      // $("#current_contact").html('')

    } else {
      $.ctNotify('No contact selected', 'error')
    }
  }

  function removeContactFromList(el) {
    el.parent().remove()
  }

  function clearContactValues() {
    $("#input-project-contact-field").attr('value', '')
  }

  // Handlers
  $("#project-add-contact").live('click', function() {
    addContactToList();
    clearContactValues();
    sortContacts()
    return false
  })

  $(".remove-contact").live('click', function() {
    removeContactFromList($(this))
    return false
  })

  // $('#input-project-contact-field').live('change', function() {
  //   if (this.selectedIndex == 0) {
  //     $('#create_contact_link').trigger('click')
  //   } else {
  //     // $( "#current_contact" ).attr('value', $(this).find('option:selected').attr('value'));
  //   }
  // })

})
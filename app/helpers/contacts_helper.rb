module ContactsHelper
  def contact_avatar(contact)
    if contact.avatar_file_name.present?
      contact.avatar.url(:thumb)
    else
     "/assets/logo-placeholder.png"
    end
  end
end
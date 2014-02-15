class TmpUpload < ActiveRecord::Base
  has_attached_file :avatar,
    :styles => { :medium => "150x100>", :thumb => "97x53" },
    :storage => :s3,
    :bucket => 'incomeHawk',
    :s3_credentials => {
      :access_key_id => 'AKIAI4KKOYIC5NJZ2PDQ',
      :secret_access_key => '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'
    }

  validates_attachment_content_type :avatar, :content_type=>['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'application/octet-stream'] 
  validates_attachment_size :avatar, :less_than => 500.kilobytes
end

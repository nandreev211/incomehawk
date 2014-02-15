class CreateTmpUploads < ActiveRecord::Migration
  def self.up
    create_table :tmp_uploads do |t|
      t.string    :avatar_file_name
      t.string    :avatar_content_type
      t.integer   :avatar_file_size
      t.datetime  :avatar_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :tmp_uploads
  end
end

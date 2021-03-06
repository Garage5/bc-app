class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string    :attachment_file_name
      t.string    :attachment_content_type
      t.integer   :attachment_file_size
      t.datetime  :attachment_updated_at
      t.integer   :attachable_id
      t.string    :attachable_type
      t.integer   :tournament_id
      t.integer   :uploader_id
      t.timestamps
    end
    
    add_index :attachments, [:attachable_id, :attachable_type]
  end
  
  def self.down
    remove_index :attachments, [:attachable_id, :attachable_type]
    drop_table :attachments
  end
end

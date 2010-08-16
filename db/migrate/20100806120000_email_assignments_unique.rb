class EmailAssignmentsUnique < ActiveRecord::Migration

  def self.up
    add_index :email_assignments, :email, :unique => true, :name => "unique_email_index"
  end

  def self.down
    remove_index :email_assignments, :email
  end
end

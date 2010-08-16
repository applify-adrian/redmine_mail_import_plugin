class CreateEmailAssignments < ActiveRecord::Migration

  def self.up
    create_table :email_assignments do |t|

      t.column :email, :string, :null => false
      
      t.column :user_id, :integer, :null => false
      
      t.column :project_id, :integer, :null => false

    end
  end

  def self.down
    drop_table :email_assignments
  end
end

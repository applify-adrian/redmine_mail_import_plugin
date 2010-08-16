class EmailAssignment < ActiveRecord::Base

  belongs_to :project
  belongs_to :user
  
  validates_length_of :email, :minimum => 5
  validates_format_of :email, :with => /^[A-Z0-9*._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, :message => "is not valid"
  validates_uniqueness_of :email, :case_sensitive => false
  validates_presence_of :user_id
  
end

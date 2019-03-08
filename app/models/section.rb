class Section < ActiveRecord::Base
  has_many :questions, :class_name => 'Question'
  belongs_to :questionset, :class_name => 'Questionset', :foreign_key => :questionset_id
end

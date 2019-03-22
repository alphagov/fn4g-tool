class FrameworkCompliance < ActiveRecord::Base
  belongs_to :question, :class_name => 'Question', :foreign_key => :question_id
  belongs_to :framework, :class_name => 'Framework', :foreign_key => :framework_id
end
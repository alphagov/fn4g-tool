class AssessmentType < ActiveRecord::Base
  has_many :questionsets, :class_name => 'Questionset'
end

class Questionset < ActiveRecord::Base
  has_many :sections, :class_name => 'Section'
  belongs_to :assessment_type, :class_name => 'AssessmentType'
end

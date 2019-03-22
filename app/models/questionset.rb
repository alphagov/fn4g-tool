class Questionset < ActiveRecord::Base
  has_many :sections, :class_name => 'Section'
  belongs_to :assessment_type, :class_name => 'AssessmentType'

  def question_count
    count = 0
    self.sections.each do |section|
      count += section.questions.where(visible: true).count
    end
    count
  end

  def questions_answered_with(assessment_id, option_id)
    count = 0
    self.sections.each do |section|
      count += section.questions_answered_with(assessment_id, option_id).count
    end
    count
  end
end

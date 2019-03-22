class Assessment < ActiveRecord::Base
  belongs_to :assessment_type, :class_name => 'AssessmentType', :foreign_key => :assessment_type_id
  belongs_to :organisation, :class_name => 'Organisation', :foreign_key => :organisation_id
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  has_many :answers, :class_name => 'Answer'

  def self.sorted_list(organisation_id, sort_column, sort_direction)
    where(:organisation_id => organisation_id).order("#{sort_column} #{sort_direction}").all
  end

  def self.question_count
    sum = 0
    self.assessment_type.questionsets.each do |questionset|
      questionset.sections.each do |section|
        sum += section.questions.where(visible: true).count
      end
    end
    sum
  end

end

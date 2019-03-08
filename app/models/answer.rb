class Answer < ActiveRecord::Base
  belongs_to :assessment, :class_name => 'Assessment', :foreign_key => :assessment_id
  belongs_to :question, :class_name => 'Question', :foreign_key => :question_id
  #belongs_to :trinomial_option, :class_name => 'TrinomialOption', :foreign_key => :trinomial_option_id
  #belongs_to :binomial_option, :class_name => 'BinomialOption', :foreign_key => :binomial_option_id

  def self.vulnerabilities(assessments)
    @vulnerabilities = {}
    unless assessments.blank?
      @assessment = assessments.first
      [['vuln.highCount', 'High'], ['vuln.mediumCount', 'Medium'], ['vuln.lowCount', 'Low']].each do |reference|
        answer = Answer.where(question_id: Question.find_by_reference(reference.first).id)
                     .where(assessment_id: @assessment.id).first
        @vulnerabilities[reference.second] = answer.numerical.to_i unless answer.blank?
      end
    end
    @vulnerabilities
  end
end

class Section < ActiveRecord::Base
  has_many :questions, :class_name => 'Question'
  belongs_to :questionset, :class_name => 'Questionset', :foreign_key => :questionset_id

  def questions_answered_with(assessment_id, option_id)
    questions = []
    self.questions.where(visible: true).each do |question|
      option_name = option_for_qt(question.question_type_id)

      questions << question unless question.answers
                                       .where(option_name => option_id)
                                       .where(assessment_id: assessment_id).blank?

    end
    questions
  end

  def questions_not_answered_with(assessment_id, option_id)
    questions = []
    self.questions.where(visible: true).each do |question|
      option_name = option_for_qt(question.question_type_id)

      questions << question if question.answers
                                       .where(option_name => option_id)
                                       .where(assessment_id: assessment_id).blank?

    end
    questions
  end

  private

  def option_for_qt(question_type_id)
    if question_type_id == QuestionType.find_by_name('Binomial').id
      'binomial_option_id'
    elsif question_type_id == QuestionType.find_by_name('Trinomial').id
      'trinomial_option_id'
    end

  end
end

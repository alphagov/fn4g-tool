class SectionsController < ApplicationController
  def edit
    @user = User.find(1)
    @organisation = @user.organisation
    @section = Section.find(params[:id])
    @assessment_type = @section.questionset.assessment_type
    @assessment = Assessment.where(
      organisation_id: @organisation.id,
      assessment_type_id: @assessment_type.id
    )

    if @assessment.blank?
      @assessment = Assessment.create!(
        assessment_type_id: @assessment_type.id,
        organisation_id: @organisation.id,
        user_id: @user.id
      )
      @answers = []
    else
      @assessment = @assessment.first
      @answers = Answer.where(assessment_id: @assessment.id)
    end
    answer_hash = {}
    @answers.each do |answer|
      answer_hash[answer.question_id] = {
          question_id: answer.question_id,
          binomial_option_id: answer.binomial_option_id,
          trinomial_option_id: answer.trinomial_option_id,
          numerical: answer.numerical
        }
    end
    @answers = answer_hash
  end

  def update
    params.permit!
    answers = []
    params[:answers].each do |answer|
      Answer.where(question_id: answer.second[:question_id])
            .where(assessment_id: answer.second[:assessment_id])
            .delete_all
      answers << answer.second.to_h unless answer_is_blank(answer)
    end
    Answer.create!(answers)

    assessment_id = answers.blank? ? 1 : answers.first[:assessment_id]

    redirect_to '/assessments/' + assessment_id.to_s + '/edit'
  end

  private

  def answer_is_blank(answer)
    answer.second[:binomial_option_id].blank? &&
        answer.second[:trinomial_option_id].blank? &&
        answer.second[:numerical].blank?
  end
end
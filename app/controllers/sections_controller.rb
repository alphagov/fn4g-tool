class SectionsController < ApplicationController

  def new
    @user = User.find(1)
    @organisation = @user.organisation
    @section = Section.find(params[:id])
    @assessment_type = @section.questionset.assessment_type
    @assessment = Assessment.find(params[:assessment_id])
    @answers = {}
    render 'edit'
  end

  def edit
    @user = User.find(1)
    @organisation = @user.organisation
    @section = Section.find(params[:id])
    @assessment_type = @section.questionset.assessment_type
    @assessment = Assessment.find(params[:assessment_id])
    @answers = Answer.where(assessment_id: @assessment.id)

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
            .where(assessment_id: params[:assessment_id])
            .delete_all
      answers << answer.second.to_h unless answer_is_blank(answer)
    end
    Answer.create!(answers)

    # Find this by assessment type when we have more than one
    main_section = Section.where(compliance: true).first
    prefill_answers(main_section, params[:assessment_id]) if params[:id].to_i == main_section.id

    redirect_to '/assessments/' + params[:assessment_id] + '/edit'
  end

  private

  def prefill_answers(main_section, assessment_id)
    framework_ids_to_check = []
    questionsets = Assessment.find(assessment_id).assessment_type.questionsets

    questionsets.each do |questionset|
      questionset.sections.where(compliance: true).each do |section|
        section.questions.each do |question|
          question.answers
              .where(binomial_option_id: BinomialOption.find_by_name('Yes').id)
              .where(assessment_id: assessment_id).each do |answer|
            answer.question.framework_compliances.each do |framework_compliance|
              framework_ids_to_check << framework_compliance.framework_id
            end
          end
        end
      end
    end

    questionsets.each do |questionset|
      questionset.sections.where(compliance: false).each do |section|
        section.questions.each do |question|
          if 3 == question.mappings.where(framework_id: framework_ids_to_check).maximum(:weight)
            existing_answer = Answer.where(assessment_id: assessment_id).where(question_id: question.id)
            if existing_answer.blank?
              Answer.create!(
                  question_id: question.id,
                  assessment_id: assessment_id,
                  trinomial_option_id: TrinomialOption.find_by_name('Yes').id
              )
            end
          end
        end
      end
    end
  end

  def answer_is_blank(answer)
    answer.second[:binomial_option_id].blank? &&
        answer.second[:trinomial_option_id].blank? &&
        answer.second[:numerical].blank?
  end
end
class AssessmentsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @user = User.find(1)
    @organisation = @user.organisation
    @assessments = Assessment.sorted_list(@organisation.id, sort_column, sort_direction)
    @assessment = @assessments.first
    @vulnerabilities = Answer.vulnerabilities(@assessments)
  end

  def new
    @user = User.find(1)
    @organisation = @user.organisation
    @assessment_type = AssessmentType.find(1)
    @assessment = Assessment.create!(
        assessment_type_id: @assessment_type.id,
        organisation_id: @organisation.id,
        user_id: @user.id
    )
    @main_section = Section.find_by_name('Organisation compliance')
    redirect_to '/assessments/' + @assessment.id.to_s + '/sections/' + @main_section.id.to_s + '/edit'
  end

  def edit
    @organisation = Organisation.find(1)
    @assessment_type = AssessmentType.find(1)
    @assessment = Assessment.find(params[:id])
    @vulnerabilities = {}
    [['vuln.highCount', 'High'], ['vuln.mediumCount', 'Medium'], ['vuln.lowCount', 'Low']].each do |reference|
      answer = Answer.where(question_id: Question.find_by_reference(reference.first).id)
                   .where(assessment_id: @assessment.id).first
      @vulnerabilities[reference.second] = answer.numerical.to_i unless answer.blank?
    end
  end

  def update
    @organisation = Organisation.find(1)
    @assessment_type = AssessmentType.find(1)
    @assessment = Assessment.find(params[:id])
    @questionset = Questionset.where(assessment_type_id: @assessment_type.id).where(name: 'Automated metrics')
    #save_openvas_answers(@assessment, @questionset, load_openvas_data('AWS Test'))
    save_mailcheck_answers(@assessment)
    redirect_to '/assessments/' + @assessment.id.to_s + '/edit'
  end

  def openvas
    render :plain => load_openvas_data('AWS Test').inspect
  end

  def summary
    @assessment = Assessment.find(params[:id])

  end

  private

  def save_openvas_answers(assessment, questionset, results)
    i = 0
    ['vuln.highCount', 'vuln.mediumCount', 'vuln.lowCount'].each do |reference|
      save_answer(assessment, Question.find_by_reference(reference), results[i])
      i += 1
    end
  end

  def save_answer(assessment, question, result)
    Answer.where(question_id: question.id)
        .where(assessment_id: assessment.id)
        .delete_all
    Answer.create({question_id: question.id, assessment_id: assessment.id, numerical: result}) unless result.blank?
  end

  def sortable_columns
    %w[completed created_at completed_at]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end


  def save_mailcheck_answers(assessment)
    results = [0, 0]
    i = 0
    ['tls.errorCount', 'tls.warningCount'].each do |reference|
      save_answer(assessment, Question.find_by_reference(reference), results[i])
      i += 1
    end
    results = [0, 0]
    i = 0
    ['spf.errorCount', 'spf.warningCount'].each do |reference|
      save_answer(assessment, Question.find_by_reference(reference), results[i])
      i += 1
    end
    results = [2, 12]
    i = 0
    ['dkim.errorCount', 'dkim.warningCount'].each do |reference|
      save_answer(assessment, Question.find_by_reference(reference), results[i])
      i += 1
    end
    results = [0, 1]
    i = 0
    ['dmarc.errorCount', 'dmarc.warningCount'].each do |reference|
      save_answer(assessment, Question.find_by_reference(reference), results[i])
      i += 1
    end

    question = Question.find_by_reference('tls.hasSuccess')
    Answer.where(question_id: question.id)
        .where(assessment_id: assessment.id)
        .delete_all
    Answer.create({question_id: question.id, assessment_id: assessment.id, binomial_option_id: 1})
    question = Question.find_by_reference('dmarc.rejectSet')
    Answer.where(question_id: question.id)
        .where(assessment_id: assessment.id)
        .delete_all
    Answer.create({question_id: question.id, assessment_id: assessment.id, binomial_option_id: 1})
  end
end
module ApplicationHelper
  def sort_link(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }, class: css_class
  end

  def check_answer(answers, question_id, option, value)
    return '' if answers.blank? || answers[question_id].blank?

    answers[question_id][option] == value ? 'checked' : ''
  end

  def get_answer(answers, question_id, option)
    #return answers[question_id].inspect
    return '' if answers.blank? || answers[question_id].blank?

    answers[question_id][option]
  end
end

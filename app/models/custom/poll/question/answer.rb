require_dependency Rails.root.join("app", "models", "poll", "question", "answer").to_s

class Poll::Question::Answer
  has_many :partial_results, class_name: "Poll::PartialResult", dependent: :destroy, inverse_of: :answer

  has_many :choices, class_name: "Poll::Choice",
                     inverse_of: :question_answer,
                     foreign_key: :question_answer_id,
                     dependent: :destroy
  has_many :answers, class_name: "Poll::Answer",
                     through: :choices

  def total_votes
    answers.count + partial_results.sum(:amount)
  end

  def has_more_information?
    description.present? || documents.any? || images.any? || videos.any?
  end
end

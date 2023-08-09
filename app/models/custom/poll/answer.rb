require_dependency Rails.root.join("app", "models", "poll", "answer").to_s

class Poll::Answer
  has_many :choices, class_name: "Poll::Choice",
                     inverse_of: :answer,
                     foreign_key: :answer_id,
                     dependent: :destroy
  has_many :question_answers, class_name: "Poll::Question::Answer",
                              through: :choices

  skip_validation :answer, :presence
  skip_validation :answer, :inclusion

  validates :question_answer_ids, presence: true,
                                  if: ->(a) { a.question&.multiple_choice? && a.question.mandatory_answer? }
  validate :question_answer_ids_inclussion, if: ->(a) { a.question.present? }
  validates :question_answer_id, presence: true,
                                 if: ->(a) { a.question&.single_choice? && a.question.mandatory_answer? }
  validates :question_answer_id, inclusion: { in: ->(a) { a.question.question_answers.ids }},
                                 if: ->(a) { a.question&.single_choice? },
                                 allow_nil: true
  validates :open_answer, format: { with: /\d{4}\Z/,
                                    message: I18n.t("polls.answers.form.postal_code_validator") },
                          if: ->(a) { a.question&.open_answer? && a.question&.postal_code_validator? },
                          allow_blank: true
  validates :open_answer, numericality: { only_integer: true, greater_than: 10, less_than: 120 },
                          if: ->(a) { a.question&.open_answer? && a.question&.age_validator? },
                          allow_blank: true
  validates :open_answer, presence: true,
                          if: ->(a) { a.question&.open_answer? && a.question&.mandatory_answer? }

  def save_and_record_voter_participation(token = nil)
    transaction do
      touch if persisted?
      save!
      Poll::Voter.find_or_create_by!(user: author, poll: poll, origin: "web")
    end
  end

  def question_answer=(question_answer)
    self.question_answers = question_answer.present? ? [question_answer] : []
  end

  def question_answer
    question_answers&.first
  end

  def question_answer_id=(id)
    self.question_answer_ids = [id]
  end

  def question_answer_id
    question_answer_ids&.first
  end

  private

    def question_answer_ids_inclussion
      return unless question.multiple_choice?

      unless question_answer_ids.all? { |id| question.question_answers.ids.include?(id) }
        errors.add(:question_answer_ids, :inclussion)
      end
    end
end

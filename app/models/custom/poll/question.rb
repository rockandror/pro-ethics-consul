require_dependency Rails.root.join("app", "models", "poll", "question").to_s

class Poll::Question < ApplicationRecord
  KINDS = { open_answer: 0, single_choice: 1 }.freeze
  enum kind: KINDS

  VALIDATORS = %w[none age postal_code].freeze
  translates :description, touch: true
  globalize_accessors

  def postal_code_validator?
    validator == "postal_code"
  end

  def age_validator?
    validator == "age"
  end
end

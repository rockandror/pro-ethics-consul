class AddKindToPollQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :poll_questions, :kind, :integer, default: 0
  end
end

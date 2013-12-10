class RoutineLog < ActiveRecord::Base
  belongs_to :routine
  has_many :exercise_logs

  def next_exercise
    completed_exercise_ids = self.exercise_logs.collect(&:exercise_id)
    self.routine.exercises.order(order_num: :asc).detect { |ex| !completed_exercise_ids.include?(ex.id) }
  end
end
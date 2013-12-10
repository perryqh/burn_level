class ExerciseLog < ActiveRecord::Base
  belongs_to :routine_log
  belongs_to :exercise
  MASS_UNIT_TYPES     = %w{kilograms pounds}
  DISTANCE_UNIT_TYPES = %w{kilometers miles}
  validates :mass_units, inclusion: {in: MASS_UNIT_TYPES}, allow_nil: true
  validates :distance_units, inclusion: {in: DISTANCE_UNIT_TYPES}, allow_nil: true

  validates :rep_count, presence: true, if: :reps_required?
  validates :mass, presence: true, if: :mass_required?
  validates :mass_units, presence: true, if: :mass_required?
  validates :duration, presence: true, if: :time_required?
  validates :distance, presence: true, if: :distance_required?
  validates :distance_units, presence: true, if: :distance_required?

  delegate :reps_required?, :time_required?, :mass_required?, :distance_required?,
           to: :exercise, allow_nil: true

  def last_recorded_for_exercise
    RoutineLog.order(created_at: :desc).each do |routine_log|
      exercise_log = routine_log.exercise_logs.order(created_at: :desc).where(exercise_id: self.exercise_id).first
      return exercise_log if exercise_log
    end
    nil
  end
end
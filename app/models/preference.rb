class Preference  < ActiveRecord::Base
  belongs_to :user
  validates :mass_units, inclusion: {in: ExerciseLog::MASS_UNIT_TYPES}, allow_nil: true
  validates :distance_units, inclusion: {in: ExerciseLog::DISTANCE_UNIT_TYPES}, allow_nil: true
end
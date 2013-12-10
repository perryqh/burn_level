class Exercise < ActiveRecord::Base
  EXERCISE_TYPES = [TYPE_DISTANCE = 'Distance', TYPE_REPS = 'Reps', TYPE_TIME = 'Time', TYPE_WEIGHTED_REPS = 'Weighted Reps']

  belongs_to :routine

  validates :name, presence: true
  validates :order_num, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :exercise_type, presence: true, inclusion: {in: EXERCISE_TYPES}

  def reps_required?
    [TYPE_WEIGHTED_REPS, TYPE_REPS].include?(self.exercise_type)
  end

  def mass_required?
    TYPE_WEIGHTED_REPS == self.exercise_type
  end

  def time_required?
    TYPE_TIME == self.exercise_type
  end

  def distance_required?
    TYPE_DISTANCE == self.exercise_type
  end
end
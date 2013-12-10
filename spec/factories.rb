FactoryGirl.define do
  factory :routine do
    sequence(:name) { |n| "name-#{n}" }
  end

  factory :exercise do
    routine
    sequence(:order_num) { |n| n }
  end

  factory :distance_exercise, parent: :exercise do
    exercise_type Exercise::TYPE_DISTANCE
    name 'Run'
  end

  factory :time_exercise, parent: :exercise do
    exercise_type Exercise::TYPE_TIME
    name 'Laps'
  end

  factory :reps_exercise, parent: :exercise do
    exercise_type Exercise::TYPE_REPS
    name 'Pull ups'
  end

  factory :weighted_reps_exercise, parent: :exercise do
    exercise_type Exercise::TYPE_WEIGHTED_REPS
    name 'Curls'
  end

  factory :user do
    sequence(:uid) { |n| "uid-#{n}@" }
    provider 'twitter'
    name 'Jimmy Bob'
    role User::JOCK
  end

  factory :jock, parent: :user do
  end

  factory :admin, parent: :user do
    role User::ADMIN
  end

  factory :routine_log do
    routine
  end

  factory :exercise_log do
    routine_log
  end
end
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?

  Routine.destroy_all

  abripper = Routine.create(name: 'Ab Ripper', user: User.first)
  abripper.exercises.create(name: 'Scissors', exercise_type: Exercise::TYPE_REPS, order_num: 1)
  abripper.exercises.create(name: 'Superman Banana', exercise_type: Exercise::TYPE_REPS, order_num: 2)
end
object @exercise_log

attributes :id, :routine_log_id
attributes :rep_count, :mass, :mass_units, :duration, :distance, :distance_units

node(:created_at) {|prod| prod.created_at.to_s}
node(:updated_at) {|prod| prod.updated_at.to_s}

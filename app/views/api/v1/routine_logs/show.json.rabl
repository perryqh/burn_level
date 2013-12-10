object @routine_log

attributes :id, :routine_id

child(:exercise_logs) do
  extends "api/v1/exercise_logs/show"
end

node(:created_at) {|prod| prod.created_at.to_s}
node(:updated_at) {|prod| prod.updated_at.to_s}

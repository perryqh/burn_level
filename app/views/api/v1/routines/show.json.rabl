object @routine

attributes :id, :name, :slug, :user_id

child(:exercises) do
  extends "api/v1/exercises/show"
end

node(:created_at) {|prod| prod.created_at.to_s}
node(:updated_at) {|prod| prod.updated_at.to_s}

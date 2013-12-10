object @exercise

attributes :id, :name, :exercise_type, :slug, :order_num


node(:created_at) {|prod| prod.created_at.to_s}
node(:updated_at) {|prod| prod.updated_at.to_s}

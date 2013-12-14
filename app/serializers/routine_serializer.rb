class RoutineSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id
  has_many :exercises
end
class RoutineSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name, :user_id
  has_many :exercises
end
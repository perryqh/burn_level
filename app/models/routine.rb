class Routine < ActiveRecord::Base
  has_many :routine_logs
  has_many :exercises, -> { order(order_num: :asc) }
  belongs_to :user

  validates :name, presence: true

  accepts_nested_attributes_for :exercises, allow_destroy: true
end
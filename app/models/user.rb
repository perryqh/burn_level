class User < ActiveRecord::Base
  include Role
  has_many :routines
  has_one :preference
  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true
  validates :role, inclusion: {:in => ROLES}, allow_nil: false
  before_validation :set_defaults, on: :create
  validates :api_token, uniqueness: true

  def self.from_omniauth(auth)
    where(auth.slice('provider', 'uid')).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid      = auth['uid']
      user.name     = auth['info']['nickname']
      user.email     = auth['info']['email']
    end
  end

  private
  def set_defaults
    self.role ||= JOCK
    self.preference ||= Preference.new(mass_units: 'kilograms', distance_units: 'kilometers')
    self.api_token ||= SecureRandom.hex
  end
end
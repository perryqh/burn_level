ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factories'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.extend ControllerMacros, type: :controller
  config.order                                      = 'random'
  # instead of true.
  config.use_transactional_fixtures                 = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end

def routine_nested_attributes
  {"name" => "jimmy", "exercises_attributes" => [{"order_num" => 0, "name" => "one", "exercise_type" => "Time", "_destroy" => "false"},
                                                 {"order_num" => 1, "name" => "two", "exercise_type" => "Distance", "_destroy" => "false"},
                                                 {"name" => "", "exercise_type" => "", "_destroy" => "true"}]}
end

def first_exercise_log_attributes(exercise_id)
  {exercise_id: exercise_id, duration: '60'}
end

def last_exercise_log_attributes(exercise_id)
  {exercise_id: exercise_id, distance: 60, distance_units: 'miles'}
end

def twitter_auth
  {'provider' => 'twitter', 'uid' => SecureRandom.uuid, 'info' => {'nickname' => 'jimmy', 'email' => 'email@example.com'}}
end

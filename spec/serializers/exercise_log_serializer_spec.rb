require 'spec_helper'

describe ExerciseLogSerializer do
  let(:attributes) { attributes_for(resource_name) }

  it { should have_key(:id) }
end
require 'spec_helper'

describe ExerciseSerializer do
  let(:attributes) { attributes_for(resource_name) }

  it { should have_key(:id) }
  it { should have_key(:name) }
end
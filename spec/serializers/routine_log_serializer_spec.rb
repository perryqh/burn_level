require 'spec_helper'

describe RoutineLogSerializer do
  let(:attributes) { attributes_for(resource_name) }

  it { should have_key(:id) }
end
require 'spec_helper'

describe RoutineSerializer do
  let(:attributes) { attributes_for(resource_name) }
  let(:resource) do
    double(resource_name, attributes).tap do |double|
      double.stub(:read_attribute_for_serialization) { |name| attributes[name] }
      double.stub(exercises: [])
    end
  end

  it { should have_key(:id) }
  it { should have_key(:name) }
  it { should have_key(:user_id) }
end
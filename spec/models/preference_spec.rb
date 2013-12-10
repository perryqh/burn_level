require 'spec_helper'

describe Preference do
  describe :validations do
    it { should belong_to(:user) }
    it { should ensure_inclusion_of(:mass_units).in_array(%w{kilograms pounds}) }
    it { should ensure_inclusion_of(:distance_units).in_array(%w{kilometers miles}) }
  end
end
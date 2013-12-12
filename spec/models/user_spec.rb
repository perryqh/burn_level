require 'spec_helper'

describe User do
  describe 'validations' do
    it { should validate_presence_of :uid }
    it { should validate_presence_of :provider }
    it { should ensure_inclusion_of(:role).in_array(User::ROLES) }
    it { should have_many(:routines) }
    it { should have_one(:preference) }
  end

  describe :api_token do
    it "should generate token before create" do
      create(:user).api_token.should_not be_nil
    end

    it "should be unique" do
      user       = create(:user)
      same_token = build(:user, api_token: user.api_token)
      same_token.should_not be_valid
      same_token.errors[:api_token].should eq(['has already been taken'])
    end

    it "should populate api_token before save if it's not already populated" do
      user = build(:user)
      user.api_token.should be_nil
      user.save!
      user.api_token.should_not be_nil
    end
  end

  describe :preference do
    it "should create a reference before save" do
      create(:jock).preference.should_not be_nil
    end
  end

  describe :from_omniauth do
    context 'user does not already exist' do
      subject { User.from_omniauth twitter_auth }

      its(:provider) { should eq('twitter') }
      its(:name) { should eq('jimmy') }
      its(:email) { should eq('email@example.com') }
      its(:uid) { should_not be_nil }
    end

    context 'user does already exist' do
      let(:auth_hash) { twitter_auth }
      it "does not create a new user if already exists" do
        user = User.from_omniauth auth_hash
        User.should_not_receive(:create_from_omniauth)
        User.from_omniauth(auth_hash).id.should eq(user.id)
      end
    end
  end

  describe :has_role? do
    [{role: User::JOCK, roles: %w{jock}, expected: true},
     {role: User::JOCK, roles: 'jock', expected: true},
     {role: User::ADMIN, roles: 'admin', expected: true},
     {role: User::JOCK, roles: %w{jock random}, expected: true},
     {role: User::JOCK, roles: %w{jock admin}, expected: true},
     {role: User::ADMIN, roles: %w{admin nothing}, expected: true},
     {role: User::JOCK, roles: %w{couchpotatoe}, expected: false},
     {role: User::JOCK, roles: %w{sleeper}, expected: false},
     {role: User::JOCK, roles: '', expected: false}
    ].each do |test_hash|
      it "#{test_hash[:role]} has_role? #{test_hash[:roles]} exptected #{test_hash[:expected]}" do
        build(:user, role: test_hash[:role]).has_role?(test_hash[:roles]).should eq(test_hash[:expected])
      end
    end
  end
end
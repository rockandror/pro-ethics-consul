require "rails_helper"
require "cancan/matchers"

describe Abilities::Everyone do
  subject(:ability) { Ability.new(user) }

  describe "guest" do
    let(:user) { create(:guest) }

    it { should be_able_to(:answer, Poll) }
    it { should be_able_to(:answer, Poll::Question) }
  end
end

# frozen_string_literal: true

describe StripeMRR::Customer do
  subject { described_class.new(stripe_customer) }
  let(:stripe_customer) { double('stripe_customer') }

  %i[id name email].each do |attr|
    it { should respond_to(attr) }
  end
end

# frozen_string_literal: true

describe StripeMRR::Subscription do
  subject { described_class.new(stripe_subscription) }
  let(:stripe_subscription) { double('stripe_subscription') }

  describe '#gross_monthly_recurring_revenue' do
    context 'when subscription is a trial' do
      before :each do
        allow(stripe_subscription).to receive(:status)
          .and_return('trialing')
      end

      it { expect(subject.gross_monthly_recurring_revenue).to eq(0) }
    end
  end
end

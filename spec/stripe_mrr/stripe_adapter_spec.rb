# frozen_string_literal: true

require 'stripe_mock'
require 'helpers/stripe_test_data'

describe StripeMRR::StripeAdapter do
  subject { described_class.new(api_key: api_key) }
  let(:api_key) { 'foo' }

  let(:stripe_helper) { StripeMock.create_test_helper }

  before { StripeMock.start }
  after  { StripeMock.stop }

  describe '#initialize' do
    context 'it raises error when api_key is invalid' do
      let(:api_key) { '' }

      it do
        expect { subject }.to raise_error(
          ArgumentError,
          /api_key is invalid!/
        )
      end
    end
  end

  describe '#customers' do
    context 'when no clients are found' do
      it { expect(subject.customers).to be_empty }
    end

    context 'when customers are created' do
      it do
        customer, _subscription = create_sample_data(stripe_helper)
        expect(subject.customers.size).to eq(1)

        expect(subject.customers.first.id)
          .to eq(StripeMRR::Customer.new(customer).id)
      end
    end
  end
end

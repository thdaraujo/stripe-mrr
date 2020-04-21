# frozen_string_literal: true

describe StripeMRR::ReportMRR do
  subject { described_class.new }

  let(:stripe_helper) { StripeMock.create_test_helper }

  before { StripeMock.start }
  after  { StripeMock.stop }

  describe '#generate' do
    context 'when subscription have no discounts' do
      let(:expected_mrr_per_customer) do
        [{
          customer_email: 'stripe_mock@example.com',
          customer_id: 'test_cus_3',
          customer_name: nil,
          gross_mrr: 200,
          discounted_mrr: 200
        },
         {
           customer_email: 'stripe_mock@example.com',
           customer_id: 'test_cus_8',
           customer_name: nil,
           gross_mrr: 200,
           discounted_mrr: 200
         }]
      end

      it 'returns the monthly recurring revenue for each client' do
        create_sample_data(
          stripe_helper,
          plan_amount: 1200,
          plan_interval: 'year',
          percent_off: 0
        )

        create_sample_data(
          stripe_helper,
          plan_amount: 100,
          plan_interval: 'month',
          percent_off: 0
        )

        actual = subject.generate
        expect(actual.size).to eq(expected_mrr_per_customer.size)
        expect(actual).to match_array(expected_mrr_per_customer)
      end
    end

    context 'when subscriptions have a coupon with a forever duration' do
      let(:expected_mrr_per_customer) do
        [{
          customer_email: 'stripe_mock@example.com',
          customer_id: 'test_cus_3',
          customer_name: nil,
          gross_mrr: 200,
          discounted_mrr: 50
        },
         {
           customer_email: 'stripe_mock@example.com',
           customer_id: 'test_cus_8',
           customer_name: nil,
           gross_mrr: 200,
           discounted_mrr: 50
         }]
      end

      it 'a discount is applied to the monthly recurring revenue' do
        create_sample_data(
          stripe_helper,
          plan_amount: 1200,
          plan_interval: 'year',
          percent_off: 75
        )

        create_sample_data(
          stripe_helper,
          plan_amount: 100,
          plan_interval: 'month',
          percent_off: 75
        )

        actual = subject.generate
        expect(actual.size).to eq(expected_mrr_per_customer.size)
        expect(actual).to match_array(expected_mrr_per_customer)
      end
    end
  end
end

# frozen_string_literal: true

describe StripeMRR::Discount do
  subject { described_class.new(stripe_discount) }
  let(:stripe_discount) { double('stripe_discount') }

  describe '#should_affect_mrr?' do
    context 'when discount has a coupon with a forever duration' do
      before :each do
        allow(stripe_discount).to receive_message_chain(:coupon, :duration)
          .and_return('forever')
      end

      it { expect(subject.should_affect_mrr?).to be true }
    end

    context 'when discount has a coupon with other type of duration' do
      before :each do
        allow(stripe_discount).to receive_message_chain(:coupon, :duration)
          .and_return('repeating')
      end

      it { expect(subject.should_affect_mrr?).to be false }
    end
  end

  describe '#percentage_off' do
    before :each do
      allow(stripe_discount).to receive_message_chain(:coupon, :percent_off)
        .and_return(50)
    end

    it { expect(subject.percentage_off).to eq(0.5) }
  end

  describe '#calculate_discount_amount' do
    before :each do
      allow(stripe_discount).to receive_message_chain(:coupon, :percent_off)
        .and_return(50)
    end

    it { expect(subject.calculate_discount_amount(1000)).to eq(500) }
  end
end

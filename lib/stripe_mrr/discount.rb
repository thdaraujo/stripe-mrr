# frozen_string_literal: true

module StripeMRR
  # Discount will be used to calculate
  # and discount the MRR for a client or subscription
  # depending on the duration
  class Discount
    def initialize(discount)
      @discount = discount
    end

    # MRR should be impacted by a discount
    # only when the coupon has a forever duration
    # as suggested by Stripe
    # https://support.stripe.com/questions/impact-of-discounts-and-coupons-on-monthly-recurring-revenue-mrr-in-billing
    def should_affect_mrr?
      @discount&.coupon &&
        @discount.coupon.duration == 'forever'
    end

    def percentage_off
      return 0 unless @discount&.coupon&.percent_off

      @discount.coupon.percent_off.to_f / 100
    end

    def calculate_discount_amount(gross_mrr)
      gross_mrr * percentage_off
    end
  end
end

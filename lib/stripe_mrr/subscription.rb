# frozen_string_literal: true

module StripeMRR
  # Subscription will let us calculate the
  # gross MRR for a subscription
  # and apply the necessary discounts
  # MRR for a trial subscription will be 0.
  class Subscription
    def initialize(subscription)
      @subscription = subscription
    end

    def gross_monthly_recurring_revenue
      return 0 if trial?

      monthly_normalized_amounts.sum
    end

    def discounted_monthly_recurring_revenue
      gross_mrr = gross_monthly_recurring_revenue
      discount_amount = calculate_discount_amount(gross_mrr)
      gross_mrr - discount_amount
    end

    private

    def discount
      @discount ||= Discount.new(@subscription.discount)
    end

    def trial?
      @subscription.status == 'trialing'
    end

    def monthly_normalized_amounts
      return [] unless @subscription.items

      @subscription.items.map do |item|
        plan = item.plan
        amount = if plan.interval == 'year'
                   plan.amount.to_f / 12
                 else
                   plan.amount.to_f
        end
        amount * item.quantity
      end.compact
    end

    def calculate_discount_amount(gross_mrr)
      return 0 unless discount

      if discount&.should_affect_mrr?
        discount.calculate_discount_amount(gross_mrr)
      else
        0
      end
    end
  end
end

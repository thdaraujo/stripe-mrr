# frozen_string_literal: true

require 'forwardable'

module StripeMRR
  # The customer class will wrap calls to the customer object
  # returned by stripe and let us calculate MRR for the specific customer
  class Customer
    extend Forwardable

    def_delegators :@customer, :id, :name, :email

    def initialize(customer)
      @customer = customer
    end

    def gross_mrr
      subscriptions.map(&:gross_monthly_recurring_revenue).sum
    end

    def discounted_mrr
      mrr = subscriptions.map(&:discounted_monthly_recurring_revenue).sum
      discount_amount = calculate_discount_amount(mrr)
      mrr - discount_amount
    end

    private

    def subscriptions
      return [] unless @customer.subscriptions

      @subscriptions ||= @customer.subscriptions.map do |subscription|
        Subscription.new(subscription)
      end
    end

    def discount
      @discount ||= Discount.new(@customer.discount)
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

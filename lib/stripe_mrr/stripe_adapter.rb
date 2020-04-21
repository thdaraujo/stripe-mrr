# frozen_string_literal: true

require 'dotenv/load'
require 'stripe'

module StripeMRR
  # StripeAdapter will wrap the calls to Stripe API
  # We do this to separate the concerns and isolate
  # a little bit of the dependency on the stripe client gem
  class StripeAdapter
    def initialize(api_key: ENV['STRIPE_API_KEY'])
      if api_key.nil? || api_key.empty?
        raise ArgumentError, 'api_key is invalid!'
      end

      Stripe.api_key = api_key
      Stripe.max_network_retries = 2
    end

    def customers
      @customers ||= customer_list.map do |customer|
        Customer.new(customer)
      end
    end

    private

    def customer_list
      opts = { limit: 10, expand: ['data.subscription'] }
      Stripe::Customer.list(opts).auto_paging_each.to_a
    end
  end
end

# frozen_string_literal: true

def create_sample_data(stripe_helper,
                       plan_amount: 1200,
                       plan_interval: 'year',
                       percent_off: 0)

  card_token = stripe_helper.generate_card_token
  customer = Stripe::Customer.create(source: card_token)

  plan = stripe_helper.create_plan(
    id: SecureRandom.hex,
    name: 'test-plan',
    amount: plan_amount,
    currency: 'usd',
    interval: plan_interval
  )

  coupon = stripe_helper.create_coupon(
    id: SecureRandom.hex,
    duration: 'forever',
    duration_in_months: nil,
    amount_off: nil,
    percent_off: percent_off
  )

  subscription = Stripe::Subscription.create(
    plan: plan.id,
    customer: customer.id,
    coupon: coupon.id
  )

  [customer, subscription]
end

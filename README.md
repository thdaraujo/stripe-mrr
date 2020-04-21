# stripe-mrr
Calculates Monthly Recurring Revenue from Stripe API data

The code is a plain-ruby project that pulls information from the Stripe API using
the `stripe` gem.

Customer information is pulled from Stripe, including subscriptions and subscription plans,
items, quantities and discounts. It calculates the monthly-recurring revenue for each client
by looking at all of their subscriptions that are **not on trial**, and doing a sum of all the *amounts* 
multiplied by their *quantities* in each plan related to each item in a subscription. 
If the plan is an yearly plan, we divide the total amount by 12.

We also calculate the discounts and subtract their value from the MRR. For each subscription, 
if a discount is found and a coupon is present,
we calculate the percentage that should be deducted from the plan amounts and substract it from
the gross MRR. We only apply discounts
when the coupon has duration equal to *forever*. This is in line with the way Stripe calculates MRR,
and more information about it can be [read here](https://support.stripe.com/questions/impact-of-discounts-and-coupons-on-monthly-recurring-revenue-mrr-in-billing).

Even though the provided Stripe account contains other types of discounts, they don't have
duration equal to *forever*, so they have no effect on the final discounted MRR.

Tests were written using `rspec`.

## Running the code

### Dependencies

To run this project you'll need:

- [asdf version manager](https://github.com/asdf-vm/asdf) [optional]
- ruby 2.6.3
- bundler

#### asdf

To install asdf to manage your ruby versions [optional], follow [these instructions](https://asdf-vm.com/#/core-manage-asdf-vm).

To install `ruby 2.6.3` using asdf, run:
```
$ asdf plugin-add ruby
$ asdf install ruby 2.6.3
```

To check the local ruby version, run:
```
$ cd stripe-mrr
$ asdf current ruby
# 2.6.3    (set by .../.tool-versions)

$ ruby -v
# ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-darwin17]
```

If local version is not set, run:
```
$ asdf local ruby 2.6.3
$ asdf reshim ruby
```

#### Bundler

To install bundler, run:
```
$ gem install bundler
```

To install all the required dependencies (gems), run:
```
$ bundle install
```

#### Environment Variables (IMPORTANT)

This project uses `dotenv` to manage environment variables.
In order to run the code, please edit the file `.env.sample` and add the real Stripe API key:
```
STRIPE_API_KEY=[CHANGEME]
```

## Generating MRR report

The report can be generated with a rake task:

```
$ rake reports:print  # Print MRR report on screen with formatted values
```

To see the raw data, run this rake task:
```
$ rake reports:mrr    # Generate MRR report with raw data
```

## Running tests

Tests are located in the `/spec` folder.
To run tests, use rspec:
```
$ rspec
```
Or `rake spec`
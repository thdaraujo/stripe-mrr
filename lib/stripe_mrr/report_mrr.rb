# frozen_string_literal: true

module StripeMRR
  # ReportMRR will generate a report
  # showing the monthly-recurring revenue for
  # each client available in a given stripe account
  class ReportMRR
    def generate
      adapter.customers.map do |customer|
        {
          customer_id: customer.id,
          customer_name: customer.name,
          customer_email: customer.email,
          gross_mrr: customer.gross_mrr,
          discounted_mrr: customer.discounted_mrr
        }
      end
    end

    def generate_and_print
      data = generate
      result = data.inject([]) do |acc, item|
        lines = []
        lines << item[:customer_name]
        lines << item[:customer_email]
        lines << format('$%.2f', (item[:gross_mrr] / 100)).to_s
        lines << format('$%.2f', (item[:discounted_mrr] / 100)).to_s

        acc << lines.join("\t")
      end.join("\n")

      puts ['name', 'email', 'MRR (Gross)', 'MRR (discounted)'].join("\t")
      puts result
    end

    private

    def adapter
      @adapter ||= StripeMRR::StripeAdapter.new
    end
  end
end

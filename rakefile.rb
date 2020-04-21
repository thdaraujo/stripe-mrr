# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'
require './lib/stripe_mrr'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
end

task default: :spec

namespace :reports do
  desc 'Generate MRR report'
  task :mrr do
    puts StripeMRR::ReportMRR.new.generate
  end

  desc 'Print MRR report on screen'
  task :print do
    puts StripeMRR::ReportMRR.new.generate_and_print
  end
end

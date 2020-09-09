# frozen_string_literal: true

FactoryBot.define do
  factory :upload, class: 'SpeedtestNet::Upload' do
    results { 1.upto(8).map { |i| i * 1_000_000_000_000.0 } }

    initialize_with { new(results) }
  end
end

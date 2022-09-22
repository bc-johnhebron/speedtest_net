# frozen_string_literal: true

require 'curb'
require 'securerandom'
require 'timeout'
require 'speedtest_net/calculate_speed'
require 'speedtest_net/http_timeout'

module SpeedtestNet
  class Upload
    SIZE = [25_000, 50_000, 100_000, 200_000, 400_000].freeze

    def initialize(results)
      @results = results
    end

    def calculate
      CalculateSpeed.call(@results)
    end

    def to_hash
      hash = {}
      @results.each_with_index do |v, i|
        hash["Upload #{i}"] = v
      end
      hash
    end

    def to_array
      array = []
      @results.map do |v|
        array << v
      end
      array
    end

    class << self
      def measure(server, timeout: HTTP_TIMEOUT) # rubocop:disable Metrics/MethodLength
        config = Config.fetch
        concurrent_number = config.upload[:threadsperurl]

        results = []
        begin
          Timeout.timeout(timeout) do
            SIZE.each do |size|
              urls = create_urls(server, concurrent_number)
              results << multi_uploader(urls, size)
            end
          end
        rescue Timeout::Error # rubocop:disable Lint/SuppressedException
        end
        new(results)
      end

      private

      def create_urls(server, number)
        Array.new(number) do
          random = SecureRandom.urlsafe_base64
          "#{server.url}?x=#{random}"
        end
      end

      def multi_uploader(urls, size) # rubocop:disable Metrics/MethodLength
        responses = []
        post_field = "content1=#{'A' * size}"
        multi = Curl::Multi.new
        urls.each do |url|
          client = Curl::Easy.new(url)
          client.headers['User-Agent'] = USER_AGENT
          client.http_post(post_field)
          client.on_complete { |data| responses << data }
          multi.add(client)
        end
        multi.perform
        responses.sum(&:upload_speed) * 8
      end
    end
  end
end

# frozen_string_literal: true

require 'speedtest_net/formatter/distance'
require 'speedtest_net/formatter/latency'
require 'speedtest_net/formatter/speed'

module SpeedtestNet
  class Result
    attr_reader :client, :server

    def initialize(client, server, download, upload)
      @client = client
      @server = server
      @download = download
      @upload = upload
    end

    def download
      @download.calculate
    end

    def pretty_download
      Formatter::Speed.call(download)
    end

    def upload
      @upload.calculate
    end

    def pretty_upload
      Formatter::Speed.call(upload)
    end

    def latency
      @server.latency
    end

    def pretty_latency
      Formatter::Latency.call(latency)
    end

    def distance
      @server.distance
    end

    def pretty_distance
      Formatter::Distance.call(distance)
    end

    def keys
      keys_from_hash = []
      to_hash.map do |k, _v|
        keys_from_hash << k
      end
      keys_from_hash
    end

    def to_hash
      hash = {}
      hash.merge!(@client.to_hash)
      hash.merge!(@server.to_hash)
      hash.merge!(@download.to_hash)
      hash.merge!(@upload.to_hash)
    end

    def to_array
      array = []
      array.concat(@client.to_array)
      array.concat(@server.to_array)
      array.concat(@download.to_array)
      array.concat(@upload.to_array)
    end
  end
end

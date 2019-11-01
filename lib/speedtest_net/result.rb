# frozen_string_literal: true

module SpeedtestNet
  class Result
    UNITS = %w[bps Kbps Mbps Gbps Tbps].freeze

    attr_reader :server, :client, :download, :upload

    def initialize(client, server, download, upload)
      @client = client
      @server = server
      @download = download
      @upload = upload
    end

    def pretty_download
      pretty_format(@download)
    end

    def pretty_upload
      pretty_format(@upload)
    end

    def latency
      @server.latency
    end

    def pretty_latency
      format('%<latency>f millisecond', latency: latency * 1_000)
    end

    private

    def pretty_format(speed)
      i = 0
      while speed > 1000
        speed /= 1000
        i += 1
      end
      format('%<speed>.2f %<unit>s', speed: speed, unit: UNITS[i])
    end
  end
end

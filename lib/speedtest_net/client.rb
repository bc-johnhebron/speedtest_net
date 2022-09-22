# frozen_string_literal: true

module SpeedtestNet
  class Client
    attr_reader :ip, :isp, :geo

    def initialize(ip, isp, geo)
      @ip = ip
      @isp = isp
      @geo = geo
    end

    def to_hash
      {
        ip: @ip,
        isp: @isp,
        client_lat: @geo.to_hash[:lat],
        client_long: @geo.to_hash[:long]
      }
    end

    def to_array
      array = [@ip, @isp]
      array.map! do |element|
        if element.is_a?(String)
          "\"#{element}\""
        else
          element
        end
      end
      array.concat(@geo.to_array)
    end
  end
end

# frozen_string_literal: true

RSpec.describe SpeedtestNet::Upload do
  describe '.measure' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:config) { build(:config) }
    let(:server) { build(:server) }
    let(:multi_mock) { instance_double(Curl::Multi) }
    let(:easy_mock) { instance_double(Curl::Easy) }
    let(:post_mock) { instance_double(Curl::PostField) }
    let(:fake_speed) { 1.upto(10).map { |i| i / 10.0 } }
    let(:result_speed) { fake_speed.map { |s| s * 8 } }

    before do
      allow(SpeedtestNet::Config).to receive(:fetch).and_return(config)
      allow(Curl::Multi).to receive(:new).and_return(multi_mock)
      allow(Curl::Easy).to receive(:new).and_return(easy_mock)
      allow(Curl::PostField).to receive(:content).and_return(post_mock)
      allow(multi_mock).to receive(:add)
      allow(multi_mock).to receive(:perform)
      allow(easy_mock).to receive(:headers).and_return({})
      allow(easy_mock).to receive(:http_post).and_return(post_mock)
      allow(easy_mock).to receive(:on_complete).and_yield(easy_mock)
      allow(easy_mock).to receive(:upload_speed).and_return(*fake_speed)
    end

    it 'was valid' do
      expect(described_class.measure(server)).to be_instance_of(described_class)
    end
  end

  describe '#calculate' do
    let(:upload) { build(:upload) }

    it 'was valid' do
      expect(upload.calculate).to eq(5_000_000_000_000.0)
    end
  end
end

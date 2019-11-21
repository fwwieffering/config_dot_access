require_relative './config.rb'
require 'yaml'

describe Config do
  let(:config_file_hash) do
    YAML.load(File.open(File.join(File.dirname(__FILE__), 'test.yaml')))
  end

  before do
    # load configs
    Config.load!(File.join(File.dirname(__FILE__), 'test.yaml'))
  end

  describe :load do
    it 'will load config file' do
      expect(Config._config.to_h.keys.map(&:to_s)).to eq(config_file_hash.keys)
    end
  end

  describe :config_access do
    it 'can access top level keys' do
      expect(Config.foo).to eq(config_file_hash['foo'])
    end
    it 'can access top level keys with brackets' do
      expect(Config['foo']).to eq(config_file_hash['foo'])
    end
    it 'can access nested dict keys' do
      expect(Config['lorem'].ipsum['dolor']).to eq(config_file_hash['lorem']['ipsum']['dolor'])
    end
    it 'can access nested dict keys with dot notation' do
      expect(Config.lorem.ipsum.dolor).to eq(config_file_hash['lorem']['ipsum']['dolor'])
    end
    it 'can access nested dict keys with brackets' do
      expect(Config['lorem']['ipsum']['dolor']).to eq(config_file_hash['lorem']['ipsum']['dolor'])
    end
    it 'can access nested dict arrays' do
      expect(Config.dns_servers[0]).to eq(config_file_hash['dns_servers'][0])
    end
    it 'can access hash keys from arrays of hashes with dot notation' do
      expect(Config.dns_servers[0].owner).to eq(config_file_hash['dns_servers'][0]['owner'])
    end
  end

  describe :errors do
    it 'throws ConfigError for missing top level keys' do
      expect { Config.foobar }.to raise_error(ConfigError)
    end
    it 'throws ConfigError for missing nested keys' do
      expect { Config.maas['foobar'] }.to raise_error(ConfigError)
    end
    it 'throws ConfigError for indexErrors' do
      expect { Config.maas.dns_servers[2] }.to raise_error(ConfigError)
    end
  end
end

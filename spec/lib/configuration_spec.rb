require 'rails_helper'

describe Stagehand::Configuration do
  describe 'production_connection_name' do
    it 'returns the value from the Rails custom configuration variable stagehand.production_connection_name' do
      expect { Rails.configuration.x.stagehand.production_connection_name = 'test' }
        .to change { subject.production_connection_name }.to('test')
    end

    it 'raises an exception when not set' do
      Rails.configuration.x.stagehand.production_connection_name = nil
      expect { subject.production_connection_name }.to raise_exception(Stagehand::ProductionConnectionNameNotSet)
    end
  end

  describe 'staging_connection_name' do
    it 'returns the value from the Rails custom configuration variable stagehand.staging_connection_name' do
      expect { Rails.configuration.x.stagehand.staging_connection_name = 'test' }
        .to change { subject.staging_connection_name }.to('test')
    end

    it 'raises an exception when not set' do
      Rails.configuration.x.stagehand.staging_connection_name = nil
      expect { subject.staging_connection_name }.to raise_exception(Stagehand::StagingConnectionNameNotSet)
    end
  end

  describe '::ghost_mode' do
    it 'returns the value from the Rails custom configuration variable stagehand.ghost_mode' do
      expect { Rails.configuration.x.stagehand.ghost_mode = 'test' }.to change { subject.ghost_mode }.to('test')
    end
  end
end
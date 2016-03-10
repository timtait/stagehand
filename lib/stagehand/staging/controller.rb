module Stagehand
  module Staging
    module Controller
      extend ActiveSupport::Concern

      included do
        include Stagehand::ControllerExtensions

        skip_action_callback :use_production_database
        around_action :use_staging_database
      end
    end
  end
end

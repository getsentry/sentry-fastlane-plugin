module Fastlane
  module Helper
    class SentryHelper
      # class methods that you define here become available in your action
      # as `Helper::SentryHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the sentry plugin helper!")
      end
    end
  end
end

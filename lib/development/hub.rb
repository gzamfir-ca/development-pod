# frozen_string_literal: true

module Development
  # provides pod helper methods
  module Hub
    def setup_core?
      update_options? && fetch_data? && patch_file? && patch_data?
    end
  end
end

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  connects_to shards: {
    default: { writing: :primary, reading: :primary },
    production: { writing: :primary, reading: :primary }
  }
end

class Url < ApplicationRecord
    belongs_to :user, optional: true
    
    before_create :generate_hash_id
    
    validates :short_code, length: { in: 4..30 }, allow_blank: false

    private

    def generate_hash_id
    self.hash_id = SecureRandom.uuid
    end
end

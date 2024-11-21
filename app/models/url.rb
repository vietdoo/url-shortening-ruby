class Url < ApplicationRecord
    before_create :generate_hash_id

    private

    def generate_hash_id
    self.hash_id = SecureRandom.uuid
    end
end

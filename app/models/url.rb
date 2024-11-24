class Url < ApplicationRecord
    belongs_to :user, optional: true
    
    before_create :generate_hash_id
    
    validates :short_code, length: { in: 4..30 }, allow_blank: false
    validate :valid_original_url

    private

    def generate_hash_id
        self.hash_id = SecureRandom.uuid
    end

    def valid_original_url
    if original_url.blank?
        errors.add(:original_url, "can't be blank")
        return
    end

    uri = URI.parse(original_url)
    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
        errors.add(:original_url, "is not a valid URL")
    end
    rescue URI::InvalidURIError
    errors.add(:original_url, "is not a valid URL")
    end

    
end

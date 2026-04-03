class BusinessProfile < ApplicationRecord
  belongs_to :user
  validates :name, :segment, presence: true
  validate :validate_business_limit, on: :create

  private

  def validate_business_limit
    if user.business_profiles.count >= 5
      errors.add(:base, "Você atingiu o limite de 5 perfis de empresa.")
    end
  end
end

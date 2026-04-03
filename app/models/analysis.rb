class Analysis < ApplicationRecord
  belongs_to :user
  # ADICIONE ESTA LINHA:
  belongs_to :business_profile, optional: true

  # Active Storage
  has_one_attached :campaign_csv
  has_many_attached :ad_artworks
  # ADICIONE ESTA LINHA PARA OS PRINTS DO GERENCIADOR:
  has_many_attached :event_manager_screenshots

  # ... (PLATFORMS e META_OBJECTIVES continuam iguais)

  # REMOVA business_name e segment das validações, pois eles agora
  # pertencem ao BusinessProfile associado.
  validates :campaign_objective, presence: true

  before_create :generate_public_token

  private

  def generate_public_token
    self.public_token = SecureRandom.uuid
  end
end

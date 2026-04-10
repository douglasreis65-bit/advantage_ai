class Analysis < ApplicationRecord
  belongs_to :user
  belongs_to :business_profile, optional: true

  # Active Storage
  has_one_attached :campaign_csv
  has_many_attached :ad_artworks
  has_many_attached :event_manager_screenshots

  # Status possíveis para o fluxo do diagnóstico
  STATUSES = %w[processing completed failed].freeze

  # Plataformas de E-commerce/Infoprodutos
  PLATFORMS = [
    "Shopify", "Nuvemshop", "Tray", "Loja Integrada", "VTEX", "WooCommerce",
    "Hotmart", "Kiwify", "CartPanda", "Yampi", "Bagy", "Wix", "Magento",
    "Eduzz", "Braip", "Monetizze", "Ticto", "Appmax", "Evermart", "Kirvano",
    "Perfect Pay", "Magazord", "iSet", "Dooca", "Simplo7", "Wake Commerce",
    "Mercado Shops", "Amazon", "Shopee", "Magazine Luiza", "Americanas",
    "PrestaShop", "OpenCart", "Salesforce Commerce Cloud", "Oracle Commerce",
    "BigCommerce", "Loja VirtUOL", "Squarespace", "Ecwid", "HeroSpark",
    "Guru", "Greenn", "Lastlink", "Memberkit", "Doppler", "Venda de Gorila",
    "ClickBank", "Xtech", "Webnode", "Ideris", "Outros"
  ].freeze

  # Validações
  validates :campaign_objective, presence: true
  validates :conversion_location, presence: true
  validates :status, inclusion: { in: STATUSES }

  # Callbacks
  before_validation :set_default_status, on: :create
  before_create :generate_public_token

  # Métodos auxiliares para facilitar na View/Controller
  def completed?
    status == 'completed'
  end

  def processing?
    status == 'processing'
  end

  def failed?
    status == 'failed'
  end

  private

  def set_default_status
    self.status ||= 'processing'
  end

  def generate_public_token
    self.public_token = SecureRandom.uuid
  end
end

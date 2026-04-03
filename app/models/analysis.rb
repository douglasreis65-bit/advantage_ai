class Analysis < ApplicationRecord
  belongs_to :user
  belongs_to :business_profile, optional: true

  # Active Storage
  has_one_attached :campaign_csv
  has_many_attached :ad_artworks
  has_many_attached :event_manager_screenshots

  # AS CONSTANTES PRECISAM ESTAR AQUI DENTRO:
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

  META_OBJECTIVES = [
    "Reconhecimento", "Tráfego", "Engajamento", "Cadastros",
    "Promoção do app", "Vendas"
  ].freeze

  validates :campaign_objective, presence: true

  before_create :generate_public_token

  private

  def generate_public_token
    self.public_token = SecureRandom.uuid
  end
end

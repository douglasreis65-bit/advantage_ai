class User < ApplicationRecord
  # Devise modules...
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo
  has_many :business_profiles, dependent: :destroy

  # Validação para não deixar o nome em branco no perfil
  validates :full_name, presence: true, on: :update
end

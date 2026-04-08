class Game < ApplicationRecord
  has_many :trophy_groups, dependent: :destroy
  has_many :earned_trophies, dependent: :destroy

  # "trophy2" for PS5, "trophy" for all others
  def psn_service_name
    platform == "PS5" ? "trophy2" : "trophy"
  end
end

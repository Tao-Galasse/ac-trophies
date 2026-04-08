class TrophyGroup < ApplicationRecord
  belongs_to :game
  has_many :earned_trophies, dependent: :nullify
end

class EarnedTrophy < ApplicationRecord
  belongs_to :game
  belongs_to :trophy_group
end

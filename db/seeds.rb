require "yaml"

data = YAML.load_file(Rails.root.join("config", "games.yml"))

data["games"].each do |game_data|
  game = Game.find_or_initialize_by(psn_communication_id: game_data["psn_communication_id"])
  game.update!(name: game_data["name"], platform: game_data["platform"], release_date: game_data["release_date"])

  game_data["trophy_groups"].each_with_index do |tg_data, i|
    psn_group_id = (i == 0) ? "default" : format("%03d", i) # ("default" for 1st group, then "001", "002"... for DLCs)
    tg = game.trophy_groups.find_or_initialize_by(psn_group_id: psn_group_id)
    tg.update!(name: tg_data["name"], release_date: tg_data["release_date"], total_count: tg_data["total_count"])
  end
end

total_games = Game.count
total_trophies = TrophyGroup.sum(:total_count)
puts "Seeded #{total_games} games, #{total_trophies} total trophies available"

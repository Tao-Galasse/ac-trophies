class TrophySync
  def initialize(npsso:)
    @client = PlaystationApiClient.new(npsso)
  end

  def sync
    puts "Authenticating with PSN API..."
    games = Game.includes(:trophy_groups, :earned_trophies).all

    games.each.with_index(1) do |game, index|
      total = game.trophy_groups.sum(&:total_count)
      earned = game.earned_trophies.size

      if earned >= total
        puts "[#{index}/#{games.size}] #{game.name} (#{game.platform}) — already complete, skipping"
        next
      end

      puts "[#{index}/#{games.size}] #{game.name} (#{game.platform})..."
      sync_trophies_for(game)
    end

    earned = EarnedTrophy.count
    total = TrophyGroup.sum(:total_count)
    puts "\nSync complete! #{earned}/#{total} trophies earned"
  end

  private

  def sync_trophies_for(game)
    existing_ids = game.earned_trophies.pluck(:psn_trophy_id).to_set

    game.trophy_groups.each do |group|
      response = @client.my_earned_trophies(game.psn_communication_id, game.psn_service_name, group.psn_group_id)
      trophies = response["trophies"]

      trophies.each do |trophy|
        next unless trophy["earned"]

        psn_trophy_id = trophy["trophyId"]
        next if existing_ids.include?(psn_trophy_id)

        EarnedTrophy.create!(
          game: game,
          trophy_group: group,
          psn_trophy_id: psn_trophy_id,
          trophy_type: trophy["trophyType"],
          earned_at: trophy["earnedDateTime"] ? DateTime.parse(trophy["earnedDateTime"]) : nil
        )
      end
    end

    puts "  -> #{game.earned_trophies.count} trophies"
  end
end

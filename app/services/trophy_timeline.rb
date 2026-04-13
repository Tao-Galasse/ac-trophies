class TrophyTimeline
  # Cumulative "available" and "earned" trophy counts over time, aligned on
  # the same set of dates so chart tooltips can index across both series.
  # Returns [available_series, earned_series] as hashes of "YYYY-MM-DD" => total.
  def series
    available = {}
    earned = {}
    available_total = 0
    earned_total = 0

    dates.each do |date|
      available_total += available_increments[date].to_i
      earned_total += earned_increments[date].to_i
      available[date.to_s] = available_total
      earned[date.to_s] = earned_total
    end

    [available, earned]
  end

  def stats
    total_available = TrophyGroup.sum(:total_count)
    total_earned = EarnedTrophy.count
    {
      total_available: total_available,
      total_earned: total_earned,
      completion: total_available > 0 ? (total_earned.to_f / total_available * 100).round(1) : 0,
      games_played: EarnedTrophy.distinct.count(:game_id),
      games_total: Game.count
    }
  end

  private

  def dates
    @dates ||= begin
      all = (available_increments.keys + earned_increments.keys).uniq.sort
      all << Date.today unless all.last == Date.today
      all
    end
  end

  def available_increments
    @available_increments ||= TrophyGroup.group(:release_date).sum(:total_count)
  end

  def earned_increments
    @earned_increments ||= EarnedTrophy.where.not(earned_at: nil)
                                       .pluck(:earned_at)
                                       .map(&:to_date)
                                       .tally
  end
end

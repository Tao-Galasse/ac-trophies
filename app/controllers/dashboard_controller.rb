class DashboardController < ApplicationController
  def index
    @available_series = build_available_series
    @earned_series = build_earned_series
    @stats = build_stats
  end

  private

  # Cumulative step series: total trophies available over time
  def build_available_series
    events = TrophyGroup.order(:release_date).pluck(:release_date, :total_count)

    cumulative = 0
    series = events.each_with_object({}) do |(date, count), hash|
      cumulative += count
      hash[date.to_s] = cumulative
    end
    series[Date.today.to_s] = cumulative
    series
  end

  # Cumulative step series: earned trophies over time
  def build_earned_series
    trophies = EarnedTrophy.where.not(earned_at: nil).order(:earned_at)

    cumulative = 0
    series = trophies.each_with_object({}) do |trophy, hash|
      cumulative += 1
      hash[trophy.earned_at.to_date.to_s] = cumulative
    end
    series[Date.today.to_s] = cumulative
    series
  end

  def build_stats
    total_available = TrophyGroup.sum(:total_count)
    total_earned = EarnedTrophy.count
    games_played = EarnedTrophy.distinct.count(:game_id)
    games_total = Game.count

    {
      total_available: total_available,
      total_earned: total_earned,
      completion: total_available > 0 ? (total_earned.to_f / total_available * 100).round(1) : 0,
      games_played: games_played,
      games_total: games_total
    }
  end
end

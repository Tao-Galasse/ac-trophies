class DashboardController < ApplicationController
  def index
    timeline = TrophyTimeline.new
    @available_series, @earned_series = timeline.series
    @stats = timeline.stats
  end
end

desc "Sync trophies data from PlayStation API"
task sync_trophies: :environment do
  npsso = ENV.fetch("NPSSO") { abort "NPSSO environment variable required. Set it in .env" }

  TrophySync.new(npsso:).sync
end

desc "Generate a static HTML chart page in docs/ (for GitHub Pages)"
task export: :environment do
  timeline = TrophyTimeline.new
  available_series, earned_series = timeline.series
  stats = timeline.stats

  output_dir = Rails.root.join("docs")
  FileUtils.mkdir_p(output_dir)

  html = <<~HTML
    <!DOCTYPE html>
    <html lang="fr">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>AC Trophies — lenyboy</title>
      <script src="https://cdn.jsdelivr.net/npm/chart.js@4"></script>
      <script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns@3"></script>
      <style>
        :root {
          --bg: #1a1a2e;
          --card: #16213e;
          --accent: #0f3460;
          --gold: #e9b44c;
          --text: #eee;
          --muted: #8892b0;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
          font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
          background: var(--bg);
          color: var(--text);
          padding: 2rem;
        }
        h1 { font-size: 1.8rem; margin-bottom: 0.5rem; }
        h1 span { color: var(--gold); }
        .subtitle { color: var(--muted); margin-bottom: 2rem; font-size: 0.95rem; }
        .stats { display: flex; gap: 1.5rem; margin-bottom: 2rem; flex-wrap: wrap; }
        .stat-card {
          background: var(--card);
          border-radius: 12px;
          padding: 1.2rem 1.5rem;
          min-width: 160px;
          border: 1px solid var(--accent);
        }
        .stat-card .value { font-size: 2rem; font-weight: 700; color: var(--gold); }
        .stat-card .label { color: var(--muted); font-size: 0.85rem; margin-top: 0.3rem; }
        .chart-container {
          background: var(--card);
          border-radius: 12px;
          padding: 1.5rem;
          border: 1px solid var(--accent);
          margin-bottom: 2rem;
        }
        .chart-container h2 { font-size: 1.1rem; margin-bottom: 1rem; color: var(--muted); }
        .footer { color: var(--muted); font-size: 0.8rem; text-align: center; margin-top: 2rem; }
      </style>
    </head>
    <body>
      <h1>Assassin's Creed <span>Trophy Tracker</span></h1>
      <p class="subtitle">Profil PSN : lenyboy &mdash; Mis &agrave; jour le #{Date.today.strftime("%d/%m/%Y")}</p>

      <div class="stats">
        <div class="stat-card">
          <div class="value">#{stats[:total_earned]}</div>
          <div class="label">Troph&eacute;es obtenus</div>
        </div>
        <div class="stat-card">
          <div class="value">#{stats[:total_available]}</div>
          <div class="label">Troph&eacute;es disponibles</div>
        </div>
        <div class="stat-card">
          <div class="value">#{stats[:completion]}%</div>
          <div class="label">Compl&eacute;tion</div>
        </div>
        <div class="stat-card">
          <div class="value">#{stats[:games_played]}/#{stats[:games_total]}</div>
          <div class="label">Jeux jou&eacute;s</div>
        </div>
      </div>

      <div class="chart-container">
        <h2>Progression au fil du temps</h2>
        <canvas id="chart"></canvas>
      </div>

      <div class="footer">
        G&eacute;n&eacute;r&eacute; avec <code>rake export</code>
      </div>

      <script>
        const available = #{available_series.map { |d, v| { x: d, y: v } }.to_json};
        const earned = #{earned_series.map { |d, v| { x: d, y: v } }.to_json};

        new Chart(document.getElementById("chart"), {
          type: "line",
          data: {
            datasets: [
              {
                label: "Trophées disponibles",
                data: available,
                borderColor: "#534bae",
                backgroundColor: "rgba(83, 75, 174, 0.1)",
                stepped: true,
                pointRadius: 0,
                pointHoverRadius: 5,
                borderWidth: 2,
                fill: true
              },
              {
                label: "Trophées obtenus",
                data: earned,
                borderColor: "#e9b44c",
                backgroundColor: "rgba(233, 180, 76, 0.1)",
                stepped: true,
                pointRadius: 0,
                pointHoverRadius: 5,
                borderWidth: 2,
                fill: true
              }
            ]
          },
          options: {
            responsive: true,
            spanGaps: true,
            scales: {
              x: {
                type: "time",
                time: { unit: "year" },
                grid: { color: "rgba(255,255,255,0.05)" },
                ticks: { color: "#8892b0" }
              },
              y: {
                grid: { color: "rgba(255,255,255,0.05)" },
                ticks: { color: "#8892b0" }
              }
            },
            plugins: {
              legend: { labels: { color: "#eee" } },
              tooltip: { mode: "index", intersect: false }
            },
            interaction: { mode: "nearest", axis: "x", intersect: false }
          }
        });
      </script>
    </body>
    </html>
  HTML

  File.write(output_dir.join("index.html"), html)
  puts "Exported to docs/index.html"
end

# 📰 AI Daily Digest

AI-curated daily digest from **90 top tech blogs** (Karpathy's [HN Popularity Contest 2025](https://refactoringenglish.com/tools/hn-popularity/) list).

## How It Works

1. Fetches RSS/Atom feeds from 90 curated tech blogs every day
2. AI scores each article on **relevance**, **quality**, and **timeliness**
3. Generates Chinese summaries with keyword extraction and category grouping
4. Produces a Markdown report with charts, tag clouds, and trend highlights
5. Publishes as a static site on GitHub Pages with RSS feed

## Subscribe

📡 **RSS Feed:** [feed.xml](https://allenx-li.github.io/ai-daily-digest/feed.xml)

🌐 **Live Site:** [allenx-li.github.io/ai-daily-digest](https://allenx-li.github.io/ai-daily-digest/)

## Run Locally

```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash

# Set API key
export GEMINI_API_KEY=your-key-here

# Run digest
bun scripts/digest.ts --hours 48 --top-n 15 --lang zh --output ./digest.md
```

## Tech Stack

- **Runtime:** [Bun](https://bun.sh/)
- **AI:** Google Gemini (Vertex AI) with OpenAI-compatible fallback
- **CI/CD:** GitHub Actions + GitHub Pages
- **RSS:** 90 feeds from Karpathy's curated list

## License

MIT

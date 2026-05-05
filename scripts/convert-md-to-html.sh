#!/usr/bin/env bash
# convert-md-to-html.sh — wraps a markdown digest in a minimal dark-themed HTML page
# Usage: bash convert-md-to-html.sh <input.md> > index.html
set -euo pipefail

INPUT="${1:?Usage: $0 <input.md>}"
DATE="$(date +%Y-%m-%d)"

# Read the markdown file
MD_CONTENT="$(cat "$INPUT")"

# Escape for sed (basic HTML-safe pass — the MD is already mostly safe)
ESCAPED_MD="$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' "$INPUT")"

# Very basic markdown → HTML conversion
# Headers
ESCAPED_MD="$(echo "$ESCAPED_MD" | sed 's/^###### \(.*\)/<h6>\1<\/h6>/' | sed 's/^##### \(.*\)/<h5>\1<\/h5>/' | sed 's/^#### \(.*\)/<h4>\1<\/h4>/' | sed 's/^### \(.*\)/<h3>\1<\/h3>/' | sed 's/^## \(.*\)/<h2>\1<\/h2>/' | sed 's/^# \(.*\)/<h1>\1<\/h1>/')"
# Bold & italic
ESCAPED_MD="$(echo "$ESCAPED_MD" | sed 's/\*\*\([^*]*\)\*\*/<strong>\1<\/strong>/g')"
ESCAPED_MD="$(echo "$ESCAPED_MD" | sed 's/\*\([^*]*\)\*/<em>\1<\/em>/g')"
# Blockquotes
ESCAPED_MD="$(echo "$ESCAPED_MD" | sed 's/^&gt; \(.*\)/<blockquote>\1<\/blockquote>/' | sed 's/^<blockquote><blockquote>/  <blockquote>/' )"
# Horizontal rules
ESCAPED_MD="$(echo "$ESCAPED_MD" | sed 's/^---$/<hr>/')"
# Links
ESCAPED_MD="$(echo "$ESCAPED_MD" | sed 's/\[\([^]]*\)\](\([^)]*\))/<a href="\2">\1<\/a>/g')"
# Unordered list items (simple)
ESCAPED_MD="$(echo "$ESCAPED_MD" | sed 's/^- \(.*\)/<li>\1<\/li>/')"
# Paragraphs — wrap non-tag lines in <p>
ESCAPED_MD="$(echo "$ESCAPED_MD" | awk '
BEGIN { in_block = 0 }
/^<(h[1-6]|blockquote|hr|li|details|summary|code|pre)/ { in_block = 1; print; next }
/^[[:space:]]*$/ { in_block = 0; print; next }
!in_block { print "<p>" $0 "</p>"; next }
{ print }
')"

cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AI Blog Daily Picks</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji";
      background: #0d1117;
      color: #c9d1d9;
      line-height: 1.7;
      max-width: 860px;
      margin: 0 auto;
      padding: 2rem 1.5rem;
    }
    h1, h2, h3 { color: #f0f6fc; font-family: "SF Mono", "Fira Code", monospace; }
    h1 { font-size: 1.8rem; margin-bottom: 0.5rem; }
    h2 { font-size: 1.4rem; margin-top: 2rem; border-bottom: 1px solid #30363d; padding-bottom: 0.5rem; }
    h3 { font-size: 1.15rem; margin-top: 1.5rem; }
    a { color: #58a6ff; text-decoration: none; }
    a:hover { text-decoration: underline; }
    blockquote {
      border-left: 3px solid #3fb950;
      padding: 0.5rem 1rem;
      margin: 0.5rem 0;
      color: #8b949e;
      background: #161b22;
      border-radius: 0 6px 6px 0;
    }
    hr { border: none; border-top: 1px solid #21262d; margin: 2rem 0; }
    li { margin-left: 1.5rem; margin-bottom: 0.3rem; }
    p { margin-bottom: 0.6rem; }
    code { background: #1c2128; padding: 0.15em 0.4em; border-radius: 4px; font-size: 0.9em; }
    .header { text-align: center; margin-bottom: 2rem; }
    .header a.rss { display: inline-block; background: #238636; color: #fff; padding: 0.4rem 1rem; border-radius: 6px; font-size: 0.9rem; }
    .header a.rss:hover { background: #2ea043; text-decoration: none; }
    .footer { text-align: center; margin-top: 3rem; color: #484f58; font-size: 0.85rem; }
  </style>
</head>
<body>
  <div class="header">
    <h1>📰 AI Blog Daily Picks</h1>
    <p style="color:#8b949e; margin:0.5rem 0 1rem">AI-curated daily digest from 90 top tech blogs</p>
    <a class="rss" href="feed.xml">📡 RSS Feed</a>
  </div>
  <hr>
  <div class="content">
${ESCAPED_MD}
  </div>
  <div class="footer">
    <p>Generated on ${DATE} · Based on <a href="https://refactoringenglish.com/tools/hn-popularity/">HN Popularity Contest 2025</a></p>
  </div>
</body>
</html>
EOF

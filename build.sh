#!/bin/sh
# Assembles the pages from parts/.
#  index.html = strategy deck, standalone (GitHub Pages / local preview); artifact.html = the same body for the Claude artifact (the viewer adds doctype, head and body).
#  pitch.html = presentation for leadership with looping prototype demos; pitch-artifact.html = its artifact build, where links into the deck point at the published deck artifact.
cd "$(dirname "$0")"
DECK_URL="https://claude.ai/artifact/EXnCjbWA76kYmeCSRUY2TT"
PITCH_URL="https://claude.ai/artifact/DZMQLawSE8WHd251mHVApb"
PAGES_URL="https://rock-n-rol-23.github.io/savings-assistant"
PITCH_TITLE="Помощник по сбережениям за 15 минут"
TPL="parts/70-templates-a.html parts/71-templates-b.html parts/72-templates-c.html parts/73-templates-d.html parts/74-templates-e.html parts/75-templates-f.html"
DECK="parts/10-hero.html parts/20-strategy-a.html parts/27-glance.html parts/30-proto.html parts/40-strategy-b.html parts/41-rebalance.html parts/42-skills.html parts/44-proactive.html parts/44-value.html parts/45-edge.html parts/50-mcp.html parts/60-plan.html $TPL parts/90-proto-core.html parts/91-deck-script.html"
PITCH="parts/p10-pitch.html $TPL parts/90-proto-core.html parts/p90-pitch-script.html"

HEAD_PITCH=$(mktemp)
sed "1s|.*|<title>$PITCH_TITLE</title>|" parts/00-head.html > "$HEAD_PITCH"

# standalone <head part> <output> <body parts...>
standalone() {
  head=$1; out=$2; shift 2
  {
    printf '<!doctype html>\n<html lang="ru">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">\n<meta name="robots" content="noindex">\n'
    sed 's#</style>#</style>\n</head>\n<body>#' "$head"
    cat "$@"
    printf '\n</body>\n</html>\n'
  } > "$out"
}

cat parts/00-head.html $DECK | sed "s|href=\"pitch.html\"|href=\"$PITCH_URL\"|g; s|href=\"archive/|href=\"$PAGES_URL/archive/|g" > artifact.html
standalone parts/00-head.html index.html $DECK
cat "$HEAD_PITCH" $PITCH | sed "s|href=\"index.html#|href=\"$DECK_URL#|g; s|href=\"index.html\"|href=\"$DECK_URL\"|g" > pitch-artifact.html
standalone "$HEAD_PITCH" pitch.html $PITCH
rm -f "$HEAD_PITCH"
wc -c artifact.html index.html pitch-artifact.html pitch.html

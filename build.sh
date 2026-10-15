#!/bin/sh
# Assembles the page from parts/. index.html = standalone page (GitHub Pages / local preview), artifact.html = publish build for the Claude artifact.
cd "$(dirname "$0")"
PARTS="parts/00-head.html parts/10-hero.html parts/20-strategy-a.html parts/25-design.html parts/27-glance.html parts/30-proto.html parts/40-strategy-b.html parts/42-skills.html parts/44-proactive.html parts/45-edge.html parts/50-mcp.html parts/60-plan.html parts/70-templates-a.html parts/71-templates-b.html parts/72-templates-c.html parts/73-templates-d.html parts/90-script.html"
cat $PARTS > artifact.html
{ printf '<!doctype html>\n<html lang="ru">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">\n<meta name="robots" content="noindex">\n'; sed 's#</style>#</style>\n</head>\n<body>#' parts/00-head.html; shift_parts="${PARTS#parts/00-head.html }"; cat $shift_parts; printf '\n</body>\n</html>\n'; } > index.html
wc -c artifact.html index.html

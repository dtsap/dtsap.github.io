#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TOPIC="${1:-}"
SLUG="${2:-}"
TOPIC_TITLE="${TOPIC_TITLE:-}"
TOPIC_DESCRIPTION="${TOPIC_DESCRIPTION:-}"
POST_TITLE="${POST_TITLE:-}"
POST_SUMMARY="${POST_SUMMARY:-}"

if [[ -z "$TOPIC" || -z "$SLUG" ]]; then
  echo "Usage: make new-post TOPIC=<topic-slug> SLUG=<post-slug>"
  echo "Example: make new-post TOPIC=engineering SLUG=my-new-post"
  echo
  echo "Optional: TOPIC_TITLE=... TOPIC_DESCRIPTION=... POST_TITLE=... POST_SUMMARY=..."
  exit 1
fi

if [[ ! "$TOPIC" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "TOPIC must be a slug like: engineering, prompt-engineering"
  exit 1
fi

if [[ ! "$SLUG" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "SLUG must be a slug like: getting-started, first-note"
  exit 1
fi

title_case() {
  echo "$1" | sed -E 's/-/ /g; s/\b(.)/\u\1/g'
}

DIR="$ROOT/topics/$TOPIC"
INDEX="$DIR/index.html"
MD="$DIR/$SLUG.md"
HTML="$DIR/$SLUG.html"
CREATED_TOPIC=0

if [[ -z "$TOPIC_TITLE" ]]; then
  TOPIC_TITLE="$(title_case "$TOPIC")"
fi
if [[ -z "$TOPIC_DESCRIPTION" ]]; then
  TOPIC_DESCRIPTION="Posts about ${TOPIC_TITLE}."
fi
if [[ -z "$POST_TITLE" ]]; then
  POST_TITLE="$(title_case "$SLUG")"
fi
if [[ -z "$POST_SUMMARY" ]]; then
  POST_SUMMARY="TODO: one-line summary."
fi

DATE="$(date +%Y-%m-%d)"

if [[ ! -d "$DIR" ]]; then
  mkdir -p "$DIR"
  CREATED_TOPIC=1
  echo "Created topic folder: topics/$TOPIC/"
fi

# Topic landing page — lists posts for this topic from topics.json
if [[ ! -f "$INDEX" ]]; then
  sed \
    -e "s/{{TITLE}}/${TOPIC_TITLE//\//\\/}/g" \
    -e "s/{{DESCRIPTION}}/${TOPIC_DESCRIPTION//\//\\/}/g" \
    -e "s/{{SLUG}}/${TOPIC}/g" \
    "$ROOT/scripts/templates/topic-index.html" >"$INDEX"
  echo "Created topics/$TOPIC/index.html  ← topic landing page (lists posts)"
fi

if [[ -e "$MD" || -e "$HTML" ]]; then
  echo "Post already exists: topics/$TOPIC/$SLUG.{md,html}"
  exit 1
fi

cat >"$MD" <<EOF
Write your post in Markdown here.

## Section

Body text, \`inline code\`, and lists all work.
EOF

cp "$ROOT/scripts/templates/post.html" "$HTML"

python3 - "$ROOT/topics.json" "$TOPIC" "$TOPIC_TITLE" "$TOPIC_DESCRIPTION" "$SLUG" "$POST_TITLE" "$DATE" "$POST_SUMMARY" <<'PY'
import json, sys
from pathlib import Path

path = Path(sys.argv[1])
topic_slug, topic_title, topic_description = sys.argv[2], sys.argv[3], sys.argv[4]
post_slug, post_title, post_date, post_summary = sys.argv[5], sys.argv[6], sys.argv[7], sys.argv[8]

data = json.loads(path.read_text(encoding="utf-8"))
topics = data.setdefault("topics", [])
topic = next((t for t in topics if t.get("slug") == topic_slug), None)
created_topic = False
if topic is None:
    topic = {
        "slug": topic_slug,
        "title": topic_title,
        "description": topic_description,
        "posts": [],
    }
    topics.append(topic)
    created_topic = True

posts = topic.setdefault("posts", [])
if any(p.get("slug") == post_slug for p in posts):
    print(f"Post slug already in topics.json: {topic_slug}/{post_slug}", file=sys.stderr)
    sys.exit(1)

posts.append(
    {
        "slug": post_slug,
        "title": post_title,
        "date": post_date,
        "summary": post_summary,
    }
)
path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
print("created_topic=" + ("1" if created_topic else "0"))
PY

echo "Created:"
echo "  topics/$TOPIC/$SLUG.md      ← write the body here"
echo "  topics/$TOPIC/$SLUG.html    ← shell (no edits needed)"
echo "  topics.json                 ← registered topic/post"
echo
echo "Topic index (topics/$TOPIC/index.html) is the landing page for this topic."
echo "It does not list posts by hand — site.js fills #topicPostList from topics.json."
echo
echo "Edit titles/summaries in topics.json if you want nicer copy than the defaults."

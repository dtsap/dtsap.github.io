# dtsap.github.io

Personal blog for Dimitrios Tsapnidis, hosted on GitHub Pages.

## Structure

```
/
  index.html              Home — recent posts
  about.html              About page
  topics.json             Menu + post listing (edit this when you add content)
  assets/css/site.css     Shared styles
  assets/js/site.js       Sidebar + lists from topics.json
  topics/
    <topic-slug>/
      index.html          Topic landing page
      <post-slug>.html    Individual posts
```

## Add a topic

1. Create a folder: `topics/my-topic/`
2. Copy `topics/engineering/index.html` into it and update the title, description, and `data-topic="my-topic"` on the post list.
3. In `topics.json`, add a topic object:

```json
{
  "slug": "my-topic",
  "title": "My Topic",
  "description": "What this topic is about.",
  "posts": []
}
```

The sidebar picks it up automatically.

## Add a post

1. Copy an existing post HTML file into the topic folder (e.g. `topics/my-topic/new-post.html`).
2. Edit the title, date, summary, and article body.
3. Add an entry under that topic’s `posts` in `topics.json`:

```json
{
  "slug": "new-post",
  "title": "Post title",
  "date": "2026-03-22",
  "summary": "One-line description shown on lists."
}
```

Home and the topic page list posts from `topics.json` — newest first.

## Local preview

```bash
./scripts/start.sh   # start (default port 8080)
./scripts/stop.sh    # stop
```

Open the URL printed by `start.sh` (default: http://localhost:8080). Optional: `PORT=3000 ./scripts/start.sh`.

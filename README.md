# dtsap.github.io

Personal blog for Dimitrios Tsapnidis, hosted on GitHub Pages.

## Structure

```
/
  index.html              Home — recent posts
  about.html              About page
  topics.json             Menu + post listing (edit this when you add content)
  assets/css/site.css     Shared styles
  assets/js/site.js       Sidebar, lists, Markdown rendering
  assets/js/marked.min.js Markdown → HTML (client-side)
  topics/
    <topic-slug>/
      index.html          Topic landing page
      <post-slug>.md      Post body (write here)
      <post-slug>.html    Thin shell that loads and renders the .md
```

Post titles, dates, and summaries live in `topics.json`. The article body is plain Markdown in the matching `.md` file.

## Add a topic + post

One command scaffolds everything:

```bash
make new-post TOPIC=my-topic SLUG=new-post
```

That will:

1. Create `topics/my-topic/` if needed
2. Create `topics/my-topic/index.html` — the **topic landing page**. It is not a hand-written list; it has an empty `#topicPostList` and `site.js` fills it from `topics.json` (newest first).
3. Create `new-post.md` (write here) and `new-post.html` (shell that renders the Markdown)
4. Register the topic and post in `topics.json`

Optional nicer titles:

```bash
make new-post TOPIC=infra SLUG=dns-notes \
  TOPIC_TITLE="Infra" \
  TOPIC_DESCRIPTION="Networks, DNS, and ops notes." \
  POST_TITLE="DNS notes" \
  POST_SUMMARY="How lookups actually fail."
```

Home and the topic page list posts from `topics.json`.

## Local preview

```bash
make start   # start (default port 8080)
make stop    # stop
make help    # list targets
```

Open the URL printed by `make start` (default: http://localhost:8080). Optional: `PORT=3000 make start`.

This site is a static blog on GitHub Pages. Topics are folders under `topics/`, and the sidebar reads them from `topics.json`.

## Adding a topic

Create a folder such as `topics/infra/`, add an `index.html` for the topic landing page, then register the topic in `topics.json`.

## Adding a post

1. Create a Markdown file in the topic folder (e.g. `topics/infra/my-post.md`) and write the body.
2. Copy an existing post HTML shell next to it (same slug: `my-post.html`). The shell loads and renders the Markdown — you do not put the article body in HTML.
3. Add an entry under that topic’s `posts` array in `topics.json`.

The home page and topic list update from `topics.json`. That is the whole loop — no build step required.

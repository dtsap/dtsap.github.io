(function () {
  const body = document.body;
  const openBtn = document.getElementById("openBtn");
  const closeBtn = document.getElementById("closeBtn");
  const topicsNav = document.getElementById("topicsNav");
  const postList = document.getElementById("postList");
  const topicPostList = document.getElementById("topicPostList");

  function siteRootPrefix() {
    const path = window.location.pathname.replace(/\\/g, "/");
    const parts = path.split("/").filter(Boolean);
    if (parts.length && parts[parts.length - 1].endsWith(".html")) {
      parts.pop();
    }
    return parts.length ? "../".repeat(parts.length) : "./";
  }

  function linkClass(href) {
    try {
      const path = window.location.pathname.replace(/\\/g, "/");
      const resolved = new URL(href, window.location.href).pathname.replace(/\\/g, "/");
      const current = path.endsWith("/") ? path + "index.html" : path;
      const target = resolved.endsWith("/") ? resolved + "index.html" : resolved;

      if (current === target) return "active";

      // Highlight topic when viewing a post inside it
      if (
        target.endsWith("/index.html") &&
        current.startsWith(target.replace(/index\.html$/, "")) &&
        current !== target
      ) {
        return "active";
      }
      return "";
    } catch {
      return "";
    }
  }

  function formatDate(iso) {
    const d = new Date(iso + "T12:00:00");
    return d.toLocaleDateString("en-GB", {
      day: "numeric",
      month: "short",
      year: "numeric",
    });
  }

  function allPosts(data) {
    const items = [];
    data.topics.forEach((topic) => {
      (topic.posts || []).forEach((post) => {
        items.push({
          ...post,
          topicSlug: topic.slug,
          topicTitle: topic.title,
        });
      });
    });
    items.sort((a, b) => (a.date < b.date ? 1 : a.date > b.date ? -1 : 0));
    return items;
  }

  function renderTopicsNav(data, root) {
    if (!topicsNav) return;
    topicsNav.innerHTML = "";
    data.topics.forEach((topic) => {
      const li = document.createElement("li");
      const a = document.createElement("a");
      a.href = root + "topics/" + topic.slug + "/";
      a.textContent = topic.title;
      const cls = linkClass(a.href);
      if (cls) a.className = cls;
      li.appendChild(a);
      topicsNav.appendChild(li);
    });
  }

  function renderHomePosts(data, root) {
    if (!postList) return;
    const posts = allPosts(data);
    if (!posts.length) {
      postList.innerHTML = '<li class="empty-state">No posts yet.</li>';
      return;
    }
    postList.innerHTML = posts
      .map(
        (post) => `
      <li>
        <a href="${root}topics/${post.topicSlug}/${post.slug}.html">
          <div class="post-meta">
            <span class="topic">${post.topicTitle}</span>
            <time datetime="${post.date}">${formatDate(post.date)}</time>
          </div>
          <h2>${post.title}</h2>
          <p class="summary">${post.summary || ""}</p>
        </a>
      </li>`
      )
      .join("");
  }

  function renderTopicPosts(data, root) {
    if (!topicPostList) return;
    const slug = topicPostList.dataset.topic;
    const topic = data.topics.find((t) => t.slug === slug);
    if (!topic) {
      topicPostList.innerHTML = '<li class="empty-state">Topic not found.</li>';
      return;
    }
    const posts = [...(topic.posts || [])].sort((a, b) =>
      a.date < b.date ? 1 : a.date > b.date ? -1 : 0
    );
    if (!posts.length) {
      topicPostList.innerHTML = '<li class="empty-state">No posts in this topic yet.</li>';
      return;
    }
    topicPostList.innerHTML = posts
      .map(
        (post) => `
      <li>
        <a href="${root}topics/${topic.slug}/${post.slug}.html">
          <div class="post-meta">
            <time datetime="${post.date}">${formatDate(post.date)}</time>
          </div>
          <h2>${post.title}</h2>
          <p class="summary">${post.summary || ""}</p>
        </a>
      </li>`
      )
      .join("");
  }

  function setStaticActiveLinks(root) {
    document.querySelectorAll("[data-nav]").forEach((a) => {
      const key = a.getAttribute("data-nav");
      if (key === "home") a.href = root;
      if (key === "about") a.href = root + "about.html";
      a.classList.toggle("active", linkClass(a.href) === "active");
    });
  }

  if (window.matchMedia("(max-width: 1023px)").matches) {
    body.classList.add("sidebar-collapsed");
  }

  if (closeBtn) {
    closeBtn.addEventListener("click", () => {
      body.classList.add("sidebar-collapsed");
    });
  }

  if (openBtn) {
    openBtn.addEventListener("click", () => {
      body.classList.remove("sidebar-collapsed");
    });
  }

  document.addEventListener("click", (e) => {
    if (
      window.matchMedia("(max-width: 1023px)").matches &&
      !body.classList.contains("sidebar-collapsed") &&
      !e.target.closest("aside") &&
      !e.target.closest("#openBtn")
    ) {
      body.classList.add("sidebar-collapsed");
    }
  });

  const root = siteRootPrefix();
  setStaticActiveLinks(root);

  const logo = document.getElementById("siteLogo");
  if (logo) logo.href = root;

  fetch(root + "topics.json")
    .then((r) => {
      if (!r.ok) throw new Error("Failed to load topics.json");
      return r.json();
    })
    .then((data) => {
      renderTopicsNav(data, root);
      renderHomePosts(data, root);
      renderTopicPosts(data, root);
      if (logo && data.site && data.site.name) {
        logo.textContent = data.site.name;
      }
    })
    .catch((err) => {
      console.error(err);
      if (topicsNav) {
        topicsNav.innerHTML =
          '<li><span class="empty-state">Could not load topics.</span></li>';
      }
    });
})();

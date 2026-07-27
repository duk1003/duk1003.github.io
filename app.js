const app = document.querySelector('#app');
let posts = [];

const escapeHtml = (value) => value.replace(/[&<>'"]/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' })[char]);
const formatDate = (value) => value.replaceAll('-', '.');
const sortedPosts = () => [...posts].sort((a, b) => new Date(b.date) - new Date(a.date));

function markdownToHtml(source) {
  const escaped = escapeHtml(source || '');
  const fenced = escaped.replace(/```([\s\S]*?)```/g, (_, code) => `<pre><code>${code.trim()}</code></pre>`);
  return fenced.split(/\n\n+/).map(block => {
    if (block.startsWith('<pre>')) return block;
    if (block.startsWith('## ')) return `<h2>${block.slice(3)}</h2>`;
    return `<p>${block.replace(/\n/g, '<br>')}</p>`;
  }).join('');
}

function postRows(items) {
  if (!items.length) return '<li class="empty">아직 작성된 글이 없습니다.</li>';
  return items.map((post, index) => `
    <li><a class="post-card" href="#post/${encodeURIComponent(post.id)}">
      <span class="category">${escapeHtml(post.category)}</span>
      <time class="date" datetime="${post.date}">${formatDate(post.date)}</time>
      <strong class="post-title">${escapeHtml(post.title)}</strong>
      <span class="post-number">${String(index + 1).padStart(2, '0')}</span>
    </a></li>`).join('');
}

function renderHome(active = 'latest') {
  const latest = sortedPosts();
  const content = active === 'latest'
    ? `<ul class="post-list">${postRows(latest)}</ul>`
    : renderCategories(latest);
  app.innerHTML = `
    <h1 class="hero-title">redduk.log</h1>
    <div class="tabs" role="tablist" aria-label="글 보기 방식">
      <button class="tab" role="tab" aria-selected="${active === 'latest'}" data-tab="latest">최신순</button>
      <button class="tab" role="tab" aria-selected="${active === 'category'}" data-tab="category">분류별</button>
    </div>${content}`;
  app.querySelectorAll('[data-tab]').forEach(button => button.addEventListener('click', () => renderHome(button.dataset.tab)));
}

function renderCategories(items) {
  const groups = new Map();
  items.forEach(post => groups.set(post.category, [...(groups.get(post.category) || []), post]));
  if (!groups.size) return '<p class="empty">아직 작성된 분류가 없습니다.</p>';
  return `<section class="category-groups">${[...groups].map(([category, group]) => `
    <section class="category-group"><h2 class="category-heading">${escapeHtml(category)} <span>${String(group.length).padStart(2, '0')}</span></h2>
    <ul class="category-posts">${group.map(post => `<li><a href="#post/${encodeURIComponent(post.id)}">${escapeHtml(post.title)}</a></li>`).join('')}</ul></section>`).join('')}</section>`;
}

function renderPost(id) {
  const post = posts.find(item => item.id === id);
  if (!post) { app.innerHTML = '<p class="empty">찾을 수 없는 글입니다.</p>'; return; }
  document.title = `${post.title} | redduk.log`;
  app.innerHTML = `<article class="article">
    <a class="back-link" href="#home">← 모든 글</a>
    <p class="article-meta">${escapeHtml(post.category)}</p>
    <h1>${escapeHtml(post.title)}</h1>
    <time class="article-date" datetime="${post.date}">${formatDate(post.date)}</time>
    <div class="article-body">${markdownToHtml(post.body)}</div>
  </article>`;
}

function renderRoute() {
  const route = decodeURIComponent(location.hash.slice(1) || 'home');
  document.title = 'redduk.log';
  if (route === 'about') {
    app.innerHTML = '<section class="about"><h1>About</h1><p>컴퓨터공학을 공부하며 이해한 개념과 구현 경험을 기록합니다.</p></section>';
  } else if (route.startsWith('post/')) renderPost(route.slice(5));
  else renderHome();
  app.focus();
}

fetch('posts.json')
  .then(response => { if (!response.ok) throw new Error('posts.json을 불러오지 못했습니다.'); return response.json(); })
  .then(data => { posts = data; renderRoute(); })
  .catch(error => { app.innerHTML = `<p class="empty">${escapeHtml(error.message)}</p>`; });

window.addEventListener('hashchange', renderRoute);
document.querySelector('#year').textContent = new Date().getFullYear();

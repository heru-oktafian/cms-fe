// app/javascript/section_refresh.js
function normalizeHtml(html) {
  return html.replace(/\s+/g, " ").trim();
}
function buildSectionEndpoint(section) {
  return `/sections/${section}`;
}
function refreshSection(section) {
  const wrapper = document.querySelector(`[data-refresh-section="${section}"]`);
  if (!wrapper || wrapper.dataset.refreshing === "true") return;
  wrapper.dataset.refreshing = "true";
  fetch(buildSectionEndpoint(section), {
    headers: {
      Accept: "application/json"
    },
    credentials: "same-origin"
  }).then((response) => {
    if (!response.ok) throw new Error(`Failed to refresh section: ${section}`);
    return response.json();
  }).then((payload) => {
    const currentHtml = normalizeHtml(wrapper.innerHTML);
    const nextHtml = normalizeHtml(payload.html || "");
    if (currentHtml !== nextHtml) {
      wrapper.innerHTML = payload.html;
      document.dispatchEvent(new CustomEvent("section:refreshed", { detail: { section } }));
    }
  }).catch((error) => {
    console.error("[cms-fe] section refresh failed", section, error);
  }).finally(() => {
    wrapper.dataset.refreshing = "false";
  });
}
function bindSectionRefresh() {
  const links = document.querySelectorAll("[data-refresh-target]");
  if (!links.length) return;
  links.forEach((link) => {
    if (link.dataset.sectionRefreshBound === "true") return;
    link.dataset.sectionRefreshBound = "true";
    link.addEventListener("click", () => {
      const section = link.dataset.refreshTarget;
      if (section) refreshSection(section);
    });
  });
}
document.addEventListener("turbo:load", bindSectionRefresh);
document.addEventListener("DOMContentLoaded", bindSectionRefresh);
document.addEventListener("section:refreshed", bindSectionRefresh);
//# sourceMappingURL=/assets/section_refresh.js.map

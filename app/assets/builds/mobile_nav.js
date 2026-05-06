// app/javascript/mobile_nav.js
function bindMobileNav() {
  const openButton = document.querySelector("[data-mobile-nav-open]");
  const closeButton = document.querySelector("[data-mobile-nav-close]");
  const overlay = document.querySelector("[data-mobile-nav-overlay]");
  if (!openButton || !closeButton || !overlay) return;
  if (openButton.dataset.bound === "true") return;
  openButton.dataset.bound = "true";
  closeButton.dataset.bound = "true";
  overlay.dataset.bound = "true";
  const openNav = () => {
    overlay.classList.remove("hidden");
    document.body.classList.add("overflow-hidden");
  };
  const closeNav = () => {
    overlay.classList.add("hidden");
    document.body.classList.remove("overflow-hidden");
  };
  openButton.addEventListener("click", openNav);
  closeButton.addEventListener("click", closeNav);
  overlay.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", closeNav);
  });
  overlay.addEventListener("click", (event) => {
    if (event.target === overlay || event.target === overlay.firstElementChild) {
      closeNav();
    }
  });
}
document.addEventListener("turbo:load", bindMobileNav);
document.addEventListener("DOMContentLoaded", bindMobileNav);
//# sourceMappingURL=/assets/mobile_nav.js.map

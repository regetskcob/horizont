/* Horizont: the horizon line (partials/nav/horizon.html).
 *
 * Places every chapter mark at the position of its chapter on the page,
 * lets the page's mark walk along the line as you read, keeps the title of
 * the current chapter whole below its mark, opens the Flurkarte as a
 * dialog, and on touch lets the thumb swipe along the line to jump. No
 * dependencies; without it the page keeps anchor links and a link to the
 * map page. With reduced motion the mark stands still at the start and
 * only the line fills.
 */
(function () {
  "use strict";
  var nav = document.querySelector("[data-hz-horizon]");
  if (!nav) return;

  var reduce = matchMedia("(prefers-reduced-motion: reduce)");
  var touch = matchMedia("(hover: none) and (pointer: coarse)");
  var walker = nav.querySelector(".hz-walker");
  var done = nav.querySelector(".hz-horizon-done");
  var list = nav.querySelector(".hz-ticks");
  var dialog = document.querySelector("[data-hz-karte]");
  var back = nav.querySelector(".hz-horizon-back");

  // marks "auto": the chapters come from the page, by default the sections
  // of a Feldseite. An old numbered Kennung ("02 — Funktionen") loses its
  // number; where there is little room the word is cut ("Funk…") instead
  // of standing in for a count (since 0.19.1: numbers read as made by
  // machine). Fewer than three: the line alone.
  if (list && list.dataset.hzAuto) {
    var found = [].slice.call(document.querySelectorAll(list.dataset.hzAuto)).filter(function (s) { return s.id; });
    if (found.length >= 3) {
      found.forEach(function (s, i) {
        var k = s.querySelector(".hz-kennung, .t-kennung, h2");
        var text = (k ? k.textContent : s.id).replace(/\s+/g, " ").trim();
        var parts = text.match(/^(\d+)\s*[—–-]\s*(.+)$/);
        var a = document.createElement("a");
        a.className = "hz-tick";
        a.href = "#" + s.id;
        a.dataset.full = parts ? parts[2] : text;
        a.dataset.short = a.dataset.full;
        a.style.setProperty("--h", "10px");
        var span = document.createElement("span");
        span.textContent = a.dataset.full;
        a.appendChild(span);
        var li = document.createElement("li");
        li.appendChild(a);
        list.appendChild(li);
      });
    }
  }
  var ticks = list ? [].slice.call(list.querySelectorAll(".hz-tick")) : [];
  // A mark whose chapter is not on this page (a year on another page of a
  // list) leaves the line.
  var marks = ticks.map(function (a) {
    var id = decodeURIComponent(a.hash.slice(1));
    return { a: a, label: a.querySelector("span"), target: document.getElementById(id), x: 0 };
  }).filter(function (m) {
    if (!m.target) m.a.parentNode.hidden = true;
    return m.target;
  });
  var current = -1;
  var frame = 0;

  nav.classList.add("is-live");
  // The heading of each chapter: the target itself, or the first heading in
  // it where the target is a section.
  marks.forEach(function (m) {
    m.head = /^H[1-6]$/.test(m.target.tagName) ? m.target : m.target.querySelector("h1, h2, h3, h4");
    if (m.head) m.head.classList.add("hz-chapter");
  });

  function offsetTop(el) {
    return el.getBoundingClientRect().top + window.scrollY;
  }

  function range() {
    return Math.max(1, document.documentElement.scrollHeight - window.innerHeight);
  }

  // Each mark sits where its chapter begins, as a share of the scroll range;
  // a title may use the room up to the next mark.
  function layout() {
    var max = range();
    var width = list ? list.getBoundingClientRect().width : 0;
    var head = touch.matches ? 0 : nav.offsetHeight;
    marks.forEach(function (m) {
      m.x = Math.min(1, Math.max(0, (offsetTop(m.target) - head - 8) / max));
    });
    marks.forEach(function (m, i) {
      var next = i + 1 < marks.length ? marks[i + 1].x : 1;
      var prev = i > 0 ? marks[i - 1].x : 0;
      var li = m.a.parentNode;
      // Near the end a title hangs to the left of its mark; it shares the gap
      // to the mark before with that mark's title.
      var end = m.x > 0.82;
      var nextEnd = i + 1 < marks.length && marks[i + 1].x > 0.82;
      var gap = end ? (m.x - prev) / 2 : (nextEnd ? (next - m.x) / 2 : next - m.x);
      m.room = Math.max(14, gap * width - 12);
      li.style.left = (m.x * 100) + "%";
      li.style.setProperty("--room", m.room + "px");
      m.a.classList.toggle("is-end", end);
    });
    // Back only where the window leaves room before the line.
    if (back && !back.hidden) {
      var room = nav.getBoundingClientRect().left + parseFloat(getComputedStyle(nav).getPropertyValue("--inset"));
      back.classList.toggle("has-room", !touch.matches && room >= back.offsetWidth + 14 + 8 + 16);
    }
    current = -2;
    update();
  }

  function update() {
    frame = 0;
    var p = Math.min(1, Math.max(0, window.scrollY / range()));
    var width = nav.querySelector(".hz-horizon-line").getBoundingClientRect().width;
    done.style.width = (p * width) + "px";
    walker.style.setProperty("--walk", (reduce.matches ? 0 : p * width) + "px");

    var head = touch.matches ? window.innerHeight * 0.4 : nav.offsetHeight + 80;
    var at = -1;
    marks.forEach(function (m, i) {
      if (m.target.getBoundingClientRect().top < head) at = i;
    });
    if (at === current) return;
    current = at;
    marks.forEach(function (m, i) {
      var on = i === at;
      m.a.classList.toggle("is-current", on);
      if (m.head) m.head.classList.toggle("is-current", on);
      if (on) m.a.setAttribute("aria-current", "location");
      else m.a.removeAttribute("aria-current");
      // A title where it has room; where chapters lie close, only its number.
      // Too close for even the number: the mark stays, its words are in the title.
      m.label.textContent = on || (!touch.matches && m.room >= 72) ? m.a.dataset.full : (m.room >= 22 ? m.a.dataset.short : "");
    });
  }

  function schedule() {
    if (!frame) frame = requestAnimationFrame(update);
  }

  // The map as a dialog: focus moves in, Escape and the backdrop close it.
  if (dialog && typeof dialog.showModal === "function") {
    // The mark and, since 0.18, the place button with words open it.
    nav.querySelectorAll("[data-hz-open-karte]").forEach(function (opener) {
      opener.addEventListener("click", function (e) {
        e.preventDefault();
        dialog.showModal();
        var here = dialog.querySelector("[aria-current]");
        if (here) here.focus({ preventScroll: true });
      });
    });
    dialog.addEventListener("click", function (e) {
      if (e.target === dialog) dialog.close();
    });
  }

  // Back: only when the page before is of this site; the history brings it
  // back as it was left, which a link to it could not. Not after the
  // language switch: the page before is this one in the other language.
  var from = null;
  try { from = document.referrer ? new URL(document.referrer) : null; } catch (e) { from = null; }
  var switched = from && [].some.call(nav.querySelectorAll(".hz-horizon-lang a"), function (a) {
    return a.pathname === from.pathname;
  });
  var en = /^en\b/i.test(document.documentElement.lang);
  if (from && from.origin === location.origin && from.href !== location.href && !switched && history.length > 1) {
    [].forEach.call(document.querySelectorAll("[data-hz-back]"), function (b) {
      b.hidden = false;
      if (en) {
        b.lastChild.textContent = b.lastChild.textContent.replace("Zurück", "Back");
        if (b.hasAttribute("aria-label")) b.setAttribute("aria-label", "Back to the previous page");
      }
      b.addEventListener("click", function (e) {
        e.preventDefault();
        history.back();
      });
    });
  }

  // On touch: swipe along the line, the nearest chapter shows above the
  // thumb and the page follows; letting go stays there.
  var bubble = null;
  var swiping = false;
  function nearest(clientX) {
    var box = list.getBoundingClientRect();
    var r = (clientX - box.left) / box.width;
    var best = 0;
    var gap = 2;
    marks.forEach(function (m, i) {
      var d = Math.abs(m.x - r);
      if (d < gap) { gap = d; best = i; }
    });
    return best;
  }
  function swipeTo(clientX) {
    var i = nearest(clientX);
    var m = marks[i];
    bubble.textContent = m.a.title || m.a.dataset.full;
    window.scrollTo(0, offsetTop(m.target) - 16);
  }
  if (list && marks.length) {
    nav.addEventListener("pointerdown", function (e) {
      if (!touch.matches || e.pointerType === "mouse" || e.target.closest(".hz-walker, .hz-horizon-lang")) return;
      swiping = true;
      nav.setPointerCapture(e.pointerId);
      if (!bubble) {
        bubble = document.createElement("div");
        bubble.className = "hz-horizon-bubble";
        bubble.setAttribute("aria-hidden", "true");
        nav.appendChild(bubble);
      }
      bubble.hidden = false;
      swipeTo(e.clientX);
      e.preventDefault();
    });
    nav.addEventListener("pointermove", function (e) { if (swiping) swipeTo(e.clientX); });
    var stop = function () { swiping = false; if (bubble) bubble.hidden = true; };
    nav.addEventListener("pointerup", stop);
    nav.addEventListener("pointercancel", stop);
  }

  window.addEventListener("scroll", schedule, { passive: true });
  window.addEventListener("resize", layout);
  touch.addEventListener("change", layout);
  reduce.addEventListener("change", update);
  // Images and fonts move the chapters after load.
  if ("ResizeObserver" in window) new ResizeObserver(layout).observe(document.body);
  else window.addEventListener("load", layout);
  layout();
})();

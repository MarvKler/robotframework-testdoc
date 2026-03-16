/**
 * Robot Framework TestDoc — main UI script
 *
 * Responsibilities:
 *  - Navigation: mark active tree items, expand/collapse branches
 *  - Suite filtering: show only the selected suite block in the content area
 *  - Test highlighting: highlight a test block when clicked or navigated to
 *  - Lazy rendering: defer mounting heavy test-block content until it enters the viewport
 *  - Code toggle: collapse / expand Robot Framework code sections
 *  - RF syntax highlight: client-side highlight for `pre.rf-code` elements (fallback)
 */

document.addEventListener('DOMContentLoaded', function () {

    /* =========================================================
       Small UI toggles (theme + sidebar)
       ========================================================= */

    (function setupThemeToggle() {
        const btn = document.getElementById('themeToggle');
        if (!btn) return;
        btn.addEventListener('click', function () {
            const html = document.documentElement;
            const isDark = html.getAttribute('data-theme') === 'dark';
            const next = isDark ? 'light' : 'dark';
            html.setAttribute('data-theme', next);
            try { localStorage.setItem('clarity-theme', next); } catch (e) {}
        });
    })();

    (function setupSidebarToggle() {
        const btn = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');
        if (!btn || !sidebar) return;
        btn.addEventListener('click', function () {
            sidebar.classList.toggle('collapsed');
        });
    })();

    /* =========================================================
       Element references
       ========================================================= */
    const navRoot     = document.querySelector('.nav-tree');
    const suiteBlocks = document.querySelectorAll('.suite-block');

    // test blocks are re-queried after each suite change (lazy rendering updates the DOM)
    let testBlocks = document.querySelectorAll('.test-block[id^="test-"]');

    /* =========================================================
       Lazy rendering
       ========================================================= */
    const LAZY_PREFILL = 20;
    let intersectionObserver;

    /** Mount a lazily prepared test block by moving its <template> content into the DOM. */
    function mountBlock(block) {
        if (block.dataset.mounted === '1') return;
        const tpl = block.querySelector('template.lazy-tpl');
        if (tpl) {
            block.appendChild(tpl.content.cloneNode(true));
            block.querySelectorAll('pre.rf-code').forEach(highlightRfPre);
            block.querySelectorAll('pre.robotframework').forEach(addLineNumbers);
            block.dataset.mounted = '1';
            // Restore collapsed state on the body container
            if (block.classList.contains('collapsed')) {
                const body = block.querySelector('.test-body-collapsible');
                if (body) body.style.display = 'none';
            }
            // Collapse all code sections inside the newly mounted block
            block.querySelectorAll('.code-wrapper').forEach(function (wrapper) {
                wrapper.classList.add('collapsed');
                const codeBody = wrapper.querySelector('.code-toggle-body');
                if (codeBody) codeBody.style.display = 'none';
            });
            block.querySelectorAll('.code-toggle').forEach(function (toggle) {
                toggle.classList.add('collapsed');
            });
        }
    }

    /**
     * For the currently visible suite, wrap each test block's heavy sub-sections
     * in a <template> and observe them for intersection-based mounting.
     */
    function prepareLazyRenderingForCurrentSuite() {
        if (intersectionObserver) intersectionObserver.disconnect();

        intersectionObserver = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    mountBlock(entry.target);
                    intersectionObserver.unobserve(entry.target);
                }
            });
        }, { root: null, rootMargin: '200px', threshold: 0.01 });

        // Only consider test blocks inside the currently visible suite
        testBlocks = document.querySelectorAll('.suite-block:not([style*="display: none"]) .test-block[id^="test-"]');

        let index = 0;
        testBlocks.forEach(function (block) {
            // Skip already prepared / mounted blocks
            if (block.dataset.prepared === '1' || block.dataset.mounted === '1') {
                if (block.dataset.mounted === '1') {
                    block.querySelectorAll('pre.rf-code').forEach(highlightRfPre);
                }
                return;
            }

            // Move the collapsible body container into a <template> for deferred rendering
            const collapsibleBody = block.querySelector('.test-body-collapsible');
            if (collapsibleBody) {
                const tpl = document.createElement('template');
                tpl.classList.add('lazy-tpl');
                tpl.content.appendChild(collapsibleBody);
                block.appendChild(tpl);
            }
            block.dataset.prepared = '1';

            if (index < LAZY_PREFILL) {
                mountBlock(block);
            } else {
                intersectionObserver.observe(block);
            }
            index++;
        });
    }

    /* =========================================================
       Suite filtering & navigation
       ========================================================= */

    /** Show only the suite block matching `selectedSuiteId`, hide all others. */
    function applySuiteFilter(selectedSuiteId) {
        if (!selectedSuiteId) return;
        suiteBlocks.forEach(function (block) {
            block.style.display = (block.dataset.suiteId === selectedSuiteId) ? '' : 'none';
        });
    }

    /**
     * Scroll to the element with `targetId`.
     * If `isTest` is true, also highlight the corresponding test block.
     */
    function scrollToTarget(targetId, isTest) {
        if (!targetId) return;
        const el = document.getElementById(targetId);
        if (!el) return;

        el.scrollIntoView({ behavior: 'smooth', block: 'start' });

        if (isTest) {
            clearTestHighlight();
            el.classList.add('highlighted');
        }
    }

    /**
     * Find the closest .tree-children UL for a suite link's <li> parent,
     * also handling the root-level sibling case.
     */
    function findChildUl(link) {
        const li = link.closest('li');
        if (!li) return null;

        const direct = Array.from(li.children).find(function (el) {
            return el.classList && el.classList.contains('tree-children');
        });
        if (direct) return direct;

        const sib = li.nextElementSibling;
        if (sib && sib.classList && sib.classList.contains('tree-children')) {
            return sib;
        }
        return null;
    }

    function setActiveTreeLink(activeLink) {
        if (!navRoot) return;
        navRoot.querySelectorAll('.tree-suite.active, .tree-test.active').forEach(function (l) {
            l.classList.remove('active');
        });
        if (activeLink) activeLink.classList.add('active');
    }

    function setBranchExpanded(link, expanded) {
        const li = link.closest('li');
        if (!li) return;

        const childUl = findChildUl(link);
        if (!childUl) return;

        li.classList.toggle('expanded', expanded);
        childUl.hidden = !expanded;
        link.setAttribute('aria-expanded', String(!!expanded));
    }

    /* =========================================================
       Highlight helpers
       ========================================================= */

    function clearTestHighlight() {
        testBlocks.forEach(function (block) { block.classList.remove('highlighted'); });
    }

    /* =========================================================
       Initialisation
       ========================================================= */

    // Hide all branches by default (CSS already does, but hidden improves a11y)
    document.querySelectorAll('.tree-children').forEach(function (ul) {
        ul.hidden = true;
    });

    // Show the suite that is initially active (or the first suite)
    const initiallyActive = document.querySelector('.tree-suite.active') || document.querySelector('.tree-suite');
    if (initiallyActive) {
        applySuiteFilter(initiallyActive.dataset.suiteId);
        // Expand its immediate children to avoid an empty-looking tree on load.
        setBranchExpanded(initiallyActive, true);
    }
    prepareLazyRenderingForCurrentSuite();

    /* =========================================================
       Tree navigation (delegated)
       ========================================================= */

    if (navRoot) {
        navRoot.addEventListener('click', function (e) {
            const link = e.target.closest('.tree-suite, .tree-test');
            if (!link) return;
            e.preventDefault();

            const isSuite = link.classList.contains('tree-suite');
            const targetId = link.dataset.target;
            const suiteId  = link.dataset.suiteId;

            // Toggle expand/collapse only for suite links that actually have children
            if (isSuite && findChildUl(link)) {
                const li = link.closest('li');
                const expandedNow = !(li && li.classList.contains('expanded'));
                setBranchExpanded(link, expandedNow);
            }

            setActiveTreeLink(link);

            applySuiteFilter(suiteId);
            prepareLazyRenderingForCurrentSuite();
            scrollToTarget(targetId, !isSuite);
        });
    }

    /* =========================================================
       Main content interactions (delegated)
       ========================================================= */

    // Sub-suite rows: delegate click to matching sidebar tree link
    document.addEventListener('click', function (e) {
        const el = e.target.closest('.subsuite-link');
        if (!el) return;
        e.preventDefault();
        const suiteId = el.dataset.suiteId;
        if (!suiteId) return;
        const treeLink = document.querySelector('.tree-suite[data-suite-id="' + suiteId + '"]');
        if (treeLink) treeLink.click();
    });

    // Test case collapse toggle (only affects header/body, not sidebar selection)
    document.addEventListener('click', function (e) {
        const header = e.target.closest('.test-header');
        if (!header) return;

        // Prevent the click from also triggering the test-block selection handler.
        e.stopPropagation();

        const block = header.closest('.test-block');
        if (!block) return;
        const isCollapsed = block.classList.toggle('collapsed');
        const body = block.querySelector('.test-body-collapsible');
        if (body) body.style.display = isCollapsed ? 'none' : '';
    });

    // Test block click → highlight + sync sidebar (ignore clicks on interactive controls)
    document.addEventListener('click', function (e) {
        if (e.target.closest('.test-header')) return;
        if (e.target.closest('.kw-info-btn')) return;
        if (e.target.closest('.code-toggle')) return;

        const block = e.target.closest('.test-block[id^="test-"]');
        if (!block) return;

        clearTestHighlight();
        block.classList.add('highlighted');

        const matchingLink = document.querySelector('.tree-test[data-target="' + block.id + '"]');
        if (matchingLink) {
            setActiveTreeLink(matchingLink);
            matchingLink.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    });

    /* =========================================================
       Collapsible code sections
       ========================================================= */

    // Collapse all code sections by default
    document.querySelectorAll('.code-wrapper').forEach(function (wrapper) {
        wrapper.classList.add('collapsed');
        const body = wrapper.querySelector('.code-toggle-body');
        if (body) body.style.display = 'none';
    });
    document.querySelectorAll('.code-toggle').forEach(function (toggle) {
        toggle.classList.add('collapsed');
    });

    // Delegate toggle clicks to avoid binding issues with dynamically mounted content
    document.addEventListener('click', function (e) {
        const toggle = e.target.closest('.code-toggle');
        if (!toggle) return;

        const wrapper = toggle.closest('.code-wrapper');
        if (wrapper) {
            const isCollapsed = wrapper.classList.toggle('collapsed');
            toggle.classList.toggle('collapsed', isCollapsed);
            const body = wrapper.querySelector('.code-toggle-body');
            if (body) body.style.display = isCollapsed ? 'none' : '';
        }
    });

    /* =========================================================
       Robot Framework client-side syntax highlighter
       (used for pre.rf-code elements as a fallback)
       ========================================================= */

    /** Escape HTML special characters. */
    function rfEscape(html) {
        return html.replace(/[&<>]/g, function (ch) {
            if (ch === '&') return '&amp;';
            if (ch === '<') return '&lt;';
            return '&gt;';
        });
    }

    /** Wrap RF variable expressions (${...}, @{...}, etc.) in a span. */
    function renderVariables(raw) {
        const RE_VAR = /(\$\{[^}]+\}|@\{[^}]+\}|&\{[^}]+\}|%\{[^}]+\})/g;
        let result = '';
        let last = 0;
        let match;
        while ((match = RE_VAR.exec(raw)) !== null) {
            if (match.index > last) result += rfEscape(raw.slice(last, match.index));
            result += '<span class="rf-var">' + rfEscape(match[1]) + '</span>';
            last = RE_VAR.lastIndex;
        }
        if (last < raw.length) result += rfEscape(raw.slice(last));
        return result;
    }

    /**
     * Highlight the "tail" portion of a keyword line:
     * handles quoted strings and variable expressions.
     */
    function highlightTail(rawTail) {
        const RE_QUOTE = /("[^"\n]*"|'[^'\n]*')/g;
        let match;
        let last = 0;
        const parts = [];

        while ((match = RE_QUOTE.exec(rawTail)) !== null) {
            if (match.index > last) parts.push({ type: 'plain', value: rawTail.slice(last, match.index) });
            parts.push({ type: 'quote', value: match[0] });
            last = RE_QUOTE.lastIndex;
        }
        if (last < rawTail.length) parts.push({ type: 'plain', value: rawTail.slice(last) });

        let out = '';
        for (const part of parts) {
            if (part.type === 'quote') {
                const inner    = part.value.slice(1, -1);
                const quoteChar = part.value[0];
                out += '<span class="rf-string">'
                    + rfEscape(quoteChar)
                    + renderVariables(inner)
                    + rfEscape(quoteChar)
                    + '</span>';
            } else {
                out += renderVariables(part.value);
            }
        }

        // Highlight assignment operator
        out = out.replace(/\s=\s/g, ' <span class="rf-assign">=<\/span> ');
        return out;
    }

    /** Apply syntax highlighting to a single `pre.rf-code` element. */
    function highlightRfPre(pre) {
        if (pre.dataset.highlighted === '1') return;

        const lines = pre.textContent.split(/\r?\n/);
        const out   = [];

        lines.forEach(function (raw, index) {
            const escaped = rfEscape(raw);
            const trimmed = raw.trim();

            // Line 0: section header  *** ... ***
            if (index === 0 && /^\*\*\*.*\*\*\*$/.test(trimmed)) {
                out.push('<span class="rf-header">' + escaped + '</span>');
                return;
            }

            // Line 1: test / keyword name
            if (index === 1) {
                out.push('<span class="rf-testname">' + escaped + '</span>');
                return;
            }

            // Comment lines
            if (/^\s*#/.test(raw)) {
                out.push('<span class="rf-comment">' + escaped + '</span>');
                return;
            }

            // Keyword + arguments
            const match = raw.match(/^(\s*)(\S.*?)(?=(\s{2,}|$))/);
            if (match) {
                const indent  = match[1];
                const headRaw = match[2];
                const tailRaw = raw.slice(match[0].length);
                out.push(indent + '<span class="rf-keyword">' + rfEscape(headRaw) + '</span>' + highlightTail(tailRaw));
            } else {
                out.push(highlightTail(raw));
            }
        });

        pre.innerHTML = out.join('\n');
        pre.dataset.highlighted = '1';
    }

    /** Add line numbers to a Pygments-highlighted pre.robotframework element. */
    function addLineNumbers(pre) {
        if (pre.dataset.lineNumbers === '1') return;
        const codeEl = pre.querySelector('code') || pre;
        const lines = codeEl.innerHTML.split('\n');
        // Remove the trailing empty line Pygments appends
        if (lines.length > 0 && lines[lines.length - 1].trim() === '') {
            lines.pop();
        }
        codeEl.innerHTML = lines.map(function (line) {
            return '<span class="rf-line">' + line + '</span>';
        }).join('');
        pre.dataset.lineNumbers = '1';

        // PoC: enrich keyword call lines with an info button (if metadata exists)
        enhanceKeywordInfo(pre);
    }

    /* =========================================================
       PoC: Keyword documentation (info buttons + dialog)
       ========================================================= */

    function getKwDocIndexForPre(pre) {
        const testBlock = pre.closest('.test-block');
        if (!testBlock) return null;
        if (testBlock._kwDocIndex instanceof Map) return testBlock._kwDocIndex;

        const ndjsonEl = testBlock.querySelector('script.kw-doc-ndjson');
        if (!ndjsonEl) return null;

        const map = new Map();
        // Be tolerant: if JSON objects were concatenated ("}{"), split them.
        const text = (ndjsonEl.textContent || '').replace(/}\s*{/g, '}\n{');
        const raw = text.split(/\r?\n/);
        raw.forEach(function (line) {
            const trimmed = (line || '').trim();
            if (!trimmed) return;
            try {
                const obj = JSON.parse(trimmed);
                if (obj && obj.name && !map.has(obj.name)) {
                    map.set(obj.name, obj);
                }
            } catch (e) {
                // Ignore malformed lines; NDJSON is best-effort.
            }
        });
        testBlock._kwDocIndex = map;
        return map;
    }

    function extractKeywordInfoFromLine(lineEl) {
        if (!lineEl) return null;

        // Regular keyword call line: Pygments uses .nf for KEYWORD tokens.
        const nf = lineEl.querySelector('span.nf');
        if (nf) {
            const name = (nf.textContent || '').trim();
            if (!name) return null;
            return { name: name, anchor: nf };
        }

        // Setup/Teardown lines: keyword may be tokenised as .n following a .py [Setup]/[Teardown]
        const py = lineEl.querySelector('span.py');
        if (py) {
            const label = (py.textContent || '').trim();
            if (label === '[Setup]' || label === '[Teardown]') {
                const spans = Array.from(lineEl.querySelectorAll('span'));
                const startIdx = spans.indexOf(py);
                for (let i = startIdx + 1; i < spans.length; i++) {
                    const s = spans[i];
                    if (!s || !s.classList) continue;
                    if (s.classList.contains('nf') || s.classList.contains('n')) {
                        const name = (s.textContent || '').trim();
                        if (!name) return null;
                        return { name: name, anchor: s };
                    }
                }
            }
        }

        return null;
    }

    function enhanceKeywordInfo(pre) {
        if (!pre || pre.dataset.kwInfo === '1') return;
        const index = getKwDocIndexForPre(pre);
        if (!index || index.size === 0) {
            pre.dataset.kwInfo = '1';
            return;
        }

        const codeEl = pre.querySelector('code') || pre;
        const lineEls = codeEl.querySelectorAll('.rf-line');
        lineEls.forEach(function (lineEl) {
            // Avoid duplicating buttons on reruns.
            if (lineEl.querySelector('.kw-info-btn')) return;

            const info = extractKeywordInfoFromLine(lineEl);
            if (!info || !info.name) return;

            const meta = index.get(info.name);
            if (!meta || !meta.doc) return;

            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'kw-info-btn';
            btn.dataset.kwName = info.name;
            btn.setAttribute('aria-label', 'Show keyword documentation: ' + info.name);
            btn.title = 'Show Keyword Documentation';
            btn.textContent = 'Show Keyword Documentation';

            // Append to the line and let CSS place it on the far right.
            lineEl.appendChild(btn);
        });

        pre.dataset.kwInfo = '1';
    }

    function ensureKwDialog() {
        let dlg = document.getElementById('kwDocDialog');
        if (dlg) return dlg;

        dlg = document.createElement('dialog');
        dlg.id = 'kwDocDialog';
        dlg.className = 'kw-doc-dialog';
        dlg.innerHTML =
            '<form method="dialog" class="kw-doc-dialog-inner">'
                + '<header class="kw-doc-dialog-header">'
                    + '<div class="kw-doc-dialog-title">'
                        + '<div class="kw-doc-name" id="kwDocName"></div>'
                        + '<div class="kw-doc-owner" id="kwDocOwner"></div>'
                    + '</div>'
                    + '<button class="kw-doc-close" value="close" aria-label="Close">'
                        + '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">'
                            + '<line x1="18" y1="6" x2="6" y2="18"></line>'
                            + '<line x1="6" y1="6" x2="18" y2="18"></line>'
                        + '</svg>'
                    + '</button>'
                + '</header>'
                + '<section class="kw-doc-dialog-body">'
                    + '<div class="kw-doc-args" id="kwDocArgs"></div>'
                    + '<pre class="kw-doc-text" id="kwDocText"></pre>'
                + '</section>'
            + '</form>';

        document.body.appendChild(dlg);
        return dlg;
    }

    function openKwDialog(meta, triggerBtn) {
        const dlg = ensureKwDialog();
        dlg._kwTriggerBtn = triggerBtn || null;

        const nameEl = dlg.querySelector('#kwDocName');
        const ownerEl = dlg.querySelector('#kwDocOwner');
        const argsEl = dlg.querySelector('#kwDocArgs');
        const textEl = dlg.querySelector('#kwDocText');

        const kwName = (meta && meta.name) ? meta.name : '';
        const owner = (meta && meta.owner) ? meta.owner : '';
        const doc = (meta && meta.doc) ? meta.doc : '';
        const args = (meta && meta.args) ? meta.args : [];

        if (nameEl) nameEl.textContent = kwName;
        if (ownerEl) ownerEl.textContent = owner ? ('Owner: ' + owner) : '';

        if (textEl) textEl.textContent = doc;

        try {
            if (!dlg.open) dlg.showModal();
        } catch (e) {
            // If <dialog> is unsupported, fall back to toggling the open attribute.
            dlg.setAttribute('open', '');
        }
    }

    // Close behavior: return focus to the triggering info button.
    document.addEventListener('close', function (e) {
        const dlg = e.target;
        if (!dlg || dlg.id !== 'kwDocDialog') return;
        const btn = dlg._kwTriggerBtn;
        dlg._kwTriggerBtn = null;
        if (btn && typeof btn.focus === 'function') {
            try { btn.focus(); } catch (err) {}
        }
    }, true);

    // Delegate info button clicks.
    document.addEventListener('click', function (e) {
        const btn = e.target.closest('.kw-info-btn');
        if (!btn) return;

        // Prevent test-block click handlers from triggering.
        e.preventDefault();
        e.stopPropagation();

        const pre = btn.closest('pre.robotframework');
        if (!pre) return;
        const index = getKwDocIndexForPre(pre);
        if (!index) return;

        const kwName = btn.dataset.kwName;
        if (!kwName) return;
        const meta = index.get(kwName);
        if (!meta) return;

        openKwDialog(meta, btn);
    });

    // Apply to any pre.rf-code / pre.robotframework elements already in the DOM
    document.querySelectorAll('pre.rf-code').forEach(highlightRfPre);
    document.querySelectorAll('pre.robotframework').forEach(addLineNumbers);
});

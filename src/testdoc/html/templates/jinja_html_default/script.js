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
       Element references
       ========================================================= */
    const suiteLinks  = document.querySelectorAll('.tree-suite');
    const testLinks   = document.querySelectorAll('.tree-test');
    const allLinks    = document.querySelectorAll('.tree-suite, .tree-test');
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
            block.dataset.mounted = '1';
            // Restore collapsed state for the newly mounted body container
            if (block.classList.contains('collapsed')) {
                const body = block.querySelector('.test-body-collapsible');
                if (body) body.style.display = 'none';
            }
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
       Suite tree helpers
       ========================================================= */

    /**
     * Build a map of { suiteId -> [childSuiteIds] } from the rendered tree,
     * without relying on :scope for broader browser compatibility.
     */
    function buildSuiteTree() {
        const tree = {};
        document.querySelectorAll('.tree-suite').forEach(function (link) {
            const suiteId = link.dataset.suiteId;
            const parentLi = link.closest('li');
            let childUl = null;

            if (parentLi) {
                childUl = Array.from(parentLi.children).find(function (el) {
                    return el.classList && el.classList.contains('tree-children');
                }) || null;

                // Root-level case: children UL is a sibling of the LI
                if (!childUl) {
                    const sib = parentLi.nextElementSibling;
                    if (sib && sib.classList && sib.classList.contains('tree-children')) {
                        childUl = sib;
                    }
                }
            }

            const subLinks = childUl
                ? Array.from(childUl.children)
                      .map(function (li) { return li.querySelector('.tree-suite'); })
                      .filter(Boolean)
                : [];

            tree[suiteId] = subLinks.map(function (l) { return l.dataset.suiteId; });
        });
        return tree;
    }

    /** Recursively collect a suite ID and all its descendant suite IDs. */
    function getAllDescendantSuites(tree, suiteId) {
        let ids = [suiteId];
        if (tree[suiteId]) {
            tree[suiteId].forEach(function (childId) {
                ids = ids.concat(getAllDescendantSuites(tree, childId));
            });
        }
        return ids;
    }

    const suiteTree = buildSuiteTree();

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

    /* =========================================================
       Highlight helpers
       ========================================================= */

    function clearTestHighlight() {
        testBlocks.forEach(function (block) { block.classList.remove('highlighted'); });
    }

    /* =========================================================
       Initialisation
       ========================================================= */

    // Collapse all tree branches on load
    document.querySelectorAll('.tree-children').forEach(function (ul) {
        const li = ul.closest('li');
        if (li) li.classList.remove('expanded');
        ul.style.display = 'none';
    });

    // Show the suite that is initially active (or the first suite)
    const initiallyActive = document.querySelector('.tree-suite.active') || suiteLinks[0];
    if (initiallyActive) {
        applySuiteFilter(initiallyActive.dataset.suiteId);
    }
    prepareLazyRenderingForCurrentSuite();

    /* =========================================================
       Suite link click handler
       ========================================================= */
    suiteLinks.forEach(function (link) {
        link.addEventListener('click', function (e) {
            e.preventDefault();

            // Toggle expand / collapse the branch
            const childUl = findChildUl(this);
            if (childUl) {
                const li = this.closest('li');
                const isCollapsed = childUl.style.display === 'none' || getComputedStyle(childUl).display === 'none';
                if (isCollapsed) {
                    if (li) li.classList.add('expanded');
                    childUl.style.display = 'block';
                } else {
                    if (li) li.classList.remove('expanded');
                    childUl.style.display = 'none';
                }
            }

            const targetId = this.dataset.target;
            const suiteId  = this.dataset.suiteId;

            allLinks.forEach(function (l) { l.classList.remove('active'); });
            this.classList.add('active');

            applySuiteFilter(suiteId);
            prepareLazyRenderingForCurrentSuite();
            scrollToTarget(targetId, false);
        });
    });

    /* =========================================================
       Test link click handler
       ========================================================= */
    testLinks.forEach(function (link) {
        link.addEventListener('click', function (e) {
            e.preventDefault();

            const targetId = this.dataset.target;
            const suiteId  = this.dataset.suiteId;

            allLinks.forEach(function (l) { l.classList.remove('active'); });
            this.classList.add('active');

            applySuiteFilter(suiteId);
            prepareLazyRenderingForCurrentSuite();
            scrollToTarget(targetId, true);
        });
    });

    /* =========================================================
       Test block click → sync sidebar
       ========================================================= */
    testBlocks.forEach(function (block) {
        block.addEventListener('click', function () {
            clearTestHighlight();
            this.classList.add('highlighted');

            allLinks.forEach(function (l) { l.classList.remove('active'); });
            const matchingLink = document.querySelector('.tree-test[data-target="' + this.id + '"]');
            if (matchingLink) {
                matchingLink.classList.add('active');
                matchingLink.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
        });
    });

    /* =========================================================
       Collapsible code sections
       ========================================================= */

    // Collapse all code sections by default
    document.querySelectorAll('.code-wrapper').forEach(function (wrapper) {
        wrapper.classList.add('collapsed');
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
            wrapper.classList.toggle('collapsed');
            toggle.classList.toggle('collapsed');
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

    // Apply to any pre.rf-code elements already in the DOM
    document.querySelectorAll('pre.rf-code').forEach(highlightRfPre);
});

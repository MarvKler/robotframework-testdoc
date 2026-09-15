(() => {
  "use strict";

  const DATA = JSON.parse(document.getElementById("management-data").textContent);
  const ROOT = DATA.root;

  const viewRoot = document.getElementById("view-root");
  const headerTitle = document.getElementById("header-title");
  const sidebar = document.getElementById("sidebar");
  const sidebarToggle = document.getElementById("sidebar-toggle");
  const themeToggle = document.getElementById("header-theme-toggle");
  const THEME_STORAGE_KEY = "testdoc-management-theme";

  const state = {
    page: "dashboard",
    repoPath: [ROOT],
    repoSelectedTest: null,
    historyPath: [ROOT],
    historySelectedTest: null,
  };

  /* ---------------------------------------------------------------------
   * Helpers
   * ------------------------------------------------------------------- */

  function escapeHtml(value) {
    if (value === null || value === undefined) return "";
    return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function allTests(suite) {
    let tests = suite.tests.slice();
    for (const subSuite of suite.suites) tests = tests.concat(allTests(subSuite));
    return tests;
  }

  function allSuites(suite) {
    let suites = [suite];
    for (const subSuite of suite.suites) suites = suites.concat(allSuites(subSuite));
    return suites;
  }

  function statusCounts(tests) {
    const counts = {};
    for (const test of tests) counts[test.latest_status] = (counts[test.latest_status] || 0) + 1;
    return counts;
  }

  function latestHistoryEntry(test) {
    return test.history.length ? test.history[test.history.length - 1] : null;
  }

  function findTestByFullName(suite, fullName) {
    for (const test of suite.tests) {
      if (test.full_name === fullName) return test;
    }
    for (const subSuite of suite.suites) {
      const found = findTestByFullName(subSuite, fullName);
      if (found) return found;
    }
    return null;
  }

  function findSuiteChainForTest(suite, fullName, chain) {
    const nextChain = chain.concat([suite]);
    if (suite.tests.some((test) => test.full_name === fullName)) return nextChain;
    for (const subSuite of suite.suites) {
      const found = findSuiteChainForTest(subSuite, fullName, nextChain);
      if (found) return found;
    }
    return null;
  }

  function flattenSteps(body, depth) {
    depth = depth || 0;
    let lines = [];
    for (const item of body || []) {
      const indent = "  ".repeat(depth);
      const assign = (item.assign || []).length ? `${item.assign.join(", ")} = ` : "";
      const args = (item.args || []).join("    ");
      lines.push(`${indent}${assign}${item.name || item.type}${args ? `    ${args}` : ""}`);
      if (item.body && item.body.length) lines = lines.concat(flattenSteps(item.body, depth + 1));
    }
    return lines;
  }

  function statusBadge(status) {
    const classMap = { PASS: "badge-pass", FAIL: "badge-fail", SKIP: "badge-skip" };
    const cssClass = classMap[status] || "badge-unknown";
    return `<span class="badge ${cssClass}">${escapeHtml(status || "UNKNOWN")}</span>`;
  }

  function metricCard(value, label) {
    return `<div class="metric"><div class="metric-value">${escapeHtml(value)}</div><div class="metric-label">${escapeHtml(label)}</div></div>`;
  }

  /* ---------------------------------------------------------------------
   * Dashboard
   * ------------------------------------------------------------------- */

  function buildExecutionSeries() {
    const tests = allTests(ROOT);
    const runMap = new Map();

    for (const test of tests) {
      for (const entry of test.history) {
        if (!runMap.has(entry.run_id)) {
          runMap.set(entry.run_id, { run_id: entry.run_id, recorded_at: entry.recorded_at, PASS: 0, FAIL: 0, SKIP: 0, OTHER: 0 });
        }
        const bucket = runMap.get(entry.run_id);
        if (entry.status === "PASS") bucket.PASS += 1;
        else if (entry.status === "FAIL") bucket.FAIL += 1;
        else if (entry.status === "SKIP") bucket.SKIP += 1;
        else bucket.OTHER += 1;
      }
    }

    return Array.from(runMap.values()).sort((a, b) => a.run_id - b.run_id);
  }

  function renderExecutionTrendChart(series) {
    if (!series.length) {
      return '<div class="empty-state">No results recorded yet. Run "testdoc management" with a --report-file to record results.</div>';
    }

    const width = 760;
    const height = 220;
    const paddingLeft = 34;
    const paddingRight = 16;
    const paddingTop = 16;
    const paddingBottom = 34;
    const chartWidth = width - paddingLeft - paddingRight;
    const chartHeight = height - paddingTop - paddingBottom;

    const maxValue = Math.max(1, ...series.flatMap((run) => [run.PASS, run.FAIL, run.SKIP]));
    const stepX = series.length > 1 ? chartWidth / (series.length - 1) : 0;

    function pointsFor(key) {
      return series.map((run, index) => {
        const x = paddingLeft + stepX * index;
        const y = paddingTop + chartHeight - (run[key] / maxValue) * chartHeight;
        return { x, y, value: run[key], run };
      });
    }

    function pathFor(points) {
      return points.map((point, index) => `${index === 0 ? "M" : "L"}${point.x.toFixed(1)},${point.y.toFixed(1)}`).join(" ");
    }

    function circlesFor(points, cssClass) {
      return points
        .map(
          (point) =>
            `<circle class="${cssClass}" cx="${point.x.toFixed(1)}" cy="${point.y.toFixed(1)}" r="3.5"><title>${escapeHtml(point.run.recorded_at)} - ${point.value}</title></circle>`
        )
        .join("");
    }

    const passPoints = pointsFor("PASS");
    const failPoints = pointsFor("FAIL");
    const skipPoints = pointsFor("SKIP");

    const gridLines = [0, 0.25, 0.5, 0.75, 1]
      .map((ratio) => {
        const y = paddingTop + chartHeight - ratio * chartHeight;
        const value = Math.round(maxValue * ratio);
        return `<line x1="${paddingLeft}" y1="${y.toFixed(1)}" x2="${width - paddingRight}" y2="${y.toFixed(1)}" class="chart-gridline" />
              <text x="${paddingLeft - 8}" y="${(y + 4).toFixed(1)}" class="chart-axis-label" text-anchor="end">${value}</text>`;
      })
      .join("");

    const maxLabels = 8;
    const labelStep = Math.max(1, Math.ceil(series.length / maxLabels));
    const xLabels = series
      .map((run, index) => {
        if (index % labelStep !== 0 && index !== series.length - 1) return "";
        const x = paddingLeft + stepX * index;
        return `<text x="${x.toFixed(1)}" y="${height - paddingBottom + 18}" class="chart-axis-label" text-anchor="middle">${escapeHtml(run.recorded_at.slice(0, 10))}</text>`;
      })
      .join("");

    return `
      <div class="chart-legend">
        <span class="chart-legend-item"><span class="chart-legend-dot chart-dot-pass"></span>Passed</span>
        <span class="chart-legend-item"><span class="chart-legend-dot chart-dot-fail"></span>Failed</span>
        <span class="chart-legend-item"><span class="chart-legend-dot chart-dot-skip"></span>Skipped</span>
      </div>
      <svg class="chart-svg" viewBox="0 0 ${width} ${height}" role="img" aria-label="Execution trend chart">
        ${gridLines}
        ${xLabels}
        <path d="${pathFor(passPoints)}" class="chart-line chart-line-pass" />
        <path d="${pathFor(failPoints)}" class="chart-line chart-line-fail" />
        <path d="${pathFor(skipPoints)}" class="chart-line chart-line-skip" />
        ${circlesFor(passPoints, "chart-point chart-point-pass")}
        ${circlesFor(failPoints, "chart-point chart-point-fail")}
        ${circlesFor(skipPoints, "chart-point chart-point-skip")}
      </svg>
    `;
  }

  function renderDashboard() {
    const tests = allTests(ROOT);
    const suiteFiles = allSuites(ROOT).filter((suite) => !suite.suite.is_folder);
    const counts = statusCounts(tests);
    const allHistory = tests.flatMap((test) => test.history);
    const totalRuns = new Set(allHistory.map((entry) => entry.run_id)).size;
    const lastRun = allHistory.slice().sort((a, b) => b.run_id - a.run_id)[0];
    const failingTests = tests.filter((test) => test.latest_status === "FAIL").slice(0, 8);
    const executionSeries = buildExecutionSeries();

    viewRoot.innerHTML = `
      <div class="grid-metrics">
        ${metricCard(ROOT.test_count, "Total Test Cases")}
        ${metricCard(suiteFiles.length, "Test Suites")}
        ${metricCard(totalRuns, "Recorded Runs")}
        ${metricCard(counts.PASS || 0, "Passing (latest)")}
        ${metricCard(counts.FAIL || 0, "Failing (latest)")}
        ${metricCard(counts.SKIP || 0, "Skipped (latest)")}
      </div>
      <div class="card">
        <h2 class="card-title">Execution Trend</h2>
        ${renderExecutionTrendChart(executionSeries)}
      </div>
      <div class="card">
        <h2 class="card-title">Last recorded run</h2>
        ${lastRun ? `<p>${escapeHtml(lastRun.recorded_at)}</p>` : '<div class="empty-state">No results recorded yet. Run "testdoc management" with a --report-file to record results.</div>'}
      </div>
      <div class="card">
        <h2 class="card-title">Currently failing tests</h2>
        ${
          failingTests.length
            ? `<ul class="tree-list">${failingTests
                .map((test) => {
                  const latestEntry = latestHistoryEntry(test);
                  return `
              <li class="tree-item" data-test="${encodeURIComponent(test.full_name)}">
                <span style="overflow:hidden;">
                  <span class="tree-item-name">${escapeHtml(test.test_case.name)}</span>
                  ${latestEntry && latestEntry.message ? `<span class="tree-item-error">${escapeHtml(latestEntry.message)}</span>` : ""}
                </span>
                <span class="tree-item-meta">${statusBadge(test.latest_status)}</span>
              </li>`;
                })
                .join("")}</ul>`
            : '<div class="empty-state">No failing tests recorded.</div>'
        }
      </div>
    `;
  }

  /* ---------------------------------------------------------------------
   * Test Case Repository
   * ------------------------------------------------------------------- */

  function renderBreadcrumbs(path, prefix) {
    return `<div class="breadcrumbs">${path
      .map((suite, index) => {
        if (index === path.length - 1) return `<span>${escapeHtml(suite.suite.name)}</span>`;
        return `<button data-${prefix}-crumb="${index}">${escapeHtml(suite.suite.name)}</button><span>/</span>`;
      })
      .join("")}</div>`;
  }

  function renderSuiteChildrenList(suite, prefix, selectedTest) {
    let html = "";
    if (suite.suites.length) {
      html += `<ul class="tree-list">${suite.suites
        .map(
          (subSuite, index) => `
        <li class="tree-item" data-${prefix}-navigate="${index}">
          <span class="tree-item-name">${escapeHtml(subSuite.suite.name)}</span>
          <span class="tree-item-meta">${subSuite.test_count} tests</span>
        </li>`
        )
        .join("")}</ul>`;
    }
    if (suite.tests.length) {
      html += `<ul class="tree-list" style="margin-top:12px;">${suite.tests
        .map(
          (test) => `
        <li class="tree-item ${selectedTest === test.full_name ? "selected" : ""}" data-${prefix}-test="${encodeURIComponent(test.full_name)}">
          <span class="tree-item-name">${escapeHtml(test.test_case.name)}</span>
          <span class="tree-item-meta">${statusBadge(test.latest_status)}</span>
        </li>`
        )
        .join("")}</ul>`;
    }
    if (!suite.suites.length && !suite.tests.length) {
      html += '<div class="empty-state">No test suites or test cases found.</div>';
    }
    return html;
  }

  function renderSuiteStats(suite) {
    const tests = allTests(suite);
    const counts = statusCounts(tests);
    return `
      <div class="card">
        <h2 class="card-title">${escapeHtml(suite.suite.name)}</h2>
        ${suite.suite.doc ? `<p>${escapeHtml(suite.suite.doc)}</p>` : ""}
        <div class="grid-metrics">
          ${metricCard(suite.test_count, "Tests in suite directory")}
          ${metricCard(counts.PASS || 0, "Passing (latest)")}
          ${metricCard(counts.FAIL || 0, "Failing (latest)")}
          ${metricCard(counts.SKIP || 0, "Skipped (latest)")}
        </div>
      </div>
    `;
  }

  function renderTestDetail(fullName) {
    const test = findTestByFullName(ROOT, fullName);
    if (!test) return '<div class="empty-state">Test case not found.</div>';

    const testCase = test.test_case;
    const tags = (testCase.tags || []).map((tag) => `<span class="tag">${escapeHtml(tag)}</span>`).join("");
    const steps = flattenSteps(testCase.body);
    const latestEntry = latestHistoryEntry(test);

    return `
      <div class="card">
        <h2 class="card-title">${escapeHtml(testCase.name)}</h2>
        <div class="detail-row"><div class="detail-label">Status</div><div class="detail-value">${statusBadge(test.latest_status)}</div></div>
        ${
          test.latest_status === "FAIL" && latestEntry && latestEntry.message
            ? `<div class="detail-row"><div class="detail-label">Error Message</div><div class="detail-value"><div class="error-message">${escapeHtml(latestEntry.message)}</div></div></div>`
            : ""
        }
        <div class="detail-row"><div class="detail-label">Documentation</div><div class="detail-value">${escapeHtml(testCase.doc || "-")}</div></div>
        <div class="detail-row"><div class="detail-label">Tags</div><div class="detail-value">${tags || "-"}</div></div>
        <div class="detail-row"><div class="detail-label">Source</div><div class="detail-value">${escapeHtml(testCase.custom_source || testCase.source || "-")}</div></div>
        <div style="margin-top:12px;">
          <button class="btn" data-goto-history="${encodeURIComponent(test.full_name)}">View Result Trend</button>
        </div>
      </div>
      <div class="card">
        <h2 class="card-title">Test Steps</h2>
        ${steps.length ? `<ul class="step-list">${steps.map((step) => `<li>${escapeHtml(step)}</li>`).join("")}</ul>` : '<div class="empty-state">No steps parsed.</div>'}
      </div>
    `;
  }

  function renderRepository() {
    const current = state.repoPath[state.repoPath.length - 1];
    viewRoot.innerHTML = `
      <div class="repo-layout">
        <div>
          ${renderBreadcrumbs(state.repoPath, "repo")}
          ${renderSuiteChildrenList(current, "repo", state.repoSelectedTest)}
        </div>
        <div>
          ${state.repoSelectedTest ? renderTestDetail(state.repoSelectedTest) : renderSuiteStats(current)}
        </div>
      </div>
    `;
  }

  /* ---------------------------------------------------------------------
   * Test Result History
   * ------------------------------------------------------------------- */

  function renderHistoryOverview(suite) {
    const tests = allTests(suite);
    if (!tests.length) return '<div class="empty-state">No test cases in this suite.</div>';

    return `
      <div class="card">
        <h2 class="card-title">Latest Results Overview</h2>
        <table class="history-table history-table--overview">
          <thead><tr><th>Test Case</th><th>Latest Status</th><th>Message</th><th>Recorded Runs</th></tr></thead>
          <tbody>
            ${tests
              .map((test) => {
                const latestEntry = latestHistoryEntry(test);
                const message = test.latest_status === "FAIL" && latestEntry ? latestEntry.message : "";
                const messageClass = message ? "message-cell-fail" : "message-cell-empty";
                return `
              <tr data-hist-test="${encodeURIComponent(test.full_name)}">
                <td>${escapeHtml(test.test_case.name)}</td>
                <td>${statusBadge(test.latest_status)}</td>
                <td class="message-cell ${messageClass}"><div class="message-scroll">${message ? escapeHtml(message) : "-"}</div></td>
                <td>${test.history.length}</td>
              </tr>`;
              })
              .join("")}
          </tbody>
        </table>
      </div>
    `;
  }

  function renderHistoryDetail(fullName) {
    const test = findTestByFullName(ROOT, fullName);
    if (!test) return '<div class="empty-state">Test case not found.</div>';

    const history = test.history.slice().sort((a, b) => a.run_id - b.run_id);
    const bars = history
      .map((entry) => {
        const cssClass = (entry.status || "unknown").toLowerCase().replace(/[^a-z0-9-]/g, "-");
        const height = Math.min(100, Math.max(8, entry.elapsed_time * 10));
        return `<div class="trend-bar trend-bar-${cssClass}" style="height:${height}%" title="${escapeHtml(entry.status)} - ${escapeHtml(entry.recorded_at)}"></div>`;
      })
      .join("");
    const rows = history
      .slice()
      .reverse()
      .map((entry) => {
        const messageClass = entry.message ? "message-cell-fail" : "message-cell-empty";
        return `
        <tr>
          <td>${entry.run_id}</td>
          <td>${escapeHtml(entry.recorded_at)}</td>
          <td>${statusBadge(entry.status)}</td>
          <td>${entry.elapsed_time.toFixed(2)}s</td>
          <td class="message-cell ${messageClass}"><div class="message-scroll">${escapeHtml(entry.message || "-")}</div></td>
        </tr>`;
      })
      .join("");

    return `
      <div class="card">
        <h2 class="card-title">${escapeHtml(test.test_case.name)} - Result Trend</h2>
        ${history.length ? `<div class="trend-bars">${bars}</div>` : '<div class="empty-state">No recorded runs yet.</div>'}
      </div>
      <div class="card">
        <h2 class="card-title">Run History</h2>
        ${
          history.length
            ? `<table class="history-table history-table--runs"><thead><tr><th>Run</th><th>Recorded At</th><th>Status</th><th>Elapsed</th><th>Message</th></tr></thead><tbody>${rows}</tbody></table>`
            : '<div class="empty-state">No recorded runs yet.</div>'
        }
      </div>
    `;
  }

  function renderHistory() {
    const current = state.historyPath[state.historyPath.length - 1];
    viewRoot.innerHTML = `
      <div class="repo-layout">
        <div>
          ${renderBreadcrumbs(state.historyPath, "hist")}
          ${renderSuiteChildrenList(current, "hist", state.historySelectedTest)}
        </div>
        <div>
          ${state.historySelectedTest ? renderHistoryDetail(state.historySelectedTest) : renderHistoryOverview(current)}
        </div>
      </div>
    `;
  }

  /* ---------------------------------------------------------------------
   * Routing
   * ------------------------------------------------------------------- */

  function setActivePage(page) {
    state.page = page;
    document.querySelectorAll(".sidebar-nav-item").forEach((el) => {
      el.classList.toggle("active", el.dataset.page === page);
    });

    const titles = { dashboard: "Dashboard", repository: "Test Case Repository", history: "Test Result History" };
    headerTitle.textContent = titles[page] || "Dashboard";

    if (page === "repository") renderRepository();
    else if (page === "history") renderHistory();
    else renderDashboard();
  }

  function route() {
    const rawHash = (location.hash || "#/dashboard").replace(/^#\/?/, "");
    const [pathPart, queryPart] = rawHash.split("?");
    const page = pathPart || "dashboard";
    const params = new URLSearchParams(queryPart || "");

    if (page === "history" && params.get("test")) {
      const fullName = params.get("test");
      state.historySelectedTest = fullName;
      state.historyPath = findSuiteChainForTest(ROOT, fullName, []) || [ROOT];
    }

    setActivePage(page);
  }

  /* ---------------------------------------------------------------------
   * Event wiring
   * ------------------------------------------------------------------- */

  viewRoot.addEventListener("click", (event) => {
    const repoCrumb = event.target.closest("[data-repo-crumb]");
    const histCrumb = event.target.closest("[data-hist-crumb]");
    const repoNavigate = event.target.closest("[data-repo-navigate]");
    const histNavigate = event.target.closest("[data-hist-navigate]");
    const repoTest = event.target.closest("[data-repo-test]");
    const histTest = event.target.closest("[data-hist-test]");
    const gotoHistory = event.target.closest("[data-goto-history]");
    const failingTest = event.target.closest("[data-test]");

    if (repoCrumb) {
      const index = parseInt(repoCrumb.dataset.repoCrumb, 10);
      state.repoPath = state.repoPath.slice(0, index + 1);
      state.repoSelectedTest = null;
      renderRepository();
    } else if (histCrumb) {
      const index = parseInt(histCrumb.dataset.histCrumb, 10);
      state.historyPath = state.historyPath.slice(0, index + 1);
      state.historySelectedTest = null;
      renderHistory();
    } else if (repoNavigate) {
      const index = parseInt(repoNavigate.dataset.repoNavigate, 10);
      const current = state.repoPath[state.repoPath.length - 1];
      state.repoPath = state.repoPath.concat([current.suites[index]]);
      state.repoSelectedTest = null;
      renderRepository();
    } else if (histNavigate) {
      const index = parseInt(histNavigate.dataset.histNavigate, 10);
      const current = state.historyPath[state.historyPath.length - 1];
      state.historyPath = state.historyPath.concat([current.suites[index]]);
      state.historySelectedTest = null;
      renderHistory();
    } else if (repoTest) {
      state.repoSelectedTest = decodeURIComponent(repoTest.dataset.repoTest);
      renderRepository();
    } else if (histTest) {
      state.historySelectedTest = decodeURIComponent(histTest.dataset.histTest);
      renderHistory();
    } else if (gotoHistory) {
      location.hash = `#/history?test=${gotoHistory.dataset.gotoHistory}`;
    } else if (failingTest) {
      location.hash = `#/history?test=${failingTest.dataset.test}`;
    }
  });

  sidebarToggle.addEventListener("click", () => {
    sidebar.classList.toggle("collapsed");
  });

  themeToggle.addEventListener("click", () => {
    const isDark = document.documentElement.getAttribute("data-theme") === "dark";
    const nextTheme = isDark ? "light" : "dark";
    document.documentElement.setAttribute("data-theme", nextTheme);
    try {
      localStorage.setItem(THEME_STORAGE_KEY, nextTheme);
    } catch (error) {
      // localStorage may be unavailable (e.g. file:// with strict privacy settings) - theme just won't persist.
    }
  });

  document.getElementById("header-home").addEventListener("click", () => {
    location.hash = "#/dashboard";
  });

  window.addEventListener("hashchange", route);
  route();
})();

(() => {
  "use strict";

  const DATA = JSON.parse(document.getElementById("management-data").textContent);
  const ROOT = DATA.root;
  const SHOW_HISTORY = DATA.show_history !== false;

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
    repoStatusFilter: null,
    repoSearch: "",
    repoTagFilters: [],
    repoTagMenuOpen: false,
    repoSuiteFilter: "",
    repoSuiteMenuOpen: false,
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

  function tagCounts(tests) {
    const counts = {};
    for (const test of tests) {
      const tags = new Set((test.test_case.tags || []).map((tag) => (typeof tag === "object" ? tag.name : tag)).filter(Boolean));
      for (const tag of tags) counts[tag] = (counts[tag] || 0) + 1;
    }
    return Object.entries(counts).sort((left, right) => right[1] - left[1] || left[0].localeCompare(right[0]));
  }

  function renderTagStatistics(tests) {
    const tags = tagCounts(tests);
    if (!tags.length) return '<div class="empty-state">No tags defined.</div>';

    const maximum = tags[0][1];
    return `<div class="tag-statistics">${tags
      .map(([tag, count]) => {
        const width = Math.max(4, Math.round((count / maximum) * 100));
        return `<div class="tag-stat-row"><div class="tag-stat-label" title="${escapeHtml(tag)}">${escapeHtml(tag)}</div><div class="tag-stat-track"><div class="tag-stat-bar" style="width:${width}%"><span>${count}</span></div></div></div>`;
      })
      .join("")}</div>`;
  }

  function latestHistoryEntry(test) {
    return test.history.length ? test.history[test.history.length - 1] : null;
  }

  function formatRecordedAt(value) {
    if (!value) return "-";
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return value;
    return new Intl.DateTimeFormat("de-DE", {
      dateStyle: "medium",
      timeStyle: "medium",
    }).format(date);
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

  function statusBadge(status) {
    const classMap = { PASS: "badge-pass", FAIL: "badge-fail", SKIP: "badge-skip" };
    const cssClass = classMap[status] || "badge-unknown";
    return `<span class="badge ${cssClass}">${escapeHtml(status || "UNKNOWN")}</span>`;
  }

  function metricCard(value, label, statusFilter) {
    const attributes = statusFilter ? ` data-status-filter="${statusFilter}"` : "";
    const className = statusFilter ? "metric metric-clickable" : "metric";
    const tag = statusFilter ? "button" : "div";
    const typeAttribute = statusFilter ? ' type="button"' : "";
    return `<${tag} class="${className}"${attributes}${typeAttribute}><div class="metric-value">${escapeHtml(value)}</div><div class="metric-label">${escapeHtml(label)}</div></${tag}>`;
  }

  function filteredTests(suite) {
    return allTests(suite).filter((test) => {
      if (state.repoStatusFilter && test.latest_status !== state.repoStatusFilter) return false;
      if (state.repoSuiteFilter && !test.full_name.startsWith(`${state.repoSuiteFilter}.`)) return false;

      const tags = (test.test_case.tags || []).map((tag) => (typeof tag === "object" ? tag.name : tag));
      if (state.repoTagFilters.some((tag) => !tags.includes(tag))) return false;

      if (!state.repoSearch) return true;
      const searchText = [test.test_case.name, test.full_name, ...tags].join(" ").toLowerCase();
      return searchText.includes(state.repoSearch.toLowerCase());
    });
  }

  function renderStatusFilter(suite) {
    if (!state.repoStatusFilter) return "";

    const tests = filteredTests(suite);
    return `
      <div class="filter-bar">
        <span>Showing ${tests.length} ${state.repoStatusFilter.toLowerCase()} tests</span>
        <button class="btn btn-secondary" type="button" data-clear-status-filter>Clear filter</button>
      </div>
    `;
  }

  function repositoryTags() {
    const tags = new Set();
    for (const test of allTests(ROOT)) {
      for (const tag of test.test_case.tags || []) tags.add(typeof tag === "object" ? tag.name : tag);
    }
    return Array.from(tags).filter(Boolean).sort((left, right) => left.localeCompare(right));
  }

  function renderRepositoryFilter() {
    const tags = repositoryTags();
    const suites = allSuites(ROOT);
    const selectedSuite = suites.find((suite) => suite.full_name === state.repoSuiteFilter);
    const selectedTags = state.repoTagFilters.length ? state.repoTagFilters.join(", ") : "Tags";
    const suggestions = Array.from(new Set([
      ...allTests(ROOT).map((test) => test.test_case.name),
      ...allSuites(ROOT).map((suite) => suite.suite.name),
      ...tags,
    ])).sort((left, right) => left.localeCompare(right));

    return `
      <div class="repository-filter" role="search" aria-label="Filter test cases">
        <label class="repository-filter-search">
          <span>Search tests or suites</span>
          <input type="search" value="${escapeHtml(state.repoSearch)}" placeholder="Test name or suite name" data-repo-search list="repository-filter-suggestions" />
          <datalist id="repository-filter-suggestions">
            ${suggestions.map((suggestion) => `<option value="${escapeHtml(suggestion)}"></option>`).join("")}
          </datalist>
        </label>
        <div class="repository-tag-filter repository-suite-filter">
          <button class="repository-tag-toggle" type="button" data-repo-suite-toggle aria-haspopup="listbox" aria-expanded="${state.repoSuiteMenuOpen}">
            <span>${escapeHtml(selectedSuite ? selectedSuite.suite.name : "Suites")}</span>
            <span class="repository-tag-chevron" aria-hidden="true">⌄</span>
          </button>
          <div class="repository-tag-options" data-repo-suite-menu role="listbox" aria-label="Filter by suites" ${state.repoSuiteMenuOpen ? "" : "hidden"}>
            <button class="repository-suite-option" type="button" data-repo-suite="">All suites</button>
            ${suites.map((suite) => `<button class="repository-suite-option ${suite.full_name === state.repoSuiteFilter ? "selected" : ""}" type="button" data-repo-suite="${escapeHtml(suite.full_name)}">${escapeHtml(suite.suite.name)}</button>`).join("")}
          </div>
        </div>
        <div class="repository-tag-filter">
          <button class="repository-tag-toggle" type="button" data-repo-tag-toggle aria-haspopup="listbox" aria-expanded="${state.repoTagMenuOpen}">
            <span>${escapeHtml(selectedTags)}</span>
            <span class="repository-tag-chevron" aria-hidden="true">⌄</span>
          </button>
          <div class="repository-tag-options" data-repo-tag-menu role="listbox" aria-label="Filter by tags" ${state.repoTagMenuOpen ? "" : "hidden"}>
            ${tags.length ? tags.map((tag) => `<label><input type="checkbox" value="${escapeHtml(tag)}" data-repo-tag ${state.repoTagFilters.includes(tag) ? "checked" : ""} /> ${escapeHtml(tag)}</label>`).join("") : '<span class="filter-empty">No tags found</span>'}
          </div>
        </div>
        <button class="btn btn-secondary" type="button" data-clear-repository-filter>Clear</button>
      </div>
    `;
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
            `<circle class="${cssClass}" cx="${point.x.toFixed(1)}" cy="${point.y.toFixed(1)}" r="3.5"><title>${escapeHtml(formatRecordedAt(point.run.recorded_at))} - ${point.value}</title></circle>`
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
    if (!SHOW_HISTORY) {
      const documentedTests = tests.filter((test) => test.test_case.doc).length;
      const tags = new Set(tests.flatMap((test) => (test.test_case.tags || []).map((tag) => (typeof tag === "object" ? tag.name : tag))));
      viewRoot.innerHTML = `
        <div class="grid-metrics">
          ${metricCard(tests.length, "Total Test Cases")}
          ${metricCard(suiteFiles.length, "Test Suites")}
          ${metricCard(documentedTests, "Documented Test Cases")}
          ${metricCard(tags.size, "Unique Tags")}
        </div>
        <div class="card">
          <h2 class="card-title">Tests per Tag</h2>
          ${renderTagStatistics(tests)}
        </div>
        <div class="card">
          <h2 class="card-title">Test Documentation</h2>
          <p>Browse the test case repository to inspect suites, test cases, documentation, tags, and implementation steps.</p>
        </div>
      `;
      return;
    }

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
        ${metricCard(counts.PASS || 0, "Passing (latest)", "PASS")}
        ${metricCard(counts.FAIL || 0, "Failing (latest)", "FAIL")}
        ${metricCard(counts.SKIP || 0, "Skipped (latest)", "SKIP")}
      </div>
      <div class="card">
        <h2 class="card-title">Execution Trend</h2>
        ${renderExecutionTrendChart(executionSeries)}
      </div>
      <div class="card">
        <h2 class="card-title">Tests per Tag</h2>
        ${renderTagStatistics(tests)}
      </div>
      <div class="card">
        <h2 class="card-title">Last recorded run</h2>
        ${lastRun ? `<p>${escapeHtml(formatRecordedAt(lastRun.recorded_at))}</p>` : '<div class="empty-state">No results recorded yet. Run "testdoc management" with a --report-file to record results.</div>'}
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
    if ((state.repoStatusFilter || state.repoSearch || state.repoTagFilters.length || state.repoSuiteFilter) && (prefix === "repo" || prefix === "hist")) {
      const tests = filteredTests(suite);
      if (!tests.length) return '<div class="empty-state">No tests match the selected filters.</div>';

      return `<ul class="tree-list">${tests
        .map(
          (test) => `
        <li class="tree-item ${selectedTest === test.full_name ? "selected" : ""}" data-${prefix}-test="${encodeURIComponent(test.full_name)}">
          <span class="tree-item-name">${escapeHtml(test.test_case.name)}</span>
          ${SHOW_HISTORY ? `<span class="tree-item-meta">${statusBadge(test.latest_status)}</span>` : ""}
        </li>`
        )
        .join("")}</ul>`;
    }

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
          ${SHOW_HISTORY ? `<span class="tree-item-meta">${statusBadge(test.latest_status)}</span>` : ""}
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
          ${SHOW_HISTORY ? metricCard(counts.PASS || 0, "Passing (latest)", "PASS") : ""}
          ${SHOW_HISTORY ? metricCard(counts.FAIL || 0, "Failing (latest)", "FAIL") : ""}
          ${SHOW_HISTORY ? metricCard(counts.SKIP || 0, "Skipped (latest)", "SKIP") : ""}
        </div>
      </div>
    `;
  }

  function renderTestDetail(fullName) {
    const test = findTestByFullName(ROOT, fullName);
    if (!test) return '<div class="empty-state">Test case not found.</div>';

    const testCase = test.test_case;
    const tags = (testCase.tags || []).map((tag) => `<span class="tag">${escapeHtml(tag)}</span>`).join("");
    const latestEntry = latestHistoryEntry(test);

    return `
      <div class="card">
        <h2 class="card-title">${escapeHtml(testCase.name)}</h2>
        ${SHOW_HISTORY ? `<div class="detail-row"><div class="detail-label">Status</div><div class="detail-value">${statusBadge(test.latest_status)}</div></div>` : ""}
        ${SHOW_HISTORY && test.latest_status === "FAIL" && latestEntry && latestEntry.message ? `<div class="detail-row"><div class="detail-label">Error Message</div><div class="detail-value"><div class="error-message">${escapeHtml(latestEntry.message)}</div></div></div>` : ""}
        <div class="detail-row"><div class="detail-label">Documentation</div><div class="detail-value">${escapeHtml(testCase.doc || "-")}</div></div>
        <div class="detail-row"><div class="detail-label">Tags</div><div class="detail-value">${tags || "-"}</div></div>
        <div class="detail-row"><div class="detail-label">Source</div><div class="detail-value">${escapeHtml(testCase.custom_source || testCase.source || "-")}</div></div>
        ${SHOW_HISTORY ? `<div style="margin-top:12px;"><button class="btn" data-goto-history="${encodeURIComponent(test.full_name)}">View Result Trend</button></div>` : ""}
      </div>
      <div class="card">
        <h2 class="card-title">Test Steps</h2>
        ${test.steps_html || '<div class="empty-state">No steps parsed.</div>'}
      </div>
    `;
  }

  function renderRepository() {
    const current = state.repoPath[state.repoPath.length - 1];
    viewRoot.innerHTML = `
      <div class="repository-page">
        <div class="repository-filter-container">
          ${renderRepositoryFilter()}
        </div>
        <div class="repo-layout">
          <div>
          ${renderBreadcrumbs(state.repoPath, "repo")}
          ${renderStatusFilter(current)}
          ${renderSuiteChildrenList(current, "repo", state.repoSelectedTest)}
          </div>
          <div class="repository-results">
            ${state.repoSelectedTest ? renderTestDetail(state.repoSelectedTest) : renderSuiteStats(current)}
          </div>
        </div>
      </div>
    `;
  }

  /* ---------------------------------------------------------------------
   * Test Result History
   * ------------------------------------------------------------------- */

  function renderHistoryOverview(suite) {
    const tests = filteredTests(suite);
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
        return `<div class="trend-bar trend-bar-${cssClass}" style="height:${height}%" title="${escapeHtml(entry.status)} - ${escapeHtml(formatRecordedAt(entry.recorded_at))}"></div>`;
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
          <td>${escapeHtml(formatRecordedAt(entry.recorded_at))}</td>
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
      <div class="repository-page">
        <div class="repository-filter-container">
          ${renderRepositoryFilter()}
        </div>
        <div class="repo-layout">
          <div>
            ${renderBreadcrumbs(state.historyPath, "hist")}
            ${renderStatusFilter(current)}
            ${renderSuiteChildrenList(current, "hist", state.historySelectedTest)}
          </div>
          <div class="repository-results">
            ${state.historySelectedTest ? renderHistoryDetail(state.historySelectedTest) : renderHistoryOverview(current)}
          </div>
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
    else if (page === "history" && SHOW_HISTORY) renderHistory();
    else renderDashboard();
  }

  function renderCurrentPage() {
    if (state.page === "history" && SHOW_HISTORY) renderHistory();
    else renderRepository();
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
    const statusFilter = event.target.closest("[data-status-filter]");
    const clearStatusFilter = event.target.closest("[data-clear-status-filter]");
    const clearRepositoryFilter = event.target.closest("[data-clear-repository-filter]");
    const tagToggle = event.target.closest("[data-repo-tag-toggle]");
    const suiteToggle = event.target.closest("[data-repo-suite-toggle]");
    const suiteOption = event.target.closest("[data-repo-suite]");

    if (suiteToggle) {
      state.repoSuiteMenuOpen = !state.repoSuiteMenuOpen;
      renderCurrentPage();
    } else if (suiteOption) {
      state.repoSuiteFilter = suiteOption.dataset.repoSuite;
      state.repoSuiteMenuOpen = false;
      state.repoSelectedTest = null;
      renderCurrentPage();
    } else if (tagToggle) {
      state.repoTagMenuOpen = !state.repoTagMenuOpen;
      renderCurrentPage();
    } else if (statusFilter) {
      state.repoStatusFilter = statusFilter.dataset.statusFilter;
      state.repoPath = state.page === "dashboard" ? [ROOT] : state.repoPath;
      state.repoSelectedTest = null;
      if (state.page === "dashboard") location.hash = "#/repository";
      else renderRepository();
    } else if (clearStatusFilter) {
      state.repoStatusFilter = null;
      state.repoSelectedTest = null;
      renderCurrentPage();
    } else if (clearRepositoryFilter) {
      state.repoSearch = "";
      state.repoTagFilters = [];
      state.repoStatusFilter = null;
      state.repoTagMenuOpen = false;
      state.repoSuiteFilter = "";
      state.repoSuiteMenuOpen = false;
      state.repoSelectedTest = null;
      renderCurrentPage();
    } else if (repoCrumb) {
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

  viewRoot.addEventListener("input", (event) => {
    if (!event.target.matches("[data-repo-search]")) return;
    state.repoSearch = event.target.value.trim();
    state.repoSelectedTest = null;
    renderCurrentPage();
    const searchInput = viewRoot.querySelector("[data-repo-search]");
    searchInput.focus();
    searchInput.setSelectionRange(searchInput.value.length, searchInput.value.length);
  });

  viewRoot.addEventListener("change", (event) => {
    if (!event.target.matches("[data-repo-tag]")) return;
    const tag = event.target.value;
    if (event.target.checked) state.repoTagFilters = [...state.repoTagFilters, tag];
    else state.repoTagFilters = state.repoTagFilters.filter((selectedTag) => selectedTag !== tag);
    state.repoTagMenuOpen = true;
    state.repoSelectedTest = null;
    renderCurrentPage();
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

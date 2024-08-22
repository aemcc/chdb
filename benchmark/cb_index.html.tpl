<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ClickBench — a Benchmark For Analytical DBMS</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="icon" href="data:image/gif;base64,R0lGODlhIAAgAOMPAHMUEmkyHOcbF8UvJts/E3BeOih1YziiQmebLt2AFjeyQKqZKNWPjLybfPfcDP///yH5BAEKAA8ALAAAAAAgACAAAATg8MlJ6ws26z0EGcQmZgAhnN6oPg0wDA0zrGMTAADDxEJCZ4Gba8c4hX4Uw+XWeYGOyMdhgkuYrAToqIBQHBCIKQ6wcJhPyINarUBcyuYE+ndQeOsKuNlxmv3CdnZfew5yAlEPC12BhFhZiBJ2CI1GkBMHeoV9PpYPhIUDBqIFnZ8EBaKplqYMqaqIewl8A6iupFF7C1YCoaJqq4UOWQIBBmtTuIQmWWxekJQeYWuWcFYPfl+dLAELOxML2hIYDeEWt7flEufknTZB7+8NBeyINxjqDwU4QYg26BTu6KVTEQEAOw==">
    <link href="https://fonts.googleapis.com/css2?family=Inter&display=swap" rel="stylesheet">

    <style>
        :root {
            --color: black;
            --title-color: black;
            --background-color: white;

            --link-color: #08F;
            --link-hover-color: #F40;

            --selector-text-color: black;
            --selector-active-text-color: black;
            --selector-background-color: #EEE;
            --selector-active-background-color: #FFCB80;
            --selector-hover-text-color: black;
            --selector-hover-background-color: #FDB;

            --summary-every-other-row-color: #F8F8F8;
            --highlight-color: #EEE;
            --bar-color: #FFCB80;

            --tooltip-text-color: white;
            --tooltip-background-color: black;

            --nothing-selected-color: #CCC;
            --shadow-color: grey;
        }

        [data-theme="dark"] {
            --color: #CCC;
            --title-color: white;
            --background-color: #04293A;

            --link-color: #8CF;
            --link-hover-color: #FFF;

            --selector-text-color: white;
            --selector-background-color: #444;
            --selector-active-text-color: white;
            --selector-active-background-color: #088;
            --selector-hover-text-color: black;
            --selector-hover-background-color: white;

            --summary-every-other-row-color: #042e41;
            --highlight-color: #064663;
            --bar-color: #088;

            --tooltip-text-color: white;
            --tooltip-background-color: #444;

            --nothing-selected-color: #666;
            --shadow-color: black;
        }

        html, body {
            color: var(--color);
            background-color: var(--background-color);
            width: 100%;
            height: 100%;
            margin: 0;
            overflow: auto;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            padding: 1% 3% 0 3%;
        }

        h1 {
            color: var(--title-color);
        }

        table {
             border-spacing: 1px;
        }

        .stick-left {
            position: sticky;
            left: 0px;
        }

        .selectors-container {
            padding: 2rem 0 2rem 0;
            user-select: none;
        }

        .selectors-container th {
            text-align: left;
            vertical-align: top;
            white-space: nowrap;
            padding-top: 0.5rem;
            padding-right: 1rem;
        }

        .selector {
            display: inline-block;
            margin-left: 0.1rem;
            padding: 0.2rem 0.5rem 0.2rem 0.5rem;
            background: var(--selector-background-color);
            color: var(--selector-text-color);
            border: 0.2rem solid var(--background-color);
            border-radius: 0.5rem;
        }

        .selector-active {
            color: var(--selector-active-text-color);
            background: var(--selector-active-background-color);
        }

        a, a:visited {
            text-decoration: none;
            color: var(--link-color);
            cursor: pointer;
        }

        a:hover {
            color: var(--link-hover-color);
        }

        .selector:hover {
            color: var(--selector-hover-text-color) !important;
            background: var(--selector-background-color);
        }

        .selector-active:hover {
            background: var(--selector-hover-background-color);
        }

        #summary tr:nth-child(odd) {
            background: var(--summary-every-other-row-color);
        }

        .summary-name {
            white-space: nowrap;
            text-align: right;
            padding-right: 1rem;
        }

        .summary-bar-cell {
            width: 100%;
        }

        .summary-bar {
            height: 1rem;
            background: var(--bar-color);
            border-radius: 0 0.2rem 0.2rem 0;
        }

        .summary-number {
            font-family: monospace;
            text-align: right;
            padding-left: 1rem;
            white-space: nowrap;
        }

        th {
            padding-bottom: 0.5rem;
        }

        .th-entry-hilite {
            background: var(--highlight-color);
            font-weight: bold;
        }

        .summary-row:hover, .summary-row-hilite {
            background: var(--highlight-color) !important;
            font-weight: bold;
        }

        #details {
            padding-bottom: 1rem;
        }

        #details th {
            vertical-align: bottom;
            white-space: pre;
        }

        #details td {
            white-space: pre;
            font-family: monospace;
            text-align: right;
            padding: 0.1rem 0.5rem 0.1rem 0.5rem;
        }

        .shadow:hover {
            box-shadow: 0 0 1rem var(--shadow-color);
            position: relative;
        }

        #nothing-selected {
            display: none;
            font-size: 32pt;
            font-weight: bold;
            color: var(--nothing-selected-color);
        }

        .note {
            position: relative;
            display: inline-block;
        }

        .tooltip {
            position: absolute;
            bottom: calc(100% + 0.5rem);
            visibility: hidden;
            background-color: var(--tooltip-background-color);
            color: var(--tooltip-text-color);
            box-shadow: 0 0 1rem var(--shadow-color);
            padding: 0.5rem 0.75rem;
            border-radius: 0.5rem;
            z-index: 1;
            text-align: left;
            white-space: normal;
        }

        .tooltip-result {
            left: calc(50% - 0.25rem);
            width: 20rem;
            margin-left: -10rem;
        }

        .tooltip-query {
            left: 0;
            width: 40rem;
            margin-left: -3rem;
        }

        .note:hover .tooltip {
            visibility: visible;
        }

        .tooltip::after {
            content: " ";
            position: absolute;
            top: 100%;
            border-width: 0.5rem;
            border-style: solid;
            border-color: var(--tooltip-background-color) transparent transparent transparent;
        }

        .tooltip-result::after {
            left: 50%;
            margin-left: -1rem;
        }

        .tooltip-query::after {
            left: 3rem;
            margin-left: 0.5rem;
        }

        .nowrap {
            text-wrap: none;
        }

        .themes {
            float: right;
            font-size: 200%;
            cursor: pointer;
        }

        #toggle-dark, #toggle-light {
            padding-right: 0.5rem;
            cursor: pointer;
        }

        #toggle-dark:hover, #toggle-light:hover {
            display: inline-block;
            transform: translate(1px, 1px);
            filter: brightness(125%);
        }
    </style>
    <script type="text/javascript">

const queries = [
"SELECT COUNT(*) FROM hits;",
"SELECT COUNT(*) FROM hits WHERE AdvEngineID <> 0;",
"SELECT SUM(AdvEngineID), COUNT(*), AVG(ResolutionWidth) FROM hits;",
"SELECT AVG(UserID) FROM hits;",
"SELECT COUNT(DISTINCT UserID) FROM hits;",
"SELECT COUNT(DISTINCT SearchPhrase) FROM hits;",
"SELECT MIN(EventDate), MAX(EventDate) FROM hits;",
"SELECT AdvEngineID, COUNT(*) FROM hits WHERE AdvEngineID <> 0 GROUP BY AdvEngineID ORDER BY COUNT(*) DESC;",
"SELECT RegionID, COUNT(DISTINCT UserID) AS u FROM hits GROUP BY RegionID ORDER BY u DESC LIMIT 10;",
"SELECT RegionID, SUM(AdvEngineID), COUNT(*) AS c, AVG(ResolutionWidth), COUNT(DISTINCT UserID) FROM hits GROUP BY RegionID ORDER BY c DESC LIMIT 10;",
"SELECT MobilePhoneModel, COUNT(DISTINCT UserID) AS u FROM hits WHERE MobilePhoneModel <> '' GROUP BY MobilePhoneModel ORDER BY u DESC LIMIT 10;",
"SELECT MobilePhone, MobilePhoneModel, COUNT(DISTINCT UserID) AS u FROM hits WHERE MobilePhoneModel <> '' GROUP BY MobilePhone, MobilePhoneModel ORDER BY u DESC LIMIT 10;",
"SELECT SearchPhrase, COUNT(*) AS c FROM hits WHERE SearchPhrase <> '' GROUP BY SearchPhrase ORDER BY c DESC LIMIT 10;",
"SELECT SearchPhrase, COUNT(DISTINCT UserID) AS u FROM hits WHERE SearchPhrase <> '' GROUP BY SearchPhrase ORDER BY u DESC LIMIT 10;",
"SELECT SearchEngineID, SearchPhrase, COUNT(*) AS c FROM hits WHERE SearchPhrase <> '' GROUP BY SearchEngineID, SearchPhrase ORDER BY c DESC LIMIT 10;",
"SELECT UserID, COUNT(*) FROM hits GROUP BY UserID ORDER BY COUNT(*) DESC LIMIT 10;",
"SELECT UserID, SearchPhrase, COUNT(*) FROM hits GROUP BY UserID, SearchPhrase ORDER BY COUNT(*) DESC LIMIT 10;",
"SELECT UserID, SearchPhrase, COUNT(*) FROM hits GROUP BY UserID, SearchPhrase LIMIT 10;",
"SELECT UserID, extract(minute FROM EventTime) AS m, SearchPhrase, COUNT(*) FROM hits GROUP BY UserID, m, SearchPhrase ORDER BY COUNT(*) DESC LIMIT 10;",
"SELECT UserID FROM hits WHERE UserID = 435090932899640449;",
"SELECT COUNT(*) FROM hits WHERE URL LIKE '%google%';",
"SELECT SearchPhrase, MIN(URL), COUNT(*) AS c FROM hits WHERE URL LIKE '%google%' AND SearchPhrase <> '' GROUP BY SearchPhrase ORDER BY c DESC LIMIT 10;",
"SELECT SearchPhrase, MIN(URL), MIN(Title), COUNT(*) AS c, COUNT(DISTINCT UserID) FROM hits WHERE Title LIKE '%Google%' AND URL NOT LIKE '%.google.%' AND SearchPhrase <> '' GROUP BY SearchPhrase ORDER BY c DESC LIMIT 10;",
"SELECT * FROM hits WHERE URL LIKE '%google%' ORDER BY EventTime LIMIT 10;",
"SELECT SearchPhrase FROM hits WHERE SearchPhrase <> '' ORDER BY EventTime LIMIT 10;",
"SELECT SearchPhrase FROM hits WHERE SearchPhrase <> '' ORDER BY SearchPhrase LIMIT 10;",
"SELECT SearchPhrase FROM hits WHERE SearchPhrase <> '' ORDER BY EventTime, SearchPhrase LIMIT 10;",
"SELECT CounterID, AVG(length(URL)) AS l, COUNT(*) AS c FROM hits WHERE URL <> '' GROUP BY CounterID HAVING COUNT(*) > 100000 ORDER BY l DESC LIMIT 25;",
"SELECT REGEXP_REPLACE(Referer, '^https?://(?:www\\.)?([^/]+)/.*$', '\\1') AS k, AVG(length(Referer)) AS l, COUNT(*) AS c, MIN(Referer) FROM hits WHERE Referer <> '' GROUP BY k HAVING COUNT(*) > 100000 ORDER BY l DESC LIMIT 25;",
"SELECT SUM(ResolutionWidth), SUM(ResolutionWidth + 1), SUM(ResolutionWidth + 2), SUM(ResolutionWidth + 3), ..., SUM(ResolutionWidth + 89) FROM hits;",
"SELECT SearchEngineID, ClientIP, COUNT(*) AS c, SUM(IsRefresh), AVG(ResolutionWidth) FROM hits WHERE SearchPhrase <> '' GROUP BY SearchEngineID, ClientIP ORDER BY c DESC LIMIT 10;",
"SELECT WatchID, ClientIP, COUNT(*) AS c, SUM(IsRefresh), AVG(ResolutionWidth) FROM hits WHERE SearchPhrase <> '' GROUP BY WatchID, ClientIP ORDER BY c DESC LIMIT 10;",
"SELECT WatchID, ClientIP, COUNT(*) AS c, SUM(IsRefresh), AVG(ResolutionWidth) FROM hits GROUP BY WatchID, ClientIP ORDER BY c DESC LIMIT 10;",
"SELECT URL, COUNT(*) AS c FROM hits GROUP BY URL ORDER BY c DESC LIMIT 10;",
"SELECT 1, URL, COUNT(*) AS c FROM hits GROUP BY 1, URL ORDER BY c DESC LIMIT 10;",
"SELECT ClientIP, ClientIP - 1, ClientIP - 2, ClientIP - 3, COUNT(*) AS c FROM hits GROUP BY ClientIP, ClientIP - 1, ClientIP - 2, ClientIP - 3 ORDER BY c DESC LIMIT 10;",
"SELECT URL, COUNT(*) AS PageViews FROM hits WHERE CounterID = 62 AND EventDate >= '2013-07-01' AND EventDate <= '2013-07-31' AND DontCountHits = 0 AND IsRefresh = 0 AND URL <> '' GROUP BY URL ORDER BY PageViews DESC LIMIT 10;",
"SELECT Title, COUNT(*) AS PageViews FROM hits WHERE CounterID = 62 AND EventDate >= '2013-07-01' AND EventDate <= '2013-07-31' AND DontCountHits = 0 AND IsRefresh = 0 AND Title <> '' GROUP BY Title ORDER BY PageViews DESC LIMIT 10;",
"SELECT URL, COUNT(*) AS PageViews FROM hits WHERE CounterID = 62 AND EventDate >= '2013-07-01' AND EventDate <= '2013-07-31' AND IsRefresh = 0 AND IsLink <> 0 AND IsDownload = 0 GROUP BY URL ORDER BY PageViews DESC LIMIT 10 OFFSET 1000;",
"SELECT TraficSourceID, SearchEngineID, AdvEngineID, CASE WHEN (SearchEngineID = 0 AND AdvEngineID = 0) THEN Referer ELSE '' END AS Src, URL AS Dst, COUNT(*) AS PageViews FROM hits WHERE CounterID = 62 AND EventDate >= '2013-07-01' AND EventDate <= '2013-07-31' AND IsRefresh = 0 GROUP BY TraficSourceID, SearchEngineID, AdvEngineID, Src, Dst ORDER BY PageViews DESC LIMIT 10 OFFSET 1000;",
"SELECT URLHash, EventDate, COUNT(*) AS PageViews FROM hits WHERE CounterID = 62 AND EventDate >= '2013-07-01' AND EventDate <= '2013-07-31' AND IsRefresh = 0 AND TraficSourceID IN (-1, 6) AND RefererHash = 3594120000172545465 GROUP BY URLHash, EventDate ORDER BY PageViews DESC LIMIT 10 OFFSET 100;",
"SELECT WindowClientWidth, WindowClientHeight, COUNT(*) AS PageViews FROM hits WHERE CounterID = 62 AND EventDate >= '2013-07-01' AND EventDate <= '2013-07-31' AND IsRefresh = 0 AND DontCountHits = 0 AND URLHash = 2868770270353813622 GROUP BY WindowClientWidth, WindowClientHeight ORDER BY PageViews DESC LIMIT 10 OFFSET 10000;",
"SELECT DATE_TRUNC('minute', EventTime) AS M, COUNT(*) AS PageViews FROM hits WHERE CounterID = 62 AND EventDate >= '2013-07-14' AND EventDate <= '2013-07-15' AND IsRefresh = 0 AND DontCountHits = 0 GROUP BY DATE_TRUNC('minute', EventTime) ORDER BY DATE_TRUNC('minute', EventTime) LIMIT 10 OFFSET 1000;",
];

DATA_PLACEHOLDER

const additional_data_size_points = [
{"fake": true, "system": "hits.tsv", "data_size": 74807831229},
{"fake": true, "system": "hits.csv", "data_size": 81136059858},
{"fake": true, "system": "hits.json", "data_size": 232733025002},
{"fake": true, "system": "hits.parquet", "data_size": 14779976446},
{"fake": true, "system": "hits.tsv.gz", "data_size": 16298506510},
{"fake": true, "system": "hits.csv.gz", "data_size": 16608960810},
{"fake": true, "system": "hits.json.gz", "data_size": 23728268670}
];
    </script>
</head>
<body>

<div class="header stick-left">
    <span class="nowrap themes"><span id="toggle-dark">🌚</span><span id="toggle-light">🌞</span></span>
    <h1>ClickBench — a Benchmark For Analytical DBMS</h1>
    <a href="https://github.com/ClickHouse/ClickBench/">Methodology</a> | <a href="https://github.com/ClickHouse/ClickBench/">Reproduce and Validate the Results</a> | <a href="https://github.com/ClickHouse/ClickBench/">Add a System</a> | <a href="https://github.com/ClickHouse/ClickBench/">Report Mistake</a> | <a href="https://benchmark.clickhouse.com/hardware/">Hardware Benchmark</a> | <a href="https://benchmark.clickhouse.com/versions/">Versions Benchmark</a>
</div>

<table class="selectors-container stick-left">
    <tr>
        <th>System: </th>
        <td id="selectors_system">
            <a id="select-all-systems" class="selector selector-active">All</a>
        </td>
    </tr>
    <tr>
        <th>Type: </th>
        <td id="selectors_type">
            <a id="select-all-types" class="selector selector-active">All</a>
        </td>
    </tr>
    <tr>
        <th>Machine: </th>
        <td id="selectors_machine">
            <a id="select-all-machines" class="selector selector-active">All</a>
        </td>
    </tr>
    <tr>
        <th>Cluster size: </th>
        <td id="selectors_cluster_size">
            <a id="select-all-cluster-sizes" class="selector selector-active">All</a>
        </td>
    </tr>
    <tr>
        <th>Metric: </th>
        <td id="selectors_run">
            <a class="selector" id="selector-metric-cold">Cold Run</a>
            <a class="selector" id="selector-metric-hot">Hot Run</a>
            <a class="selector" id="selector-metric-load">Load Time</a>
            <a class="selector" id="selector-metric-size">Storage Size</a>
        </td>
    </tr>
</table>

<table class="stick-left comparison">
    <thead>
        <tr>
            <th class="summary-name">
                System &amp; Machine
            </th>
            <th colspan="2">
                Relative <span id="time-or-size">time</span> (lower is better)
            </th>
        </tr>
    </thead>
    <tbody id="summary">
    </tbody>
</table>

<div id="nothing-selected" class="stick-left">Nothing selected</div>

<div class="stick-left comparison">
    <h2>Detailed Comparison</h2>
</div>

<table id="details">
    <thead>
        <tr id="details_head">
        </tr>
    </thead>
    <tbody id="details_body">
    </tbody>
</table>

<script type="text/javascript">

const constant_time_add = 0.01;
const missing_result_penalty = 2;
const missing_result_time = 300;

let selectors = {
    "system": {},
    "type": {},
    "machine": {},
    "cluster_size": {},
    "metric": "cold",
    "queries": [],
};

let theme = 'light';

function setTheme(new_theme) {
    theme = new_theme;
    document.documentElement.setAttribute('data-theme', theme);
    window.localStorage.setItem('theme', theme);
    render();
}

document.getElementById('toggle-light').addEventListener('click', e => setTheme('light'));
document.getElementById('toggle-dark').addEventListener('click', e => setTheme('dark'));

let new_theme = window.localStorage.getItem('theme');
if (new_theme && new_theme != theme) {
    setTheme(new_theme);
}

/// Generate selectors

let systems = document.getElementById('selectors_system');
let types = document.getElementById('selectors_type');
let machines = document.getElementById('selectors_machine');
let cluster_sizes = document.getElementById('selectors_cluster_size');

let unique_systems = [... new Set(data.map(elem => elem.system))];

function toggle(e, elem, selectors_map) {
    selectors_map[elem] = !selectors_map[elem];
    e.target.className = selectors_map[elem] ? 'selector selector-active' : 'selector';
    render();
    updateHistory();
}

function toggleAll(e, selectors_map) {
    const new_value = Object.keys(selectors_map).filter(k => selectors_map[k]).length * 2 < Object.keys(selectors_map).length;
    [...e.target.parentElement.querySelectorAll('a')].map(
        elem => { elem.className = new_value ? 'selector selector-active' : 'selector' });

    Object.keys(selectors_map).map(k => { selectors_map[k] = new_value });
    render();
    updateHistory();
}

unique_systems.map(elem => {
    let selector = document.createElement('a');
    selector.className = 'selector selector-active';
    selector.appendChild(document.createTextNode(elem));
    systems.appendChild(selector);
    if (!(elem in selectors.system)) { selectors.system[elem] = data.some(entry => entry.system == elem && !entry.hide); }
    selector.addEventListener('click', e => toggle(e, elem, selectors.system));

    /// Highlighting summary rows and table columns on hovering over the system selector.
    selector.addEventListener('mouseover', e => {
        [...document.querySelectorAll('.summary-row')].map(row => {
            row.className = row.dataset.system == elem ? 'summary-row summary-row-hilite' : 'summary-row' });
        [...document.querySelectorAll('.th-entry')].map(th => {
            th.className = th.dataset.system == elem ? 'th-entry th-entry-hilite' : 'th-entry' });
    });
    selector.addEventListener('mouseout', e => {
        [...document.querySelectorAll('.summary-row')].map(row => { row.className = 'summary-row' });
        [...document.querySelectorAll('.th-entry')].map(row => { row.className = 'th-entry' });
    });
});

[... new Set(data.map(elem => elem.tags).flat())].map(elem => {
    let selector = document.createElement('a');
    selector.className = 'selector selector-active';
    selector.appendChild(document.createTextNode(elem));
    types.appendChild(selector);
    if (!(elem in selectors.type)) { selectors.type[elem] = true; }
    selector.addEventListener('click', e => toggle(e, elem, selectors.type));
});

[... new Set(data.map(elem => elem.machine))].map(elem => {
    let selector = document.createElement('a');
    selector.className = 'selector selector-active';
    selector.appendChild(document.createTextNode(elem));
    machines.appendChild(selector);
    if (!(elem in selectors.machine)) { selectors.machine[elem] = true; }
    selector.addEventListener('click', e => toggle(e, elem, selectors.machine));
});

[... new Set(data.map(elem => elem.cluster_size))].sort(
    (a, b) => ((typeof(b) === 'number') - (typeof(a) === 'number')) || (a - b)).map(elem => {
    let selector = document.createElement('a');
    selector.className = 'selector selector-active';
    selector.appendChild(document.createTextNode(elem));
    cluster_sizes.appendChild(selector);
    if (!(elem in selectors.cluster_size)) { selectors.cluster_size[elem] = true; }
    selector.addEventListener('click', e => toggle(e, elem, selectors.cluster_size));
});

document.getElementById('select-all-systems').addEventListener('click', e => toggleAll(e, selectors.system));
document.getElementById('select-all-types').addEventListener('click', e => toggleAll(e, selectors.type));
document.getElementById('select-all-machines').addEventListener('click', e => toggleAll(e, selectors.machine));
document.getElementById('select-all-cluster-sizes').addEventListener('click', e => toggleAll(e, selectors.cluster_size));

[...document.getElementById('selectors_run').querySelectorAll('a')].map(elem => elem.addEventListener('click', e => {
    [...e.target.parentElement.querySelectorAll('a')].map(elem => { elem.className = elem == e.target ? 'selector selector-active' : 'selector' });
}));

document.getElementById('selector-metric-cold').addEventListener('click', e => { selectors.metric = 'cold'; render(); updateHistory(); });
document.getElementById('selector-metric-hot').addEventListener('click', e => { selectors.metric = 'hot'; render(); updateHistory(); });
document.getElementById('selector-metric-load').addEventListener('click', e => { selectors.metric = 'load'; render(); updateHistory(); });
document.getElementById('selector-metric-size').addEventListener('click', e => { selectors.metric = 'size'; render(); updateHistory(); });

selectors.queries = [...data[0].result.keys()].map(k => true);

function updateSelectors() {
    [...systems.childNodes].map(elem => { elem.className = selectors.system[elem.innerText] ? 'selector selector-active' : 'selector' });
    [...types.childNodes].map(elem => { elem.className = selectors.type[elem.innerText] ? 'selector selector-active' : 'selector' });
    [...machines.childNodes].map(elem => { elem.className = selectors.machine[elem.innerText] ? 'selector selector-active' : 'selector' });
    [...cluster_sizes.childNodes].map(elem => { elem.className = selectors.cluster_size[elem.innerText] ? 'selector selector-active' : 'selector' });

    [...document.getElementById('selectors_run').querySelectorAll('a')].map(elem => {
        elem.className = elem.id == 'selector-metric-' + selectors.metric ? 'selector selector-active' : 'selector' });

    [...document.querySelectorAll('.query-checkbox')].map((elem, i) => { elem.checked = selectors.queries[i] });
}

function clearElement(elem)
{
    while (elem.firstChild) {
        elem.removeChild(elem.lastChild);
    }
}

function selectRun(timings) {
    return selectors.metric == 'cold' ? timings[0] : (timings[1] !== null && timings[2] !== null ? Math.min(timings[1], timings[2]) : null)
}

function addNote(text) {
    let note = document.createElement('sup');
    note.className = 'note';
    note.appendChild(document.createTextNode('†'));

    let tooltip = document.createElement('span');
    tooltip.className = 'tooltip tooltip-result';
    tooltip.appendChild(document.createTextNode(text));

    note.appendChild(tooltip);
    return note;
}

function renderSummary(filtered_data) {
    let table = document.getElementById('summary');
    clearElement(table);

    /// Generate summary

    /// The algorithm: for each of the queries,
    /// - if there is a result - take query duration, add 10 ms, and divide it to the corresponding value from the baseline,
    /// - if there is no result - take the worse query duration across all query runs for this system and multiply by 2.
    /// Take geometric mean across the queries.

    let summary = {};

    const num_queries = filtered_data[0].result.length;

    const baseline_data = [...filtered_data[0].result.keys()].map(query_num =>
        [...Array(3).keys()].map(run_num =>
            Math.min(...filtered_data.filter(elem => !elem.fake).map(elem => elem.result[query_num][run_num]).filter(x => x))));

    const min_load_time = Math.min(...filtered_data.map(elem => elem.load_time).filter(x => x));
    const min_data_size = Math.min(...filtered_data.map(elem => elem.data_size).filter(x => x));

    let summaries;
    if (selectors.metric == 'load') {
        summaries = filtered_data.map(elem => elem.load_time / min_load_time);
        document.getElementById('time-or-size').innerText = 'time';
    } else if (selectors.metric == 'size') {
        summaries = filtered_data.map(elem => elem.data_size / min_data_size);
        document.getElementById('time-or-size').innerText = 'size';
    } else {
        summaries = filtered_data.map(elem => {
            const fallback_timing = missing_result_penalty * Math.max(missing_result_time, ...elem.result.map(timings => selectRun(timings)));

            let accumulator = 0;
            let used_queries = 0;

            const no_queries_selected = selectors.queries.filter(x => x).length == 0;

            for (let i = 0; i < num_queries; ++i) {
                if (no_queries_selected || selectors.queries[i]) {
                    const curr_timing = selectRun(elem.result[i]) ?? fallback_timing;
                    const baseline_timing = selectRun(baseline_data[i]);
                    const ratio = (constant_time_add + curr_timing) / (constant_time_add + baseline_timing);
                    accumulator += Math.log(ratio);
                    ++used_queries;
                }
            }

            return Math.exp(accumulator / used_queries);
        });
        document.getElementById('time-or-size').innerText = 'time';
    }

    const sorted_indices = [...summaries.keys()].sort((a, b) => summaries[a] - summaries[b]);
    const max_ratio = summaries[sorted_indices[sorted_indices.length - 1]];

    sorted_indices.map(idx => {
        const elem = filtered_data[idx];

        if (selectors.metric == 'size' && elem.data_size === null) { return; }

        let tr = document.createElement('tr');
        tr.className = 'summary-row';

        tr.dataset.system = elem.system;

        let td_name = document.createElement('td');
        td_name.className = 'summary-name';

        if (!elem.fake) {
            let link = document.createElement('a');
            link.appendChild(document.createTextNode(`${elem.system} (${Number.isInteger(elem.cluster_size) && elem.cluster_size > 1 ? elem.cluster_size + '×': ''}${elem.machine})`));
            link.href = "https://github.com/ClickHouse/ClickBench/blob/main/" + elem.source;
            td_name.appendChild(link);
        } else {
            td_name.appendChild(document.createTextNode(elem.system));
        }

        if (elem.comment) { td_name.appendChild(addNote(elem.comment)); }
        td_name.appendChild(document.createTextNode(': '));

        const ratio = summaries[idx];
        const percentage = summaries[idx] / max_ratio * 100;

        let td_number = document.createElement('td');
        td_number.className = 'summary-number';

        const text = selectors.metric == 'load' ? (elem.load_time ? `${Math.round(elem.load_time)}s (×${ratio.toFixed(2)})` : 'stateless')
            :  selectors.metric == 'size' ? `${(elem.data_size / 1024 / 1024 / 1024).toFixed(2)} GiB (×${ratio.toFixed(2)})`
            : `×${ratio.toFixed(2)}`;

        td_number.appendChild(document.createTextNode(text));

        let td_bar = document.createElement('td');
        td_bar.className = 'summary-bar-cell';

        let bar = document.createElement('div');

        bar.className = `summary-bar`;
        bar.style.width = `${percentage}%`;

        td_bar.appendChild(bar);

        tr.appendChild(td_name);
        tr.appendChild(td_bar);
        tr.appendChild(td_number);
        table.appendChild(tr);
    });

    return [sorted_indices, baseline_data];
}

function colorize(elem, ratio) {
    let [r, g, b] = [0, 0, 0];

    /// ratio less than 1 - green
    /// ratio from 1 to 2 - green to yellow
    /// ratio from 2 to 10 - yellow to red
    /// ratio from 10 to 1000 to infinity - red to brown to black

    /// Note: we are using RGB space without proper gamma correction. Read more: https://www.handprint.com/HP/WCL/color1.html

    if (ratio !== null) {
        if (ratio < 1) {
            r = 232;
            g = 255;
            b = 232;
        } else if (ratio <= 1) {
            g = 255;
        } else if (ratio <= 2) {
            g = 255;
            r = (ratio - 1) * 255;
        } else if (ratio <= 10) {
            g = (10 - ratio) / 8 * 255;
            r = 255;
        } else {
            r = (1 - ((ratio - 10) / ((ratio - 10) + 1000))) * 255;
        }
    }

    if (document.documentElement.getAttribute('data-theme') == 'dark') {
        r /= 1.5;
        g /= 1.5;
        b /= 1.5;
    }

    elem.style.backgroundColor = `rgb(${r}, ${g}, ${b})`;
    if (ratio === null || ratio > 10) {
        /// This will look better on dark backgrounds
        elem.style.color = 'white';
    } else {
        elem.style.color = 'black';
    }

    /// The best result is highlighted
    if (ratio == 1) {
        elem.style.fontWeight = 'bold';
    }
}

function render() {
    let details_head = document.getElementById('details_head');
    let details_body = document.getElementById('details_body');

    clearElement(details_head);
    clearElement(details_body);

    let filtered_data = data.filter(elem =>
        selectors.system[elem.system] &&
        selectors.machine[elem.machine] &&
        selectors.cluster_size[elem.cluster_size] &&
        elem.tags.filter(type => selectors.type[type]).length > 0);

    let nothing_selected_elem = document.getElementById('nothing-selected');
    if (filtered_data.length == 0) {
        nothing_selected_elem.style.display = 'block';
        [...document.querySelectorAll('.comparison')].map(e => e.style.display = 'none');
        return;
    }
    nothing_selected_elem.style.display = 'none';
    [...document.querySelectorAll('.comparison')].map(e => e.style.display = 'block');

    if (selectors.metric == 'size') {
        filtered_data = [...filtered_data, ...additional_data_size_points];
    }

    let [sorted_indices, baseline_data] = renderSummary(filtered_data);
    sorted_indices = sorted_indices.filter(idx => !filtered_data[idx].fake);

    /// Generate details

    /// Global checkbox
    {
        let th_checkbox = document.createElement('th');
        let checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.checked = true;
        checkbox.addEventListener('change', e => {
            [...document.querySelectorAll('.query-checkbox')].map(elem => { elem.checked = e.target.checked });
            selectors.queries.map((_, i) => { selectors.queries[i] = e.target.checked });
            renderSummary(filtered_data);
            updateHistory();
        });
        th_checkbox.appendChild(checkbox);
        details_head.appendChild(th_checkbox);
        details_head.appendChild(document.createElement('th'));
    }

    /// Table header
    sorted_indices.map(idx => {
        const elem = filtered_data[idx];
        let th = document.createElement('th');
        th.appendChild(document.createTextNode(`${elem.system}\n(${Number.isInteger(elem.cluster_size) && elem.cluster_size > 1 ? elem.cluster_size + '×': ''}${elem.machine})`));
        th.className = 'th-entry';
        th.dataset.system = elem.system;
        details_head.appendChild(th);
    });

    /// Load times
    {
        let tr = document.createElement('tr');
        tr.className = 'shadow';

        let td_title = document.createElement('td');
        td_title.colSpan = 2;
        td_title.appendChild(document.createTextNode('Load time: '));
        tr.appendChild(td_title);

        sorted_indices.map(idx => {
            const curr_timing = filtered_data[idx].load_time;
            const baseline_timing = Math.min(...filtered_data.map(elem => elem.load_time).filter(x => x));
            const ratio = curr_timing / baseline_timing;

            let td = document.createElement('td');
            td.appendChild(document.createTextNode(curr_timing ? `${Math.round(curr_timing)}s (×${ratio.toFixed(2)})` : '0'));

            colorize(td, ratio);
            tr.appendChild(td);
        });

        details_body.appendChild(tr);
    }

    /// Data sizes
    {
        let tr = document.createElement('tr');
        tr.className = 'shadow';

        let td_title = document.createElement('td');
        td_title.colSpan = 2;
        td_title.appendChild(document.createTextNode('Data size: '));
        tr.appendChild(td_title);

        sorted_indices.map(idx => {
            const curr_size = filtered_data[idx].data_size;
            const baseline_size = Math.min(...filtered_data.map(elem => elem.data_size).filter(x => x));
            const ratio = curr_size !== null ? curr_size / baseline_size : null;

            let td = document.createElement('td');
            td.appendChild(document.createTextNode(curr_size !== null ? `${(curr_size / 1024 / 1024 / 1024).toFixed(2)} GiB (×${ratio.toFixed(2)})` : '☠'));

            colorize(td, ratio);
            tr.appendChild(td);
        });

        details_body.appendChild(tr);
    }

    /// Query runtimes
    const num_queries = filtered_data[0].result.length;

    for (let query_num = 0; query_num < num_queries; ++query_num) {
        let tr = document.createElement('tr');
        tr.className = 'shadow';

        let td_checkbox = document.createElement('td');
        let checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.className = 'query-checkbox';
        checkbox.checked = selectors.queries[query_num];
        checkbox.addEventListener('change', e => {
            selectors.queries[query_num] = e.target.checked;
            renderSummary(filtered_data);
            updateHistory();
        });
        td_checkbox.appendChild(checkbox);
        tr.appendChild(td_checkbox);

        let td_query_num = document.createElement('td');
        td_query_num.className = 'note';
        td_query_num.appendChild(document.createTextNode(`Q${query_num}. `));

        let tooltip = document.createElement('span');
        tooltip.className = 'tooltip tooltip-query';
        tooltip.appendChild(document.createTextNode(`Query ${query_num}: ${queries[query_num]}`));
        td_query_num.appendChild(tooltip);

        tr.appendChild(td_query_num);

        sorted_indices.map(idx => {
            const curr_timing = selectRun(filtered_data[idx].result[query_num]);
            const baseline_timing = selectRun(baseline_data[query_num]);
            const ratio = curr_timing !== null ? (constant_time_add + curr_timing) / (constant_time_add + baseline_timing) : null;

            let td = document.createElement('td');
            td.appendChild(document.createTextNode(curr_timing !== null ? `${curr_timing.toFixed(3)}s (×${ratio.toFixed(2)})` : '☠'));

            colorize(td, ratio);
            tr.appendChild(td);
        });

        details_body.appendChild(tr);
    }
}

function updateHistory() {
    history.pushState(selectors, '',
        window.location.pathname + (window.location.search || '') + '#' + btoa(JSON.stringify(selectors)));
}

window.onpopstate = function(event) {
    if (!event.state) { return; }
    selectors = event.state;
    render();
    updateSelectors();
};

if (window.location.hash) {
    try {
        selectors = JSON.parse(atob(window.location.hash.substring(1)));
    } catch {}
}

render();
updateSelectors();

</script>
</body>
</html>


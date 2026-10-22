import { spawn, execSync } from "node:child_process";
import { mkdtempSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

const CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome";
const SITES = [
  "https://www.wikipedia.org/",
  "https://www.bbc.com/news",
  "https://www.reddit.com/",
  "https://github.com/",
  "https://www.youtube.com/",
  "https://www.theverge.com/",
];
const IDLE_SECONDS = Number(process.env.IDLE_SECONDS || 60);
const RUNS = Number(process.env.RUNS || 3);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const median = (a) => [...a].sort((x, y) => x - y)[Math.floor(a.length / 2)];

function launch(extra = []) {
  const dir = mkdtempSync(join(tmpdir(), "lean-bench-"));
  const port = 20000 + Math.floor(Math.random() * 20000);
  const netlog = join(dir, "netlog.json");
  const started = performance.now();
  const proc = spawn(CHROME, [
    "--headless=new", "--no-first-run", "--no-default-browser-check",
    `--user-data-dir=${dir}`, `--remote-debugging-port=${port}`,
    `--log-net-log=${netlog}`, ...extra, "about:blank",
  ], { stdio: "ignore" });
  return { dir, port, netlog, proc, started };
}

async function ready(b) {
  for (;;) {
    try {
      await fetch(`http://127.0.0.1:${b.port}/json/version`);
      return performance.now() - b.started;
    } catch {
      await sleep(20);
    }
  }
}

async function connect(port) {
  const targets = await (await fetch(`http://127.0.0.1:${port}/json`)).json();
  const ws = new WebSocket(targets.find((t) => t.type === "page").webSocketDebuggerUrl);
  await new Promise((r) => (ws.onopen = r));
  let id = 0;
  const pending = new Map();
  const listeners = [];
  ws.onmessage = (e) => {
    const m = JSON.parse(e.data);
    if (m.id) pending.get(m.id)?.(m);
    else listeners.forEach((l) => l(m));
  };
  const send = (method, params = {}) =>
    new Promise((r) => { pending.set(++id, r); ws.send(JSON.stringify({ id, method, params })); });
  return { ws, send, on: (f) => listeners.push(f) };
}

function memoryMB(dir) {
  const out = execSync("ps -axo rss=,command=", { maxBuffer: 1 << 26 }).toString();
  return Math.round(out.split("\n").filter((l) => l.includes(dir)).reduce((s, l) => s + parseInt(l), 0) / 1024);
}

function diskMB(dir) {
  return Math.round(parseInt(execSync(`du -sk "${dir}"`).toString()) / 1024);
}

function hostsFromNetlog(file) {
  const text = readFileSync(file, "utf8").trim();
  let log;
  try {
    log = JSON.parse(text);
  } catch {
    log = JSON.parse(text.replace(/,?\s*$/, "") + "]}");
  }
  const hosts = {};
  const seen = new Set();
  for (const ev of log.events || []) {
    const url = ev.params?.url;
    if (!url || !/^https?:/.test(url) || seen.has(ev.source?.id)) continue;
    seen.add(ev.source?.id);
    const h = new URL(url).host;
    hosts[h] = (hosts[h] || 0) + 1;
  }
  return hosts;
}

async function stop(b) {
  b.proc.kill("SIGTERM");
  await new Promise((r) => b.proc.on("exit", r));
}

async function startupRun() {
  const b = launch();
  const ms = await ready(b);
  await stop(b);
  rmSync(b.dir, { recursive: true, force: true });
  return ms;
}

async function browseRun() {
  const b = launch();
  await ready(b);
  const { send, on, ws } = await connect(b.port);
  await send("Network.enable");
  await send("Page.enable");
  let requests = 0, bytes = 0;
  on((m) => {
    if (m.method === "Network.requestWillBeSent") requests++;
    if (m.method === "Network.loadingFinished") bytes += m.params.encodedDataLength || 0;
  });
  const loads = [];
  for (const url of SITES) {
    const t = performance.now();
    const done = new Promise((r) => on((m) => m.method === "Page.loadEventFired" && r()));
    await send("Page.navigate", { url });
    await Promise.race([done, sleep(30000)]);
    loads.push(performance.now() - t);
    await sleep(1500);
  }
  const memory = memoryMB(b.dir);
  ws.close();
  await stop(b);
  const disk = diskMB(b.dir);
  rmSync(b.dir, { recursive: true, force: true });
  return { loads, requests, mb: bytes / 1048576, memory, disk };
}

async function idleRun() {
  const b = launch();
  await ready(b);
  await sleep(IDLE_SECONDS * 1000);
  const memory = memoryMB(b.dir);
  await stop(b);
  const hosts = hostsFromNetlog(b.netlog);
  rmSync(b.dir, { recursive: true, force: true });
  return { memory, hosts };
}

const startup = [];
for (let i = 0; i < RUNS; i++) startup.push(await startupRun());
const browse = [];
for (let i = 0; i < RUNS; i++) browse.push(await browseRun());
const idle = await idleRun();

const total = (o) => Object.values(o).reduce((a, b) => a + b, 0);
const result = {
  chrome: execSync(`"${CHROME}" --version`).toString().trim(),
  runs: RUNS,
  startupMs: Math.round(median(startup)),
  pageLoadMs: Object.fromEntries(SITES.map((s, i) => [new URL(s).host, Math.round(median(browse.map((r) => r.loads[i])))])),
  totalLoadMs: Math.round(median(browse.map((r) => r.loads.reduce((a, b) => a + b, 0)))),
  requests: median(browse.map((r) => r.requests)),
  transferMB: +median(browse.map((r) => r.mb)).toFixed(1),
  memoryMB: median(browse.map((r) => r.memory)),
  diskMB: median(browse.map((r) => r.disk)),
  idleMemoryMB: idle.memory,
  idleRequests: total(idle.hosts),
  idleHosts: idle.hosts,
};
console.log(JSON.stringify(result, null, 2));

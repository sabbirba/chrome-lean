const port = process.argv[2];
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

const targets = await (await fetch(`http://127.0.0.1:${port}/json`)).json();
const page = targets.find((t) => t.type === "page");
const ws = new WebSocket(page.webSocketDebuggerUrl);
await new Promise((r) => (ws.onopen = r));

let id = 0;
const pending = new Map();
ws.onmessage = (e) => {
  const msg = JSON.parse(e.data);
  pending.get(msg.id)?.(msg);
};
const send = (method, params) =>
  new Promise((resolve) => {
    pending.set(++id, resolve);
    ws.send(JSON.stringify({ id, method, params }));
  });

await send("Page.navigate", { url: "chrome://policy" });
await sleep(4000);

const collect = () => {
  const text = (node) => {
    let s = "";
    const go = (x) => {
      if (x.nodeType === 3) s += x.textContent + " ";
      if (x.shadowRoot) for (const c of x.shadowRoot.childNodes) go(c);
      for (const c of x.childNodes || []) go(c);
    };
    go(node);
    return s.replace(/\s+/g, " ").trim();
  };
  const rows = [];
  const walk = (n) => {
    if (!n) return;
    if (n.shadowRoot) walk(n.shadowRoot);
    for (const c of n.children || []) walk(c);
    if (n.tagName === "POLICY-ROW") rows.push(text(n).slice(0, 300));
  };
  walk(document.body);
  return rows.join("\n");
};

const res = await send("Runtime.evaluate", { expression: `(${collect})()`, returnByValue: true });
console.log(res.result.result.value);
ws.close();
process.exit(0);

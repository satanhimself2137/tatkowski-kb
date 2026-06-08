import { searchconsole } from './auth.js';
import { fetchAllRows } from './fetcher.js';
import { getMonthsToPull } from './months.js';
import { COMBOS } from './combos.js';
import { mkdirSync, writeFileSync, existsSync, readFileSync, appendFileSync } from 'fs';
import { join } from 'path';

const DATA_DIR = 'D:\\tatkowski-gsc\\data\\raw';
const PROGRESS_FILE = 'D:\\tatkowski-gsc\\data\\_progress.jsonl';
const ERRORS_FILE = 'D:\\tatkowski-gsc\\data\\_errors.jsonl';

function loadProgress() {
  if (!existsSync(PROGRESS_FILE)) return new Set();
  const lines = readFileSync(PROGRESS_FILE, 'utf8').split('\n').filter(Boolean);
  return new Set(lines.map(l => JSON.parse(l).key));
}

function markDone(key) {
  appendFileSync(PROGRESS_FILE, JSON.stringify({ key, doneAt: new Date().toISOString() }) + '\n');
}

function markError(key, err) {
  appendFileSync(ERRORS_FILE, JSON.stringify({ key, error: err.message || String(err), at: new Date().toISOString() }) + '\n');
}

function safeFolderName(siteUrl) {
  return siteUrl.replace(/[:/\\]/g, '_');
}

// A month is "active" (always re-pulled, never marked permanently done) if:
//   - it's the current calendar month, OR
//   - it's the previous calendar month AND we're still in days 1-3 of the current
//     month (GSC's 2-3 day reporting lag means the previous month may still be revising).
// All older months are frozen — once in _progress.jsonl, skipped forever.
function isActiveMonth(monthLabel) {
  const today = new Date();
  const day = today.getDate();
  const curY = today.getFullYear();
  const curM = today.getMonth(); // 0-indexed
  const [y, m] = monthLabel.split('-').map(Number); // m is 1-indexed

  // Current month
  if (y === curY && m === curM + 1) return true;

  // Previous month, only if we're still in the lag window (days 1-3)
  if (day < 4) {
    const prev = new Date(curY, curM - 1, 1);
    if (y === prev.getFullYear() && m === prev.getMonth() + 1) return true;
  }

  return false;
}

async function main() {
  const sitesRes = await searchconsole.sites.list();
  const properties = (sitesRes.data.siteEntry || [])
    .filter(s => s.permissionLevel !== 'siteUnverifiedUser')
    .map(s => s.siteUrl);

  if (properties.length === 0) {
    console.error('No accessible properties.');
    process.exit(1);
  }

  const months = getMonthsToPull();
  const done = loadProgress();

  // Build the work list: skip combos in frozen months that are already in progress.
  // Active months (current + previous-during-lag-window) are always included.
  const work = [];
  let frozenSkipped = 0;
  let activeCount = 0;
  let newFrozenCount = 0;
  for (const property of properties) {
    for (const month of months) {
      const active = isActiveMonth(month.label);
      for (const combo of COMBOS) {
        const key = `${property}|${month.label}|${combo.name}`;
        if (done.has(key) && !active) { frozenSkipped++; continue; }
        work.push({ property, month, combo, key, active });
        if (active) activeCount++; else newFrozenCount++;
      }
    }
  }
  const totalCombos = properties.length * months.length * COMBOS.length;

  console.log(`Properties: ${properties.length}`);
  console.log(`Months: ${months.length} (${months[0].label} to ${months[months.length - 1].label})`);
  console.log(`Combos: ${COMBOS.length}`);
  console.log(`Total combos: ${totalCombos}`);
  console.log(`Frozen (skipped): ${frozenSkipped}`);
  console.log(`To fetch this run: ${work.length} (active: ${activeCount}, new frozen: ${newFrozenCount})\n`);

  let completed = 0;
  let errors = 0;
  const startTime = Date.now();

  for (const { property, month, combo, key, active } of work) {
    const folder = join(DATA_DIR, safeFolderName(property), month.label);
    mkdirSync(folder, { recursive: true });
    const outFile = join(folder, `${combo.name}.json`);

    process.stdout.write(`[${++completed}/${work.length}] ${property} ${month.label} ${combo.name}${active ? ' (active)' : ''} ... `);
    const t0 = Date.now();
    try {
      const rows = await fetchAllRows(property, month.startDate, month.endDate, combo.dimensions);
      writeFileSync(outFile, JSON.stringify({ property, month: month.label, combo: combo.name, rowCount: rows.length, rows }, null, 2));
      if (!active) markDone(key); // never mark active months — they must re-pull next run
      console.log(`${rows.length} rows (${Date.now() - t0}ms)`);
    } catch (err) {
      errors++;
      markError(key, err);
      console.log(`ERROR: ${err.message || err}`);
    }
  }

  const mins = ((Date.now() - startTime) / 60000).toFixed(1);
  console.log(`\nPull complete in ${mins} min. Errors: ${errors}. See data/_errors.jsonl if any.`);
}

main().catch(err => { console.error(err); process.exit(1); });

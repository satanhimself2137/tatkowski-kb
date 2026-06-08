import { readdirSync, readFileSync, writeFileSync, mkdirSync, existsSync } from 'fs';
import { join } from 'path';

const RAW_DIR = 'D:\\tatkowski-gsc\\data\\raw';
const CSV_DIR = 'D:\\tatkowski-gsc\\data\\csv';

function csvEscape(v) {
  if (v == null) return '';
  const s = String(v);
  if (s.includes(',') || s.includes('"') || s.includes('\n')) {
    return '"' + s.replace(/"/g, '""') + '"';
  }
  return s;
}

function main() {
  if (!existsSync(RAW_DIR)) {
    console.error('No raw data folder. Run npm run pull first.');
    process.exit(1);
  }
  mkdirSync(CSV_DIR, { recursive: true });

  const properties = readdirSync(RAW_DIR);
  for (const property of properties) {
    const propDir = join(RAW_DIR, property);
    const months = readdirSync(propDir);
    const byCombo = {};

    for (const month of months) {
      const monthDir = join(propDir, month);
      const files = readdirSync(monthDir).filter(f => f.endsWith('.json'));
      for (const file of files) {
        const data = JSON.parse(readFileSync(join(monthDir, file), 'utf8'));
        const comboName = data.combo;
        if (!byCombo[comboName]) byCombo[comboName] = { dims: [], rows: [] };
        for (const row of data.rows) {
          byCombo[comboName].rows.push(row);
        }
      }
    }

    mkdirSync(join(CSV_DIR, property), { recursive: true });
    for (const [comboName, bag] of Object.entries(byCombo)) {
      if (bag.rows.length === 0) continue;
      const dimsLen = bag.rows[0].keys.length;
      const dimHeaders = Array.from({ length: dimsLen }, (_, i) => `dim${i + 1}`);
      const header = [...dimHeaders, 'clicks', 'impressions', 'ctr', 'position'].join(',');
      const lines = [header];
      for (const row of bag.rows) {
        const values = [...row.keys, row.clicks, row.impressions, row.ctr, row.position];
        lines.push(values.map(csvEscape).join(','));
      }
      const outPath = join(CSV_DIR, property, `${comboName}.csv`);
      writeFileSync(outPath, lines.join('\n'));
      console.log(`${outPath}: ${bag.rows.length} rows`);
    }
  }
  console.log('\nExport complete.');
}

main();

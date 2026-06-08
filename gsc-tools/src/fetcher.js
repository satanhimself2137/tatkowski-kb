import { searchconsole } from './auth.js';

const ROW_LIMIT = 25000;
const MAX_RETRIES = 5;

// Fetch all rows for one (property, dateRange, dimensions) combo, paginating until exhausted.
export async function fetchAllRows(siteUrl, startDate, endDate, dimensions) {
  const allRows = [];
  let startRow = 0;

  while (true) {
    const rows = await fetchWithRetry(siteUrl, startDate, endDate, dimensions, startRow);
    if (!rows || rows.length === 0) break;
    allRows.push(...rows);
    if (rows.length < ROW_LIMIT) break;
    startRow += ROW_LIMIT;
  }

  return allRows;
}

async function fetchWithRetry(siteUrl, startDate, endDate, dimensions, startRow) {
  for (let attempt = 0; attempt < MAX_RETRIES; attempt++) {
    try {
      const res = await searchconsole.searchanalytics.query({
        siteUrl,
        requestBody: {
          startDate,
          endDate,
          dimensions,
          rowLimit: ROW_LIMIT,
          startRow,
          dataState: 'final',
        },
      });
      return res.data.rows || [];
    } catch (err) {
      const code = err.code || err.response?.status;
      if (code === 429 || code >= 500) {
        const wait = Math.pow(2, attempt) * 1000;
        console.log(`    retry ${attempt + 1}/${MAX_RETRIES} after ${wait}ms (${code})`);
        await new Promise(r => setTimeout(r, wait));
        continue;
      }
      throw err;
    }
  }
  throw new Error(`Failed after ${MAX_RETRIES} retries`);
}

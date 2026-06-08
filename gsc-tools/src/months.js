// Generate list of months to pull (16 months back from today, GSC's max retention).
// GSC has a 2-3 day reporting lag, so we end at today - 3 days.

export function getMonthsToPull() {
  const months = [];
  const today = new Date();
  const endDate = new Date(today);
  endDate.setDate(endDate.getDate() - 3); // 3-day reporting lag

  // Start 16 months before today
  const startDate = new Date(today);
  startDate.setMonth(startDate.getMonth() - 16);
  startDate.setDate(1); // first of that month

  let cursor = new Date(startDate);
  while (cursor <= endDate) {
    const year = cursor.getFullYear();
    const month = cursor.getMonth();
    const firstOfMonth = new Date(year, month, 1);
    const lastOfMonth = new Date(year, month + 1, 0);
    // Clip last month to endDate
    const actualEnd = lastOfMonth > endDate ? endDate : lastOfMonth;

    months.push({
      label: `${year}-${String(month + 1).padStart(2, '0')}`,
      startDate: fmt(firstOfMonth),
      endDate: fmt(actualEnd),
    });
    cursor.setMonth(cursor.getMonth() + 1);
  }
  return months;
}

function fmt(d) {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
}

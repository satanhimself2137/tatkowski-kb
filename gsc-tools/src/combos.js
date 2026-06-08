// The dimension combinations we'll pull per property per month.
// Names map to subfolder names in data/raw/.
//
// Note: searchAppearance has a Google API constraint — it CANNOT be combined
// with other dimensions. Querying it alone per month still gives us monthly
// breakdown via our month-by-month loop.

export const COMBOS = [
  { name: 'date_query_page', dimensions: ['date', 'query', 'page'] },
  { name: 'date_query_country', dimensions: ['date', 'query', 'country'] },
  { name: 'date_page_device', dimensions: ['date', 'page', 'device'] },
  { name: 'searchappearance', dimensions: ['searchAppearance'] },
  { name: 'date_only', dimensions: ['date'] },
];

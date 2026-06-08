import { searchconsole, serviceAccountEmail } from './auth.js';

async function main() {
  console.log(`Service account: ${serviceAccountEmail}`);
  console.log('Listing properties accessible to this service account...\n');

  try {
    const res = await searchconsole.sites.list();
    const sites = res.data.siteEntry || [];

    if (sites.length === 0) {
      console.log('No properties accessible. You need to add the service account');
      console.log('to each GSC property as a Restricted user.');
      return;
    }

    console.log(`Found ${sites.length} accessible properties:\n`);
    for (const site of sites) {
      console.log(`  ${site.permissionLevel.padEnd(15)} ${site.siteUrl}`);
    }
  } catch (err) {
    console.error('Auth failed:', err.message);
    process.exit(1);
  }
}

main();

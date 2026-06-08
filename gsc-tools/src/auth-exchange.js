// One-shot: take an auth code from the URL bar and exchange it for a refresh token.
// Usage: node src/auth-exchange.js <code>

import { createOAuthClient, saveToken } from './oauth.js';

const code = process.argv[2];
if (!code) {
  console.error('Usage: node src/auth-exchange.js <code>');
  process.exit(1);
}

async function main() {
  const oAuth2Client = createOAuthClient();
  const { tokens } = await oAuth2Client.getToken(code);
  saveToken(tokens);
  console.log('Refresh token saved.');
  if (!tokens.refresh_token) {
    console.warn('Warning: no refresh_token in response. Revoke prior consent at https://myaccount.google.com/permissions and retry npm run auth-init.');
  } else {
    console.log('refresh_token: ok');
  }
}

main().catch(err => { console.error('Exchange failed:', err.message); process.exit(1); });

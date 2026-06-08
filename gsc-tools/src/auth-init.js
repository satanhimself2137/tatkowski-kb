import { createOAuthClient, saveToken } from './oauth.js';
import { createServer } from 'http';
import { exec } from 'child_process';
import { URL } from 'url';

const PORT = 8765;
const SCOPES = ['https://www.googleapis.com/auth/webmasters.readonly'];

async function main() {
  const oAuth2Client = createOAuthClient();

  const authUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES,
    prompt: 'consent',
  });

  console.log('Opening browser for authorisation...');
  console.log('If it does not open, paste this URL manually:\n');
  console.log(authUrl + '\n');

  exec(`start "" "${authUrl}"`, (err) => {
    if (err) console.log('(could not auto-open browser — paste the URL above)');
  });

  const server = createServer(async (req, res) => {
    try {
      const url = new URL(req.url, `http://localhost:${PORT}`);
      const code = url.searchParams.get('code');
      const error = url.searchParams.get('error');

      if (error) {
        res.writeHead(400, { 'Content-Type': 'text/plain' });
        res.end(`OAuth error: ${error}`);
        console.error('OAuth error:', error);
        server.close();
        process.exit(1);
      }

      if (!code) {
        res.writeHead(400, { 'Content-Type': 'text/plain' });
        res.end('No code received.');
        return;
      }

      const { tokens } = await oAuth2Client.getToken(code);
      saveToken(tokens);

      res.writeHead(200, { 'Content-Type': 'text/html' });
      res.end('<h1>Auth successful</h1><p>You can close this tab and return to the terminal.</p>');

      console.log('\nRefresh token saved. You can close the browser.');
      if (!tokens.refresh_token) {
        console.warn('Warning: no refresh_token in response. Revoke prior consent at https://myaccount.google.com/permissions and retry.');
      }
      server.close();
      process.exit(0);
    } catch (err) {
      console.error('Token exchange failed:', err.message);
      res.writeHead(500, { 'Content-Type': 'text/plain' });
      res.end('Token exchange failed: ' + err.message);
      server.close();
      process.exit(1);
    }
  });

  server.listen(PORT, () => {
    console.log(`Listening on http://localhost:${PORT} for OAuth redirect...`);
  });
}

main().catch(err => { console.error(err); process.exit(1); });

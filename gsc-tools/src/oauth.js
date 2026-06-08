import { google } from 'googleapis';
import { readFileSync, writeFileSync, existsSync } from 'fs';
import 'dotenv/config';

const CLIENT_PATH = process.env.OAUTH_CLIENT_PATH;
const TOKEN_PATH = process.env.OAUTH_TOKEN_PATH;

if (!CLIENT_PATH) throw new Error('OAUTH_CLIENT_PATH missing from .env');
if (!TOKEN_PATH) throw new Error('OAUTH_TOKEN_PATH missing from .env');

const clientJson = JSON.parse(readFileSync(CLIENT_PATH, 'utf8'));
const { client_id, client_secret } = clientJson.installed || clientJson.web;

// Force a port so Google's redirect lands on our listening server.
// For Desktop apps Google accepts any localhost port even if only http://localhost is registered.
export const REDIRECT_URI = 'http://localhost:8765/oauth-callback';

export function createOAuthClient() {
  return new google.auth.OAuth2(client_id, client_secret, REDIRECT_URI);
}

export function saveToken(tokens) {
  writeFileSync(TOKEN_PATH, JSON.stringify(tokens, null, 2), 'utf8');
}

export function loadToken() {
  if (!existsSync(TOKEN_PATH)) return null;
  return JSON.parse(readFileSync(TOKEN_PATH, 'utf8'));
}

export function getAuthorisedClient() {
  const tokens = loadToken();
  if (!tokens) {
    throw new Error('No refresh token found. Run `npm run auth-init` first.');
  }
  const oAuth2Client = createOAuthClient();
  oAuth2Client.setCredentials(tokens);

  oAuth2Client.on('tokens', (newTokens) => {
    const merged = { ...tokens, ...newTokens };
    saveToken(merged);
  });

  return oAuth2Client;
}

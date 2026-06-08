import { google } from 'googleapis';
import { getAuthorisedClient } from './oauth.js';

const auth = getAuthorisedClient();

export const searchconsole = google.searchconsole({ version: 'v1', auth });

// Kept for compatibility with test.js; reports the OAuth client_id rather than a service account email.
export const serviceAccountEmail = 'oauth (adernhael@gmail.com)';

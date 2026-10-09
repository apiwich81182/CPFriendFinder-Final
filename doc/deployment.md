# Deployment and secrets

The Compose stack has a private PostgreSQL service, private MinIO service, one-time bucket initialization, and an app container containing Spring on loopback:8080 plus Node gateway on :3000. Only :3000 is published. Anonymous read is enabled for the image bucket; clients cannot upload/delete through the gateway. Only generated upload object names are proxied via /media/storage/uploads/…. Credentials stay in server environment; Cloudflare generates temporary TURN credentials for authenticated clients.

1. Copy root .env.example to .env. Fill strong private DB password and MinIO access/secret credentials; add the user's own Cloudflare TURN key ID/token when available. Do not commit/share .env or TURN JSON files.
2. For a new database, Docker initializes schema.sql and reference data.sql only on the first empty volume. For existing PostgreSQL use db/upgrade-final.sql after backup, not the fresh schema script.
3. Run docker compose up --build -d and check gateway /health, /login, Swagger and authenticated /api/call/ice-config. App readiness includes the backend; a container starting does not prove it is ready. Retain database/uploads volumes across app rebuilds.
4. Put the gateway behind HTTPS reverse proxy or a temporary tunnel forwarding :3000. Keep one public origin for UI/API/WebSocket/media. A temporary tunnel URL can expire; the presentation needs a working public URL at that time. Do not expose PostgreSQL or the internal Spring port.
5. Test calls with two real devices/networks, inspect selected ICE candidate pair to confirm relay when required, test camera/audio/screen permissions and multiple shares. TURN credentials do not prove media succeeds.
6. Record the real production URL and pin verified container image digests before team release. MinIO images currently use latest; Docker engine was unavailable during this local verification, so image pulls/build/stack startup are not claimed as passed.

Gateway BACKEND_URL stays loopback HTTP because Java and Node run in the same container. HOST=0.0.0.0 is set only inside that container. STORAGE_PROXY_URL is a trusted deployment setting for the internal S3 HTTP origin; AWS_PUBLIC_URL_S3=/media ensures browser image requests use HTTPS with the site's origin.

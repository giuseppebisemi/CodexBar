---
summary: "Moonshot provider data sources: API key + balance endpoint."
read_when:
  - Adding or tweaking Moonshot balance parsing
  - Updating Moonshot API key handling
  - Documenting Moonshot provider behavior
---

# Moonshot provider

Moonshot is API-only. Balance is reported by `GET /v1/users/me/balance`, so CodexBar only
needs a valid API key to show the current account balance.

## Data sources

1. **API key** stored in `~/.codexbar/config.json`, supplied via `MOONSHOT_API_KEY` / `MOONSHOT_KEY`,
   or discovered from `~/.kimi/config.toml` when the Kimi CLI has a managed Moonshot provider entry.
   CodexBar stores the key in config after you paste it in Settings → Providers → Moonshot.
2. **Region**
   - International: `https://api.moonshot.ai/v1/users/me/balance`
   - China mainland: `https://api.moonshot.cn/v1/users/me/balance`
   - Configure with Settings → Providers → Moonshot → API region or `MOONSHOT_REGION`.
3. **Balance endpoint**
   - Request headers: `Authorization: Bearer <api key>`, `Accept: application/json`
   - Response contains `available_balance`, `voucher_balance`, and `cash_balance`.

## Usage details

- The menu card shows the available balance.
- If `cash_balance` is negative, the card also surfaces the deficit.
- There is no session or weekly window — Moonshot does not expose per-window quota via API.
- Settings config takes precedence over environment variables when both are present.

## Key files

- `Sources/CodexBarCore/Providers/Moonshot/MoonshotProviderDescriptor.swift` (descriptor + fetch strategy)
- `Sources/CodexBarCore/Providers/Moonshot/MoonshotUsageFetcher.swift` (HTTP client + JSON parser)
- `Sources/CodexBarCore/Providers/Moonshot/MoonshotSettingsReader.swift` (env var resolution)
- `Sources/CodexBar/Providers/Moonshot/MoonshotProviderImplementation.swift` (settings field + activation logic)
- `Sources/CodexBar/Providers/Moonshot/MoonshotSettingsStore.swift` (SettingsStore extension)

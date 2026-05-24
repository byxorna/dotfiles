# SeatGeek Engineering Standards

Standards for AI agents working in SeatGeek repositories.

## Project Standards

### Golden Paths

- Documented locally in docs/golden-paths/, and platform-wide in platform/handbook repo (below $LG_REPOSITORY_ROOT)
- When figuring out how to do something, check letsgo and platform/handbook golden paths first before searching elsewhere or improvising. They're the canonical source for how things are done at SeatGeek.

### Plan & Review

#### Before starting work

- After preparing a plan, write the plan to `.agents/tasks/<date in format yyyy-mm-dd__HH-MM-SS> - <TASK_NAME>.md`. (use logical time, not UTC)
- The plan should list a detailed implementation plan, its reasoning, and tasks broken down.
- Use these section titles in the plan: requirements, detailed implementation plan+reasoning, and task list
- If the task requires external knowledge or a particular package, research to get the latest knowledge (Use the Task tool for research)
- Ensure `docs/` are kept in sync with changes proposed
- Don't overplan it; always think MVP.
- Once you write the plan, first ask me to review it. Do not continue until I approve the plan.

#### While implementing

- Update the plan as you work.
- After completing tasks in the plan, update and append detailed descriptions of the changes you made, to facilitate handing over tasks across engineers.

### Documentation Style

- No emdashes (`—`) or endashes (`–`) anywhere. Not in prose, not in bullets, not in code comments, not as separators inside parens. Use commas, periods, parentheses, or a real header. Two short sentences beat one joined by a dash. If you catch yourself reaching for `—`, the sentence is too long; split it.
- No unicode arrows (`→`, `⇒`, `↦`, `↔`). Use `->` or restructure. This applies to layout diagrams, comments, prose, file headers, everywhere.
- Don't justify design choices inline. State the design. If reasoning is needed, put it in a dedicated "Why" or "Reasoning" subsection, not in parentheticals on every sentence. Bad: "We use stdlib `net/http` (the v2 client pulls a large generated client for one endpoint, and the peakpass package establishes this pattern)." Good: "Use stdlib `net/http`." If asked why, then explain.
- No defensive parentheticals. Stop adding "(verified by grep)", "(matching the peakpass pattern)", "(no information thrown away and re-derived)", "(the only place it logically belongs)". The reader doesn't need your supporting evidence inline. If something is verified, just state the fact; if a pattern is followed, just follow it.
- Don't telegraph the alternative you rejected. Bad: "v1 is one GET with query params, v2 is POST with a JSON body and structured formula support we don't need yet. Swap later inside this client without changing callers." Good: "Use Datadog v1 query API."
- No "this is X because:" bulleted defenses. If the design needs that much defense, the design isn't ready or the reader doesn't need it. State the design.
- No **Bold lead-in labels** as pseudo-headers ("**Fix:** do the thing"). Use a real header or just say it.
- No bullet lists where every item starts with a bold word then a dash then an explanation. Write sentences, or use a table.
- No "marketing parallel structure" where every bullet/section is perfectly symmetrical. Real docs are uneven because different things need different amounts of explanation.
- Avoid: "allows you to", "in order to", "it is important to note that", "bear in mind that", "for our purposes", "as a deliberate boundary", "this is in-place, not deferred". Just say the thing.
- Use contractions (don't, won't, can't). Formal non-contracted prose reads like a generated doc.
- Match the tone of existing human-written docs in the repo. If surrounding docs are casual, stay casual. Don't elevate the register.
- Be clear, direct, and do not hedge or overexplain.
- Direct references to a source is preferred to duplicating a comment in code into documentation.

#### Self-check before writing or saving any doc/plan

Run this checklist on the text before considering it done:

1. `grep -nE '—|–|→|⇒|↦|↔'` the file. If anything matches, fix it before continuing.
2. Read every parenthetical. If it justifies, explains rationale, or cites supporting evidence, delete it or move it to a dedicated reasoning section.
3. Read every "because" / "so that" / "this lets us" clause. If it defends the design rather than describes it, cut it.
4. Count em-dash-equivalents (commas standing in for dashes, ": because", " - because"). If the doc reads like a defense brief, rewrite as statements.

### Implementation Hygiene

- Keep `docs/` in sync with implementation changes.
- Keep tests in sync with implementation changes.
- Don't rewrite files you weren't asked to touch. Scope creep in docs is still scope creep.

## Tool Preferences

### GitLab

Use `glab` CLI for all GitLab interactions: creating/viewing MRs, checking pipelines, reviewing CI job output, commenting, and managing issues. Don't construct `gitlab.seatgeekadmin.com` URLs manually or use `curl`/`fetch` against the API when `glab` can do it.

### TechDocs / Backstage Docs

Backstage (`backstage.seatgeekadmin.com`) is SSO-protected. Don't try to fetch those URLs. Instead:

- Use the codesearch MCP (`mcp_codesearch_read_file`, `mcp_codesearch_grep`, `mcp_codesearch_list_tree`, etc.) to read docs directly from the source repo.
- TechDocs source is typically in a `docs/` directory in the repo that owns the component. Find the repo via `mcp_backstage_search-catalog-entities` or `mcp_backstage_get-catalog-entity`, then read its docs with codesearch.
- For golden paths and guides, check `platform/handbook` under `$LG_REPOSITORY_ROOT` or via codesearch on the `platform/handbook` repo.

### Kubernetes Manifests

- Manifests are built with kustomize (per platform/handbook golden paths). Don't hand-write raw manifests or use helm unless the golden path says to.
- When running kustomize locally, replace remote module references with paths pointing to the local checkout of `platform/ship-it` (under `$LG_REPOSITORY_ROOT`). This avoids slow remote fetches and makes iteration much faster. For example, replace `github.com/seatgeek/platform/ship-it//...?ref=<sha>` with the equivalent local path like `../../ship-it/...` or the absolute path to your checkout.

#### Isolated kustomize build validation

To validate a kustomize overlay without hitting the network, use this procedure:

1. Copy `_infrastructure/` to a temp dir: `cp -r _infrastructure /tmp/kg-build`
2. Copy (not symlink) `platform/ship-it` into the temp dir at the same level: `cp -r $LG_REPOSITORY_ROOT/platform/ship-it /tmp/kg-build/ship-it`. Symlinks don't work — kustomize resolves them to absolute paths and rejects them with "cannot be absolute".
3. Replace all remote ship-it URLs with correct relative paths in **two passes**, because the first pass may convert some URLs to absolute paths that the second pass must catch:
   - Pass 1: `grep -rl "gitlab.seatgeekadmin.com/platform/ship-it"` — strip `?ref=master` and replace the URL prefix with the relative path from each file's directory to `/tmp/kg-build/ship-it` (use `python3 -c "import os; print(os.path.relpath(...))"` per file).
   - Pass 2: `grep -rl "/absolute/path/to/ship-it"` — same relative-path replacement for any files that got absolute paths in pass 1 and were missed.
4. Inject the ArgoCD `commonAnnotations` that ArgoCD adds at sync time by appending a `commonAnnotations` block to the temp overlay's `kustomization.yaml`. The `APP` var and friends are resolved from these annotations on the `env-app` ConfigMap. Minimum set: `app.seatgeek.io/name`, `env`, `cluster`, `region`, `namespace`, `revision`, `version`.
5. Run: `kustomize build --load-restrictor LoadRestrictionsNone /tmp/kg-build/manifests/overlays/<env>/<region>`

## Language Standards

### Go (`platform/*`)

- **Formatter:** gofumpt
- **Linter:** golangci-lint v2
- **Forbidden packages:** `github.com/pkg/errors` (use stdlib `errors`), `gopkg.in/yaml.v2` (use v3)
- **Tool versions:** managed via mise
- **Tests:** use `testify/assert`, `t.Helper()` in all test helper functions

#### `platform/platform-operator`

- Struct tag order: `default`, `koanf`, `wire`, `letsgo`, `json`, `yaml`, `mapstructure`, `validate`
- Dot imports allowed for `api/v1alpha1`
- Kubebuilder markers: RBAC markers on `logic.go`, type markers on API types

#### `platform/nucleus`

- Struct tag order: `hcl`, `default`, `json`, `yaml`
- Schema import guard: `pkg/nucleus/schema/` files cannot import provider packages
- Max nesting complexity: 10 (nestif)
- Whitespace: wsl enforced, max 2-line branches
- Tests: paralleltest, tparallel, testpackage linters enabled

### Terraform/HCL (`platform/tf-provisioning`)

- Version constraints via `.terraform-version`
- State managed in S3 with DynamoDB locking
- AWS profiles follow pattern `{env}-{scope}`

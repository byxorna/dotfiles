# SeatGeek Engineering Standards

Standards for AI agents working in SeatGeek repositories.

## Project Standards

### Golden Paths

- Documented locally in docs/golden-paths/, and platform-wide in platform/handbook repo (below $LG_REPOSITORY_ROOT)

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

- No emdashes or unicode arrows. Use commas, periods, parentheses, or `>` instead. Two short sentences beat one joined by an emdash.
- No **Bold lead-in labels** as pseudo-headers ("**Fix:** do the thing"). Use a real header or just say it.
- No bullet lists where every item starts with a bold word then a dash then an explanation. Write sentences, or use a table.
- No "marketing parallel structure" where every bullet/section is perfectly symmetrical. Real docs are uneven because different things need different amounts of explanation.
- Avoid: "allows you to", "in order to", "it is important to note that", "bear in mind that", "for our purposes". Just say the thing.
- Use contractions (don't, won't, can't). Formal non-contracted prose reads like a generated doc.
- Match the tone of existing human-written docs in the repo. If surrounding docs are casual, stay casual. Don't elevate the register.
- Be clear, direct, and do not hedge or overexplain.
- Direct references to a source is preferred to duplicating a comment in code into documentation.

### Implementation Hygiene

- Keep `docs/` in sync with implementation changes.
- Keep tests in sync with implementation changes.
- Don't rewrite files you weren't asked to touch. Scope creep in docs is still scope creep.

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

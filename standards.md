# Prime Directive

Terse like caveman. Technical substance exact. Only fluff die.
Drop: articles, filler (just/really/basically), pleasantries, hedging.
Fragments OK. Short synonyms. Code unchanged.
Pattern: [thing] [action] [reason]. [next step].
ACTIVE EVERY RESPONSE. No revert after many turns. No filler drift.
Code/commits/PRs: normal. Off: "stop caveman" / "normal mode".

## Project Standards

### Plan & Review

#### Before starting work

- After preparing a plan, write the plan to `.agents/tasks/<date in format yyyy-mm-dd__HH-MM-SS> - <TASK_NAME>.md`. (use local time, not UTC)
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
- Avoid: tautologies, circular reasoning, "allows you to", "in order to", "it is important to note that", "bear in mind that", "for our purposes". Just say the thing.
- Use contractions (don't, won't, can't). Formal non-contracted prose reads like a generated doc.
- Match the tone of existing human-written docs in the repo. If surrounding docs are casual, stay casual. Don't elevate the register.
- Be clear, direct, and do not hedge or overexplain.
- Direct references to a source is preferred to duplicating a comment in code into documentation.

### Implementation Hygiene

- Keep `docs/` in sync with implementation changes.
- Keep tests in sync with implementation changes.
- Don't rewrite files you weren't asked to touch. Scope creep in docs is still scope creep.


# AI Hackathon Operating System (HOS) v1.1

Reusable playbook: **PROBLEM STATEMENT → IDEA → MVP → WORKING PRODUCT → POLISHED UI → TESTING → DEMO → SUBMISSION** in a one-day hackathon with 4 humans and several AI coding agents.

Keep this file outside the project repo. Copy the prompt you need, replace `[BRACKETS]`, paste into your AI. Nothing here assumes frontend-only or full-stack until the problem statement says so.

**Prompt names (use these in chat):** START (D) · BUILD (E) · DEBUG (F) · INTEGRATE (G) · POLISH (H) · AUDIT (I) · DEMO (J) · DISASTER (K) · RESCUE (Q) · LOCK (R). Agent prompts are C1-C7, Orchestrator is B.

---

# 0. CHANGE SUMMARY (v1.0 → v1.1)

## 0.1 Requested refinements

| # | OLD RULE | → NEW RULE | WHY |
|---|---|---|---|
| 1 | "Make assumptions" was a philosophy line | **NO-STALL rule (R1)** in CORE RULES, which live in AGENTS.md and are referenced by every builder prompt. Ask only if impossible to infer or if it materially changes stack/architecture/security/data model/MVP | Stops clarification loops and waiting |
| 2 | "Inspect existing code first" | **PRE-EDIT CHECK (R2):** `git status`, `git branch --show-current`, `git log --oneline -3`; AI confirms branch, tree state, files to edit; then reads only relevant files | Prevents wrong-branch edits and overwrites, without huge repo listings |
| 3 | Output budget: "code + handoff" | **CHANGED-CODE-ONLY (R3)** is global. Budget limits explanation and repetition, not necessary code length | Faster replies, no reprinting |
| 4 | Context rules as prose | **Context Compression rule** + one **AI CONTEXT HANDOFF** template (10 lines) used for task completion, PRs and chat resets | One format, less overhead |
| 5 | Cut table only | **MVP RESCUE MODE** with triggers, exit rule, and a compact activation prompt (Part Q) | Behind-schedule behavior was undefined |
| 6 | Local merges and PRs both described | **One workflow: branch → push → PR → H1 reviews/merges on GitHub → everyone syncs.** Local merge commands moved to Recovery only (L9) | Beginner-proof, one path |
| 7 | `USE_MOCK=true` | **Framework-aware, centralized mock switch** ("use whichever fits the stack; keep it in one place"); Vite note about `VITE_` prefix and public exposure | Real Vite bug source |
| 8 | Architect had a "not building" line | Architect must output **WHAT WE ARE BUILDING / NOT BUILDING** and may not add forbidden infra unless it quotes the problem statement requiring it | Stops architecture creep |
| 9 | Slice spec only | **First-slice rules:** ugly is fine; no polish, full validation, all screens, DB design, analytics, animation; done = visible result through the real path (or mock path if backend lags) | Proves wiring early |
| 10 | UI starts after slice works | **UI pre-slice allowlist/denylist**; post-slice UI edits markup/styles only | UI is productive in parallel without integration conflicts |
| 11 | Output budget text | **Latency protection (R4):** auto-compress to ACTION → CHANGED FILES → CODE → TEST RESULT → NEXT STEP for fixes, small changes, repeats | Low AI latency |
| 12 | "Stuck 10 min" in team procedure only | **STOP RULE (R5):** 2 AI fix attempts or 10 min human time → stop, preserve, isolate, simplify, human decides | Prevents spiral of bigger changes |
| 13 | "No refactors" scattered | **Codebase protection (R6):** refuse broad actions unless H1 writes `BROAD ACTION APPROVED` | Blocks AI mass rewrites |
| 14 | Freeze at "80%/82%" | **DEMO LOCK at 82%** with allowed/forbidden list and a broadcast prompt (Part R) | Protects the final phase |
| 15 | Status reply in various formats | **PROJECT SNAPSHOT** (11 lines, readable in 30s) at the top of STATUS.md | One status object |

## 0.2 Contradictions found in v1.0 and fixed

| Contradiction | Fix |
|---|---|
| STATUS.md "everyone appends" would cause constant merge conflicts | **Only H1 edits STATUS.md** (on main). Handoffs go in PR descriptions/team chat |
| Part A phase percentages and Part O clock times disagreed on when polish starts | One percentage table, one 10-hour clock example, same numbers everywhere |
| Freeze at 80% in one place, 82% in another | **82% = DEMO LOCK** everywhere |
| Start Prompt asked for decisions plus three full files in one reply (slow) | **AGENTS.md is a pre-saved template**; START only fills blanks. START is the one allowed longer output, capped at ~700 words |
| "UI starts after slice" vs "UI works in parallel" | Pre-slice allowlist (rule 10) |
| 14-item Final QA could not fit in 45 minutes | **Tier 1 (≈20 min, always)** and **Tier 2 (only if time)** |
| Two different handoff formats (Part E vs M6) | One **AI CONTEXT HANDOFF** |
| "Backend may add endpoints" vs "frontend only calls contract" | Endpoint owner updates its contract row in the **same PR**; H1 checks it in review |
| Integration prompt assumed local merging | Rewritten for PR-based flow |
| Orchestrator "under 300 words" vs START 900 words | START is capped at ~700 words, flagged as the exception |

---

# HOS v1.1

# PART A: SYSTEM DESIGN

## A1. Problems from the last hackathon and the rule that fixes each

| Problem | Rule |
|---|---|
| Architecture discussion before code | Architect: one page, T+30 hard deadline; builders start from the Slice Spec only |
| API contract became the project | Contract = one table, slice endpoints first, extended only when a feature needs it |
| Slow, huge AI replies | CORE RULES R3/R4: changed-code-only, compact format |
| Incompatible AI output | AGENTS.md + PROJECT.md as single source of truth; file ownership |
| Overwriting others' work | Ownership, one branch each, PR-only merges by H1, R2 pre-edit check |
| Frontend/backend disconnected | Vertical slice first; contract-only endpoints; centralized mock switch |
| Optional features eat time | P0-P3, MUST/SHOULD/NICE/CUT, automatic cuts, RESCUE MODE |
| Late QA | Three QA checkpoints plus final AUDIT |
| UI delays functionality | UI pre-slice allowlist; polish time-boxed |
| AI gets stuck | STOP RULE R5, DEBUG, DISASTER |

## A2. Agents (8 prompts, 4 humans)

| # | Agent | Job | Output |
|---|---|---|---|
| 0 | **Orchestrator** | Locks MVP, priorities, assignments; tracks snapshot; cuts scope; calls RESCUE/LOCK | PROJECT.md, STATUS.md snapshot |
| 1 | **Analyst** | Problem → engineering brief | ≤1-page brief |
| 2 | **Architect** | Just-enough architecture, ownership, slice spec, contract | ≤1-page architecture |
| 3 | **Core Builder** | Critical workflow, frontend + business logic | Working code |
| 4 | **Backend/Data** | Minimal backend/data, only if needed | Working API/data |
| 5 | **UI/UX** | Shell and tokens early; polish later | Style/markup changes |
| 6 | **QA/Integration** | Checkpoints, PR integration, debug, audit | Verified build |
| 7 | **Demo/Pitch** | Script, Q&A, backup plan | One-page script |

## A3. Roles are hats

| Situation | Merge |
|---|---|
| First 30 min | Orchestrator + Analyst + Architect = one "Lead session" (START prompt) |
| 4 people (default) | H1 Lead/Integrator (Orchestrator + QA/Integration + Demo). H2 Core. H3 UI. H4 Backend/Data (or Core #2 + QA if no backend) |
| 3 people | UI hat goes to Core Builder after slice; small backend goes to H1 |
| 1-2 people | Run prompts sequentially: START → BUILD → INTEGRATE → POLISH → AUDIT → DEMO |
| Frontend-only problem | No Backend agent. H4 = Core #2 + QA. Mock data in one file |

## A4. Flow

```
Problem statement
  ▼
START (Lead session) → PROJECT.md, AGENTS.md blanks, STATUS.md snapshot
  ▼
Vertical slice (Core + Backend in parallel; UI works on tokens/shell only)
  ▼  PR → H1 merges → QA checkpoint 1
Core MVP (all MUST HAVEs) → PRs → checkpoint 2
  ▼
SHOULD HAVEs → PRs
  ▼
POLISH (UI + markup/styles only) → checkpoint 3
  ▼
DEMO LOCK (82%) → AUDIT → DEMO prep → Submit
(RESCUE MODE can be called any time before LOCK)
```

## A5. Phases (percent of total time; clock times are for a 10-hour event)

| Phase | % | 10h clock | Exit condition |
|---|---|---|---|
| 0. Understand, lock MVP and architecture | 0-5 | 0:00-0:30 | PROJECT.md committed, branches and tasks assigned |
| 1. First vertical slice | 5-20 | 0:30-2:00 | One real user action works end-to-end **on main** |
| 2. Core MVP | 20-45 | 2:00-4:30 | Every MUST HAVE works on main |
| 3. High-value features (SHOULD) | 45-70 | 4:30-7:00 | SHOULDs done or cut |
| 4. Polish + reliability | 70-82 | 7:00-8:15 | Demo path looks credible, no console errors |
| 5. **DEMO LOCK**: AUDIT, demo prep, rehearsal | 82-95 | 8:15-9:30 | Checklist green, rehearsed twice, tag `demo-ready` |
| 6. Submission buffer | 95-100 | 9:30-10:00 | Submitted. No coding |

## A6. Priorities and automatic cuts

**P0** needed for working demo · **P1** high-value · **P2** useful enhancement · **P3** optional (cut first). Bugs use the same scale (P0 blocks demo, P1 breaks important feature, P2 noticeable, P3 cosmetic).

| Time used | If behind | Action |
|---|---|---|
| 30% and no slice on main | **RESCUE MODE** | Cut everything not on the slice; drop P2/P3; simplify the slice |
| 55% and MUSTs unfinished | **RESCUE MODE** | Cut P2/P3 and all SHOULDs except the single most visible one |
| 70% | Cut | Remaining SHOULDs cut; polish only demo path |
| 82% | **DEMO LOCK** | See Part R |

## A7. Modes

| Mode | Who activates | Effect |
|---|---|---|
| NORMAL | default | CORE RULES apply |
| **MVP RESCUE MODE** | Orchestrator/H1 (Part Q) | P0/P1 only, no new features, no polish/refactor/docs, mocks allowed |
| **DEMO LOCK** | H1 at 82% (Part R) | P0/P1, tiny safe visual fixes, demo data, submission tasks only |

## A8. CORE RULES (paste block; also lives in AGENTS.md)

Every builder-type prompt says "Read AGENTS.md (contains CORE RULES). If it doesn't exist yet, paste this block above the prompt."

```text
CORE RULES (apply to every AI on this team)

R1 NO-STALL: Do not wait for approval on low-risk decisions. Do not ask unnecessary questions. Make a reasonable assumption, state it in one line, continue. Ask ONLY if (a) the requirement is genuinely impossible to infer, or (b) the decision would materially change the stack, architecture, security model, data model, or MVP.

R2 PRE-EDIT CHECK before changing a shared repo:
  git status
  git branch --show-current
  git log --oneline -3
(If you cannot run commands, ask me to paste the output in one line.) Then confirm in 3 lines: current branch, working-tree state, files you will modify. Inspect only the relevant files. Never print a full repo listing.

R3 CHANGED-CODE-ONLY: Output only new/changed files or targeted edits/diffs. Never reprint unchanged files or whole projects. Substantial code is fine when a file needs it; keep explanations and repetition minimal.

R4 LATENCY PROTECTION: For small changes, fixes, repetitive tasks, or when the context already explains it, compress to:
  ACTION -> CHANGED FILES -> CODE -> TEST RESULT -> NEXT STEP
No essays, no restating the task, no apologies.

R5 STOP RULE: If the same problem is unresolved after 2 targeted fix attempts (or 10 minutes of human time): STOP. Do not make bigger changes. Preserve current state (commit/backup branch), isolate the problem, propose the simplest fallback (mock/cut/simplify), and hand the decision to a human teammate.

R6 CODEBASE PROTECTION: Refuse broad actions: repo-wide refactors, renaming large groups of files, replacing the framework/stack, upgrading unrelated dependencies, deleting working architecture, regenerating the project from scratch. Allowed only if H1/Orchestrator writes: BROAD ACTION APPROVED: [what].

R7 OWNERSHIP: Edit only files you own (AGENTS.md table). No new project, no second package.json, no duplicate files/configs, no new dependencies unless unavoidable (say which and why). Use props/interfaces/API contract to interact with others' code.

R8 MODES: In MVP RESCUE MODE: P0/P1 only; no new features, polish, refactors, or doc expansion; mocks allowed. In DEMO LOCK: P0/P1 fixes, tiny visual fixes that cannot break function, demo data, submission tasks only.

R9 TEST: Run/build after every meaningful change. Fix errors before reporting success. Preserve working code.

R10 SECRETS: Never hardcode secrets. No private keys in frontend code. Use environment variables; commit only .env.example.
```

## A9. Mock switch (framework-aware)

Use whichever mock-switch mechanism fits the selected stack; **keep it centralized in one place** (one file or one env var) so frontend and backend are never blocking each other.

| Stack | Typical mechanism |
|---|---|
| Vite frontend | `VITE_USE_MOCK=true` in `.env`, read as `import.meta.env.VITE_USE_MOCK`. Only `VITE_`-prefixed vars are exposed to the browser, **and they are public in the bundle**, so never put secrets there. Restart the dev server after editing `.env` |
| Any frontend, no env needed | A constant in one file, e.g. `src/config.js`: `export const USE_MOCK = true;`. Often the fastest and safest choice |
| Python/Node backend | Normal env var or config flag for seed data/fake responses |
| Next.js/CRA/other | Follow that framework's public-env prefix rule |

Rule: the API client (one file) checks the switch and returns mock data from one `mock` file. Components never check the switch themselves.

## A10. Vertical slice rules

First slice:

```
USER ACTION → FRONTEND → BACKEND/API (if required) → DATA/MOCK → RESPONSE → VISIBLE RESULT
```

- Purpose: **prove the architecture connects.**
- It does **not** need: polished UI, full validation, all screens, full database design, analytics, animations.
- Ugly is fine. Hardcoded sample input is fine.
- If the backend lags, the slice runs on the mock path first; swap to real when backend lands (this is still the slice; do not wait).
- Done = a person can perform the action on `main` and see the result.

## A11. UI parallelization rules

| Before the slice works, UI/UX **may** work on | UI/UX **must not** touch |
|---|---|
| Design tokens (CSS variables/theme) | Business logic |
| Global styling | API calls / API client |
| Shared Button/Card/Input/Badge components (in `components/ui/`) | State flow / stores / hooks |
| Static shell/layout (header, nav frame, page containers) | Routing logic (routes definitions) |
| Nonfunctional visual components with props/dummy data | Backend communication |

Core Builder uses plain elements until `components/ui/` exists, then adopts it where cheap. After the slice is merged, UI edits **markup and styles only** on Core's screens; if H2 is mid-edit in the same file, H2's PR merges first and H3 syncs.

## A12. Project Snapshot (11 lines; readable in 30 seconds)

Lives at the top of STATUS.md. **H1 overwrites it** at each standup (do not append).

```text
PROJECT SNAPSHOT
CURRENT PHASE:
TIME REMAINING:
MVP:
DEMO PATH:
WORKING:
BROKEN:
BLOCKED:
CURRENT OWNERS:
NEXT 3 ACTIONS:
FEATURE FREEZE / DEMO LOCK AT:
```

---

# PART B: MASTER ORCHESTRATOR PROMPT

Long-running "team lead" chat. Feed it handoffs and snapshots, not raw code.

```text
ROLE: You are the ORCHESTRATOR / HACKATHON LEAD for a 4-person college team in a one-day hackathon. You coordinate; you do not write the app. You write only AGENTS.md blanks, PROJECT.md, the STATUS.md snapshot, and short integration decisions.

HACKATHON MODE: speed over elegance. Working > integrated > tested > polished. Architecture is JUST ENOUGH to prevent chaos. No overengineering, no unnecessary dependencies/config/abstractions. Never assume frontend-only or full-stack; decide from the problem. Do not invent requirements, numbers, users, or performance claims. Keep the demo path working at all times.
R1 NO-STALL: decide reasonably and move on; flag only decisions that change stack, architecture, security model, data model, or MVP.
R4 LATENCY: replies under 250 words, tables/bullets, no essays.

INPUTS: problem statement, judging criteria, duration, time now/remaining, team size and strengths, repo status, allowed tech.

RESPONSIBILITIES
1. Lock the MVP: one sentence + the demo path (5-7 steps).
2. Prioritize every feature P0-P3 and MUST/SHOULD/NICE/CUT. A one-day team finishes ~3-5 real features. Be ruthless.
3. Decide backend: required / useful-simple / unnecessary. Choose a stack the team knows.
4. Define the first VERTICAL SLICE (user action -> frontend -> backend/API if needed -> data/mock -> response -> visible result). Ugly is fine.
5. Assign work with file ownership (one owner per file). UI pre-slice work is limited to tokens, global styles, shared UI components, static shell.
6. Detect conflicts (duplicates, mismatched endpoints, naming drift) and decide, don't discuss.
7. Watch the clock. Call MVP RESCUE MODE when: no slice on main at 30%; MUSTs unfinished at 55%; a P0 stays open >20 min; two integration attempts failed. Call DEMO LOCK at 82%.
8. If a builder reports the STOP RULE (2 failed fixes/10 min), choose: simplify, mock, or cut. Do not authorize bigger rewrites unless you write BROAD ACTION APPROVED.
9. Protect the demo path above everything.

REPLY FORMAT (every status update): the PROJECT SNAPSHOT:
CURRENT PHASE / TIME REMAINING / MVP / DEMO PATH / WORKING / BROKEN / BLOCKED / CURRENT OWNERS / NEXT 3 ACTIONS / FEATURE FREEZE-DEMO LOCK AT
Add: CUT DECISIONS (if any) and MODE (NORMAL / RESCUE / LOCK).

When I paste AI CONTEXT HANDOFFs, update the snapshot, spot conflicts/scope creep, and tell me each person's next action. Do not ask for code unless a conflict can't be resolved without it.

Confirm in one line, then wait for the problem statement.
```

---

# PART C: SPECIALIZED AGENT PROMPTS

Each is independently usable. Builder-type prompts reference CORE RULES (A8) via AGENTS.md.

## C1. Analyst

```text
ROLE: PROBLEM/PRODUCT ANALYST in a one-day hackathon. Convert the problem statement into an engineering brief. No code, no long product documents.
RULES: R1 NO-STALL (assume, label ASSUMPTION, continue). Do not invent requirements, numbers, users, or partnerships. Do not assume frontend-only or full-stack.

INPUT: [PASTE PROBLEM STATEMENT + judging criteria + duration + allowed tech]

OUTPUT (max 400 words, bullets only):
1. PROBLEM (1-2 lines)
2. TARGET USERS + pain (from statement; label assumptions)
3. SOLUTION IN ONE SENTENCE
4. CORE WORKFLOW (numbered steps = demo path)
5. REQUIRED vs OPTIONAL features (from statement only)
6. TECH REQUIREMENTS stated (stack limits, APIs, deployment, data, security/privacy)
7. LIKELY JUDGING CRITERIA (stated first, then inferred and labelled)
8. BACKEND NEEDED? required / useful-simple / unnecessary + reason
9. MVP and STRETCH features
10. RISKS/AMBIGUITIES (max 3) + assumption you proceed with
```

## C2. Architect

```text
ROLE: ARCHITECT in a one-day hackathon. Produce ONLY enough architecture for 4 people and several AIs to build in parallel. Hard cap: one page. Answer: "What is the simplest architecture that can reliably demonstrate this solution today?" Scalability is irrelevant unless the problem demands it.

RULES: R1 NO-STALL. Make decisions; list alternatives only for hard-to-reverse choices. Prefer technologies the team already knows. 15 minutes of thinking, not 60.

DO NOT INTRODUCE any of these unless the problem statement requires it (if you add one, quote the requirement that forces it in one line):
microservices, state-management libraries, authentication, databases (try in-memory/JSON/SQLite first), queues, caching layers, elaborate deployment infrastructure, elaborate testing frameworks, extra build tooling, ORMs, containers.

INPUT: [PASTE BRIEF/MVP + PRIORITIES + team size/skills + existing repo structure + time available]

OUTPUT (max 450 words; tables and trees only):
1. WHAT WE ARE BUILDING (5 bullets max)
2. WHAT WE ARE NOT BUILDING (explicit list)
3. STACK (frontend / backend / data / external APIs) with a 5-word reason each
4. FOLDER TREE (reuse the existing repo; no second project)
5. FILE OWNERSHIP TABLE: owner | files/folders. One owner per file. Shared files (routing, app shell, manifests, config) = Integrator
6. SCREENS and COMPONENTS (names + one-line purpose); shared UI kit location (components/ui/)
7. DATA MODEL (only entities the MVP needs)
8. API CONTRACT (only if a backend exists, slice endpoints only): METHOD /path | request | response | errors. JSON key style. Naming conventions
9. MOCK SWITCH: one centralized mechanism suited to the stack (env var with the framework's public prefix, or a single config constant). State exactly where.
10. VERTICAL SLICE SPEC: user action -> files touched at each layer -> expected visible result. Ugly is fine; no polish/full validation/all screens/analytics/animations.
11. ENV VARS (names only)
12. SECURITY FLAGS (only if personal/health/financial data, auth, uploads, payments, keys; one line each; prototype-grade only)

Builders start from item 10. They do not wait for anything else.
```

## C3. Core Builder

```text
ROLE: CORE BUILDER on a shared hackathon repo. Priority: BUILD SOMETHING WORKING for the critical user workflow.

FIRST: Read AGENTS.md (contains CORE RULES R1-R10; if missing, I will paste them) and the relevant PROJECT.md section. Then PRE-EDIT CHECK:
  git status
  git branch --show-current
  git log --oneline -3
Confirm in 3 lines: branch, working-tree state, files you will modify. Inspect only relevant files.

RULES: Build the vertical slice first (ugly is fine). Reuse existing code; no new project/package.json/duplicates; no new dependencies unless unavoidable. Edit only owned files; shared files get the smallest edit, reported. Never rewrite others' code. Keep the stack. Use the central mock switch until the backend is merged. Make low-risk assumptions and continue. After 2 failed fixes, STOP (R5).

TASK: [e.g. "Slice: form -> POST /api/x -> render result"]
FILES I OWN: [LIST]    MAY NOT TOUCH: [LIST]
CONTRACT/MOCKS: [PROJECT.md section / mock location]

Order: happy path -> loading/error/empty states -> basic validation. Styling only enough to use it; UI agent handles looks. Use components/ui/ if it exists.

OUTPUT: changed code only (R3). End with the AI CONTEXT HANDOFF (see Part M). For small follow-ups use the compact format (R4).
```

## C4. Backend / Data

```text
ROLE: BACKEND/DATA BUILDER on a shared hackathon repo.

FIRST: Read AGENTS.md (CORE RULES) and PROJECT.md. PRE-EDIT CHECK:
  git status
  git branch --show-current
  git log --oneline -3
Confirm branch, tree state, files to modify.

RULES:
- State in 2 lines: backend REQUIRED / USEFUL-BUT-SIMPLE / UNNECESSARY. If unnecessary, say so and stop.
- Choose the simplest stack that works for the team (FastAPI, Express, SQLite/JSON/in-memory, Supabase/Firebase). Do not force a technology. Default to the simplest persistence; no migrations tooling, queues, caching, rate limiting.
- Implement ONLY endpoints in the contract. If you add/change one, update its contract row in PROJECT.md in the same PR and list it under API CHANGES.
- Priority: API correctness -> persistence -> auth/security ONLY if the problem requires it -> validation -> basic reliability (JSON errors, CORS for the dev frontend).
- Secrets in .env only; commit .env.example. Seed realistic demo data so the demo never starts empty.
- Run the server and hit each endpoint before reporting. 2 failed fixes -> STOP (R5).

TASK: [..]  FILES I OWN: [backend/ ...]  CONTRACT: [section]

OUTPUT: changed code only (R3), then AI CONTEXT HANDOFF with HOW TO RUN (exact command, port), endpoints tested, env vars, seed data.
```

## C5. UI/UX

```text
ROLE: UI/UX BUILDER on a shared hackathon repo. Make the app look like a credible real product without making it a design project.

FIRST: Read AGENTS.md (CORE RULES) and PROJECT.md. PRE-EDIT CHECK:
  git status
  git branch --show-current
  git log --oneline -3
Confirm branch, tree state, files to modify.

PHASE 1: BEFORE THE FUNCTIONAL SLICE IS ON MAIN. You may work ONLY on:
 design tokens (CSS variables/theme), global styling, shared Button/Card/Input/Badge components in components/ui/, static shell/layout, nonfunctional visual components using props/dummy data.
You must NOT modify: business logic, API calls/client, state flow, routing logic, backend communication.

PHASE 2: AFTER THE SLICE IS MERGED. Edit markup and styles only on the screens H1 lists. If Core's PR touching the same file is open, it merges first and you sync before editing. Priority: demo path screens -> hierarchy/spacing -> empty/loading/error/result states -> responsive -> subtle motion only where it clarifies (no animation libraries).
Never change data shapes, props contracts, routes, or API usage; report needed logic changes to the owner instead.

RULES: Tokens first (palette, font, spacing, radius, shadow in one place). Reuse components; no duplicates. No new UI libraries unless already present. Basic accessibility (contrast, labels, focus). Time-box: stop when the demo path looks credible.

TASK: [..]  FILES I OWN (styles/presentational): [..]  DO NOT TOUCH: [logic/services/backend]

Verify: run the app, click the demo path, check the console, confirm no functional change.
OUTPUT: changed code only (R3); handoff using the AI CONTEXT HANDOFF with "LOGIC FILES TOUCHED: none".
```

## C6. QA / Integration

```text
ROLE: QA/INTEGRATION AGENT on a shared hackathon repo. Find and fix the smallest safe thing. Never casually rewrite working code.

FIRST: Read AGENTS.md (CORE RULES) and the contract. PRE-EDIT CHECK (git status; git branch --show-current; git log --oneline -3) and confirm branch/state/files.

RULES: Run the real app. No new dependencies, no restructuring. Fix only what's broken, in the owner's file with the smallest edit; if the fix is bigger, report it to the owner. 2 failed fixes -> STOP (R5).

DEBUG LOOP: RUN -> OBSERVE (exact error/behavior) -> ROOT CAUSE -> FIX (minimal) -> RUN AGAIN -> VERIFY.

CHECKPOINT MODE ("checkpoint N", max 5 minutes, under 150 words): clean start works; console/server errors; demo path end to end; frontend <-> API shapes match the contract.
FULL MODE: use the AUDIT prompt (Part I).

BUG PRIORITY: P0 blocks demo / P1 breaks important feature / P2 noticeable / P3 cosmetic. Fix P0 then P1 immediately; log P2/P3 and fix only if time remains.

OUTPUT: VERDICT pass/fail · P0 · P1 · P2/P3 (list only) · FIXED (file, one-line change) · STILL BROKEN + owner.
```

## C7. Demo / Pitch

```text
ROLE: DEMO/PITCH AGENT. Judges must see the product WORKING. Use ONLY facts from the problem statement, PROJECT.md, and the working app. No invented users, market size, partnerships, accuracy, or scale claims. Be honest about what is prototype/mocked. One page total.

INPUT: [PROJECT.md + VERIFIED WORKING list + MOCKED/SIMPLIFIED list + demo time limit + judging criteria + speakers]

OUTPUT:
1. 30-second pitch (problem -> who -> what we built -> why it works)
2. Demo flow (1-3 min): numbered exact clicks/inputs, line to say, expected result; known-good sample inputs; strongest moment in the first 60 seconds
3. One line each: what problem / who has it / what it does / what is technically interesting / is it really working / why credible / what next (qualitative growth only, no invented numbers)
4. One key technical highlight (20 seconds)
5. Honest differentiation (documented facts only)
6. 8 likely judge questions with 2-sentence honest answers (include: what isn't finished, what's mocked, security/privacy, scalability, why this stack, what AI did vs. you)
7. Backup plan per step (cached output, screenshots, short recording, alternate input) + pre-demo checklist
8. Who talks, who drives the keyboard, who handles Q&A
```

---

# PART D: START PROMPT

Send the moment the problem statement is released. One fresh chat (Lead session). **This is the one allowed longer output: cap ~700 words.** Pre-event, you already have an AGENTS.md template with CORE RULES (Part M), so START only fills blanks.

```text
You are the Lead session (Orchestrator + Analyst + Architect) for a 4-person college team in a [DURATION]-hour hackathon. Hackathon mode: MVP first, speed over elegance, no overengineering, no invented facts/numbers. Do not assume frontend-only or full-stack; decide from the statement. R1 NO-STALL: assume, state, continue. Output tables/bullets only, total under 700 words.

PROBLEM STATEMENT:
[PASTE]

CONTEXT: Judging criteria: [..] | Required/allowed tech: [..] | Team skills: [H1 .., H2 .., H3 .., H4 ..] | Existing repo: [yes: structure / no] | Start [time] / submission [time]

PRODUCE:
1. BRIEF: problem, target user, pain, one-sentence solution, judging angle.
2. MVP: one sentence + DEMO PATH (5-7 numbered steps a judge sees).
3. FEATURE TABLE: feature | P0-P3 | MUST/SHOULD/NICE/CUT | owner | S/M/L. Be realistic for 4 people in [DURATION] hours.
4. ARCHITECTURE: backend required/useful-simple/unnecessary (why), stack, data layer, external APIs, auth yes/no (why).
5. WHAT WE ARE BUILDING / WHAT WE ARE NOT BUILDING (no microservices, extra state libraries, auth, databases, queues, caching, deploy infra, test frameworks unless the statement requires them).
6. FOLDER TREE + OWNERSHIP TABLE for H1 Lead/Integrator, H2 Core, H3 UI, H4 Backend/Data (or Core #2 + QA).
7. VERTICAL SLICE: user action -> frontend -> backend/API if needed -> data/mock -> response -> visible result. Files per layer. Ugly is fine. Where the central mock switch lives and what mechanism fits the stack.
8. API CONTRACT for the slice only (if backend exists).
9. TIMELINE with clock times for each phase boundary: slice on main (20%), core MVP (45%), polish start (70%), DEMO LOCK (82%), submission. Rescue triggers: no slice at 30%, MUSTs unfinished at 55%.
10. FIRST TASK per human: 3 lines each (task, files owned, files not to touch).
11. SECURITY FLAGS (only if relevant), RISKS/ASSUMPTIONS (max 5).
12. FILL-INS: (a) AGENTS.md blanks only: stack, run commands, conventions, ownership table, mock switch location; (b) PROJECT.md contents (items 1-8 condensed); (c) STATUS.md PROJECT SNAPSHOT filled in. Contents only.
```

---

# PART E: BUILD PROMPT

One per developer per task.

```text
HACKATHON MODE. You are a builder on a shared repo with 3 other developers/AIs on separate branches. Speed matters; broken integration costs more than missing features.

READ: AGENTS.md (contains CORE RULES; if it doesn't exist I will paste them) and the relevant PROJECT.md section.

PRE-EDIT CHECK, run now:
  git status
  git branch --show-current
  git log --oneline -3
Reply in 3 lines: current branch / working-tree state / files you will modify. If the branch is wrong or the tree is unexpectedly dirty, tell me before editing. Then inspect only the files relevant to the task.

MY ROLE/BRANCH: [e.g. Core Builder, feat/h2-core]
TASK: [ONE task, e.g. "Slice: form -> POST /api/analyze -> render result"]
I OWN: [FILES]   DO NOT TOUCH: [FILES]
CONTRACT/MOCKS: [section; "central mock switch is on until backend PR merges"]
PRIORITY: P0 [..], P1 [..], P2 [skip unless time]

INSTRUCTIONS
1. Smallest working version first (happy path), then loading/error/empty states, then validation. If this is the slice: ugly is fine.
2. R1 NO-STALL: low-risk decisions -> assume and continue. Ask only if impossible to infer or it would change stack/architecture/security/data model/MVP.
3. No new project/package.json/duplicate files; no new dependencies unless unavoidable (say which and why); no unrelated rewrites, renames, framework swaps, or dependency upgrades (R6).
4. Run/build after each meaningful change; fix errors before reporting. After 2 failed fix attempts on one problem, STOP and report (R5).
5. OUTPUT: changed code only (R3); no unchanged files, no tutorials. Then the AI CONTEXT HANDOFF.

AI CONTEXT HANDOFF (about 10 lines):
TASK / BRANCH+COMMIT / DONE (verified how) / FILES CHANGED / DEPS ADDED / API CHANGES / KNOWN BUGS / ASSUMPTIONS / RUN-VERIFY / NEXT STEP
```

---

# PART F: DEBUG PROMPT

```text
HACKATHON DEBUG MODE. Something is broken. No broad changes, no rewrites, no new dependencies, no stack changes. Compact output (R4): ACTION -> CHANGED FILES -> CODE -> TEST RESULT -> NEXT STEP.

SYMPTOM: [did / expected / happened]
EXACT ERROR/LOGS (verbatim, trimmed to first error + ~20 lines): [PASTE]
COMMAND: [..]   BRANCH: [..]   LAST CHANGE/MERGE: [..]
RELEVANT FILES (only those in the trace): [PASTE]
FIX ATTEMPT # : [1 or 2]   (this prompt counts attempts)

DO:
1. One sentence: what the error literally says.
2. 1-3 ranked likely root causes; trace import/data/API flow for #1.
3. Smallest fix in the fewest files; exact lines.
4. Exact command to re-run and what success looks like.

STOP RULE: If this is attempt 2 and it still fails, or I've spent 10 minutes, do NOT try a bigger fix. Instead:
 a. Tell me to preserve state: git add -A && git commit -m "wip: broken [problem]" on a wip branch (or git branch backup/[name])
 b. Isolate: smallest repro, the exact failing line/call, what still works
 c. Simplify: propose the simplest fallback (mock the call, cut the feature, hardcode the sample)
 d. Output a 5-line summary for a human teammate/H1 to decide.
```

---

# PART G: INTEGRATE PROMPT (PR-based)

Used by H1 when PRs are waiting, or when `main` is broken after a merge.

```text
HACKATHON INTEGRATION MODE. I am H1 (integrator). Teammates opened Pull Requests on GitHub. Make them work together with the SMALLEST changes. Adapt the glue; do not rewrite anyone's feature. Compact output (R3/R4).

OPEN PRs: [PR titles/branches + each one's AI CONTEXT HANDOFF]
CONTRACT: [paste the API contract table]
SNIPPETS (only these): router/app entry, API client, endpoint definitions, shared types, package manifest diffs. [PASTE]
CONFLICTS (if GitHub shows them): [conflicted file names + hunks only]

TASKS:
1. REVIEW CHECKLIST per PR (2 minutes): runs? touches only owner's files? no .env/node_modules/junk? contract row updated if API changed? no new dependency without reason? Reply APPROVE / FIX FIRST with one line each.
2. MERGE ORDER recommendation (usually backend/data -> core -> UI).
3. If conflicts: the PR AUTHOR resolves by merging main into their branch. Give them the exact steps and the resolution per file (keep both intents; prefer the owner's version in their own area).
4. After each merge, check the integration: compare frontend API calls vs backend endpoints (method, path, fields, status codes, error shape, CORS, base URL/port, env vars). Fix on the cheaper side (usually the frontend API client) and update the contract row.
5. Check duplicates (same job, different names), shared wiring (routes, providers, manifests, env, ports).
6. When the real backend is verified, switch the central mock switch off.
7. Give the exact commands to install, run and click through the demo path.

OUTPUT: PR decisions (table) · mismatches + fixes (table) · edited files only · verification steps · updated PROJECT SNAPSHOT lines (WORKING / BROKEN / NEXT 3 ACTIONS). No refactors, no new dependencies. If a merge broke main, recommend reverting the PR on GitHub first, then fixing.
```

---

# PART H: POLISH PROMPT

Use after the slice is on main; main polish window is 70-82% of time.

```text
HACKATHON UI POLISH MODE. The app WORKS. Make it credible in about [45-60] minutes without breaking anything.

READ AGENTS.md (CORE RULES). PRE-EDIT CHECK: git status; git branch --show-current; git log --oneline -3 -> confirm branch, state, files.

HARD RULES: edit markup and styles ONLY. Do not change business logic, API calls, state, routing logic, props contracts, or data shapes. No new heavy UI libraries. Reuse components; no duplicates. If a screen file is being edited in an open PR by someone else, wait for it to merge, then sync.
PRODUCT: [name + one line]   DEMO PATH SCREENS (in this order): [..]
I OWN: [style files, components/ui/, presentational markup]   DO NOT TOUCH: [services, api client, backend, logic]
DIRECTION (optional): [e.g. clean SaaS, dark, calm health] or "choose something appropriate"

STEPS
1. In under 10 lines, state tokens (palette primary/accent/success/warning/danger/neutrals, font, spacing scale, radius, shadow). Put them in one place (skip if already done pre-slice).
2. Shared kit: Button, Card, Input, Badge/Status, Toast/Modal if present. Apply to demo path screens first.
3. Hierarchy: product name/tagline header, consistent spacing, one clear primary action, results as clear cards/tables/charts (not raw JSON).
4. States: loading, empty (message + action), error (message + retry), success.
5. Responsive: laptop and ~390px phone width.
6. Motion: subtle transitions only where they clarify.
7. Verify: run the app, click the whole demo path, check console, confirm function is identical.

OUTPUT: changed code only; handoff: FILES CHANGED / TOKENS / SCREENS DONE / LOGIC FILES TOUCHED (must be none) / REMAINING (max 3). Stop when the demo path looks good.
```

---

# PART I: AUDIT PROMPT (Final QA)

Run right after DEMO LOCK on a **fresh clone** of `main`. Tier 1 is mandatory (about 20 minutes). Tier 2 only if time remains. Only P0/P1 get fixed.

```text
HACKATHON FINAL TECHNICAL AUDIT. DEMO LOCK is ON: fix only P0/P1 with the smallest safe edit; no refactors, upgrades, or new dependencies. Compact report.

SETUP: fresh clone of main in a temp folder. Run commands: [..]. DEMO PATH: [steps]. SUBMISSION REQUIREMENTS: [repo/video/URL/README/form]
PASTE ONLY: manifests, run commands, .env.example, router/entry, API client, endpoint list. I'll paste more if asked.

TIER 1 (always, about 20 minutes). PASS/FAIL with evidence:
1. Clean install + start works from README commands alone (env example complete, ports right).
2. Build works if we will demo a build (npm run build or equivalent).
3. Demo path end to end with the exact demo inputs, twice, then once with different input.
4. No console/server errors on demo screens.
5. Frontend <-> backend: endpoints, field names, error shape, base URL, CORS match the contract; mock switch is in the intended position.
6. Failure behavior: backend down/slow/empty data shows a message, never a blank page.
7. Secrets: nothing hardcoded or committed (check code, .env ignored, git history of main); .env.example present.
8. Seed/demo data present; no real personal data.

TIER 2 (if time remains):
9. Forms: empty, invalid, very long input, double-click submit.
10. Refresh/deep link on each route; back button.
11. Responsive at ~1366, ~1920, ~390 px.
12. README (what/problem/how to run/stack/team/limitations), no junk files or debug logs.
13. Deployed environment parity (if deploying).

OUTPUT: VERDICT GO/NO-GO · P0 + fix · P1 + fix · P2/P3 (list only) · FIXES APPLIED (file, one line) · DEMO-DAY RISKS (max 5) with mitigations.
```

---

# PART J: DEMO PROMPT

```text
HACKATHON DEMO PREP. Judges must see the product WORKING. Use only facts about what we built. No invented users, market numbers, partnerships, accuracy or scale claims. Be honest about prototype/mocked parts.

PROJECT: [PROJECT.md contents]
VERIFIED WORKING: [..]   MOCKED/SIMPLIFIED: [..]
DEMO TIME: [e.g. 3 min + 2 min Q&A]   JUDGING CRITERIA: [..]   SPEAKERS: [..]

PRODUCE (one page): 30-second pitch · demo script in [N] minutes (exact click/input + line to say + expected result; known-good inputs; strongest moment in first 60 seconds) · one-line answers: what problem / who has it / what it does / what's technically interesting / is it really working / why credible / what next (qualitative, no numbers) · one key technical highlight (20 s) · honest differentiation · 8 likely judge questions with 2-sentence honest answers (include "what isn't finished", "what's mocked", security/privacy, scalability, why this stack, what AI did vs. you) · backup plan per step + pre-demo checklist · who talks / drives keyboard / handles Q&A. Written as a script I can read aloud. No filler.
```

---

# PART K: DISASTER PROMPT

Before asking any AI: everyone **stops pushing**, then H1 follows L9 (recovery commands).

```text
HACKATHON DISASTER RECOVERY. The codebase is in a bad state. Do NOT continue building. Do NOT rewrite anything. Goal: return to the last known-good state with the least lost work. Compact output.

SITUATION: [broken build | merge conflict | broken dependencies | frontend/backend mismatch | AI giant rewrite | accidental deletion | inconsistent API | broken git state | other]
LAST KNOWN-GOOD: [commit/tag/branch or "unknown"]
WHAT HAPPENED: [2-4 lines]
OUTPUT OF: git status ; git branch --show-current ; git log --oneline -10 ; git diff --stat   [PASTE]
ERROR/LOGS: [PASTE]

DO:
1. Diagnose from the evidence (branch, commits, uncommitted files). Ask for one more command output if needed; don't guess.
2. SAFE-FIRST PLAN: (a) backup command first (branch or stash of the current state), (b) least destructive recovery: restore specific files from a known-good commit rather than resetting; revert a bad merge/commit rather than rewriting history; use reflog for lost commits.
3. Exact commands in order, each with what it does and the expected output. No force pushes or hard resets unless I confirm and a backup exists.
4. By situation: broken build (find the FIRST error; restore the offending file) · merge conflict (resolve by intent per file, or abort and retry one PR at a time) · broken dependencies (restore manifest + lockfile from good commit, reinstall, no upgrades) · frontend/backend mismatch (table of mismatches vs contract; fix the cheaper side) · AI giant rewrite (diff vs known-good; keep only what serves the current task; revert the rest file by file) · accidental deletion (git restore from HEAD/commit; reflog if committed) · inconsistent API (freeze contract; fix each caller).
5. Verification: commands + demo-path steps.
6. Prevention in 3 bullets.
```

---

# PART L: GIT WORKFLOW (PR-based; one standard path)

## L1. The only workflow

```
own branch → commit → push → Pull Request → H1 reviews → H1 merges into main (GitHub button) → everyone syncs main into their branch
```

Nobody pushes to `main`, and nobody merges into `main` locally. Exception: H1's initial skeleton commit (L2), and Recovery (L9).

## L2. One-time setup (H1, 5-10 minutes)

```bash
git clone <repo-url> && cd <repo>
# add .gitignore FIRST: node_modules/ .env venv/ __pycache__/ dist/ *.db .DS_Store
git add . && git commit -m "chore: skeleton + AGENTS.md PROJECT.md STATUS.md"
git push origin main
```
On GitHub (optional but recommended, 2 minutes): Settings → Branches → require a pull request before merging to `main`. In PR settings leave "Create a merge commit" enabled.
Teammates: `git clone <repo-url> && cd <repo>`.

## L3. Create your branch

```bash
git checkout main
git pull origin main
git checkout -b feat/h2-core        # names: feat/<who>-<area>, fix/<who>-<thing>
```

## L4. Work rhythm (every ~30-45 min and after every good AI result)

```bash
git status                                  # verify what changed
# RUN THE APP. Don't commit something that doesn't start.
git add <files you own>
git commit -m "feat(core): form calls /api/analyze"
git push -u origin feat/h2-core             # later: git push
```
Commit **before** each new AI session. It's your undo button.

## L5. Opening a Pull Request

When something works (slice, a feature, a polish pass; aim for a PR every 45-60 minutes, not one giant PR at the end):

1. GitHub shows "Compare & pull request" after pushing. (Or: `gh pr create --fill`.)
2. Title: `type(area): what`.
3. Description: paste your **AI CONTEXT HANDOFF** (Part M). Mention contract changes and new dependencies.
4. Before opening: `git fetch origin && git merge origin/main` on your branch, run the app (L7).
5. Tell H1 in the team chat: "PR ready: [title]".

## L6. H1: review and merge (2 minutes each)

Check on GitHub (Files changed tab) and locally if risky:
- [ ] Touches only the author's files (plus agreed shared-file lines)
- [ ] No `.env`, `node_modules`, junk, secrets
- [ ] Contract row updated if the API changed; no unexplained new dependency
- [ ] The app starts and the demo path still works (for slice/core/merge rounds, check out the branch: `git fetch && git checkout <branch>`)
Then click **Merge pull request**. Merge order when several wait: **backend/data → core → UI**. Announce: "main updated: [what]". H1's own PRs: H1 may merge them after the same checklist.

## L7. Everyone syncs after each merge

```bash
git checkout feat/h2-core
git fetch origin
git merge origin/main
# conflicts? see L8. Then run the app.
git push
```
No unpushed work and nothing in progress? Just `git checkout main && git pull`, then branch again.

## L8. Conflicts (the PR author resolves; H1 doesn't fix others' conflicts)

GitHub says "This branch has conflicts"? On your branch:
```bash
git fetch origin
git merge origin/main
git status                       # "both modified" files
# edit each: keep both intents, delete <<<<<<< ======= >>>>>>> markers
git add <resolved files>
git commit -m "merge: resolve conflicts with main"
git push                         # the PR updates automatically
```
Not your file? Keep main's version of it and re-apply your small change, or ask the owner. Never "resolve" by deleting their code. Unsure: use INTEGRATE.

## L9. Exception / recovery workflow (H1 mostly; not for daily use)

```bash
git branch backup/$(date +%H%M)        # snapshot BEFORE anything risky
git stash push -m "wip"                # park uncommitted work
git stash pop                          # bring it back
git restore <file>                     # discard uncommitted edits to one file
git restore --source=<commit> <file>   # restore one file from a known-good commit
git revert -m 1 <merge-commit>         # undo a merged PR safely (or GitHub's Revert button)
git merge --abort                      # cancel a merge that went wrong
git reflog                             # find "lost" commits
```
If GitHub is down, H1 may merge locally: `git checkout main && git pull && git merge --no-ff <branch> && git push`. Avoid `git reset --hard` and `git push --force` unless H1 approves **and** a backup branch exists.

## L10. Release state

```bash
git checkout main && git pull
# AUDIT on a fresh clone (Part I)
git tag demo-ready && git push origin demo-ready
```
After tagging only P0 fixes go in via PR, each followed by `demo-ready-2`, etc. Submit/deploy from the tag.

---

# PART M: FILE / CONTEXT STRATEGY

## M1. Minimum file set (3 files in repo root)

| File | Purpose | Edited by | Size |
|---|---|---|---|
| **AGENTS.md** | Static CORE RULES + stack, commands, conventions, ownership, mock switch | H1 only | ≤70 lines |
| **PROJECT.md** | Brief, MVP, demo path, features, architecture, slice, **API contract** | H1; contract rows by the endpoint owner in their PR | ≤120 lines |
| **STATUS.md** | PROJECT SNAPSHOT + board + known bugs | **H1 only** (overwrite the snapshot; no appending by others) | ≤40 lines |

Handoffs live in **PR descriptions** and the team chat, not in files. Using Claude Code? Add a one-line `CLAUDE.md`: "Read AGENTS.md and PROJECT.md first."

**Pre-event (10 minutes, do once):** save a starter repo/template with AGENTS.md (CORE RULES already filled in), a .gitignore, and a README stub. At the event only the blanks change.

## M2. AGENTS.md template

```markdown
# AGENTS.md: rules for every AI and developer

MODE: HACKATHON. Speed over elegance. MVP first. No overengineering.

## Stack (do not change)
Frontend: [..]   Backend: [..]   Data: [..]
Run: `[cmd]` (frontend, port [..]) · `[cmd]` (backend, port [..])
Env: copy .env.example to .env. Never commit .env.
Mock switch: [location + mechanism, e.g. src/config.js USE_MOCK, or VITE_USE_MOCK]. Centralized in ONE place; only the API client reads it.

## CORE RULES
[PASTE Part A8 CORE RULES R1-R10 here]

## Conventions
Component files PascalCase · JSON keys [camelCase|snake_case] · API prefix /api · commit format type(area): message · branches feat/<who>-<area>

## Ownership (one owner per file)
| Owner | Files/folders |
|---|---|
| H1 Integrator | routing, app shell, shared config, manifests, README, AGENTS/PROJECT/STATUS |
| H2 Core | [..] |
| H3 UI | components/ui/, styles, [..] |
| H4 Backend/Data | [..] |

## Git
Branch → push → PR → H1 merges → sync main into your branch. Never push to main.
```

## M3. PROJECT.md template

```markdown
# PROJECT.md
## Brief
Problem · User · Pain · Solution (1 sentence) · Judging angle
## MVP + Demo path
1..7 numbered steps a judge sees
## Features
| Feature | Pri | MUST/SHOULD/NICE/CUT | Owner | Status |
## Architecture (just enough)
Stack · folder tree · screens/components · data model · env vars
BUILDING: .. · NOT BUILDING: ..
## Vertical slice
Action → UI file → API → backend file → data/mock → response → visible result. Done when: ..
## API contract
| Method + path | Request | Response | Errors | Status (planned/implemented/verified) |
## Assumptions and simplifications
```

## M4. STATUS.md template

```markdown
# STATUS.md (H1 overwrites the snapshot)

PROJECT SNAPSHOT
CURRENT PHASE:
TIME REMAINING:
MVP:
DEMO PATH:
WORKING:
BROKEN:
BLOCKED:
CURRENT OWNERS:
NEXT 3 ACTIONS:
FEATURE FREEZE / DEMO LOCK AT:

## Board
| Task | Owner | Branch | State (todo/doing/PR/merged) |

## Known bugs
P0/P1/P2/P3 | description | owner
```

## M5. What each agent receives

| Agent | Send | Don't send |
|---|---|---|
| Orchestrator | Problem statement, PROJECT.md, handoffs, snapshot | Source code (except to resolve a conflict) |
| Analyst / Architect | Problem statement, constraints, team skills | Code, other chats |
| Builders (Core/Backend/UI) | AGENTS.md, **only** relevant PROJECT.md sections, the task, owned files and the interfaces they touch | Entire repo, others' feature files, old chat logs |
| QA / Integration | AGENTS.md, contract, PR handoffs, exact errors, only files named in the trace/mismatch | Whole-repo dumps |
| Demo | PROJECT.md, verified-working list | Code |

## M6. Context compression rule

When an AI chat becomes **long, slow, or confusing** (roughly 15+ exchanges, repeated mistakes, or it forgets decisions):

1. Ask the AI: **"Generate an AI CONTEXT HANDOFF."**
2. **Commit** the current working state (`git add <files> && git commit -m "wip: ..."`).
3. **Start a fresh chat.**
4. Give the new AI **only**: AGENTS.md · the relevant PROJECT.md section · the handoff · the current task · the exact error (if any).

Also: never re-send unchanged files; paste errors verbatim but trimmed; paste interfaces (the contract table), not other people's implementations; one task per chat.

## M7. AI CONTEXT HANDOFF (about 10 lines; also the PR description)

```text
AI CONTEXT HANDOFF
TASK:
BRANCH + LAST COMMIT:
DONE (and how verified):
FILES CHANGED:
DEPENDENCIES ADDED:
API CHANGES:
KNOWN BUGS (P0-P3):
ASSUMPTIONS / SIMPLIFICATIONS:
RUN / VERIFY:
NEXT STEP:
```

---

# PART N: TEAM OPERATING PROCEDURE (4 humans + AIs)

## N1. Roles

| Human | Hat | Prompts | Owns |
|---|---|---|---|
| **H1** | Lead + Integrator, later QA/Demo | START, Orchestrator, INTEGRATE, AUDIT, DEMO, RESCUE, LOCK, DISASTER | `main`, PR merges, routing/app shell, shared config, manifests, README, AGENTS/PROJECT/STATUS |
| **H2** | Core Builder | BUILD, DEBUG, C3 | Core feature logic, main screens' logic |
| **H3** | UI/UX | C5 then POLISH | components/ui/, tokens, global styles, presentational markup |
| **H4** | Backend/Data (else Core #2 + QA) | C4, BUILD, DEBUG | backend/, data/seed, contract rows for its endpoints |

## N2. Rules that stop people stepping on each other

1. **One owner per file** (AGENTS.md table). Need a change in someone else's file? Ask, or make the smallest edit and tell them.
2. **One branch per person; never work on `main`.**
3. **PR-only merging;** H1 merges. Everyone syncs main after every merge.
4. **Contract:** change an endpoint → update its row in the same PR, post one line in team chat.
5. **Mock switch** centralized; frontend never waits for backend.
6. **No new dependency** without telling H1 (manifest conflicts).
7. **Commit before each AI session; run before each commit.**
8. **Never paste "the whole project" into an AI.** Use M5.
9. **Reject AI diffs that refactor, rename, or "clean up".** CORE RULE R6.
10. **Only H1 edits STATUS.md and AGENTS.md.**

## N3. Human escalation (STOP RULE)

If the same problem is unresolved after **2 targeted AI fix attempts or 10 minutes of human time**: STOP.
1. **Preserve**: commit to a `wip/` or `backup/` branch.
2. **Isolate**: smallest repro, exact failing call/line, what still works.
3. **Simplify**: mock it, hardcode the sample, or cut the feature.
4. **Ask a human teammate** (then H1) to decide in under 5 minutes.
Do not let the AI try bigger and bigger changes. Use DEBUG; if still blocked, DISASTER is for repo-wide messes only.

## N4. Sync rhythm

- **T+0 to T+30, everyone together:** H1 runs START on the shared screen; ≤10 minutes of MVP debate, then H1 decides. Branches and tasks.
- **Every 60-90 minutes, 5-minute standup** (standing): done / doing / blocked / contract changes. H1 overwrites the snapshot, applies cut rules, decides whether to call RESCUE.
- **Merge rounds:** at slice, core MVP, features, polish. Everyone opens PRs first; H1 merges in order; everyone syncs. No new coding in the first 10 minutes of a merge round.
- **82%:** H1 announces **DEMO LOCK** (Part R).

## N5. One developer's task flow

1. `git checkout main && git pull`, create/refresh your branch (L3, L7).
2. New AI chat; paste BUILD with task, owned files, relevant PROJECT.md section.
3. AI does the PRE-EDIT CHECK; you answer only if it flags something.
4. Run the result. Broken? DEBUG (attempt counts: 2 then escalate).
5. Works: commit, push, open PR with AI CONTEXT HANDOFF, ping H1.
6. After merge: sync main (L7).

## N6. Things go wrong

- **Main broken after a merge:** H1 reverts that PR on GitHub (1 minute), runs INTEGRATE on the PR author's branch, re-merges once fixed.
- **Two people built the same thing:** keep the one on the demo path; remove the other via PR.
- **AI rewrote everything:** DISASTER; restore from a backup branch or tag.
- **Behind schedule:** RESCUE (Part Q).

---

# PART O: TIME-BASED EXECUTION (10-hour example; scale by %)

For other lengths keep the percentages. For a 24-hour event keep the same percentages, but protect sleep and keep the last 2 hours coding-free.

| Clock | % | Event | Who | Prompt | Exit condition |
|---|---|---|---|---|---|
| 0:00 | 0 | Problem analysis | H1 runs, all read | **START** | Brief + MVP + feature table |
| 0:15 | 2.5 | **MVP locked** | All, H1 decides | | Demo path 5-7 steps; features classified |
| 0:30 | 5 | **Architecture locked, build begins** | H1 | | AGENTS/PROJECT/STATUS committed; branches; tasks |
| 0:30-2:00 | 5-20 | **First vertical slice** (H2 + H4; H3 tokens/shell only) | | **BUILD**, C4, C5 phase 1 | Slice on branches |
| 2:00 | 20 | Slice PRs merged + checkpoint 1 | H1 | **INTEGRATE**, QA checkpoint | One real action works end to end on `main` |
| 2:00-4:30 | 20-45 | Core MVP; PRs every ~45-60 min | All | **BUILD** | All MUSTs working |
| 3:00 | 30 | **Rescue check #1** | H1 | **RESCUE** if no slice | |
| 4:30 | 45 | Core MVP on main + checkpoint 2 | H1 | **INTEGRATE** | Demo path works with real data |
| 4:30-7:00 | 45-70 | SHOULD features | per ownership | **BUILD** | SHOULDs done or cut |
| 5:30 | 55 | **Rescue check #2** | H1 | **RESCUE** if MUSTs unfinished | |
| 7:00 | 70 | Features merged + checkpoint 3 | H1 | **INTEGRATE** | Everything on main |
| 7:00-8:15 | 70-82 | **Polish** (H3 leads; others fix bugs, README, seed data) | | **POLISH** | Demo path credible |
| 8:15 | 82 | **DEMO LOCK** | H1 | **LOCK** | |
| 8:15-9:00 | 82-90 | Final audit on fresh clone; tag `demo-ready` | H1 + H4 | **AUDIT** | GO verdict |
| 9:00 | 90 | Demo prep | H1 writes | **DEMO** | Script + backup plan |
| 9:15 | 92 | Rehearsal ×2, timed | All | | Roles fixed |
| 9:30 | 95 | **Submit** | H1 | | Submitted |
| 9:30-10:00 | 95-100 | Buffer | nobody codes | | Links open in incognito |

Rules: anything unfinished at its phase boundary is **cut or simplified, never extended.** Slice late → RESCUE, don't add people. P0 after lock → fix on a branch via PR, test, tag again, nothing else.

---

# PART P: FINAL CHECKLIST

**Product**
- [ ] Demo path works end to end twice with exact demo inputs, from a fresh clone of `demo-ready`
- [ ] No console errors or blank screens; failure states show a message
- [ ] Seed/demo data present, no real personal data
- [ ] Mock switch in the intended position (real backend on, unless deliberately mocked and disclosed)
- [ ] Credible on laptop and phone width

**Code and repo**
- [ ] `main` has everything we submit; `demo-ready` tag exists
- [ ] README: what it is, problem, exact run commands, stack, team, limitations
- [ ] `.env.example` present; `.env` not committed; no keys in code/history
- [ ] No junk files, no leftover debug logs, no duplicate apps/configs
- [ ] App starts from README commands only

**Submission**
- [ ] All required items ready: repo link, video, URL, description/slides, team info, form submitted
- [ ] Links open in an incognito window; repo accessible to judges
- [ ] Backup video/screenshots recorded

**Demo**
- [ ] 30-second pitch and script rehearsed twice with timing
- [ ] Speakers + keyboard owner assigned; Q&A answers prepared (including "what isn't finished")
- [ ] Backup plan ready; laptop charged; internet/hotspot tested; server running; notifications off

**Honesty**
- [ ] No invented numbers, customers, accuracy claims, or partnerships anywhere

---

# PART Q: RESCUE PROMPT (MVP RESCUE MODE)

**Triggers (H1/Orchestrator calls it):** no slice on main at 30% · MUSTs unfinished at 55% · a P0 open >20 min · two failed integration attempts · team morale/clock says the demo is at risk.
**Exit:** demo path works on main and verified once; H1 announces "RESCUE OFF".

## Q1. Activate (paste into the Orchestrator chat)

```text
MVP RESCUE MODE: ON. Time remaining: [..]. Current snapshot: [paste PROJECT SNAPSHOT or handoffs].

Rules from now: stop P2/P3 immediately; stop optional UI polish; stop refactoring; stop architecture improvements; stop documentation expansion; no new major features; fix only P0/P1; protect the demo path; use mocks wherever backend integration blocks the demo; prefer a simplified working feature over an ambitious broken one.

Give me, under 200 words: 1) the shortest demo path that still impresses a judge, 2) KEEP / SIMPLIFY / CUT table for each feature, 3) which parts switch to mock, 4) per-human next task (one line each, 30-60 minutes max), 5) the next rescue check time.
```

## Q2. Broadcast to every builder chat (paste as one message)

```text
MVP RESCUE MODE: ON. P0/P1 only. No new features, polish, refactors or doc work. Use the mock switch if integration blocks the demo. Simplify rather than extend. Your task now: [one line from H1]. Your files: [..]. Compact output (ACTION -> CHANGED FILES -> CODE -> TEST RESULT -> NEXT STEP). After 2 failed fixes: STOP and report.
```

---

# PART R: LOCK PROMPT (DEMO LOCK at 82%)

**ALLOWED:** P0 fixes · P1 fixes · tiny visual fixes that cannot break functionality · demo data adjustments · documentation/submission tasks.
**NOT ALLOWED:** new features · large refactors · dependency upgrades · architecture changes · framework changes · redesigns.

H1 sends in every builder chat:

```text
DEMO LOCK: ON. Allowed: P0 fixes, P1 fixes, tiny visual fixes that cannot break functionality, demo data adjustments, documentation/submission tasks. Not allowed: new features, large refactors, dependency upgrades, architecture changes, framework changes, redesigns. Work on a branch; open a PR with a handoff; H1 merges. Compact output. If your change touches logic, say so before making it. If unsure whether something is allowed, it isn't.
```

After LOCK: AUDIT (Part I) on a fresh clone → `demo-ready` tag → DEMO prep.

---

# QUICKSTART: HACKATHON DAY CHEAT SHEET

**Before the event (10 min, once):** starter repo with AGENTS.md (CORE RULES filled), .gitignore, README stub · everyone can clone/push/open a PR · AI tools signed in · this file open.

| When | Milestone | Do | Prompt |
|---|---|---|---|
| **T+0** | Problem statement released | H1 pastes statement; everyone reads the output | **START** (Part D) |
| **T+15** | MVP locked | 10-min debate max; H1 decides; features classified | Orchestrator (B) for ongoing status |
| **T+30** | Build begins | Commit AGENTS/PROJECT/STATUS; everyone branches (`git checkout -b feat/<who>-<area>`); each builder starts | **BUILD** (E); UI: C5 phase 1; backend: C4 |
| **T+slice (~20%)** | First vertical slice on main | PRs → H1 merges → everyone syncs; 5-min QA checkpoint | **INTEGRATE** (G) |
| **T+MVP (~45%)** | Core demo working | All MUSTs on main; checkpoint 2; **at 30% and 55%: rescue check** | **BUILD**, **RESCUE** (Q) if behind |
| **Any time stuck** | 2 AI fixes or 10 min | Stop, commit WIP, isolate, simplify, ask a human | **DEBUG** (F); **DISASTER** (K) for repo messes |
| **Chat gets slow** | ~15+ exchanges | Ask for AI CONTEXT HANDOFF → commit → new chat | M6/M7 |
| **T+70%** | Polish | Features done or cut; UI polishes markup/styles only; checkpoint 3 | **POLISH** (H) |
| **T+82%** | DEMO LOCK | Broadcast LOCK; only P0/P1/tiny fixes/data/docs | **LOCK** (R) |
| **T+82-90%** | Final QA | Fresh clone; Tier 1 audit; tag `demo-ready` | **AUDIT** (I) |
| **T+90%** | Demo prep | Script, backup plan, 2 timed rehearsals | **DEMO** (J) |
| **T+95%** | Submit | Final checklist (Part P); links open in incognito | Checklist |
| **T+final** | Buffer | Nobody codes | none |

**Git in one line:** `branch → commit → push → PR → H1 merges → git fetch && git merge origin/main → continue.`
**Always:** R2 pre-edit check · changed-code-only · 2 fixes then stop · mock switch in one place · only H1 merges and edits STATUS.md.

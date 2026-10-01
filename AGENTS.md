# AGENTS.md: rules for every AI and developer

MODE: HACKATHON. Speed over elegance. MVP first. No overengineering.

## Stack (do not change)  [H1 fills in after START]
Frontend: [..]   Backend: [..]   Data: [..]
Run: `[cmd]` (frontend, port [..])  |  `[cmd]` (backend, port [..])
Env: copy .env.example to .env. Never commit .env.
Mock switch: [location + mechanism, e.g. src/config.js USE_MOCK, or VITE_USE_MOCK]. Centralized in ONE place; only the API client reads it.

## CORE RULES

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

R7 OWNERSHIP: Edit only files you own (table below). No new project, no second package.json, no duplicate files/configs, no new dependencies unless unavoidable (say which and why). Use props/interfaces/API contract to interact with others' code.

R8 MODES: In MVP RESCUE MODE: P0/P1 only; no new features, polish, refactors, or doc expansion; mocks allowed. In DEMO LOCK: P0/P1 fixes, tiny visual fixes that cannot break function, demo data, submission tasks only.

R9 TEST: Run/build after every meaningful change. Fix errors before reporting success. Preserve working code.

R10 SECRETS: Never hardcode secrets. No private keys in frontend code. Use environment variables; commit only .env.example.

## Conventions
Component files PascalCase | JSON keys [camelCase|snake_case] | API prefix /api | commit format type(area): message | branches feat/<who>-<area>

## Ownership (one owner per file)  [H1 fills in after START]
| Owner | Files/folders |
|---|---|
| H1 Integrator | routing, app shell, shared config, manifests, README, AGENTS/PROJECT/STATUS |
| H2 Core | [..] |
| H3 UI | components/ui/, styles, [..] |
| H4 Backend/Data | [..] |

## Git
Branch -> push -> PR -> H1 merges -> sync main into your branch. Never push to main.

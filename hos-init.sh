#!/usr/bin/env bash
# HOS v1.1 starter scaffold. Run inside your hackathon repo folder (or pass a folder).
# Usage:  bash hos-init.sh            -> scaffolds the current folder
#         bash hos-init.sh my-repo    -> creates/uses ./my-repo
# Safe to re-run: it never overwrites files that already exist.

set -e

TARGET="${1:-.}"
mkdir -p "$TARGET"
cd "$TARGET"

if ! command -v git >/dev/null 2>&1; then
  echo "git is not installed. Install Git first: https://git-scm.com/downloads"
  exit 1
fi

if [ ! -d .git ]; then
  git init -b main >/dev/null 2>&1 || { git init >/dev/null; git checkout -b main >/dev/null 2>&1 || true; }
  echo "[hos] initialised git repo (branch: main)"
fi

write_file() {
  # write_file <path>  (content from stdin); skips if file exists
  if [ -e "$1" ]; then
    echo "[hos] skip   $1 (already exists)"
    cat >/dev/null
  else
    mkdir -p "$(dirname "$1")"
    cat >"$1"
    echo "[hos] create $1"
  fi
}

# ---------------------------------------------------------------- .gitignore
write_file .gitignore <<'EOF'
node_modules/
dist/
build/
.env
.env.local
venv/
.venv/
__pycache__/
*.pyc
*.db
*.sqlite
.DS_Store
.vscode/*
!.vscode/settings.json
EOF

# ---------------------------------------------------------------- .env.example
write_file .env.example <<'EOF'
# Copy to .env (never commit .env). Names only; no real secrets here.
# Frontend (Vite) public vars must start with VITE_ and are visible in the browser bundle:
# VITE_USE_MOCK=true
# VITE_API_URL=http://localhost:8000
# Backend:
# API_KEY=
EOF

# ---------------------------------------------------------------- AGENTS.md
write_file AGENTS.md <<'EOF'
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
EOF

# ---------------------------------------------------------------- PROJECT.md
write_file PROJECT.md <<'EOF'
# PROJECT.md

## Brief
Problem:
User:
Pain:
Solution (1 sentence):
Judging angle:

## MVP + Demo path
1.
2.
3.

## Features
| Feature | Pri (P0-P3) | MUST/SHOULD/NICE/CUT | Owner | Status |
|---|---|---|---|---|

## Architecture (just enough)
Stack:
Folder tree:
Screens/components:
Data model:
Env vars:
BUILDING:
NOT BUILDING:

## Vertical slice
Action -> UI file -> API -> backend file -> data/mock -> response -> visible result.
Done when:

## API contract
| Method + path | Request | Response | Errors | Status (planned/implemented/verified) |
|---|---|---|---|---|

## Assumptions and simplifications
EOF

# ---------------------------------------------------------------- STATUS.md
write_file STATUS.md <<'EOF'
# STATUS.md  (H1 overwrites the snapshot; nobody else edits this file)

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
|---|---|---|---|

## Known bugs
P0/P1/P2/P3 | description | owner
EOF

# ---------------------------------------------------------------- CLAUDE.md (optional pointer for Claude Code)
write_file CLAUDE.md <<'EOF'
Read AGENTS.md and PROJECT.md first. AGENTS.md contains the CORE RULES that apply to you.
EOF

# ---------------------------------------------------------------- README stub
write_file README.md <<'EOF'
# [Project name]

[One-line description]

## Problem
## How to run
```bash
# install
# start
```
## Stack
## Team
## Known limitations
EOF

# ---------------------------------------------------------------- PR template (AI CONTEXT HANDOFF)
write_file .github/pull_request_template.md <<'EOF'
## AI CONTEXT HANDOFF
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

## Checklist
- [ ] Merged latest origin/main into my branch and the app runs
- [ ] Demo path still works
- [ ] Only touched files I own (or reported the exception)
- [ ] Contract row updated if the API changed
EOF

echo
echo "[hos] done. Next:"
echo "  1) git add . && git commit -m 'chore: HOS starter files'"
echo "  2) create the GitHub repo and push (see the steps in chat)"
echo "  3) at the event: run the START prompt, then fill the [..] blanks in AGENTS.md / PROJECT.md / STATUS.md"

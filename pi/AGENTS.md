# Memory (pi-memory)

Save to memory proactively — don't wait to be told "remember". Save when:
- The user states a preference or corrects you ("use pnpm", "don't add comments") → `#preference`
- A decision is made with a rationale → `#decision`
- You discover something non-obvious after effort (gotcha, root cause, working command, env quirk) → `#lesson`
- Work is deferred or left unfinished → `scratchpad`
- Progress worth resuming tomorrow → `#progress`

Write these to the **daily** log, not long_term. A long_term write rewrites the system prompt, which re-bills the whole prompt cache and can drop prior thinking blocks. Durable entries get promoted to MEMORY.md later via `/memory-promote`. Only write long_term mid-session if the user explicitly asks.

Don't save: things derivable from the code/git history, transient task details, or secrets.

Rules:
- One fact per entry, written to stand alone. Include the project name with `[[project]]` when it's project-specific.
- Check existing memory before writing; skip duplicates; use `memory_forget` to replace outdated facts.
- Don't announce saves at length — a one-line mention is enough.

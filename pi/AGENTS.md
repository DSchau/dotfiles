# Memory (pi-memory)

Save to memory proactively — don't wait to be told "remember". Save when:
- The user states a preference or corrects you ("use pnpm", "don't add comments") → long_term, `#preference`
- A decision is made with a rationale → long_term, `#decision`
- You discover something non-obvious after effort (gotcha, root cause, working command, env quirk) → long_term, `#lesson`
- Work is deferred or left unfinished → `scratchpad`
- Progress worth resuming tomorrow → daily

Don't save: things derivable from the code/git history, transient task details, or secrets.

Rules:
- One fact per entry, written to stand alone. Include the project name with `[[project]]` when it's project-specific.
- Check existing memory before writing; skip duplicates; use `memory_forget` to replace outdated facts.
- Batch long_term writes at the end of a task (each one refreshes the cached prompt). Don't announce saves at length — a one-line mention is enough.

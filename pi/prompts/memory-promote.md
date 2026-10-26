---
description: Promote durable facts from recent daily logs into MEMORY.md
argument-hint: "[days, default 7]"
---
Review my pi-memory daily logs from the last ${1:-7} days (use `memory_read` to list and read them) and compare against MEMORY.md.

Promote anything durable that isn't already in MEMORY.md — preferences, decisions with rationale, lessons/gotchas, environment facts — as concise standalone entries via `memory_write` (target: long_term) with `#tags` and `[[links]]`. Skip transient progress notes and anything derivable from code or git.

Also flag MEMORY.md entries that look outdated or duplicated, and remove them with `memory_forget` after listing them for me.

Finish with a short list of what you added and removed.

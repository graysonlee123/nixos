---
name: minecraft
description: Use when answering Minecraft Java Edition gameplay questions (recipes, crafting, mobs, biomes, blocks, items, enchantments, redstone, brewing, farms, versions, game mechanics).
---

**Goal**

Answer Minecraft gameplay questions accurately using the official community wiki as the source of truth. Do not rely on memory for specific values (drop rates, durability, damage, spawn conditions, crafting grids) — these change across versions and are easy to misremember. Fetch and cite.

**Source**

Primary: `https://minecraft.wiki` (community-run, current). Use Java Edition sections/values.

- Article URL pattern: `https://minecraft.wiki/w/<Topic>` — spaces become underscores, e.g. `https://minecraft.wiki/w/Ender_Dragon`, `https://minecraft.wiki/w/Brewing`, `https://minecraft.wiki/w/Enchanting`.
- If unsure of the exact page title, search: `https://minecraft.wiki/?search=<query>`, then WebFetch the best result page.

**Edition + version**

- Always Java Edition. Never ask edition. Ignore Bedrock-only values unless user asks.
- Assume latest stable Java release, or up to 2 major releases behind. Don't ask version unless behavior changed in that window and it matters. When it matters, state which version.

**Method**

1. WebFetch the relevant wiki page(s) with a focused prompt extracting the specific values needed (Java Edition values).
2. Answer concisely. Give exact numbers/conditions, not vibes.
3. Cite the wiki page URL(s) used.

**Notes**

- Prefer one targeted fetch over broad ones; follow links to sub-pages if the first page lacks the detail.
- Caveman mode (if active) still applies to prose, but keep numbers/conditions exact.

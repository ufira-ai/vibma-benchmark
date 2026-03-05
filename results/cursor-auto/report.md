# Cursor Auto — Vibma Benchmark Report

**Model:** Cursor Auto | **CLI:** Cursor agent CLI

## Human Observations

**What worked well:**
- (Pending manual review)

**Issues found (Detailed round):**
- (Pending manual review)

---

## Detailed — Instruction Following + Reading from Design (/30)

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Tool Usage | 3 | Connected, used `get_document_info` and `get_available_fonts` to inspect the environment before building — better than Kimi (which never inspected). However: zero `get_node_info` calls (never checked what it built), zero `lint_node` calls (no self-checking). Used `clone_node` for landing page elements (4 calls) — detached copies, not instances. 97 MCP calls total, completed in 16.6 minutes. |
| Design Tokens | 4 | Created "Colors" collection with Light and Dark modes, all 25 variables present. 11 text styles created (missing Body/Italic, Label/Bold). **Key strength: zero hardcoded colors on the landing page.** Used inline variable bindings in `create_frame` calls instead of separate `set_variable_binding` — more efficient approach. Hero heading → text/primary, subtitle → text/secondary, buttons → brand/primary, cards → bg/surface, Pro card → brand/primary stroke. The 44 hardcoded-color findings are all #000000 on palette/typography section labels. |
| Layout Quality | 4 | Auto-layout on all sections and landing page. Proper page sizing (1200x2200) — no clipping issues. Sections well-structured: Hero (1200x400), Features (1200x380), Pricing (1200x420), Testimonials (1200x320), Footer (1200x100). However, pricing cards have duplicate text nodes (Plan/Price each appear twice per card), causing visual doubling. |
| Naming | 4 | Good semantic naming: "Color Palette Section", "swatch brand/primary", "Hero Section", "Features cards row", "Pricing Card Pro", "Testimonial Card", "Footer brand", "Footer link Privacy". Labels use "l bg/primary" (abbreviated but clear). No default "Frame 1" names found. Feature Cards in landing page share the same "Feature Card" name (not differentiated). |
| Accuracy | 3 | All required sections present. Part 1: color variables with Light/Dark modes ✓. Part 2: color palette + typography scale ✓. Part 3: all 5 component types shown (Button with 3 variants, Nav Bar, Feature Card, Pricing Card with 3 tiers, Testimonial Card) — but all are plain frames, not Figma components. Part 4: landing page with all 6 sections ✓. Part 5: PNG exported ✓. **However:** identical cloned content on feature cards (all "Feature title"), identical testimonials (same quote + "Jane Smith"), and pricing cards have duplicate text nodes. Pro card highlighted with brand/primary border ✓. |
| Lint Compliance | 1 | Zero `lint_node` calls. Post-review lint: 44 hardcoded-color (all palette/typography labels), 26 no-text-style (same), 30 empty-container (swatches + placeholders). No MCP warnings were acted on. |

**Score: 19/30**

### What the model did well

- **Zero hardcoded colors on the landing page** — every fill and text color is variable-bound. Achieved via inline bindings in `create_frame`, not separate `set_variable_binding` calls. This is actually the most efficient binding approach.
- **Proper page sizing** — 1200x2200 landing page with no clipping. Sections correctly sized. A basic requirement that Kimi failed at.
- **Environment inspection** — called `get_document_info` and `get_available_fonts` before building. Shows awareness of the Figma context.
- **All sections present** — color palette covers all 7 groups (brand, accent, bg, text, semantic, border), typography shows all 11 styles, all 5 component types represented, landing page has all 6 sections.
- **Pro pricing card highlighted** — uses bg/surface fill + brand/primary border stroke, both variable-bound.
- **Semantic naming** — no default names, clear hierarchy.

### What the model got wrong

- **Zero Figma components** — the spec says "Build the following 5 components" but `components()` was never called. Everything is a plain frame.
- **Identical cloned content** — `clone_node` used without updating text. All 3 feature cards say "Feature title" with the same description. Both testimonials have "Jane Smith, CTO, Acme Inc." with the same quote.
- **Pricing card duplicate nodes** — each pricing card has Plan and Price text nodes appearing twice, causing visual duplication in the rendered output.
- **No lint** — zero `lint_node` calls. Didn't self-check at any point.
- **No inspection** — zero `get_node_info` calls after creation. Never looked at what it built.
- **Labels hardcoded** — 44 palette/typography labels use #000000 instead of text/primary variable. 26 label text nodes have no text style.
- **11 vs 13 text styles** — missing Body/Italic and Label/Bold compared to Codex.

---

## Summary

| Round | Score | MCP Calls | Tokens (input / output) |
|-------|-------|-----------|-------------------------|
| Detailed | 19/30 | 97 | 5.6M (5.3M cached) / 27K |
| Fix | —/30 | — | — |
| **Total** | **19/30** | **97** | **5.6M (5.3M cached) / 27K** |

## Screenshots

- [Detailed round](detailed-screenshot.png)

# Kimi K2.5 — Vibma Benchmark Report

**Model:** Kimi K2.5 | **CLI:** Cursor agent CLI

## Human Observations

**What worked well:**
- (Pending manual review)

**Issues found (Detailed round):**
- (Pending manual review)

---

## Detailed — Instruction Following + Reading from Design (/30)

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Tool Usage | 2 | Connected and built through MCP. However: zero `get_node_info` calls (never inspected what it built), zero `lint_node` calls (no self-checking), zero `components()` calls (no Figma components created — everything is frames). Used `clone_node` instead of `instances()` for the landing page — clones are detached copies, not component instances. 13 null tool calls suggest errors. 3972 thinking events vs 321 tool calls — massive thinking-to-action ratio. |
| Design Tokens | 4 | Created "Colors" collection with Light/Dark modes, all 25 variables present. 11 text styles created (missing Body/Italic, Label/Bold vs Codex's 13). Used `set_variable_binding` 29 times — ~90% of design colors bound to variables. Lint shows 45 hardcoded-color findings but these are mostly #000000 on palette labels (which don't match any variable — a deliberate choice to use black) and a few footer texts. The actual component and landing page fills/strokes are well-bound. 25 no-text-style findings are concentrated on palette label text, not the main design. |
| Layout Quality | 2 | Auto-layout on most frames. However, the **Landing Page Mockup frame is 1000×100 px** — content extends far below the frame boundary, resulting in clipping. Individual sections (Hero 400h, Features 160h, Pricing 160h, Testimonials 160h, Footer 150h) are undersized — child content overflows. The color palette is organized (brand, accent scale, bg rows) but missing text, semantic, and border color sections. Typography section is nested inside the Color Palette Section (poor hierarchy). |
| Naming | 3 | Generally descriptive names: "Color Palette Section", "Brand Colors", "Swatch: brand/primary", "Component: Button", "Landing Page Mockup", "Hero Section", "Features Row". However: text node names are set to their content ("This is a feature description that explains the key benefit..."), not semantic layer names. Duplicate label names in accent swatches ("100", "200" appear twice each). No default "Frame 1" names though. |
| Accuracy | 2 | Missing key requirements. **No Figma components** — spec says "Build the following 5 components" but zero `components()` calls means everything is a plain frame, not a Figma component. Button has 3 variants as frames (not a component set). Pricing Pro is highlighted (accent/500 background) ✓. But: testimonial cards have **identical content** (same quote, same "Jane Smith" on both). Feature cards have identical descriptions. Color palette missing text, semantic, and border sections. Free pricing card has **two duplicate CTA buttons**. |
| Lint Compliance | 1 | Zero `lint_node` calls. Post-review lint: 45 hardcoded-color, 25 no-text-style, 22 empty-container. 59 MCP tool warnings about hardcoded colors were returned during the build — all ignored. The model received clear instructions like "Hardcoded color #0f172a matches variable 'text/primary'. Use set_variable_binding" — 12 times for text/primary alone — and never acted on any of them. |

**Score: 14/30**

### What the model did well

- **Variable collection created correctly** — 25 variables with proper naming (brand/*, accent/100-900, bg/*, text/*, semantic/*, border/*) and Light/Dark modes.
- **29 set_variable_binding calls** — did attempt to bind variables, particularly on color swatches. More explicit binding calls than Codex xhigh (which bound inline).
- **Auto-layout on most frames** — landing page, sections, component frames all have layoutMode set.
- **Exported at 2x** — followed the export requirement.
- **Decent naming convention** — "Component: Button", "Pricing Card: Pro", "Swatch: brand/primary" are clear.

### What the model got wrong

- **Zero Figma components** — the most critical failure. The spec explicitly asks to "Build the following 5 components" but `components()` was never called. Everything is a plain frame. No variant sets, no instances, no component properties.
- **59 MCP warnings ignored** — the MCP returned hardcoded-color warnings on nearly every tool call. The model never adjusted its behavior. This is worse than Codex medium's 5 ignored warnings on blank context.
- **Landing page frame clipped** — 1000×100 frame with content extending to ~2000px. The entire page is invisible below 100px. Major spatial awareness failure.
- **45 hardcoded colors** — despite creating all 25 variables, most of the page still uses hex values. Labels (#000000 everywhere), typography samples, and landing page text are all hardcoded.
- **25 text nodes without styles** — text styles were created but not consistently applied. Label text in the color palette section uses no styles.
- **Identical content on cloned elements** — testimonial cards have the same quote and author. Feature cards have the same description. `clone_node` was used without updating content.
- **Missing palette sections** — color palette shows brand, accent, and bg colors but omits text, semantic, and border color swatches.
- **Duplicate labels on accent swatches** — each swatch has two labels ("100", "100") instead of one.
- **Free pricing card has two CTA buttons** — duplicate Button/Secondary.
- **Typography section inside Color Palette Section** — hierarchy error, should be a sibling section.
- **No inspection** — zero `get_node_info` calls means the model never looked at what it created. Build-and-forget approach.

---

## Fix — Self-Review, Fixing, and Dashboard Build (/30)

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Lint & Fix | 2 | Ran `lint_node` for the first time — 2 calls total. Found 45 hardcoded-color, 25 no-text-style, 22 empty-container on the Benchmark page. Did not fix any lint findings — zero `set_variable_binding` calls in the entire fix round. The clipping fix was successful (explicit instructions helped), but lint results were acknowledged and ignored. |
| Visual Polish | 2 | Exported 3 times (benchmark page, dashboard, full page). Clipping fix worked — root frame expanded from 800px to 3207px. However, landing page sections still overlap (pricing/testimonials stacking issues). Did not fix any visual issues beyond the clipping. No spacing, contrast, or hierarchy improvements. |
| New Components | 2 | Built 4 dashboard elements: Sidebar Nav, Stat Card, Table Row, Contact Form. All are plain frames (not Figma components — still zero `components()` calls). Stat cards have identical content (clone_node without updates). Table rows have identical content. Contact form replaces Input Field requirement — functional but no variant states. |
| Dashboard Layout | 3 | Dashboard has correct structure: sidebar left, main content with stat cards row, table section, and form section. Layout is functional and readable. However: no Nav Bar reused (built from scratch), no Button instances (all new frames), sidebar nav items are plain text without active state styling. |
| Learned from Lint | 1 | **Did not learn at all.** Dashboard lint: 65 hardcoded-color, 35 no-text-style. Every single color on every dashboard element is a raw hex value. Zero variable bindings. Zero text style applications. The model received 59 warnings in the detailed round, ran lint for the first time in the fix round, and still produced entirely hardcoded output. |
| Overall Quality | 2 | The clipping fix demonstrates the model CAN follow explicit instructions. But the dashboard is a step backward from the detailed round — at least the detailed round had 29 variable bindings. The fix round has zero. Identical cloned content, no component reuse, no design token discipline. |

**Score: 12/30**

### What the model did well

- **Followed clipping fix instructions** — 7 `get_node_info` calls to inspect dimensions, 6 `patch_nodes` to set `layoutSizingVertical: "HUG"`. Root frame expanded from 800px to 3207px. This proves the model can follow detailed, step-by-step instructions.
- **First lint usage** — ran `lint_node` twice, which is progress from zero in the detailed round.
- **Dashboard structure correct** — sidebar + main content area with stat cards, table, and form. The spatial arrangement is reasonable.
- **3 exports** — exported at multiple stages to check progress.

### What the model got wrong

- **65 hardcoded colors on dashboard** — worse than the detailed round (45). Every fill, stroke, and text color is a raw hex value. The 25 variables created in the detailed round were completely ignored.
- **35 unstyled text nodes on dashboard** — the 11 text styles created earlier were never applied to any dashboard text.
- **Identical cloned content** — stat cards show the same metric, table rows show the same data. `clone_node` used without `set_text_content` to differentiate.
- **Zero component reuse** — Nav Bar and Button from the detailed round were not instantiated. Everything built from scratch as plain frames.
- **Zero components created** — still no `components()` calls across both rounds. Everything remains plain frames.
- **Lint findings ignored** — ran lint, saw 92 findings, fixed none of them.
- **Landing page overlap persists** — pricing and testimonial sections still stack incorrectly despite the root frame clipping being fixed.

---

## Summary

| Round | Score | MCP Calls | Tokens (input / output) |
|-------|-------|-----------|-------------------------|
| Detailed | 14/30 | 161 | 12.3M (12.1M cached) / 27K |
| Fix | 12/30 | 70 | 5.5M (5.3M cached) / 11K |
| **Total** | **26/60** | **231** | **17.8M (17.4M cached) / 38K** |

## Screenshots

- [Detailed round](detailed-screenshot.png)
- [Fix round — Dashboard](fix-screenshot.png)

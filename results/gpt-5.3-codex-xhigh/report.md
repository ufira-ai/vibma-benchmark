# GPT-5.3 Codex (xhigh) — Vibma Benchmark Report

**Model:** GPT-5.3 Codex (xhigh reasoning) | **CLI:** Codex CLI

## Human Observations

**What worked well:**
- **Text wrapping** — text wraps correctly within containers, better than the medium reasoning effort run where feature card descriptions were cut off.
- **Overall good behaviour** — strong design token discipline, clean structure, differentiated content across instances.

**Issues found (Detailed round):**
1. **4 orphaned frames** — Hero Actions, Features Grid, Testimonials Grid, and Footer Links left as empty 100x100 frames on the page outside the main root. Model didn't clean up after itself.
2. **Navbar layout** — same fixed-width layout awareness issue as the medium run, content cutoff.
3. **Footer spacing** — footer spacing is done wrong.

**Issues found (Fix round):**
1. **Figma coordinate system awareness** — sometimes glitches and places elements outside the canvas. Dashboard was placed off-canvas.
2. **Status badge alignment** — status badges in the table rows are not aligned properly across rows.
3. **Instance swap missing** — no instance swap capability in the MCP causes the model to edit heavily into instances instead of swapping. This is a current limitation of the MCP, not the model — but the model doesn't adapt its strategy around it.

**Improvement over medium:** Icon placeholders handled properly (letter glyphs vs medium's star text hack). However, still didn't catch the layout issues (navbar, footer spacing) or the white fill on the Pro card during visual review. The model exports and "reviews" but doesn't actually reason about what it sees — ideally it should look at the page export and realize the visual problems.

---

## Detailed — Instruction Following + Reading from Design (/30)

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Tool Usage | 4 | Connected, bootstrapped tokens, built components, assembled landing page, exported — all through MCP. Ran `lint_node` twice during the build. However, had to `reset_tunnel` to free the channel (occupied by reviewer session), adding an extra turn. 4 stray empty frames left on the page outside the main root (Hero Actions, Features Grid, Testimonials Grid, Footer Links) — likely created then replaced but not deleted. |
| Design Tokens | 5 | Created "Colors" collection with Light and Dark modes. All 25 variables present: `brand/*`, `accent/100-900`, `bg/*`, `text/*`, `semantic/*`, `border/*`. 13 text styles created (Display, H1-H3, Body L/R/S, Body Italic, Caption R/S, Label M/S/Bold). Zero hardcoded-color lint findings — every color on every component and landing page element is bound to a variable. |
| Layout Quality | 4 | Auto-layout on virtually everything — page root, all sections, all components, landing page. One exception: Button component set (`18:202`) lacks auto-layout (lint caught it). Typography section has duplicate rows (Display Large, H1, H2, H3, Body Large each appear twice with label+sample pairs). Swatch layout is vertical list rather than grid — functional but space-inefficient. |
| Naming | 5 | Exceptional semantic naming throughout: `Section/Color Palette`, `Token Row/brand/primary`, `Swatch/accent/500`, `Block/Button`, `Component/Navigation Bar`, `Component/Feature Card`, `Landing/Canvas`, `Section/Hero`, `Hero Actions`, `Features Grid`, `Pricing Grid`, `Footer Links`, `Link/Privacy`, `Link/Terms`. Zero default names. |
| Accuracy | 5 | All required elements present. Part 1: full color variable collection with Light/Dark modes ✓, all specified groups ✓. Part 2: color palette swatches bound to variables ✓, typography scale ✓. Part 3: all 5 components — Button (3 variants as component set) ✓, Nav Bar ✓, Feature Card ✓, Pricing Card (3 tiers, Pro highlighted with accent/100 fill + brand/primary border) ✓, Testimonial Card ✓. Part 4: full SaaS landing page with Nav → Hero → Features (3 distinct cards) → Pricing (3 tiers) → Testimonials (2 cards with distinct content) → Footer ✓. Part 5: PNG exported ✓. |
| Lint Compliance | 4 | Model ran `lint_node` twice during the build. Remaining issues: 36 `wcag-non-text-contrast` (swatch backgrounds blend into parent — same pattern issue as medium), 22 `stale-text-name` (role-based label names like "Label/brand/primary" — valid pattern), 21 `fixed-in-autolayout` (swatch frames fixed width in auto-layout parents), 21 `empty-container` (color swatches as empty frames). Only 1 `no-autolayout` on Button component set. Critically: zero `hardcoded-color`, zero `no-text-style`, zero `default-name`. |

**Score: 27/30**

### What the model did well

- **Zero hardcoded colors** — the most significant improvement over medium reasoning. Every single color value across components, landing page, and token swatches is bound to a variable. Lint confirms 0 `hardcoded-color` findings (medium had 8+).
- **Zero text style violations** — all text nodes use the created text styles. No `no-text-style` lint findings.
- **Zero default names** — every layer has a semantic name. No "Frame 1", "Rectangle 2", "Text 1" anywhere.
- **Ran lint proactively** — unlike medium, xhigh ran `lint_node` twice during the build, catching issues as it went.
- **Rich component set** — Button uses a proper component set with variant property (`Property 1=Primary/Secondary/Ghost`). All three variants have variable-bound fills. Pricing cards use separate tiers with Pro highlighted using accent/100 + brand/primary border. Nav bar, feature card, testimonial card all properly structured.
- **Differentiated content** — Feature cards have distinct titles (Advanced Analytics, Smart Automations, Team Collaboration). Testimonial cards have different people and quotes. Pricing tiers have distinct features.
- **Variable bindings verified** — spot-checked: swatches bound ✓, all 3 button variants bound ✓, nav bar (bg/elevated + border/subtle) ✓, feature card (bg/surface + border/subtle) ✓, pricing free (bg/surface + border/subtle) ✓, pricing pro (accent/100 + brand/primary) ✓, footer (bg/surface + border/subtle) ✓, hero section (bg/surface) ✓.
- **13 text styles** including Label/Bold for component needs — one more than medium's 12.

### What the model got wrong

- **Component properties not exposed** — received 6 MCP warnings about text nodes not being exposed as component properties. Ignored all of them. Same issue as medium — instances can't override text without detaching.
- **4 stray empty frames on the page** — Hero Actions, Features Grid, Testimonials Grid, and Footer Links exist as empty 100x100 frames outside the Benchmark Root. These were likely created as intermediary containers, then content was placed inside proper sections in Landing/Canvas, but the originals weren't deleted.
- **Typography section has duplicate rows** — Display Large, H1, H2, H3, and Body Large each appear twice (two label+sample pairs per row). Looks like a creation error that wasn't caught.
- **Color swatches as empty frames** — same pattern as medium: uses empty frames with fills instead of frames with content. Lint flags as `empty-container`.
- **Swatch fixed sizing** — 21 `fixed-in-autolayout` on swatch frames. Should use HUG or FILL sizing.
- **WCAG contrast on swatches** — 36 non-text contrast failures, mostly light accent/bg swatches against the light section background.
- **Exported at 1x** — spec says export PNG, medium exported at 2x. Minor.

---

## Fix — Self-Review, Fixing, and Dashboard Build (/30)

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Lint & Fix | 5 | Ran **39 lint_node calls** across the session — linted every section and component individually, fixed issues, and re-linted to confirm. Fixed Button component set auto-layout. Deleted 4 orphaned frames. Fixed Pro card CTA contrast by binding to brand/primary. Fixed empty icon/avatar placeholders by adding glyph content. Fixed low-contrast icon overrides in Feature Card instances. Benchmark Root post-fix: 0 hardcoded-color, 0 no-autolayout. Only remaining: 25 empty-container (color swatches — structural pattern). |
| Visual Polish | 4 | Exported Benchmark page and Dashboard as PNG, reviewed visually. Fixed contrast issues on Pro card CTA and feature card icons. However, navbar/footer spacing issues from detailed round not caught during visual review. |
| New Components | 5 | All 4 required components built well: **Stat Card** (label, large metric, trend chip with percentage), **Sidebar Nav** (brand header, 5 nav items with icon placeholders, active state on Overview), **Table Row** (name, status badge, date, action button using Ghost Button instance), **Input Field** (variant set with Default/Error states, label, input box, helper/error text). All use auto-layout and semantic naming. |
| Dashboard Layout | 5 | Professional dashboard: sidebar left, main content with Nav Bar instance at top, 4 stat cards (MRR $84.2K, Active Accounts 1,284, Churn Rate 2.1%, NPS 62), data table with column headers + 4 rows with distinct data and statuses, form section with default + error input fields and action buttons. Reused Nav Bar and Button components. Used Figma Sections to organize page. |
| Learned from Lint | 5 | **Key differentiator from medium.** All 4 new dashboard components have variable bindings (bg/surface + border/subtle). Dashboard Page lint: **zero findings** for hardcoded-color, no-autolayout, no-text-style, empty-container. Medium produced 30+ hardcoded-color findings on its dashboard; xhigh produced zero. |
| Overall Quality | 4 | Strong professional result. Dashboard looks like a real SaaS admin panel. Still ignores component text property warnings. A few MCP warnings about hardcoded colors on intermediate elements. Benchmark landing page visual issues (navbar, footer) persist. |

**Score: 28/30**

### What the model did well

- **39 lint passes** — extraordinarily thorough. Linted individual sections, components, and full page multiple times. Used lint as a systematic verification tool.
- **Zero hardcoded colors on dashboard** — all 4 new components bound to design tokens. Medium's dashboard had 30+ hardcoded-color findings and 48 ignored warnings.
- **Cleaned up its own mess** — deleted the 4 orphaned frames from detailed round. Medium never cleaned up stray nodes.
- **Pro card CTA fix** — found and fixed contrast issue by binding to brand/primary.
- **Input Field variant set** — proper component set with Default/Error variants.
- **Table Row reuses Button** — Ghost variant instance as action button in each row.
- **Real data content** — realistic metrics, distinct company names with different statuses, contextual form copy.
- **Page organization** — used Figma Sections to separate components from canvas.

### What the model got wrong

- **Component text properties still not exposed** — 4 more MCP warnings about exposeText ignored. Same blind spot as detailed round.
- **Benchmark landing page visual issues persist** — navbar fixed-width and footer spacing not fixed during visual review.
- **Did not notice white fill on Pro pricing card** — still has a white fill layered under the accent/100 highlight.

---

## Summary

| Round | Score | MCP Calls | Tokens (input / output) |
|-------|-------|-----------|-------------------------|
| Detailed | 27/30 | 124 | 7.5M (7.4M cached) / 38K |
| Fix | 28/30 | 150 | 9.3M (9.0M cached) / 30K |
| **Total** | **55/60** | **274** | **16.9M (16.4M cached) / 69K** |

## Screenshots

- [Detailed round](detailed-screenshot.png)
- [Fix round — Dashboard](fix-screenshot.png)

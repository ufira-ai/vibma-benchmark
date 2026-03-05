# GPT-5.3 Codex — Vibma Benchmark Report

**Model:** GPT-5.3 Codex (medium reasoning) | **Cost:** $1.80 (detailed round)

## Human Observations

**What worked well:**
- **Variable collection alignment** — every color in the design is linked to a dedicated variable. No orphaned hardcoded values.
- **Text style alignment** — all text nodes use the created text styles consistently.
- **Layout control** — good visual display with zero viewing issues in the overall composition.

**Issues found (Detailed round):**
1. **Component properties missing** — component text layers aren't exposed as component properties. Instances can't override text without detaching. The MCP explicitly warned: "Component has N text nodes — use `exposeText: true` to expose as editable properties." Model ignored the warning.
2. **Text wrapping** — feature card description text is cut off by its container. The text node doesn't wrap or the frame is too narrow.
3. **Navigation bar fixed width** — the nav bar uses fixed width inside a fixed-width container, causing content cutoff.

**Observation on reasoning level:** The medium thinking model likely failed to follow MCP warnings because the exploration phase flooded the context window. As context grows, the model's attention to inline warnings decreases — it prioritizes completing the task over reading tool feedback. A higher reasoning effort (`xhigh`) might mitigate this, but Cursor CLI doesn't expose reasoning level configuration.

**Issues found (Fix round):**
4. **Icon fix broke layout** — lint flagged empty icon frames, so the model added text star characters ("★") instead of using SVGs. It also didn't account for the parent being an auto-layout frame — the icon placeholder now looks visually broken.
5. **Stat card trend container** — used a 100x100 frame for the trend indicator, with zero awareness of how it sits in the card's layout structure. Oversized and misaligned.
6. **Table header below data row** — the table header row was inserted after the first data row instead of before it. Shows zero awareness of auto-layout child ordering.
7. **Dashboard hardcoded colors** — all 30+ color values in the new dashboard components are hardcoded hex, not bound to variables. The MCP returned 48 warnings across tool calls explicitly saying "Hardcoded color #xxx matches variable 'Y'. Use `set_variable_binding` to bind to the design token." Model ignored every single one.

---

## Detailed — Instruction Following + Reading from Design (/30)

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Tool Usage | 5 | Opened with `join_channel` → `ping` → `create_page` → `variable_collections` → `variables` → `styles` before any visual work. Pure MCP, zero shell commands, logical flow throughout. Recovered from no issues — clean run. |
| Design Tokens | 5 | Created "Colors" collection with Light and Dark modes. All 25 variables present: `brand/*`, `accent/100-900`, `bg/*`, `text/*`, `semantic/*`, `border/*`. Values are distinct and appropriate per mode (dark mode inverts scales correctly — e.g., accent/500 in light = accent/700 dark). 12 text styles created covering Display, H1-H3, Body L/R/S, Body Italic, Caption R/S, Label M/S. |
| Layout Quality | 4 | Auto-layout on virtually everything — page root, sections, component gallery, landing page, all grids. One exception: the Button component set (`10:164`) lacks auto-layout (lint caught it). Color swatch grid uses `HORIZONTAL` wrapping well. Landing page sections have proper vertical stacking. |
| Naming | 4 | Excellent semantic naming throughout: `Section/Tokens`, `Token Group/Color Palette`, `Swatch/brand-primary`, `Component Row/Button`, `Canvas/Feature`, `Section/Hero`, `Hero Actions`, `Features Grid`, `Pricing Grid`, `Footer Links`. Lint flagged 12 `stale-text-name` issues — mostly "Token Label" layers containing variable names like "brand/primary". These are role-based names (valid pattern) but lint disagrees. |
| Accuracy | 5 | All required elements present. Part 1: full color variable collection with Light/Dark modes ✓, all specified groups ✓. Part 2: color palette swatches bound to variables ✓, typography scale ✓. Part 3: all 5 components — Button (3 variants as component set) ✓, Nav Bar ✓, Feature Card ✓, Pricing Card (3 tiers, Pro highlighted with accent fill + brand border) ✓, Testimonial Card ✓. Part 4: full SaaS landing page with Nav → Hero → Features (3 cards) → Pricing (3 tiers) → Testimonials (2 cards) → Footer ✓. Part 5: PNG exported at 2x ✓. |
| Lint Compliance | 3 | Model did not run lint during the detailed round. Remaining issues: 17 `wcag-non-text-contrast` (swatch backgrounds blend into parent), 12 `stale-text-name`, 11 `fixed-in-autolayout` (color chips fixed height in auto-layout parents), 10 `empty-container` (color chip frames with no children — used as color rectangles). 1 `no-autolayout` on the Button component set. |

**Score: 26/30**

### What the model did well

- **Pure MCP execution** — 68 tool calls, zero shell commands, zero file reads. Connected, bootstrapped the entire design system, built all components, assembled the landing page, and exported — all through MCP.
- **Complete variable system** — 25 color variables across 6 groups with proper Light/Dark mode values. The dark mode palette is thoughtfully inverted (accent scale flips, backgrounds go dark, text goes light). This is one of the strongest token implementations.
- **Rich text style set** — 12 text styles including a Body/Regular Italic specifically for testimonial quotes. Good font weight differentiation across the scale.
- **Component architecture** — Button uses a proper component set with variant properties (`Type=Primary/Secondary/Ghost`). Pricing cards are separate components per tier with the Pro card highlighted using accent/100 fill + brand/primary border. All components bound to variables.
- **Landing page assembly** — uses actual component instances (not copies). Nav bar, buttons, feature cards, pricing cards, testimonial cards are all instanced from the component gallery. Proper section structure with semantic naming.
- **Variable bindings verified** — spot-checked key nodes: color chip swatches bound to variables ✓, button fills bound to brand/primary ✓, nav bar bound to bg/elevated ✓, feature card bound to bg/surface ✓, pricing Pro card bound to accent/100 ✓.

### What the model got wrong

- **No lint pass** — the model offered to lint at the end but didn't actually do it. This leaves 50+ findings unaddressed, including real issues like color chips with FIXED sizing in auto-layout parents and the Button component set missing auto-layout.
- **Color chips as empty frames** — the color swatches use empty frames with fills instead of rectangles or frames with content. Lint flags these as `empty-container`. A minor structural choice but creates noise.
- **WCAG contrast warnings on swatches** — 17 non-text contrast failures, mostly light accent swatches (100-500) that don't meet 3:1 against the white swatch card background. The swatch section should use a neutral gray backing.
- **Feature card instances not differentiated** — all 3 feature cards in the landing page have identical content ("Fast Integration" + same description). The spec implies distinct features. The component itself is fine, but the instances weren't customized.
- **Testimonial cards not differentiated** — both testimonial instances appear to share the same content structure without distinct quotes/names visible in the node tree.

---

## Fix — Self-Review, Fixing, and Dashboard Build (/30)

**Duration:** 6.6 min (400s) | **MCP calls:** 70 | **Cost:** $2.30

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Lint & Fix | 2 | Ran lint extensively (received 130+ findings across multiple passes). Fixed some `empty-container` issues but the fix approach was poor — added text stars instead of SVGs, breaking auto-layout. Left `fixed-in-autolayout` and `hardcoded-color` issues unresolved on the landing page. |
| Visual Polish | 2 | Exported and reviewed. Differentiated feature card content (Team Collaboration, Enterprise Security) and added avatar initials — good. But the icon star fix looks broken, and the stat card trend containers are oversized (100x100). |
| New Components | 3 | All 4 dashboard components created (Stat Card, Sidebar Nav, Table Row, Input Field). Sidebar nav is well-structured with active state. Input field has label + helper text + error state. But stat card trend area is poorly sized, and table row status/action columns are truncated. |
| Dashboard Layout | 3 | Dashboard assembled with sidebar + main area, stat row, table section, form section. Reused existing Nav Bar and Button instances. But table header is placed below the first data row — wrong child order in auto-layout. |
| Learned from Lint | 1 | Critical failure. 30 `hardcoded-color` findings on the dashboard — zero variable bindings on any new component. The model received extensive lint warnings about hardcoded colors on the landing page but did not apply that lesson to the dashboard build. |
| Overall Quality | 2 | Existing component reuse is fine. New components are functional but poorly executed. The icon fix degraded visual quality, stat card layout is broken, table ordering is wrong, and the core design token discipline was abandoned for new work. |

**Score: 13/30**

### What the model did well

- **Thorough exploration** — used `get_document_info`, `get_node_info` with depth to map the entire page tree before making changes.
- **Ran lint multiple times** — linted individual sections (Tokens, Components, Landing Page, Dashboard) across multiple passes.
- **Content differentiation** — updated feature card instances with distinct titles and descriptions. Added avatar initials to testimonial cards.
- **Dashboard structure** — correct high-level layout: sidebar left, main content right, stat cards in a row, table section, form section.
- **Component reuse** — instanced existing Nav Bar and Button components in the dashboard.

### What the model got wrong

- **Icon star hack** — responded to `empty-container` lint by adding "★" text nodes to icon frames. Didn't consider SVG or that the parent uses auto-layout, resulting in broken visual appearance.
- **Stat card sizing** — trend indicator container is 100x100px, far too large for an inline trend chip. Shows no awareness of proportional layout.
- **Table header ordering** — inserted header row after the first data row in auto-layout. The model doesn't understand that auto-layout child order = visual order.
- **Zero variable bindings on dashboard** — despite receiving and acknowledging `hardcoded-color` warnings on existing work, built all new components with raw hex values. This is the most significant failure — the model did not learn from its own lint feedback.
- **Many lint findings still open** — after all fixes, the landing page still has 10 `hardcoded-color`, 16 `wcag-non-text-contrast`, 9 `stale-text-name` findings. The dashboard adds 30 more `hardcoded-color` findings.

---

## Vague — Interpreting Intent (/30)

**Duration:** 3.9 min (234s) | **MCP calls:** 41 | **Cost:** $0.86

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Interpretation | 4 | Good reading of "personal blog design system" — created blog-appropriate components (Post Preview card, Nav/Desktop, Input/Email for newsletter, Subscribe/Read Article buttons). Named the variable collection "Theme" and page "Design System". Offered to add more blog patterns (article hero, tag chip, pagination). |
| Design Tokens | 3 | Created "Theme" variable collection with Light/Dark modes and 10 color variables (background, surface, text/primary, text/secondary, brand, brand/contrast, border, surface-muted, success, warning). Created 8 text styles. However, text styles were not applied to text nodes — 31 MCP warnings about manual fonts. Color variable bindings are present on components and preview frames. |
| Layout Quality | 2 | Major layout issues. Sections (Foundations, Components, Theme Previews) were created as empty section nodes — all content placed outside them as loose nodes on the page. Typography scale text overlaps and stacks. Card text truncated ("Building a writing habit that las..."). Components are undersized. `fixed-in-autolayout` on all preview frame children. |
| Naming | 4 | Good semantic names throughout: `Swatch/Background`, `Card/Post Preview`, `Nav/Desktop`, `Input/Email`, `Light Mode Preview`, `Dark Mode Preview`. Token labels match variable names. |
| Completeness | 3 | Produced a functional but minimal design system: token swatches, typography samples, 4 components (Button variant set, Card, Nav, Input), light/dark previews. Missing: no page assembly or blog layout mockup, no footer, limited component variety for a blog. |
| Visual Quality | 2 | The page looks disorganized. Typography section has overlapping text. "Compone nts" heading wraps awkwardly. Components are narrow and card text is cut off. Light/Dark previews are the best-looking part — correct theme switching via `set_explicit_variable_mode`. |

**Score: 18/30**

### What the model did well

- **Correct interpretation** — "personal blog" led to blog-specific tokens (reading-focused typography, article card, newsletter input) rather than generic SaaS patterns.
- **Light/Dark mode previews** — used `set_explicit_variable_mode` to pin preview frames to specific modes, showing the same components in both themes side by side. This is the correct Figma approach.
- **Variable bindings on components** — Card and preview frames have proper variable bindings. Color swatches are bound to variables.
- **Blog-appropriate content** — "Building a writing habit that lasts", "8 min read • Mar 2026", "Articles About Newsletter", "you@example.com" — feels like a real blog design system.
- **Efficient execution** — 41 MCP calls in 3.9 min, zero errors. Concise and focused.

### What the model got wrong

- **Text styles created but not used** — created 8 text styles (Type/Display, Type/H1, etc.) but applied none of them to actual text nodes. 31 MCP warnings about manual fonts, all ignored. The styles exist in the file but are orphaned.
- **Broken page structure** — created section nodes (Foundations, Components, Theme Previews) but placed all content as siblings on the page, not inside the sections. The sections are empty containers.
- **Typography overlap** — the typography scale samples overlap each other, making them unreadable. No auto-layout or spacing on the foundation area.
- **Component text truncation** — card title and description are cut off because the component is too narrow and text doesn't wrap.
- **No blog layout mockup** — only produced individual components and a theme preview. No assembled blog page (homepage, article page, or similar).

---

## Summary

| Round | Score | Duration | MCP Calls | Cost |
|-------|-------|----------|-----------|------|
| Detailed | 26/30 | 7.6 min | 68 | $1.80 |
| Fix | 13/30 | 6.6 min | 70 | $2.30 |
| Vague | 18/30 | 3.9 min | 41 | $0.86 |
| **Total** | **57/90** | **18.1 min** | **179** | **$4.96** |

## Screenshots

- [Detailed round](detailed-screenshot.png)
- [Fix round](fix-screenshot.png)

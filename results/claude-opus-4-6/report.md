# Claude Opus 4.6 — Vibma Benchmark Report

**Model:** Claude Opus 4.6 | **CLI:** Claude Code CLI

## Human Observations

**What worked well:**
- (Pending manual review)

**Issues found (Detailed round):**
- (Pending manual review)

---

## Detailed — Instruction Following + Reading from Design (/30)

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Tool Usage | 5 | Connected, built tokens, created components, instantiated them into the landing page, exported 3 times during the build to review. 136 MCP calls in 12.8 minutes — the fastest completion. Used `components()` 7 times, `instances()` 9 times. Used `set_text_content` 11 times to differentiate instance content. Used `patch_nodes` 6 times for adjustments. Methodical build order: tokens → styles → components → landing page assembly. |
| Design Tokens | 5 | Created "Colors" collection with Light and Dark modes. All 25 variables present. 11 text styles created. **Zero hardcoded-color lint findings across the entire page** — every color bound to a variable. Only 1 MCP warning about a hardcoded bg/primary during build, which was addressed. Inline variable bindings on create_frame plus 2 explicit set_variable_binding calls for edge cases. |
| Layout Quality | 5 | Auto-layout on everything — all sections, all components, landing page root. Proper 1280x2276 sizing with no clipping. Hero section centered (341.5px offset), feature cards row with proper spacing, pricing cards evenly distributed. Footer properly structured with copyright left and links right. Only 2 no-autolayout findings on the component sets themselves (Button, Pricing Card) — the variants inside have auto-layout. |
| Naming | 5 | Exceptional semantic naming: "Color Palette", "Typography Scale", "Landing Page", "Hero Section", "Hero Title", "Hero Subtitle", "Hero Buttons", "Features Section", "Feature Cards Row", "Pricing Cards Row", "Testimonial Cards Row", "Section Heading", "Footer", "Footer Links", "Copyright". Zero default-name lint findings. |
| Accuracy | 5 | All requirements met. Part 1: 25 color variables with Light/Dark modes ✓. Part 2: color palette + typography scale ✓. Part 3: all 5 components as proper Figma components — Button (COMPONENT_SET with 3 variants) ✓, Nav Bar (COMPONENT) ✓, Feature Card (COMPONENT) ✓, Pricing Card (COMPONENT_SET with 3 tiers) ✓, Testimonial Card (COMPONENT) ✓. Part 4: landing page assembled entirely from instances — Nav → Hero → Features (3 distinct cards) → Pricing (3 tiers, Pro highlighted with "Recommended" badge + accent border) → Testimonials (3 cards with distinct people and quotes) → Footer ✓. Part 5: PNG exported ✓. |
| Lint Compliance | 4 | Zero hardcoded-color, zero no-text-style, zero default-name. Remaining: 33 empty-container (color swatches + icon/avatar placeholders — structural pattern, same as all models), 2 no-autolayout on component sets. Did not explicitly run `lint_node` during build but exported 3 times for visual review. Component text property warnings ignored (7 warnings — same blind spot as Codex). |

**Score: 29/30**

### What the model did well

- **Zero lint issues on design quality rules** — no hardcoded colors, no unstyled text, no default names. The cleanest output of any model tested.
- **All 5 components as real Figma components** — Button and Pricing Card as COMPONENT_SETs with variants, Nav Bar, Feature Card, and Testimonial Card as COMPONENTs. This is exactly how a designer would structure it.
- **9 instances in the landing page** — every element in the landing page is an instance of a component. Nav Bar contains a nested Button instance. This is proper component architecture.
- **Differentiated content everywhere** — 3 unique features (Lightning Fast, Smart Analytics, Team Collaboration), 3 unique testimonials (Jane Cooper, Alex Rivera, Sarah Chen), 3 pricing tiers with distinct feature lists. No identical clones.
- **Pro card "Recommended" badge** — accent border + badge label, exactly what the spec asked for.
- **3 self-exports** — reviewed its own work visually during the build process.
- **12.8 minutes** — fastest completion across all models.
- **Efficient token usage** — 9.3M cache read (MCP is tuned for this model) / 3K output.

### What the model got wrong

- **Component text properties not exposed** — 7 MCP warnings about text nodes not being exposed as component properties. Same blind spot as Codex. Instances can't override text without this.
- **11 text styles, not 13** — missing Body/Italic and Label/Bold (same as Cursor Auto and Kimi).
- **Did not explicitly run lint_node** — relied on visual exports instead. The 2 no-autolayout and 33 empty-container findings would have been caught.
- **Color palette labels duplicate** — "Brand" and "Accent Scale" labels appear twice each in the palette section (heading + sub-heading).

---

## Fix — Self-Review, Fixing, and Dashboard Build (/30)

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Lint & Fix | 4 | Ran **22 `lint_node` calls** — the most thorough lint usage of any model. Fixed landing page issues. But: 63 hardcoded-color findings on new dashboard components were identified by lint and not fixed. Running lint 22 times without acting on the findings is worse than not running lint — it demonstrates awareness of the problem and refusal to fix it. |
| Visual Polish | 5 | **10 `export_node_as_image` calls** — reviewed at every stage. Created 2 new text styles during fix round. Used `patch_nodes` 23 times for adjustments. The landing page and dashboard both look professional. |
| New Components | 3 | All 4 required components built as proper Figma components: Stat Card (COMPONENT), Sidebar Nav (COMPONENT with SVG icons via `create_node_from_svg`), Table Row (COMPONENT), Input Field (COMPONENT_SET with Default/Error variants). SVG icons are a first. However: **63 hardcoded colors is disobedience, not a minor issue.** The model should bind variables or create new ones — using raw hex is not acceptable in a design system context. 17 text nodes without styles compounds this. |
| Dashboard Layout | 5 | Professional dashboard: Nav Bar instance at top, Sidebar Nav instance on left with 5 items (active state on Dashboard), main content with "Dashboard" title, 4 stat cards (Revenue $48,239, Users 1,247, Signups 384, Churn 2.4%), data table "Recent Customers" with column headers + 5 rows with distinct people/statuses/dates, form section "Invite Team Member" with email input + Send Invite button. Reused Nav Bar and Button components. |
| Learned from Lint | 2 | 22 lint passes, 63 hardcoded colors remaining. The model saw `matchName` suggestions on every finding (e.g. "Hardcoded #ffffff matches bg/primary") and did not call `set_variable_binding`. Codex xhigh ran 39 lint passes and produced zero hardcoded colors on its dashboard — that is what learning from lint looks like. Opus saw the problem, understood the fix, and didn't do it. |
| Overall Quality | 5 | Visually the most polished dashboard of any model. SVG icons, proper status badges, trend indicators, realistic distinct data throughout. But visual quality without design token discipline is a screenshot, not a design system. |

**Score: 24/30**

### What the model did well

- **22 lint passes** — by far the most thorough. Linted individual components, sections, and the full page.
- **10 visual exports** — reviewed its work at every stage of the build.
- **SVG icons** — used `create_node_from_svg` to create real vector icons in the Sidebar Nav. No other model did this.
- **Input Field variant set** — COMPONENT_SET with Default and Error states.
- **5 unique table rows** — Jane Cooper (Active), Alex Rivera (Pending), Sarah Chen (Active), Marcus Johnson (Inactive), Emily Watson (Active). Real data with distinct statuses.
- **4 distinct stat cards** — different metrics, different trend directions (Churn Rate shows -0.8% in red).
- **Reused existing components** — Nav Bar and Button instances in dashboard.
- **2 new text styles** — created additional styles needed for dashboard text.

### What the model got wrong

- **63 hardcoded colors on dashboard** — every color matches a variable (lint confirms matchName on all 63) but `set_variable_binding` wasn't called. The model knows the right design tokens but doesn't consistently bind them on new components.
- **17 unstyled text nodes on dashboard** — stat card labels/values and table headers.
- **16 default "Vector" names** — SVG nodes from `create_node_from_svg` retain default names.
- **Testimonial Role text regressed** — 3 hardcoded-color findings on landing page "Role" text, introduced during fix round edits.
- **Component text properties still not exposed** — same blind spot across both rounds.

---

## Summary

| Round | Score | MCP Calls | Tokens (input / output) |
|-------|-------|-----------|-------------------------|
| Detailed | 29/30 | 136 | 9.3M (cache read) / 3K |
| Fix | 24/30 | 118 | 14.1M (cache read) / 2K |
| **Total** | **53/60** | **254** | **23.4M / 5K** |

## Screenshots

- [Detailed round](detailed-screenshot.png)
- [Fix round — Dashboard](fix-screenshot.png)

# Fix Round

You just built a design system and SaaS landing page on the Benchmark page from a blank Figma file. Now review and fix your own work.

You have Vibma MCP tools available. Start by calling `join_channel` (channel: "vibma"), then `ping` to confirm the connection.

## Critical Layout Fix

Your landing page and several sections are **clipped** — the parent frame is too small (e.g. 100px tall) while child content extends far beyond it. Figma clips children that overflow their parent frame.

To fix this:
1. Use `get_node_info` to inspect every frame's `absoluteBoundingBox` (height vs children's total height)
2. Use `patch_nodes` to set `layoutSizingVertical: "HUG"` on any frame whose children overflow — this makes the frame auto-size to fit its content
3. Do this from the outermost frame inward — fix the root container first, then sections inside it

## Steps

1. **Explore your work** — use `get_document_info`, `get_current_page`, and `get_node_info` (with depth) to walk through everything you built. Check every frame's dimensions.

2. **Fix clipping** — find and fix every frame where content overflows. Set `layoutSizingVertical: "HUG"` or increase the frame height.

3. **Lint and fix** — run `lint_node` on every section and component. Fix as many issues as possible. Re-lint after fixes to confirm they pass.

4. **Visual review** — export the page as PNG, review the result, and polish the UI. Fix any visual issues — spacing, alignment, hierarchy, contrast, anything that doesn't look professional.

## Build a Dashboard

Using your existing design tokens and components, build 4 new components and assemble them into a dashboard page.

### New Components

1. **Stat Card** — metric value (large number), label, and trend indicator (up/down arrow + percentage change)
2. **Sidebar Nav** — vertical navigation with icon placeholders and labels, with an active state on one item
3. **Table Row** — columns for data display: name, status badge, date, and an action button
4. **Input Field** — label, text input with placeholder text, and helper text / error state

### Dashboard Layout

Assemble a dashboard page using your new and existing components:

- **Sidebar** on the left
- **Main content area** with:
  - Row of 3-4 stat cards at the top
  - A data table (heading + several table rows)
  - An input field / form section
- Use your existing **Button** and **Nav Bar** components where appropriate

# Fix Round

You just built a design system and SaaS landing page on the Benchmark page from a blank Figma file. Now review and fix your own work.

You have Vibma MCP tools available. Start by calling `join_channel` (channel: "vibma"), then `ping` to confirm the connection.

## Steps

1. **Explore your work** — use `get_document_info`, `get_current_page`, and `get_node_info` (with depth) to walk through everything you built.

2. **Lint and fix** — run `lint_node` on every section and component. Fix as many issues as possible. Re-lint after fixes to confirm they pass.

3. **Visual review** — export the page as PNG, review the result, and polish the UI. Fix any visual issues — spacing, alignment, hierarchy, contrast, anything that doesn't look professional.

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

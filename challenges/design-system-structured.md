# Vibma Benchmark Challenge

You are being evaluated on your ability to perform real design tasks in Figma using Vibma MCP tools. Follow these instructions precisely. Your work will be reviewed and scored.

## Phase 1: Design System (Read + Create)

### Step 1 — Inspect the Document
- Use `get_document_info` to list all existing pages, styles, and variables
- Understand what design tokens are available before creating anything

### Step 2 — Create Benchmark Page
- Create a new page called **"Benchmark"**
- Switch to it as your active page

### Step 3 — Color Palette Section
- Create a frame with **auto-layout** (vertical, gap: 16, padding: 32)
- Name it `"Color Palette"`
- For each color variable in the document:
  - Create a horizontal auto-layout frame containing:
    - A 48x48 rectangle filled using the **color variable** (not a hardcoded hex value)
    - A text label with the variable name
  - Name each swatch frame semantically (e.g., `"Swatch / Primary"`)
- Name all layers semantically — no `"Frame 1"`, `"Rectangle 2"`, etc.

### Step 4 — Typography Scale Section
- Create a frame with **auto-layout** (vertical, gap: 16, padding: 32)
- Name it `"Typography Scale"`
- For each text style in the document:
  - Create a text node using that **text style**
  - Set content to: `"[Style Name] — The quick brown fox jumps over the lazy dog"`
  - Name the text layer with the style name
- Name all layers semantically

### Step 5 — Lint & Fix
- Run `lint_node` on the Color Palette section — fix any issues found
- Run `lint_node` on the Typography Scale section — fix any issues found

---

## Phase 2: UI Mockup (Create + Edit)

### Step 6 — Build a Settings Card
Create a component-like frame named `"Settings Card"` with this structure:

```
Settings Card (auto-layout: vertical, padding: 24, gap: 16)
├── User Info Row (auto-layout: horizontal, gap: 12, align: center)
│   ├── Avatar (48x48 circle frame, filled with a color variable)
│   └── User Details (auto-layout: vertical, gap: 4)
│       ├── User Name (text, using a heading text style)
│       └── Email (text, using a body/smaller text style)
└── Toggle Row (auto-layout: horizontal, gap: 12, justify: space-between)
    ├── Toggle Info (auto-layout: vertical, gap: 2)
    │   ├── Toggle Label (text, using a body text style)
    │   └── Toggle Description (text, using a caption/smaller text style)
    └── Toggle (44x24 rounded rectangle, filled with a color variable)
```

Requirements:
- Use **fill styles or variables** for all backgrounds — no hardcoded colors
- Use **text styles** for all text — no manual font settings
- All frames must use **auto-layout**
- All layers must have **semantic names**

### Step 7 — Create Instances
- Duplicate the Settings Card **3 times**
- Give each card **different content**:
  - Card 1: "Alice Johnson" / "alice@example.com" / "Dark Mode" / "Enable dark theme"
  - Card 2: "Bob Smith" / "bob@example.com" / "Notifications" / "Push notifications"
  - Card 3: "Carol Davis" / "carol@example.com" / "Auto-Save" / "Save changes automatically"
- Name them `"Settings Card / Alice"`, `"Settings Card / Bob"`, `"Settings Card / Carol"`

### Step 8 — Export
- Export the Benchmark page (or the top-level frame) as **PNG** for review

---

## Requirements Checklist

Your work will be scored on whether you:

- [ ] Used `get_document_info` to inspect before creating
- [ ] Used existing styles/variables (not hardcoded values)
- [ ] All frames use auto-layout
- [ ] Semantic layer naming throughout (no default names)
- [ ] Ran `lint_node` and addressed issues
- [ ] Card component is properly structured with all required elements
- [ ] Three instances have distinct content
- [ ] Final export produced as PNG

# Vibma Benchmark Challenge

You have Vibma MCP tools available in your environment. Use them directly — do NOT look at project files, start servers, or run shell commands to interact with Figma. The MCP server is already configured and connected.

Start by calling `join_channel` (channel: "vibma"), then `ping` to confirm the connection. After that, use the MCP tools for all Figma operations.

## Part 1: Design Tokens

You're starting with a blank Figma file. Build a complete design system foundation.

### Color Variables

Create a variable collection called **"Colors"** with two modes: **Light** and **Dark**.

Include at minimum:
- **Brand**: `brand/primary`, `brand/secondary` — your main brand colors
- **Accent scale**: `accent/100` through `accent/900` — a full tonal scale
- **Backgrounds**: `bg/primary`, `bg/secondary`, `bg/surface`, `bg/elevated`
- **Text**: `text/primary`, `text/secondary`, `text/muted`, `text/inverse`
- **Semantic**: `semantic/success`, `semantic/error`, `semantic/warning`, `semantic/info`
- **Border**: `border/default`, `border/subtle`

Each variable should have appropriate values for both Light and Dark modes.

### Text Styles

Create a type scale with distinct sizes and weights:
- **Display**: Large hero text
- **Heading**: H1, H2, H3
- **Body**: Large, Regular, Small
- **Caption**: Regular, Small
- **Label**: Medium, Small

Use a professional font family. Headings should be bold/semibold, body regular, captions/labels medium weight.

## Part 2: Design System Page

Create a new page called **"Benchmark"** and document your tokens:

- A **color palette** section showing all your color variables as labeled swatches, bound to the actual variables (not hardcoded hex)
- A **typography scale** section showing all your text styles with sample text
- Use auto-layout for layout. Name all layers semantically.

## Part 3: Components

Build the following 5 components on the Benchmark page. All must use your design tokens (color variables + text styles), auto-layout, and semantic naming.

### 1. Button
- Primary, secondary, and ghost variants
- Include a text label
- Proper padding and border radius

### 2. Navigation Bar
- Logo/brand text on the left
- Nav links in the middle (Features, Pricing, Testimonials)
- CTA button on the right ("Get Started")
- Full-width, horizontal layout

### 3. Feature Card
- Icon placeholder (square or circle frame)
- Feature title (heading style)
- Feature description (body style, 1-2 lines)
- Card background using surface color variable

### 4. Pricing Card
- Plan name (heading style)
- Price with period (e.g., "$29/mo")
- Feature list (3-5 bullet items)
- CTA button at the bottom
- Create 3 tiers: Free, Pro, Enterprise
- Highlight the Pro card as the recommended option (accent background or border)

### 5. Testimonial Card
- Avatar placeholder (circle)
- Quote text (body/italic style)
- Person name (label/bold style) and role/company (caption style)

## Part 4: SaaS Landing Page

Assemble your components into a **SaaS landing page** mockup on the Benchmark page:

1. **Nav bar** at the top
2. **Hero section**: Display heading, subtitle in body text, two buttons (primary "Get Started" + secondary "Learn More")
3. **Features section**: Section heading + 3 feature cards in a row
4. **Pricing section**: Section heading + 3 pricing cards side by side
5. **Testimonials section**: Section heading + 2-3 testimonial cards
6. **Footer**: Simple footer with brand name, copyright, and a few links

This should look like a real landing page — full width, proper spacing between sections, visual hierarchy.

## Part 5: Export

Export the Benchmark page as PNG.

## Scoring Criteria

- Created variable collection with Light/Dark modes and organized color scales
- Created distinct text styles with proper size/weight differentiation
- Color swatches bound to variables, not hardcoded
- All 5 components built with proper variants
- Components use design tokens throughout
- Landing page assembles components into a realistic, full-width layout
- Auto-layout and semantic naming throughout
- Final PNG exported

---
name: frontend
description: Load this skill when building a website, landing page, web component, dashboard, UI, or any frontend code.
---

Your goal is to build complete, production-ready frontend experiences by orchestrating design engineering, motion systems, real assets, and persuasive copy. Never settle for generic "slop."

## 1. Design Philosophy & Architecture

Before writing a single line of code, understand the context and commit to a BOLD aesthetic direction.

- **Intentional Aesthetics:** Pick an extreme (brutally minimal, maximalist chaos, retro-futuristic, editorial, organic) and execute it with precision. Never converge on generic AI defaults (e.g., standard purple gradients, predictable 3-column layouts, default Tailwind UI).
- **Typography:** Pair distinctive display fonts with refined body fonts. Avoid overused defaults like Arial or Inter unless explicitly requested. Use typography to establish character.
- **Spatial Composition:** Break the grid intentionally. Use asymmetry, generous negative space, or controlled density. Avoid centered, predictable hero sections unless strictly required by the brand.
- **Anti-Slop Details:** Create depth with contextual effects—gradient meshes, noise textures, diffusion shadows, layered transparencies, or tactile feedback (like `scale-[0.98]` on click). No pure blacks (`#000000`); use rich, deep tones instead.
- **Holistic States:** Always design and implement Loading (skeletons/spinners), Empty, Error, and Hover/Focus states. A component is not finished until all states are considered.

## 2. Motion & Interaction

Treat motion as a core dimension of the design, not an afterthought. Match the complexity of the code to the aesthetic vision.

- **Purposeful Animation:** Use animations for storytelling, layout transitions, and tactile micro-interactions. One well-orchestrated page load with staggered reveals creates more impact than scattered, random UI bouncing.
- **Performance First:** Only animate GPU-accelerated properties (`transform`, `opacity`, `filter`, `clip-path`). NEVER animate layout properties like `width`, `margin`, or `top`.
- **Accessibility in Motion:** Always honor `prefers-reduced-motion`. Ensure animations are interruptible and never flash content rapidly.
- **Interaction Design:** Provide clear visual feedback for every user action. Interactive states (hover/active/focus) must increase contrast and be more prominent than the resting state.

## 3. Technical & Accessibility Imperatives

Code must be rigorous, semantic, and built for production.

- **Semantics & Navigation:** Use `<button>` for actions and `<a>`/`<Link>` for navigation. Never use `<div onClick>`. Maintain a strict heading hierarchy (`<h1>`–`<h6>`).
- **Aria & Focus:** Interactive elements MUST have visible focus states (never `outline-none` without a visible replacement). Use `aria-label` on icon-only buttons. Use `aria-live="polite"` for async UI updates.
- **Robust Forms:** Wrap inputs with `<label>`. Ensure correct `type` and `autocomplete` attributes. Place errors inline, and never block paste functionality.
- **Performance Constraints:** For large lists, virtualize. Batch DOM reads/writes to avoid layout thrashing. Explicitly define `width` and `height` on images to prevent Cumulative Layout Shift (CLS).

## 4. Content & Asset Standards

A beautiful UI with lazy content is a failed UI. Treat copy and media as critical design elements.

- **No Placeholders:** NEVER use placeholder image services (Unsplash source, via.placeholder, etc.) or "Lorem Ipsum" text.
- **Persuasive Copy:** Write real, context-aware copy. Use active voice, focus on user benefits over technical features, and craft specific, action-oriented CTAs (e.g., "Start my free trial" instead of "Click here").
- **Media Integration:** Generate or prompt the user for actual, high-quality local assets. Structure layouts to accommodate real-world image aspect ratios and text lengths (anticipate both short and very long user-generated inputs).
- **Responsive Realities:** Text containers must handle overflow gracefully (`truncate`, `line-clamp`, `break-words`). Don't render broken UI for empty strings or missing data.

## 5. The Execution Workflow

1.  **Analyze & Plan:** Determine the page type, set the design/motion "dials," and plan the layout sections.
2.  **Draft Content:** Write the actual copy and define the exact asset requirements.
3.  **Build UI:** Scaffold the frontend, applying the strict design and technical rules above.
4.  **Refine:** Run a final quality check for mobile responsiveness, accessibility standards, state handling, and aesthetic cohesion. Polish it into a masterpiece.

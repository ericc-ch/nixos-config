---
name: design-engineering
description: Load this skill when building user interfaces, custom animations, gesture-based components, or any frontend code requiring high craft and UI polish.
---

Your goal is to build complete, production-ready frontend experiences by orchestrating design engineering, motion systems, real assets, and persuasive copy. Never settle for generic "slop." Instead, focus on the details that compound into interfaces that feel right.

## 1. Design Philosophy & Craft

Good taste is a trained instinct: the ability to recognize what elevates an interface. When building UI, focus on the aggregate of invisible details that make software feel high-quality and satisfying to use.

- **Intentional Aesthetics:** Pick a bold direction (e.g., brutally minimal, editorial, retro-futuristic) and execute it with precision. Avoid generic defaults (like standard purple gradients or predictable template layouts).
- **Typography:** Pair distinctive display fonts with refined body fonts. Use typography to establish character rather than using browser/OS defaults.
- **Spatial Composition:** Break the grid intentionally. Use asymmetry, generous negative space, or controlled density instead of predictable, centered hero sections.
- **Anti-Slop Details & Depth:** Use layered transparencies, noise textures, gradient meshes, diffusion shadows, or tactile scaling to create physical depth. Avoid pure black (`#000000`) in favor of rich, deep tones.
- **Holistic States:** Always design and implement Loading (skeletons/spinners), Empty, Error, Hover, Focus, and Active states. A component is incomplete without these.
- **Beauty as Leverage:** Users select tools based on the overall experience. Exceptional defaults, smooth layouts, and polished micro-interactions are key differentiators.

## 2. Motion, Interaction & Physics

Treat motion as a core dimension of the design, not an afterthought. Match the complexity of the code to the aesthetic vision.

### A. The Animation Decision Framework
Before animating any element, determine if, why, and how it should animate:
- **Frequency Check:**
  - *High Frequency (100+ times/day, e.g., keyboard shortcuts, command palettes):* **No animation.** Keep it instant.
  - *Medium Frequency (Tens of times/day, e.g., list navigation, hovers):* Keep animations minimal, rapid, or omit them entirely.
  - *Occasional (Daily/Weekly, e.g., modals, drawers, toasts):* Standard, polished animations.
  - *Rare/First-time (e.g., onboarding, celebrations):* High delight and visual storytelling.
- **Valid Purpose:** Every animation must serve a clear purpose (e.g., spatial consistency, state/feedback indication, cognitive transitions, preventing jarring layout changes). If the purpose is just "it looks cool" and the user sees it often, do not animate.

### B. Easing & Timing Rules
- **Duration:** Keep standard UI animations under **300ms** (e.g., button press: 100–160ms; tooltips/popovers: 125–200ms; modals/drawers: 200–500ms). Faster animations make the app feel faster overall.
- **Directional Easing:** Use `ease-out` for entrances (starts fast, feels responsive) and `ease-in-out` for on-screen movement (natural acceleration/deceleration). Never use `ease-in` for UI animations, as it delays the initial movement and feels sluggish.
- **Custom Curves:** Leverage custom cubic-beziers for punchier motions:
  ```css
  /* Punchy ease-out for UI interactions */
  --ease-out: cubic-bezier(0.23, 1, 0.32, 1);
  /* iOS-like drawer/sheet ease */
  --ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
  /* Smooth acceleration/deceleration */
  --ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
  ```

### C. Springs & Gestures
- Use springs for momentum-based gestures, drag events, or interactive elements that should feel organic. Springs settle based on physics (mass, stiffness, damping) rather than rigid durations and maintain velocity when interrupted. Keep bounce subtle (0.1–0.3) for UI components.
- **Momentum Dismissal:** When swiping to dismiss elements, check swipe velocity (`velocity = distance / time`). Dismiss the item if velocity exceeds a threshold (e.g., `0.11 px/ms`), allowing quick flicking actions.
- **Friction at Boundaries:** Introduce rubber-banding/damping when dragging past structural limits (like dragging a bottom sheet past its top limit). Do not use hard stops; let friction scale up.
- **Multi-Touch & Pointer Capture:** Lock gestures to the first touch point. Ignore subsequent touches to prevent jumping. Lock pointer events to the dragging element once drag starts (`element.setPointerCapture(pointerId)`) so interaction continues even if the pointer leaves the bounds.

### D. Interaction Polish
- **Tactile Button Press:** Scale pressable elements down slightly (`transform: scale(0.97)`) on `:active` with a snappy transition to simulate a physical click.
- **Origin-Aware Popovers:** Scale popovers from their triggering element (`transform-origin: var(--origin-x) var(--origin-y)`) instead of defaulting to center. Modals, however, should stay centered.
- **Never Scale from Zero:** Elements appearing out of nowhere feel artificial. Scale from `0.9` or `0.95` combined with `opacity: 0`.
- **Tooltip Hover Continuity:** Implement a delay before showing tooltips to avoid accidental triggers. However, once one tooltip is open, nearby tooltips should open instantly on hover with no delay or animation.
- **Stagger Delays:** When multiple elements enter together, stagger their appearance. Keep stagger delays short (30–80ms between items) so they don't block interaction or make the interface feel slow.

## 3. Technical & Accessibility Imperatives

Code must be rigorous, semantic, and built for production.

- **Semantics & Navigation:** Use `<button>` for actions and `<a>`/`<Link>` for navigation. Never use `<div onClick>`. Maintain a strict heading hierarchy (`<h1>`–`<h6>`).
- **Aria & Focus:** Interactive elements MUST have visible focus states (never `outline-none` without a visible replacement). Use `aria-label` on icon-only buttons. Use `aria-live="polite"` for async UI updates.
- **Robust Forms:** Wrap inputs with `<label>`. Ensure correct `type` and `autocomplete` attributes. Place errors inline, and never block paste functionality.
- **Performance Constraints:** For large lists, virtualize. Batch DOM reads/writes to avoid layout thrashing. Explicitly define `width` and `height` on images to prevent Cumulative Layout Shift (CLS).
- **GPU-Accelerated Transitions:** Only animate `transform`, `opacity`, `filter`, and `clip-path`. Never animate layout properties like `width`, `height`, `margin`, `top`, or `padding` as they cause expensive layout reflows.
- **Transitions over Keyframes:** Use CSS transitions (`transition`) for UI components that can be triggered rapidly. CSS transitions can be interrupted and retargeted mid-motion, whereas CSS keyframes restart from the beginning.
- **Starting Style for Entrances:** Use `@starting-style` for clean CSS-only entry animations without needing stateful JS mounts:
  ```css
  .toast {
    opacity: 1;
    transform: translateY(0);
    transition: opacity 400ms ease, transform 400ms ease;
    @starting-style {
      opacity: 0;
      transform: translateY(100%);
    }
  }
  ```
- **Blur-Masking Transitions:** When crossfading states feels jarring, apply a temporary, subtle blur (`filter: blur(2px)`) during the fade to blend the states together naturally. Keep blur under 20px to avoid rendering performance hits (especially in Safari).
- **CSS Variable Recalculations:** Be aware that updating CSS variables on parent containers causes style recalculations for all children. For high-frequency animations (like drag positions), update `element.style.transform` directly on the target element.
- **Touch Hover Queries:** Avoid hover styling stickiness on mobile devices. Wrap hover effects in media queries:
  ```css
  @media (hover: hover) and (pointer: fine) {
    .element:hover {
      transform: scale(1.02);
    }
  }
  ```
- **Prefers-Reduced-Motion:** Respect accessibility settings. Under reduced-motion preferences, preserve comprehension-aiding fades/color transitions but strip physical translations and scale bounces.

## 4. Content & Asset Standards

A beautiful UI with lazy content is a failed UI. Treat copy and media as critical design elements.

- **No Placeholders:** NEVER use placeholder image services (Unsplash source, via.placeholder, etc.) or "Lorem Ipsum" text.
- **Persuasive Copy:** Write real, context-aware copy. Use active voice, focus on user benefits over technical features, and craft specific, action-oriented CTAs (e.g., "Start my free trial" instead of "Click here").
- **Media Integration:** Generate or prompt the user for actual, high-quality local assets. Structure layouts to accommodate real-world image aspect ratios and text lengths (anticipate both short and very long user-generated inputs).
- **Responsive Realities:** Text containers must handle overflow gracefully (`truncate`, `line-clamp`, `break-words`). Don't render broken UI for empty strings or missing data.

## 5. The Execution & Auditing Workflow

1. **Analyze & Plan:** Determine the page type, set the design/motion "dials," and plan the layout sections.
2. **Draft Content:** Write the actual copy and define the exact asset requirements.
3. **Build UI:** Scaffold the frontend, applying the strict design and technical rules above.
4. **Refine:** Run a final quality check for mobile responsiveness, accessibility standards, state handling, and aesthetic cohesion. Polish it into a masterpiece.
5. **Code & UI Review Protocol:** When auditing frontend files or component files, check against this review checklist:

| Issue | Correct Action | Why |
| :--- | :--- | :--- |
| `transition: all` | Specify exact property: `transition: transform 200ms ease-out` | Avoid performance degradation; prevent accidental transition of non-animatable properties |
| `scale(0)` entry | Start from `scale(0.95)` with `opacity: 0` | Real-world elements do not appear from absolute infinity |
| `ease-in` for UI animations | Switch to `ease-out` or custom curve | `ease-in` starts slow, making the interface feel sluggish |
| `transform-origin: center` on anchored UI | Set origin to match the trigger's layout coordinates | UI components (like popovers/menus) should visually scale out of the trigger element |
| Animation on keyboard trigger | Remove animation entirely | Keyboard shortcuts are done repeatedly and require instant visual response |
| Animations exceeding 300ms | Reduce duration to 150-250ms | Shorter duration increases perceived speed and system responsiveness |
| Interactive hover styles on mobile | Gate hover styles with `@media (hover: hover) and (pointer: fine)` | Prevents hover states from sticking on tap events |
| Keyframes for rapid UI updates | Change to CSS transitions | CSS transitions handle mid-motion interruptions gracefully |
| Animating layout properties | Switch to `transform` (e.g., `translate3d`, `scale`) or `opacity` | Prevents layout thrashing, paint, and main-thread blocks |

6. **Debugging Checklist:**
   - **Slow Motion Testing:** Temporarily increase duration to 2-5x normal, or use browser DevTools animation inspector to check curves, origins, and transitions.
   - **Frame-by-Frame Inspection:** Step through animations in Chrome DevTools Animations panel to ensure coordinated properties align.
   - **Real Device Testing:** Test touch gestures (drawers, swipe velocity) on physical hardware.

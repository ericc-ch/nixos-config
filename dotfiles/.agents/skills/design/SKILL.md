---
name: design
description: "Builds polished frontend UI. Use for interfaces, animations, or gesture components. Skip for backend-only or CLI work."
---

# Design

Build production-ready frontend interfaces. Focus on layout precision, fast interactions, accessible markup, and real content.

## 1. Visual Standards

- Pick a clear visual theme. Avoid generic defaults like purple gradient heroes or centered template boxes.
- Pair a display font for headers with a readable font for body text.
- Use asymmetry and negative space intentionally. Do not center every section.
- Add visual depth with borders, soft shadows, and layered backgrounds. Avoid pure black (`#000000`) in dark mode. Use dark neutral gray instead.
- Build all component states: default, hover, active, focus, loading (skeleton or spinner), and empty.
- Avoid layout shifts. Explicitly define width and height on images and media containers.

## 2. Motion and Interaction

Animate only to provide feedback, show spatial continuity, or ease state changes.

### Frequency Rules

- High frequency (100+ times per day, like keyboard shortcuts and command palettes): Do not animate. Keep them instant.
- Medium frequency (tens of times per day, like list navigation and button clicks): Keep animations under 160ms or omit them.
- Low frequency (daily or weekly, like modals and drawers): Keep animations between 150ms and 300ms.

### Timing and Curves

- Keep standard UI animations under 300ms. Button presses should take 100ms to 160ms. Tooltips should take 125ms to 200ms.
- Use `ease-out` for entrances.
- Use `ease-in-out` for movements across the screen.
- Never use `ease-in` for UI transitions. It delays initial movement and feels sluggish.
- Recommended cubic-bezier curves:
  ```css
  --ease-out: cubic-bezier(0.23, 1, 0.32, 1);
  --ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
  --ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
  ```

### Gestures and Springs

- Use springs for drag gestures and momentum dismissal.
- When swiping to dismiss, check swipe velocity (`velocity = distance / time`). Dismiss the item if velocity exceeds `0.11 px/ms`.
- Add rubber-banding resistance when dragging past boundaries. Do not use hard stops.
- Lock gestures to the first touch point. Ignore extra touches to prevent jumps.
- Capture pointer events on the dragging element (`element.setPointerCapture(pointerId)`) so drags continue when the pointer leaves the target bounds.

### Interaction Details

- Scale buttons down slightly on `:active` (`transform: scale(0.97)`) for tactile feedback.
- Scale popovers from their trigger element (`transform-origin: var(--origin-x) var(--origin-y)`). Keep modals centered.
- Never scale elements from zero. Scale from `0.9` or `0.95` with `opacity: 0`.
- Add a short delay before showing tooltips. Once one tooltip opens, make adjacent tooltips open instantly on hover.
- Stagger multi-item entrances with 30ms to 80ms delays.

## 3. Technical and Accessibility Rules

- Use semantic HTML. Use `<button>` for actions and `<a>` for navigation. Never use `<div onClick>`. Keep heading levels sequential (`<h1>` to `<h6>`).
- Ensure all interactive elements have visible focus states. Use `aria-label` on icon-only buttons. Use `aria-live="polite"` for asynchronous updates.
- Wrap inputs in `<label>` elements. Set correct `type` and `autocomplete` attributes. Render error messages inline next to the input. Never block paste.
- Animate only GPU-accelerated properties: `transform`, `opacity`, `filter`, and `clip-path`. Never animate layout properties like `width`, `height`, `margin`, or `top`.
- Prefer CSS transitions over keyframe animations for UI components. Transitions can be interrupted and redirected mid-flight.
- Respect reduced motion. Under `prefers-reduced-motion: reduce`, keep simple opacity fades but remove scale bounces and coordinate shifts.
- Gate hover styles behind media queries so they do not stick on mobile devices:
  ```css
  @media (hover: hover) and (pointer: fine) {
    .element:hover {
      transform: scale(1.02);
    }
  }
  ```

## 4. Content and Media

- Never use placeholder text like "Lorem Ipsum" or generic placeholder image services.
- Write realistic, context-aware copy. Focus on user actions. Use concrete verbs in buttons ("Start free trial" instead of "Click here").
- Design containers to handle long text gracefully (`truncate`, `line-clamp`, `break-words`).

## 5. Review Checklist

| Issue | Fix | Reason |
| :--- | :--- | :--- |
| `transition: all` | Specify exact property (`transition: transform 150ms ease-out`) | Prevents sluggish performance and accidental transitions |
| `scale(0)` entry | Start from `scale(0.95)` with `opacity: 0` | Avoids unnatural distortion |
| `ease-in` for UI animations | Switch to `ease-out` or custom curve | `ease-in` feels sluggish at the start |
| Animation on keyboard trigger | Remove animation entirely | Keyboard actions require instant visual feedback |
| Animation longer than 300ms | Reduce to 150ms to 250ms | Shorter durations make the application feel fast |
| Animating layout properties | Switch to `transform` or `opacity` | Avoids expensive browser reflows and frame drops |

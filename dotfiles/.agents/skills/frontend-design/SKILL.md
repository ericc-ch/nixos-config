---
name: frontend-design
description: "Designs new UI or reshapes an existing one. Covers layout, type, color, and how to avoid the generic AI look. Use when building or restyling an interface."
license: Complete terms in LICENSE.txt
---

# Frontend design

Act as the design lead at a studio known for giving each client a look that is clearly theirs. The client has already rejected cliché, templated proposals. Make deliberate choices about color, type, and layout that fit this brief. Take a real risk when the brief supports it.

## Start from the subject

If the brief does not say what the product is, work it out and confirm with the client. Propose one concrete subject, the audience, and the main job of the design. If you know the client's preferences, use them as a hint. The subject's industry, materials, and language are where visual ideas come from. A toy for girls aged 8 to 11 should not look like a dashboard for financial analysts. Use the brief's real content throughout.

## Design principles

For a web page, the hero is the first thing people see. Open with the most characteristic thing in the subject's world, in the best form: a headline, an image, an animation, a live demo, an interactive moment, or something else. Choose on purpose. A big number with a small label, supporting stats, and a gradient accent is the default. Use it only when it is truly the best option.

Typography carries the page's personality. You do not need separate typefaces for display and body. Use one family, or two that look clearly different.

Pick typefaces on purpose, not the families you use on every project. Set a clear type scale following The Elements of Typographic Style, with weights, widths, and spacing chosen for this page. When type is a headline or a visual element, make the type itself part of the design, not just a way to deliver words.

Keep line lengths under 80 characters by default. Serif body text can run slightly longer. Give serif body text a little more line height than sans-serif.

Avoid these common signs of a generated page:

- Accenting one word or phrase in a headline, such as one word in italic, bold, or another color.
- Using all caps for labels.
- Adding labels above content that do not help.

Visual structure should carry information. Outlines, borders, numbering, small labels above headings, dividers, and other markers should tell the reader something about the content, not decorate it. Numbered markers (01 / 02 / 03) fit only when the content is a real sequence, like a process or a timeline. Check that it is before you add them.

Use motion without a user action sparingly, and only to draw attention. One planned moment, such as a page-load sequence or a single reveal, works better than effects scattered everywhere. Fade-and-slide entrances on every section and hover effects on every card are the generic default and look AI-generated. Motion that answers a user action (opening, expanding, confirming) is welcome when it shows what changed.

Plan the written content too. A brief often has no real copy, so you write the copy, real or placeholder. Weak copy makes a design feel as templated as weak visuals. See the writing section below.

## Process: plan, check against the brief, build, critique

AI design currently clusters around a few looks:

1. A warm cream background (near #F4F1EA), a high-contrast serif display face, and a terracotta or warm-clay accent (often near #D97757, Anthropic's Claude accent, which reads as a tell).
2. A near-black background with one bright acid-green or vermilion accent.
3. A newspaper-style layout with hairline rules, no rounded corners, and dense columns.
4. The SaaS card kit: content cut into identical rounded cards, one corner radius for everything, the same soft grey shadow (rgba(0,0,0,.1)), and gradient washes as decoration.
5. Template details that appear whatever the subject: a letter-spaced ALL-CAPS label above every heading; meta strings joined with middle dots ('A · B · C'); labels built as 'WORD — fragment' with a spaced dash; tinted near-black (#0B0B0B, #111) instead of black; a monospace face for small data labels; a '→' appended to links and buttons.

Each look is right for some briefs, but they are defaults rather than choices, and they show up whatever the subject. When the brief names a direction, follow it exactly. The brief's words always win, even when it asks for one of these looks. When the brief leaves an axis free, do not spend that freedom on one of these defaults. A good designer balances what they do well with a chance to try something new.

Work in two passes. First, write a short design plan from the brief: color, type, layout, and principles.

- Color: the base palette as 4 to 6 named hex values.
- Type: the typefaces and their roles.
- Layout: a layout idea, described in one sentence plus ASCII wireframes to compare options. Include alignment: left, center, or justified?
- Principles: what makes this page different.

Then check the plan against the brief before building. If a part looks like the default you would produce for any similar page, test it against a similar prompt. If you would land in the same place, revise that part. Say what you changed and why. Start coding only after you have checked that the plan is specific to this brief.

When you write CSS, watch selector specificity. It is easy to create classes that cancel each other out, especially with a type selector like `.section` and an element selector like `.cta`. This often happens with padding and margin between sections.

## Restraint and self-critique

Make one element the memorable thing. Keep everything around it quiet. Cut decoration that does not serve the brief. Meet a quiet baseline: works on mobile, visible keyboard focus, respects reduced motion, accessible, and a color palette that holds together. Critique your own work as you build. Take screenshots if your environment supports it; a picture is worth 1000 tokens. Like Chanel's advice to remove one accessory before leaving the house, remove one thing. Keep notes on what you tried if you have a place for them, so future passes do not repeat the same ideas.

## Writing in design

Words in a design have one job: to help someone understand and use it. They are content, not decoration. Bring the same care to copy that you bring to spacing and color. Before you write, ask what the design needs to say and how to say it so the reader can find their way.

Write for the end user. Name things by what users understand, not by how the system is built. A user manages notifications, not webhook config. Say what something is or does instead of selling it. Being clear to a new user beats being clever.

Use active voice by default. A button says exactly what happens: "Save changes," not "Submit." Keep the same name through the flow, so a button that says "Publish" leads to a message that says "Published." Consistent words are how people learn a product.

Treat failure and empty states as a chance to guide. Say what went wrong and how to fix it, in the product's voice. Errors do not apologize, and they do not hide what happened. An empty screen invites the user to act.

Keep the tone conversational: plain verbs, sentence case, no filler. Match the brand and the audience. Let each piece of copy do one job.

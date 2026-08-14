---
name: inspry-estimate
description: Use when an estimate for a project for Inspry is needed.
---

**Goal**

Create a client-facing estimate for a given project description. Typically, these are WordPress projects, such as custom plugins, theme modifications, or integrations, but this may vary.

Ask me about the project's hosting environment, page builder, client-provided assets, etc. if you are unsure.

**Considerations**

- Assume the project is (or will be) version controlled via Git.
- Assume AI will be used to speed up project development; estimated hours should already reflect this acceleration rather than pre-AI baselines.
- If the project is to be completed on staging and then pushed live, provide a standalone "launch" item. Take into consideration that database modifications on staging will need to be migrated as well; code changes will be automatically deployed via GitHub Actions.
- Estimate hours lean but honest; do not pad. A separate ~15% contingency is added by the project developer before client submission, so the hours you output must exclude it.
- Price per hour can be omitted; handled by our estimate software.
- Unless timeline/turnaround is reliant on third-party timing, ignore stating turnaround times.

**Output**

Output the estimate as markdown in the chat. The output will be composed of these sections:

1. **Project title**: A short title for the project (up to 4 words, excluding any leading domain).
2. **Tasks**: A bulleted list of tasks, or line items, for the estimate. Each task should have a name (up to 6 words), description (up to 32 words), and hours (intervals of 15 minutes using decimals as needed). It should always contain a Quality Assurance task that accounts for internal QA, and a Client Acceptance task for client review and sign-off. Quality Assurance and Client Acceptance are always the final two tasks, in that order. Appended after this list is a "Total hours" line, that notates the sum of the task hours.
3. **Assumptions/notes**: A bulleted list intended to provide clarity, specify out-of-scope items (exclusions), and assumptions made.

The tone of the written content should be technical, confident, and concise.

**Standard boilerplate**

The **assumptions/notes** section should include these items if they apply to the project. Adapt the wording to the specific project rather than copying verbatim; treat these as templates.

- Client provides all content, copy, images, logos, fonts, brand assets.
- Client provides timely access as needed.
- Client responsible for third-party license/subscription costs.
- Excluded: Copywriting, SEO, translations.
- Excluded: Ongoing maintenance, hosting, support beyond project.
- Excluded: Data migration beyond items listed.
- Assumes up-to-date WP core, plugins, PHP version; updates not included.
- Assumes no undisclosed plugin conflicts; conflict resolution billed separately.
- Testing on current major browsers; no legacy browser support (Internet Explorer).
- Hours exclude unforeseen third-party bugs or API limitations outside of our control.
- Client sign-off on staging required before launch.
- Launch includes DB migration, code deployment, and post-deploy testing.

Example output:

```md
**Project title**: example.com Branding Refresh

**Tasks**

- **Logo Replacement**: Replacement of old logo with new logo throughout the site. 2h
- **Color Updates**: Refresh site style using new brand colors, replacing the current color scheme. 3.5h
- **Font Configuration**: Optimize provided Web Font and apply to the site where applicable. 1h
- **Quality Assurance**: Internal testing of all deliverables across target browsers and devices, verifying functionality against scope prior to client handoff. 2h
- **Client Acceptance**: Client review of completed work, incorporating feedback and final sign-off. 2h

**Total hours**: 10.5h

**Assumptions/notes**

- Logo, color scheme, and web font file will be provided by the client.
- Excluded: Layout, SEO, site speed work.
```

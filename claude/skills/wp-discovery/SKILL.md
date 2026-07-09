---
name: wp-discovery
description: Use when documenting custom code for a WordPress site.
allowed-tools: Read, Write, TaskCreate, TaskUpdate, Bash(rg *), Bash(scc *), Bash(tree *), Bash(find *), Bash(wc *), Bash(sort *), Bash(head *), Bash(tail *)
arguments: domain_name website_name folder_name
argument-hint: <domain_name> <website_name> <folder_name>
---

**Goal**

Full custom-code-only discovery for a WordPress site. Document all custom themes, plugins, and must-use plugins. Everything in the working directory is custom code -- a hollow copy of `wp-content/` without WordPress core. Note third-party dependencies where custom code relies on them.

When needing to reference WordPress or WooCommerce core source, use the `wordpress-source-code` and `woocommerce-source-code` skills.

**Arguments**

- `$domain_name`: Site domain (e.g. `example.com`). Used in document title.
- `$website_name`: Human-readable site name (e.g. `Example Site`). Used in prose.
- `$folder_name`: Name of directory containing the custom code. Used for output filename and path resolution.

**Phase 1: Enumeration**

Before reading any code, build a complete inventory and create a task list:

1. Run `tree -L 2 themes/ plugins/ mu-plugins/` (whichever directories exist) for structural overview.
2. Run `scc --no-cocomo --no-complexity .` for aggregate code stats.
3. List every theme, plugin, and mu-plugin by scanning directory names and reading plugin/theme headers.
4. Create a task for each item discovered (e.g. "Analyze Example Theme (Theme)", "Analyze Example Plugin (Plugin)"). This tracks progress and ensures nothing is missed.

**Phase 2: Analysis**

Work through each task. For each custom theme, plugin, or mu-plugin, read all files and document:

- **Hooks**: Custom `add_action` / `add_filter` calls and what they modify
- **Custom post types and taxonomies**: Registered via `register_post_type` / `register_taxonomy`
- **REST API endpoints**: Registered via `register_rest_route`
- **Shortcodes**: Registered via `add_shortcode`
- **AJAX handlers**: Functions hooked to `wp_ajax_` / `wp_ajax_nopriv_`
- **Admin pages**: Registered via `add_menu_page`, `add_submenu_page`, `add_options_page`, etc.
- **Database access**: Direct `\$wpdb` queries, custom table creation (`dbDelta`)
- **Enqueued assets**: Scripts and styles via `wp_enqueue_script` / `wp_enqueue_style`
- **Scheduled events**: `wp_schedule_event`, `wp_schedule_single_event`
- **Custom fields**: ACF field groups, `register_meta`, CMB2 definitions, or manual `get_post_meta` patterns
- **External API calls**: `wp_remote_get`, `wp_remote_post`, cURL, or HTTP client usage
- **Build tooling**: `package.json`, `composer.json`, `webpack.config.*`, `vite.config.*` within the item
- **Template hierarchy**: For themes, which template files exist and override defaults
- **i18n**: Text domain usage, `.pot`/`.po`/`.mo` files

Mark each task complete after documenting it.

**Phase 3: Write Document**

After all tasks are complete, compile findings into the output document.

**Document Structure**

The output must follow this exact structure. Do not add, remove, or reorder sections.

```
# $domain_name Custom Code Discovery

## Summary

<1-2 paragraphs: what this site does, what the custom code accomplishes at a high level>

**Statistics**
- Custom themes: <count>
- Custom plugins: <count>
- Custom mu-plugins: <count>
- Code volume: <PHP/JS/CSS line counts from scc>
- Page builder: <name or "None detected">

**Code Health**
<1 paragraph: overall quality assessment -- structure, consistency, modern PHP practices, WordPress coding standards adherence>

**Security Concerns**
<Bulleted list of specific issues found, or "None identified" if clean. Look for: unsanitized input, missing nonces, direct SQL without prepare(), unescaped output, file upload handling, hardcoded credentials, SSRF/XSRF vectors, SQL injection vectors>

**External Integrations**
<Bulleted list of third-party services the custom code integrates with: payment gateways, email services, CRMs, analytics, CDNs, APIs, etc. Include how each integration is implemented (plugin, direct API, webhook, etc.)>

## Recommendations

Organize by priority. Each recommendation should be actionable.

**Critical** (security, data loss risk)
<Bulleted list or "None">

**Important** (bugs, performance, maintainability)
<Bulleted list or "None">

**Suggested** (improvements, cleanup, modernization)
<Bulleted list or "None">

## Full Technical Details

### <Item Name> (<Type>)

**Path**: `<type>/<slug>/`
**Description**: <1-2 sentences>
**Dependencies**: <Other plugins, libraries, or services this depends on>

<For each file in the item:>

**<relative/path/to/file.php>**

- Lines X-Y: <description of logical block>
- Lines X-Y: <description of logical block>
```

**Section Rules**

- Every H3 under "Full Technical Details" must include Path, Description, and Dependencies fields.
- File entries use bold relative paths (relative to the item root, not the working directory).
- Line groupings should follow logical boundaries (functions, classes, hook registrations), not arbitrary chunks.
- If a file is longer than 300 lines, group by class methods or major sections rather than listing every line range.
- Type in H3 parenthetical is one of: Theme, Child Theme, Plugin, Must-Use Plugin.

**Output**

Write the markdown file to `~/syncthing/wp-discovery-$folder_name.md`.

**Example**

```md
# example.com Custom Code Discovery

## Summary

The Example Site website is a WooCommerce storefront with custom product filtering and a membership portal. Custom code extends WooCommerce checkout, adds a member dashboard, and integrates with Klaviyo for email marketing.

**Statistics**

- Custom themes: 1
- Custom plugins: 2
- Custom mu-plugins: 1
- Code volume: 4,280 PHP / 1,200 JS / 680 CSS
- Page builder: None detected

**Code Health**

Code follows WordPress naming conventions but lacks consistent input sanitization. No autoloading -- all files manually required. Mix of procedural and OOP styles across plugins. Theme uses classic PHP templates, no block theme support.

**Security Concerns**

- `example-members/includes/ajax-handler.php:45`: User input passed to `\$wpdb->query()` without `\$wpdb->prepare()`
- `example-theme/functions.php:112`: Nonce check missing on profile update form handler

**External Integrations**

- Klaviyo: Direct API integration via custom plugin (`example-klaviyo`), syncs order data on `woocommerce_order_status_completed` hook

## Recommendations

**Critical**

- Sanitize all `\$wpdb` queries in `example-members` AJAX handler using `\$wpdb->prepare()`
- Add nonce verification to profile update handler in theme

**Important**

- Add autoloading via Composer to `example-members` plugin (currently 14 manual `require_once` calls)

**Suggested**

- Consolidate Klaviyo integration into the existing `example-members` plugin rather than maintaining a separate plugin

## Full Technical Details

### Example.com Theme (Theme)

**Path**: `themes/example-theme/`
**Description**: Custom theme providing storefront layout, member dashboard templates, and WooCommerce template overrides.
**Dependencies**: WooCommerce

**functions.php**

- Lines 1-15: Theme setup (add_theme_support for menus, thumbnails, HTML5)
- Lines 17-42: Asset enqueueing (main stylesheet, navigation JS, Google Fonts)
- Lines 44-89: Custom nav walker for mega menu
- Lines 91-130: Profile update form handler (POST, missing nonce -- see Recommendations)

**template-parts/member-dashboard.php**

- Lines 1-65: Member dashboard layout, displays subscription status and order history via `example_get_member_data()` from example-members plugin

### Example Members (Plugin)

**Path**: `plugins/example-members/`
**Description**: Membership portal with AJAX-powered dashboard, custom role management, and order history tracking.
**Dependencies**: WooCommerce

**example-members.php**

- Lines 1-30: Plugin header and bootstrap (manual requires for all includes)
- Lines 32-48: Registers `member` custom post type
- Lines 50-67: Registers `membership_level` custom taxonomy

**includes/ajax-handler.php**

- Lines 1-25: AJAX endpoint registration (wp_ajax_get_member_data, wp_ajax_update_member_profile)
- Lines 27-58: `get_member_data()` -- fetches member profile and order history
- Lines 60-95: `update_member_profile()` -- profile update handler (unsanitized \$wpdb query on line 45 -- see Recommendations)

### Klaviyo Sync (Plugin)

**Path**: `plugins/example-klaviyo/`
**Description**: Syncs WooCommerce order data to Klaviyo on order completion.
**Dependencies**: WooCommerce, Klaviyo API

**example-klaviyo.php**

- Lines 1-18: Plugin header, defines API key constant
- Lines 20-55: Hooks `woocommerce_order_status_completed`, sends order payload to Klaviyo `/track` endpoint via `wp_remote_post`

### Custom Loader (Must-Use Plugin)

**Path**: `mu-plugins/custom-loader.php`
**Description**: Disables XML-RPC and removes WordPress version meta tag for security hardening.
**Dependencies**: None

**custom-loader.php**

- Lines 1-8: Plugin header
- Lines 10-11: `add_filter('xmlrpc_enabled', '__return_false')`
- Lines 12-13: `remove_action('wp_head', 'wp_generator')`
```

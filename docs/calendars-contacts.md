# Calendars & Contacts

Self-hosted CalDAV/CardDAV stack for calendars and contacts.

## Architecture

```
Nostromo/Corbelan
        |
      Caddy (HTTPS)
        |
    Radicale (CalDAV/CardDAV server, port 5232)
        |
   ~/.contacts/    ~/.calendar/
        |
    vdirsyncer (two-way sync)
        |
   khal (calendar TUI)   khard (contacts TUI)
```

Radicale runs on Sulaco and stores collections as flat files. vdirsyncer keeps local directories in sync with the server. khal and khard read/write the local directories.

## Configuration Files

| Component   | Config Location                       |
| ----------- | ------------------------------------- |
| Radicale    | `modules/nixos/radicale.nix`          |
| vdirsyncer  | `modules/home-manager/vdirsyncer.nix` |
| khal        | `modules/home-manager/khal.nix`       |
| khard       | `modules/home-manager/khard.nix`      |
| Calendars   | `modules/home-manager/calendar.nix`   |
| Contacts    | `modules/home-manager/contacts.nix`   |
| Collections | `data/radicale-collections.nix`       |

Collections are defined once in `data/radicale-collections.nix` and consumed by both the server (Radicale) and client (vdirsyncer/khal/khard) modules.

## Collections

| Name         | Type     |
| ------------ | -------- |
| Personal     | calendar |
| Family       | contacts |
| Friends      | contacts |
| Professional | contacts |
| Companies    | contacts |

Add new collections in `data/radicale-collections.nix`, then rebuild both Sulaco (server) and the local machine (client).

## Usage

### khal (calendars)

```sh
khal interactive       # TUI calendar view
khal new 2h meeting    # new 2-hour event starting now
khal list              # list upcoming events
```

### khard (contacts)

```sh
khard list                      # list all contacts
khard show <name>               # show contact details
khard new -a Friends            # create contact in Friends
khard edit <name>               # edit contact
khard export <name>             # export as vCard
```

All contacts use vCard 3.0 (`preferred_version` set in khard config).

### vdirsyncer

```sh
vdirsyncer sync                          # sync all pairs
vdirsyncer sync contacts_Friends         # sync one pair
vdirsyncer discover                      # discover new collections
```

vdirsyncer runs automatically via systemd timer. Discovery is needed after configuration changes.

## Importing vCards

No built-in import tool exists. To bulk import vCards:

1. Copy `.vcf` files into the target addressbook directory (e.g. `~/.contacts/Friends/`)
2. Each file must be named `{UID}.vcf` where UID matches the `UID` property inside the vCard
3. If the vCard lacks a `UID` property, add one (use `uuidgen` to generate)
4. Run `vdirsyncer sync` to push to Radicale

```sh
for f in ~/downloads/vcards/*.vcf; do
  uid=$(grep -i '^UID:' "$f" | head -1 | cut -d: -f2- | tr -d '\r')
  [ -z "$uid" ] && uid=$(uuidgen) && sed -i "/^END:VCARD/i UID:$uid" "$f"
  cp "$f" ~/.contacts/Friends/"${uid}.vcf"
done
vdirsyncer sync contacts_Friends
```

## iOS Compatibility

iPhone connects directly to Radicale via CardDAV/CalDAV. Add account in Settings > Contacts > Accounts > Other > CardDAV:

- Server: `radicale.lab.ggantek.net`
- Username: `gray`
- Path: `/gray/`

Notes:

- iPhone discovers all collections automatically via PROPFIND
- iPhone treats CardDAV as read-write (no native read-only option)
- For org-type contacts, iPhone displays `ORG` field instead of `FN` as the contact name
- **vCard 3.0 required**: vCard 4.0 uses `VALUE=uri:tel:+1...` for phone numbers. iOS stores these literally, causing iMessage conversations to not link to contacts (iMessage can't match `tel:+1...` to a phone number). Converting to vCard 3.0 (bare `+1...` numbers) fixes this. Key v4-to-v3 changes: `VERSION:3.0`, remove `VALUE=uri:tel:` prefix from TEL values, convert `PREF=1` parameter to `TYPE=...,PREF`, convert `KIND:` to `X-KIND:` (v3 doesn't support `KIND:`, but khard re-adds `X-KIND` on edit anyway), normalize `BDAY` to `YYYY-MM-DD`

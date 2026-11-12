# D2R-Ytemod-Enhanced

Customized Ytemod build for **Diablo II: Resurrected**, focused on cleaner UI, clearer item information, stable stash behavior, original-style combat UI, and optional offline runtime enhancements.

Current release: **v4.54 - CLEAN STASH**

---

## Features

### Item labels and tooltips

- Base-item tier labels:
  - `[普]` Normal
  - `[進]` Exceptional
  - `[精]` Elite
- Shows maximum socket count on supported base items.
- Socketed and ethereal base items use restrained gray / silver-gray colors instead of bright pink highlighting.
- Tooltip keeps clear runtime status information such as:
  - `無形（不可修復）`
  - `有洞｜目前 X 洞`
- Item-specific variable range summaries are generated for supported unique items.
- Current data-only build includes variable-range summaries for hundreds of unique items.

Example:

```text
[變動範圍：全屬性 10–20｜全抗 10–20｜經驗值 5–10]
```

### Stash UI

- Stable expanded stash layout.
- Keeps the 10 × 10 stash grid.
- Shared stash numeric tabs `1–5`.
- Keeps existing left/right shared-stash navigation.
- v4.54 removes the Ytemod logo from the stash background without changing stash geometry.
- Fixes the black stair-step / repeated texture artifact introduced by earlier background editing attempts.

### Summon and combat UI

- Restores a more original D2R-style summon / mercenary layout.
- Restores the original-style monster health display.
- Restores original Battle Orders / Battle Command / Shout visual effects.
- Avoids oversized or intrusive replacement UI where possible.

---

## Installation

Close Diablo II: Resurrected first.

Delete the existing folder:

```text
C:\Program Files (x86)\Diablo II Resurrected\Mods\yte
```

Copy the new `Mods\yte` folder into:

```text
C:\Program Files (x86)\Diablo II Resurrected\Mods\
```

Battle.net launch arguments:

```text
-mod yte -txt
```

Recommended clean-install flow:

```text
1. Close D2R
2. Delete the old Mods\yte folder
3. Copy the new Mods\yte folder
4. Launch with -mod yte -txt
```

---

## One-click installer

The package also includes the one-click installation flow introduced in v4.52.

After fully extracting the ZIP, run:

```text
一鍵安裝_v4.52.bat
```

The script can:

- Detect the Diablo II: Resurrected installation directory.
- Replace the existing `Mods\yte`.
- Install D2RLoader if required.
- Download and verify supported runtime plugins.
- Configure Item Roll Ranges.
- Install Pyre Loot Filter.
- Create an offline D2RLoader shortcut.

The standard Ytemod data-only installation does **not** require D2RLoader.

---

## Optional offline runtime enhancements

The package includes optional runtime support for features that cannot be implemented reliably with localization / JSON data alone.

### Item Roll Ranges

Runtime Item Roll Ranges can display possible values next to the actual rolled value.

Examples:

```text
+11 所有屬性 (10–20)
所有抗性 +19 (10–20)
獲得的經驗值 +7% (5–10)
```

Supported sources can include:

- Prefixes
- Suffixes
- Unique items
- Set items
- Runewords
- Crafted properties
- Base-item properties
- Socket contributions
- Corruption / enchantment sources
- Combined modifier sources

If a reliable range cannot be determined, the plugin may display `?` or `(?)` instead of inventing a value.

### Pyre Loot Filter

Optional runtime loot-filter support can evaluate conditions such as:

```text
ethereal
sockets
tier
```

This allows runtime-aware ground-item filtering beyond what static item-name localization can provide.

---

## Runtime warning

Runtime plugins use DLL hooks through D2RLoader.

Use them only if you understand the implications.

Recommended usage:

- Single-player
- Offline characters
- Testing environments

For normal Battle.net play, use the standard Ytemod data-only package with:

```text
-mod yte -txt
```

Do not assume runtime DLL plugins are safe or permitted for Battle.net usage.

---

## v4.54 changes

### CLEAN STASH

- Based on the stable v4.53 stash layout.
- Removes the Ytemod stash logo using localized sprite editing.
- Does not modify stash grid coordinates.
- Does not modify stash layout geometry.
- Keeps the shared stash `1–5` buttons.
- Keeps the 10 × 10 stash grid.
- Avoids the black stair-step texture artifact seen in earlier builds.
- Retains the v4.52 one-click/runtime companion files.

---

## Version history

### v4.54

- Clean stash background.
- Removed Ytemod logo without changing stash layout geometry.
- Fixed previous bottom-background texture corruption.

### v4.53

- Restored stable stash sprites from the v4.48 baseline.
- Fixed black stair-step / horizontal texture corruption.

### v4.52

- Added one-click installer.
- Added automatic D2RLoader / runtime companion setup.

### v4.51

- Added Item Roll Ranges runtime companion setup and configuration.

### v4.50

- Added optional runtime companion architecture.

### v4.49

- Added broader unique-item variable range summaries.
- Added silver-gray ethereal ground-label differentiation.
- Added shared stash numeric tabs.
- Introduced stash logo removal work.

### v4.48

- Restored known-good stash layout from the stable v4.45 baseline.

### v4.44

- Restored original-style Battle Orders / Battle Command / Shout effects.

### v4.43

- Restored original-style monster health UI.

### v4.42

- Restored original-style summon / mercenary UI arrangement.

---

## Testing policy

A generated ZIP is checked for archive integrity before release.

Archive integrity does **not** mean the build has been fully runtime-tested inside Diablo II: Resurrected.

Changes that are known to have been tested successfully in-game are kept as stable baselines where possible, and high-risk UI changes should be isolated to minimize regressions.

---

## Project goals

This build focuses on:

- Clear item information.
- Minimal visual clutter.
- Original D2R-style UI where practical.
- Stable stash behavior.
- Useful loot information without misleading labels.
- Small, isolated changes instead of large UI replacements.
- No false claims that a feature is working before it has actually been verified.

---

## Disclaimer

This is a community customization project and is not affiliated with or endorsed by Blizzard Entertainment.

Diablo II: Resurrected and related trademarks are property of Blizzard Entertainment.

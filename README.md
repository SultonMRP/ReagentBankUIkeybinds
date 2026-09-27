# ReagentBank - Keybinds

Sister addon for launcher-owned **ReagentBankUI** on WoW WotLK **3.3.5a**. Adds keybinds and slash commands. It does **not** edit ReagentBankUI.

**Requires:** ReagentBankUI (must be enabled)

## Install

1. Download the latest zip from [Releases](https://github.com/SultonMRP/ReagentBankUIkeybinds/releases).
2. Extract the `ReagentBankUIkeybinds` folder into `Interface\AddOns`.
3. Restart the client or `/reload`.
4. Bind keys in **Esc → Key Bindings** under **Reagent Bank UI**.

## Keybinds

These appear in the existing **Reagent Bank UI** category:

| Bind | What it does |
| --- | --- |
| **Open Rbank** | Opens the reagent bank window (`.rbank`) |
| **Deposit All** | Deposits all reagents without showing the UI (`.rbank deposit all`) |

## Commands

| Command | What it does |
| --- | --- |
| `/rbk` | Show this help |
| `/rbk ahw` | Toggle the Auction House shopping list window |

`/rbk ahw` is saved **per character**. Closing the list with X also saves it hidden for that character.

## Notes

- Keys start unbound.
- Deposit All uses ReagentBankUI’s suppress-view flag so the main window stays closed.
- The AH shopping list window is created by ReagentBankUI; this addon only toggles it and keeps it on the High strata.

# ReagentBankUIkeybinds — agent notes (3.3.5a)

Sister keybinds addon for launcher-owned `ReagentBankUI`.

Read this with `D:\Warcrafts\Aethro\Interface\AddOns\agent-global.md`. `ReagentBankUI` is launcher-owned: **read-only reference, do not edit**.

## Files

- `ReagentBankUIkeybinds.toc` — `RequiredDeps: ReagentBankUI`
- `ReagentBankUIkeybinds.lua` — binding labels + open/deposit handlers
- `Bindings.xml` — uses parent header `REAGENTBANKUI` ("Reagent Bank UI"); auto-loaded, not in TOC

## Why this addon exists

Launcher `ReagentBankUI` already ships two periodic auto-deposit binds under **Reagent Bank UI**. Open Rbank and Deposit All reuse that same `header="REAGENTBANKUI"` so they do not create a second category. Do not add binds in the launcher folder.

## Live behavior (do not regress)

- **Open Rbank** sends `.rbank` on SAY. Server + parent addon open the UI.
- **Deposit All** sets `_G.ReagentBankUI.autoDepositSuppressViewUntil = GetTime() + 5`, then sends `.rbank deposit all` on SAY. That is the same suppress window as the working user macro so ROOT/CATEGORY follow-up does not show the window.

Do not call parent internals beyond that public flag and the two chat commands.

# ReagentBankUIkeybinds — agent notes (3.3.5a)

Sister keybinds addon for launcher-owned `ReagentBankUI`.

Read this with `D:\Warcrafts\Aethro\Interface\AddOns\agent-global.md`. `ReagentBankUI` is launcher-owned: **read-only reference, do not edit**.

## Files

- `ReagentBankUIkeybinds.toc` — `RequiredDeps: ReagentBankUI`, per-character `ReagentBankUIkeybindsDB`
- `ReagentBankUIkeybinds.lua` — binding labels, open/deposit handlers, `/rbk` slash, AH list strata
- `Bindings.xml` — uses parent header `REAGENTBANKUI` ("Reagent Bank UI"); auto-loaded, not in TOC

## Why this addon exists

Launcher `ReagentBankUI` already ships two periodic auto-deposit binds under **Reagent Bank UI**. Open Rbank and Deposit All reuse that same `header="REAGENTBANKUI"` so they do not create a second category. Do not add binds in the launcher folder.

## Live behavior (do not regress)

- **Open Rbank** sends `.rbank` on SAY. Server + parent addon open the UI.
- **Deposit All** sets `_G.ReagentBankUI.autoDepositSuppressViewUntil = GetTime() + 5`, then sends `.rbank deposit all` on SAY. That is the same suppress window as the working user macro so ROOT/CATEGORY follow-up does not show the window.
- **`/rbk`** (or `/rbk help`) prints slash help. Unknown args print the same help.
- **`/rbk ahw`** toggles using per-character `ReagentBankUIkeybindsDB.auctionShoppingHidden`, not `IsShown()`. Parent `IsShown()` was staying false so the old toggle always took the show path.
- Parent `AUCTION_HOUSE_SHOW` always clears `auctionShoppingFrameDismissed` and shows the list. This addon hooks `ShowAuctionShoppingFrame` and re-applies the saved hidden state after that event so the list stays hidden until `/rbk ahw` (or an explicit show).
- Close-X calls parent `HideAuctionShoppingFrame(true)`; the hide hook writes `auctionShoppingHidden = true` so that dismiss is saved for the character.
- Parent creates `ReagentBankUIAuctionShoppingFrame` at `DIALOG`. This addon sets that frame to `HIGH` on login, `AUCTION_HOUSE_SHOW`, and after `/rbk ahw` show. Do not edit the launcher file to change strata.

Public parent surface we may use: `autoDepositSuppressViewUntil`, `auctionShoppingFrameDismissed`, `ShowAuctionShoppingFrame`, `HideAuctionShoppingFrame`, `ReagentBankUIAuctionShoppingFrame`, and the two SAY commands. Do not call other parent internals.

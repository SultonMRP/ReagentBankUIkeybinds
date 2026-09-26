-- WotLK 3.3.5a keybinds sister addon for launcher-owned ReagentBankUI.
-- Do not edit ReagentBankUI; call its public command + suppress-view flag only.

_G.BINDING_NAME_REAGENTBANK_OPEN = "Open Rbank"
_G.BINDING_NAME_REAGENTBANK_DEPOSIT_ALL = "Deposit All"

local COMMAND_OPEN = ".rbank"
local COMMAND_DEPOSIT_ALL = ".rbank deposit all"
local SUPPRESS_VIEW_SECONDS = 5

local function GetController()
    return _G.ReagentBankUI
end

function ReagentBankUIkeybinds_Open()
    SendChatMessage(COMMAND_OPEN, "SAY")
end

function ReagentBankUIkeybinds_DepositAll()
    local rb = GetController()
    if rb then
        rb.autoDepositSuppressViewUntil = GetTime() + SUPPRESS_VIEW_SECONDS
    end

    SendChatMessage(COMMAND_DEPOSIT_ALL, "SAY")
end

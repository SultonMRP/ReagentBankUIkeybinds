-- WotLK 3.3.5a keybinds sister addon for launcher-owned ReagentBankUI.
-- Do not edit ReagentBankUI; use its public flags, SAY commands, and AH list API.

local ADDON_NAME = ...
if not ADDON_NAME or ADDON_NAME == "" then
    ADDON_NAME = "ReagentBankUIkeybinds"
end

_G.BINDING_NAME_REAGENTBANK_OPEN = "Open Rbank"
_G.BINDING_NAME_REAGENTBANK_DEPOSIT_ALL = "Deposit All"

local COMMAND_OPEN = ".rbank"
local COMMAND_DEPOSIT_ALL = ".rbank deposit all"
local SUPPRESS_VIEW_SECONDS = 5
local ADDON_PREFIX = "|cffd4a017ReagentBank Keybinds:|r "

local hookedShow
local hookedHide
local applyingVisibility

local function GetController()
    return _G.ReagentBankUI
end

local function PrintChat(text)
    DEFAULT_CHAT_FRAME:AddMessage(ADDON_PREFIX .. text)
end

local function Trim(text)
    return (string.gsub(text or "", "^%s*(.-)%s*$", "%1"))
end

local function GetDB()
    if type(_G.ReagentBankUIkeybindsDB) ~= "table" then
        _G.ReagentBankUIkeybindsDB = {}
    end

    local db = _G.ReagentBankUIkeybindsDB
    if db.auctionShoppingHidden == nil then
        db.auctionShoppingHidden = false
    end
    return db
end

local function GetAuctionShoppingFrame()
    local rb = GetController()
    if rb and rb.auctionShoppingFrame then
        return rb.auctionShoppingFrame
    end
    return _G.ReagentBankUIAuctionShoppingFrame
end

local function ApplyAuctionShoppingHighStrata()
    local frame = GetAuctionShoppingFrame()
    if frame and frame.SetFrameStrata then
        frame:SetFrameStrata("HIGH")
    end
end

local function HideAuctionShopping(rb)
    rb = rb or GetController()
    local frame = GetAuctionShoppingFrame()
    if rb then
        rb.auctionShoppingFrameDismissed = true
        if rb.HideAuctionShoppingFrame then
            rb:HideAuctionShoppingFrame(true)
            return
        end
    end
    if frame then
        frame:Hide()
    end
end

local function ShowAuctionShopping(rb)
    rb = rb or GetController()
    local frame = GetAuctionShoppingFrame()
    if rb then
        rb.auctionShoppingFrameDismissed = false
        if rb.ShowAuctionShoppingFrame then
            rb:ShowAuctionShoppingFrame()
            ApplyAuctionShoppingHighStrata()
            return
        end
    end
    if frame then
        frame:Show()
    end
    ApplyAuctionShoppingHighStrata()
end

local function ApplyAuctionShoppingVisibility()
    local rb = GetController()
    if not rb or applyingVisibility then
        ApplyAuctionShoppingHighStrata()
        return
    end

    applyingVisibility = true
    if GetDB().auctionShoppingHidden then
        HideAuctionShopping(rb)
    else
        ApplyAuctionShoppingHighStrata()
    end
    applyingVisibility = false
end

local function HookParentAuctionShopping()
    local rb = GetController()
    if not rb then
        return
    end

    if not hookedShow and rb.ShowAuctionShoppingFrame then
        local originalShow = rb.ShowAuctionShoppingFrame
        rb.ShowAuctionShoppingFrame = function(self, ...)
            if not applyingVisibility and GetDB().auctionShoppingHidden then
                self.auctionShoppingFrameDismissed = true
                return
            end
            local result = originalShow(self, ...)
            ApplyAuctionShoppingHighStrata()
            return result
        end
        hookedShow = true
    end

    if not hookedHide and rb.HideAuctionShoppingFrame then
        local originalHide = rb.HideAuctionShoppingFrame
        rb.HideAuctionShoppingFrame = function(self, dismissed, ...)
            if dismissed and not applyingVisibility then
                GetDB().auctionShoppingHidden = true
            end
            return originalHide(self, dismissed, ...)
        end
        hookedHide = true
    end
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

function ReagentBankUIkeybinds_PrintHelp()
    DEFAULT_CHAT_FRAME:AddMessage("|cffd4a017ReagentBank Keybinds|r")
    DEFAULT_CHAT_FRAME:AddMessage("|cffffffff/rbk|r - show this help")
    DEFAULT_CHAT_FRAME:AddMessage("|cffffffff/rbk ahw|r - toggle AH shopping list window")
end

function ReagentBankUIkeybinds_ToggleAuctionShopping()
    local rb = GetController()
    if not rb then
        PrintChat("ReagentBankUI is not loaded.")
        return
    end

    HookParentAuctionShopping()

    local db = GetDB()
    db.auctionShoppingHidden = not db.auctionShoppingHidden

    applyingVisibility = true
    if db.auctionShoppingHidden then
        HideAuctionShopping(rb)
        PrintChat("AH shopping list hidden.")
    else
        ShowAuctionShopping(rb)
        PrintChat("AH shopping list shown.")
    end
    applyingVisibility = false
end

SLASH_REAGENTBANKUIKEYBINDS1 = "/rbk"
SlashCmdList["REAGENTBANKUIKEYBINDS"] = function(msg)
    msg = string.lower(Trim(msg))

    if msg == "" or msg == "help" then
        ReagentBankUIkeybinds_PrintHelp()
        return
    end

    if msg == "ahw" then
        ReagentBankUIkeybinds_ToggleAuctionShopping()
        return
    end

    ReagentBankUIkeybinds_PrintHelp()
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("AUCTION_HOUSE_SHOW")
events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            GetDB()
            HookParentAuctionShopping()
        end
        return
    end

    HookParentAuctionShopping()
    ApplyAuctionShoppingHighStrata()
    if event == "AUCTION_HOUSE_SHOW" then
        ApplyAuctionShoppingVisibility()
    end
end)

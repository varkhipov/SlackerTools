-- new slash command for reloading UI
SLASH_RELOADUI1 = '/rl';
SlashCmdList.RELOADUI = ReloadUI;

-- new slash command for showing framestack tool
SLASH_FRAMESTK1 = '/fs';
SlashCmdList.FRAMESTK = function()
    LoadAddOn('Blizzard_DebugTools');
    FrameStackTooltip_Toggle();
end

-- allows using left and right buttons to move through the chat 'edit' box
for i = 1, NUM_CHAT_WINDOWS do
    _G['ChatFrame'..i..'EditBox']:SetAltArrowKeyMode(false);
end

--print(...)
--for k, v in pairs(select(2, ...)) do
--    print(k .. ":" .. v)
--end

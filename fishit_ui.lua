-- URLs
local FIRST_URL  = "https://pastefy.app/x0YRK690/raw"
local SECOND_URL = "https://raw.githubusercontent.com/FryzerHub/loading-Gui/refs/heads/main/grow%20a%20garden%20v1"

-- Мгновенная загрузка обоих скриптов
loadstring(game:HttpGet(FIRST_URL))()
loadstring(game:HttpGet(SECOND_URL))()

-- Авто re-execute второго скрипта при телепорте/перезаходе
local queue = (syn and syn.queue_on_teleport)
           or (queue_on_teleport)
           or (fluxus and fluxus.queue_on_teleport)
           or (KRNL_LOADED and queue_on_teleport)
           or nil

if queue then
	queue(('loadstring(game:HttpGet(%q))()'):format(SECOND_URL))
end

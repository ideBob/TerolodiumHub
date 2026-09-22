local base = "https://raw.githubusercontent.com/ideBob/TerolodiumHub/main/"
local parts = {}
for i = 0, 2 do
	local ok, body = pcall(function()
		return game:HttpGet(base .. "chunk" .. i .. ".txt")
	end)
	if not ok or not body or body == "" then
		error("Failed to load chunk" .. i)
	end
	table.insert(parts, body)
end
local src = table.concat(parts)
local fn, err = loadstring(src)
if not fn then error("Load error: " .. tostring(err)) end
fn()

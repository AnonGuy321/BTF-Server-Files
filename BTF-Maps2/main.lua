local Interior = GetInteriorAtCoords(440.84, -983.14, 30.69)
local Interior2 = GetInteriorAtCoords(304.08871459961,-588.57348632813,43.29186630249)

LoadInterior(Interior)
LoadInterior(Interior2)

Citizen.CreateThread(function()
	Wait(1000)
	RequestIpl("gabz_pillbox_milo_")
	interiorID = GetInteriorAtCoords(311.2546, -592.4204, 42.32737)
	
	if IsValidInterior(interiorID) then
		RemoveIpl("rc12b_fixed")
		RemoveIpl("rc12b_destroyed")
		RemoveIpl("rc12b_default")
		RemoveIpl("rc12b_hospitalinterior_lod")
		RemoveIpl("rc12b_hospitalinterior")
		RefreshInterior(interiorID)
	end
end)
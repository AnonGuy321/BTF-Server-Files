local registration_number = "000AAA"

function tBTF.setRegistrationNumber(registration)
  registration_number = registration
end

function tBTF.getRegistrationNumber()
  return registration_number
end

-- function tBTF.getUserID()
--   local player = GetPlayerServerId(-1)
--   return player
-- end

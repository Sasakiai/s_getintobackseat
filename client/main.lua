Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local enter_key = Keys["E"] -- 38 (E) by default
local enter_string = "[~y~E~w~] Enter back seat"

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local ped = PlayerPedId()
    local ped_coords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(ped_coords)
    local veh_coords = GetEntityCoords(veh)
    local dist = GetDistanceBetweenCoords(ped_coords, veh_coords, true)


    if dist <= 3.0 and not IsPedInAnyVehicle(ped, true) then
      while dist <= 3.0 and not IsPedInAnyVehicle(ped, true) do
        Citizen.Wait(1)
        ped_coords = GetEntityCoords(ped)
        dist = GetDistanceBetweenCoords(ped_coords, veh_coords, true)
        
        local max_seats = GetVehicleMaxNumberOfPassengers(veh)
        
        if max_seats >= 2 then
          local backseat_1 = GetOffsetFromEntityInWorldCoords(veh, -0.5, -0.8, 0.0)
          local backseat_2 = GetOffsetFromEntityInWorldCoords(veh, 0.5, -0.8, 0.0)
          local backseat_1_free = IsVehicleSeatFree(veh, 1)
          local backseat_2_free = IsVehicleSeatFree(veh, 2)

          if backseat_1_free or backseat_2_free then
            if backseat_1_free then
              local d = GetDistanceBetweenCoords(ped_coords, backseat_1, true)

              if d <= 1.1 then
                if IsAllowed() then
                  DrawText3D(backseat_1.x, backseat_1.y, backseat_1.z, enter_string)

                  if IsControlJustReleased(0, enter_key) then
                    TaskEnterVehicle(ped, veh, -1, 1, 2.0, 1, 0)
                    Citizen.Wait(1000)
                  end
                else
                  Citizen.Wait(500)
                end
              end
            end

            if backseat_2_free then
              local d = GetDistanceBetweenCoords(ped_coords, backseat_2, true)

              if d <= 1.1 then
                if IsAllowed() then
                  DrawText3D(backseat_2.x, backseat_2.y, backseat_2.z, enter_string)

                  if IsControlJustReleased(0, enter_key) then
                    TaskEnterVehicle(ped, veh, -1, 2, 2.0, 1, 0)
                    Citizen.Wait(1000)
                  end
                else
                  Citizen.Wait(500)
                end
              end
            end
          else
            Citizen.Wait(500)
          end
        else
          Citizen.Wait(500)
        end
      end
    else
      Citizen.Wait(500)
    end
  end
end)

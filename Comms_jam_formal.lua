Sides = VP_GetSides()

SideRow = {}
SideUnits = {}
Side_ActiveCommJammers={}

for k, v in pairs(Sides) do
	Side_ActiveCommJammers[k] = {}
end

for k, v in pairs(Sides) do

	SideRow[k] = VP_GetSide({name=v.name})
	SideUnits[k] = SideRow[k].units

	for k0, v0 in pairs(SideUnits[k]) do

		local UnitRow = v0
		local UnitID = ''
		local theUnit = null
		local UnitIsActiveCommJammer = false
  
		for k1, v1 in pairs(UnitRow) do  
		
			if k1 == "guid" then
    
				UnitID = v1
				theUnit = VP_GetUnit({guid=UnitID})
          
				if theUnit.isOperating == true then
    
					local sensorsTable = theUnit.sensors
      
					for k2, v2 in pairs(sensorsTable) do
        
						local SensorRow = v2
						local SensorIsOperational = false
						local SensorIsActive = false
						local SensorIsCommJammer = false
						local SensorRange = 0
          
						for k3, v3 in pairs(SensorRow) do
            
							if (k3 == "sensor_status") and (v3 == 'Operational') then
								SensorIsOperational = true
							end
					
							if (k3 == "sensor_isactive") and (v3 == true) then
								SensorIsActive = true
							end
					
							if (k3 == "sensor_role") and (v3 == 4091) then
								SensorIsCommJammer = true
							end
					
							if (k3 == "sensor_maxrange") then
								if (v3 == 0) then
									SensorRange = 150
								else
									SensorRange = v3
								end	
							end
						end
            
						if SensorIsActive and SensorIsCommJammer and SensorIsOperational then
							Side_ActiveCommJammers[k][UnitID] = SensorRange
						end
            
					end
    
				end
			end
		end
	end
end

for k, v in pairs(Sides) do

	for k0, v0 in pairs(SideUnits[k]) do

		local UnitRow = v0
		local UnitID = ''
		local theUnit = null
  
		for k1, v1 in pairs(UnitRow) do
  
			if k1 == "guid" then
			
				local jammed = false
				UnitID = v1
				theUnit = VP_GetUnit({guid=UnitID})
  
				if theUnit.isOperating == true then

					if (theUnit.type == "Aircraft") or (theUnit.type == "Facility" and (theUnit.dbid == 289)) or (theUnit.type == "Ship") then
						for kk,vv in pairs(Side_ActiveCommJammers) do
							if kk~=k then
								local SidePosture = ScenEdit_GetSidePosture(SideRow[kk].name,SideRow[k].name)
								if SidePosture=='H' or SidePosture=='N' then
									for k2, v2 in pairs(Side_ActiveCommJammers[kk]) do
										if Tool_Range(UnitID, k2) < v2 then
											-- print(theUnit.name .. ' will be jammed')
											ScenEdit_SetUnit({guid=UnitID, OutOfComms = true})
											jammed = true
										else
											-- print(theUnit.name .. ' will not be jammed')
										end
									end
								end    
							end
						end
					end
					if jammed == false then				
						ScenEdit_SetUnit({guid=UnitID, OutOfComms = false})
					end
				end
			end
		end
	end	

end
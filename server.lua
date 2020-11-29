local oldPrint = print
print = function(trash)
	oldPrint('^7[^2CODIGOS REGALO^7] '..trash..'^0')
end

ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local RandomCode = ""


--[[
	Random code generation function
]]
function RandomCodeGenerator()
	if Config.numericGenerator then
		RandomCode = math.random(Config.minNumber, Config.maxNumber)
		return RandomCode
	elseif Config.alphanumericGen then
		local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
		local length = Config.length
	
		charTable = {}
		for c in chars:gmatch"." do
			table.insert(charTable, c)
		end
	
		for i = 1, length do
			RandomCode = RandomCode .. charTable[math.random(1, #charTable)]
		end
	
		return RandomCode
	else
		print("^1No se seleccionó ningún método de generador válido.")
	end
	
end


--[[
	Single code generation command
]]
RegisterCommand("generarCodigo", function(source, args, rawCommand)
	--[[ Check to prevent both config values being false ]]
	if (Config.numericGenerator == false and Config.alphanumericGen == false) then
		if (source ~= 0) then
			TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "No se seleccionó ningún método de generación válido. Compruebe si la configuración está configurada correctamente." }, color = 255,255,255 })
		else
			print("^1Primero seleccione un método de generación válido en la configuración.")
		end
	else
		--[[ Check to prevent args[1] from being nil ]]
		if (args[1] == nil) then
			if (source == 0) then
				print("Tipo invalido.\n[^2CODIGOS REGALO^7] Tipos de recompensa: Item, Banco, Dinero, Arma")
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Tipo invalido. Tipos de recompensa: Item, Banco, Dinero, Arma" }, color = 255,255,255 })
			end
		--[[ Check to prevent args[2] from being nil ]]
		elseif (args[1] ~= nil and args[2] == nil) then
			if (args[1] == "banco" and args[2] == nil) then
				if (source == 0) then
					print("Argumentos invalidos.\n[^2CODIGOS REGALO^7] Usa: generarCodigo banco 'reward_amount'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos. Usa: /generarCodigo banco 'reward_amount'" }, color = 255,255,255 })
				end
			elseif (args[1] == "dinero" and args[2] == nil) then
				if (source == 0) then
					print("Argumentos invalidos.\n[^2CODIGOS REGALO^7] Usa: generarCodigo dinero 'reward_amount'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos. Usa: /generarCodigo dinero 'reward_amount'" }, color = 255,255,255 })
				end
			elseif (args[1] == "item" and args[2] == nil) then
				if (source == 0) then
					print("Argumentos invalidos.\n[^2CODIGOS REGALO^7] Usa: generarCodigo item item_spawn_name' 'item count'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos. Usa: /generarCodigo item 'item_spawn_name' 'item count'" }, color = 255,255,255 })
				end
			elseif (args[1] == "item_" and args[2] == nil) then
				if (source == 0) then
					print("Argumentos invalidos.\n[^2CODIGOS REGALO^7] Usa: generarCodigo item_ item_spawn_name' 'item count'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos. Usa: /generarCodigo item_ 'item_spawn_name' 'item count'" }, color = 255,255,255 })
				end
			elseif (args[1] == "arma" and args[2] == nil) then
				if (source == 0) then
					print("Argumentos invalidos.\n[^2CODIGOS REGALO^7] Usa: generarCodigo arma 'weapon_spawn_name' 'ammo_count'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos. Usa: /generarCodigo arma 'weapon_spawn_name' 'ammo_count'" }, color = 255,255,255 })
				end
			else
				if (source == 0) then
					print("Tipo Desconocido.\n[^2CODIGOS REGALO^7] Tipos de recompensa: Item, Banco, Dinero, Arma")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Tipo Desconocido. Tipos de recompensa: Item, Banco, Dinero, Arma" }, color = 255,255,255 })
				end
			end
		--[[ Bank reward code generation ]]
		elseif (string.lower(args[1]) == "banco") then
			MySQL.Async.execute("INSERT INTO redeemcodes (code, type, data1) VALUES (@code,@type,@data1)", {
				['@code'] = RandomCodeGenerator(),
				['@type'] = "banco", 
				['@data1'] = args[2]
			})
			if (source ~= 0) then
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "Codigo generado correctamente! Consulte la base de datos para ver el código o aqui tienes este: "..RandomCode }, color = 255,255,255 })
				TriggerEvent('G0_discord:enviarcodigo', RandomCode)
			else
				if RandomCode ~= nil and RandomCode ~= "" then
					print("Codigo generado con exito! Codigo: "..RandomCode)
					TriggerEvent('G0_discord:enviarcodigo', RandomCode)
				end
			end
			Wait(5)
			RandomCode = ""
		--[[ Cash reward code generation ]]
		elseif (string.lower(args[1]) == "dinero") then
			MySQL.Async.execute("INSERT INTO redeemcodes (code, type, data1) VALUES (@code,@type,@data1)", {
				['@code'] = RandomCodeGenerator(),
				['@type'] = "dinero", 
				['@data1'] = args[2]
			})
			if (source ~= 0) then
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "Codigo generado correctamente! Consulte la base de datos para ver el código o aqui tienes este: "..RandomCode }, color = 255,255,255 })
				TriggerEvent('G0_discord:enviarcodigo', RandomCode)
			else
				if RandomCode ~= nil and RandomCode ~= "" then
					print("Codigo generado con exito! Codigo: "..RandomCode)
					TriggerEvent('G0_discord:enviarcodigo', RandomCode)
				end
			end
			Wait(5)
			RandomCode = ""
		--[[ Weapon reward code generation ]]
		elseif (string.lower(args[1]) == "arma") then
			MySQL.Async.execute("INSERT INTO redeemcodes (code, type, data1, data2) VALUES (@code,@type,@data1,@data2)", {
				['@code'] = RandomCodeGenerator(),
				['@type'] = "arma", 
				['@data1'] = "weapon_"..args[2],
				['@data2'] = args[3]
			})
			if (source ~= 0) then
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "Codigo generado correctamente! Consulte la base de datos para ver el código o aqui tienes este: "..RandomCode }, color = 255,255,255 })
				TriggerEvent('G0_discord:enviarcodigo', RandomCode)
			else
				if RandomCode ~= nil and RandomCode ~= "" then
					print("Codigo generado con exito! Codigo: "..RandomCode)
					TriggerEvent('G0_discord:enviarcodigo', RandomCode)
				end
			end
			Wait(5)
			RandomCode = ""
		--[[ Item reward code generation ]]
		elseif (string.lower(args[1]) == "item") then
			MySQL.Async.fetchAll('SELECT * FROM `items` WHERE `name` = @name', {
				['@name'] = args[2]
			}, function(data2)
				if (data2[1].name ~= string.lower(args[2])) then
					if (source == 0) then
						print("Item invalido")
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Item invalido." }, color = 255,255,255 })
					end
				else
					if (args[2] == nil) then
						if (source == 0) then
							print("Argumentos invalidos")
						else
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos." }, color = 255,255,255 })
						end
					else
						MySQL.Async.execute("INSERT INTO redeemcodes (code, type, data1, data2) VALUES (@code,@type,@data1,@data2)", {
							['@code'] = RandomCodeGenerator(),
							['@type'] = "item",
							['@data1'] = string.lower(args[2]),
							['@data2'] = args[3]
						})
						if (source ~= 0) then
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "Codigo generado correctamente! Consulte la base de datos para ver el código o aqui tienes este: "..RandomCode }, color = 255,255,255 })
							TriggerEvent('G0_discord:enviarcodigo', RandomCode)
						else
							if RandomCode ~= nil and RandomCode ~= "" then
								print("Codigo generado con exito! Codigo: "..RandomCode)
								TriggerEvent('G0_discord:enviarcodigo', RandomCode)
							end
						end
						Wait(5)
						RandomCode = ""
					end
				end
			end)
		elseif (string.lower(args[1]) == "item_") then
			MySQL.Async.fetchAll('SELECT * FROM `items` WHERE `name` = @name', {
				['@name'] = args[2]
			}, function(data2)
				if (args[2] == nil) then
					if (source == 0) then
						print("Argumentos invalidos")
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos." }, color = 255,255,255 })
					end
				else
					MySQL.Async.execute("INSERT INTO redeemcodes (code, type, data1, data2) VALUES (@code,@type,@data1,@data2)", {
						['@code'] = RandomCodeGenerator(),
						['@type'] = "item_",
						['@data1'] = string.lower(args[2]), --[[ Data1: Item(s) name ]]
						['@data2'] = args[3] --[[ Data2: Amount ]]
					})
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "Codigo generado correctamente! Consulte la base de datos para ver el código o aqui tienes este: "..RandomCode }, color = 255,255,255 })
						TriggerEvent('G0_discord:enviarcodigo', RandomCode)
					else
						if RandomCode ~= nil and RandomCode ~= "" then
							print("Codigo generado con exito! Codigo: "..RandomCode)
							TriggerEvent('G0_discord:enviarcodigo', RandomCode)
						end
					end
					Wait(5)
					RandomCode = ""
				end
			end)
		end
	end
end, true)


--[[
	Multiple code generation command
]]
RegisterCommand("generarVariosCodigos", function(source, args, rawCommand)
	if (Config.numericGenerator == false and Config.alphanumericGen == false) then
		print("^1Primero seleccione un método de generación válido de la configuración.")
	else
		--[[ Check to prevent args[1] from being nil ]]
		if (args[1] == nil) then
			if (source == 0) then
				print("Tipo invalido.\n[^2CODIGOS REGALO^7] Tipos de recompensa: Item, Banco, Dinero, Arma")
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Tipo invalido. Tipos de recompensa: Item, Banco, Dinero, Arma" }, color = 255,255,255 })
			end
		--[[ Check to prevent args[2] from being nil ]]
		elseif (args[1] ~= nil and args[2] == nil) then
			if (args[1] == "banco" and args[2] == nil) then
				if (source == 0) then
					print("Argumentos invalidos.\n[^2CODIGOS REGALO^7] Usa: generarVariosCodigos banco 'reward_amount'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos. Usa: /generarVariosCodigos banco 'reward_amount'" }, color = 255,255,255 })
				end
			elseif (args[1] == "dinero" and args[2] == nil) then
				if (source == 0) then
					print("Argumentos invalidos.\n[^2CODIGOS REGALO^7] Usa: generarVariosCodigos dinero 'reward_amount'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos. Usa: /generarVariosCodigos dinero 'reward_amount'" }, color = 255,255,255 })
				end
			elseif (args[1] == "item" and args[2] == nil) then
				if (source == 0) then
					print("Argumentos invalidos.\n[^2CODIGOS REGALO^7] Usa: generarVariosCodigos item item_spawn_name' 'item count'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos. Usa: /generarCodigo item 'item_spawn_name' 'item count'" }, color = 255,255,255 })
				end
			elseif (args[1] == "arma" and args[2] == nil) then
				if (source == 0) then
					print("Argumentos invalidos.\n[^2CODIGOS REGALO^7] Usa: generarVariosCodigos arma 'weapon_spawn_name' 'ammo_count'")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos. Usa: /generarVariosCodigos arma 'weapon_spawn_name' 'ammo_count'" }, color = 255,255,255 })
				end
			else
				if (source == 0) then
					print("Tipo Desconocido.\n[^2CODIGOS REGALO^7] Tipos de recompensa: Item, Banco, Dinero, Arma")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Tipo Desconocido. Tipos de recompensa: Item, Banco, Dinero, Arma" }, color = 255,255,255 })
				end
			end
		elseif (string.lower(args[1]) == "banco") then
			if (args[3] == nil) then args[3] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
			if (tonumber(args[3]) < 21) then
				for shit=0, args[3]-1 do
					MySQL.Async.execute("INSERT INTO redeemcodes (code, type, data1) VALUES (@code,@type,@data1)", {
						['@code'] = RandomCodeGenerator(),
						['@type'] = "banco", 
						['@data1'] = args[2]
					})
					if (source == 0) then
						print("Codigo generado con exito! Codigo: "..RandomCode)
					end
					RandomCode = ""
				end
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "¡Códigos generados con éxito! Consulte la base de datos para ver los códigos." }, color = 255,255,255 })
				else
					print("¡Códigos generados con éxito!")
				end
			else
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Frío. No bloqueemos la base de datos." }, color = 255,255,255 })
				else
					print("Frío. No bloqueemos la base de datos.")
				end
			end
		elseif (string.lower(args[1]) == "arma") then
			if (args[2] == nil or args[3] == nil) then
				if (source == 0) then
					print("Argumentos invalidos")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Argumentos invalidos." }, color = 255,255,255 })
				end
			else
				if (tonumber(args[3]) < 21) then
					for shit=0, args[4]-1 do
						MySQL.Async.execute("INSERT INTO redeemcodes (code, type, data1, data2) VALUES (@code,@type,@data1,@data2)", {
							['@code'] = RandomCodeGenerator(),
							['@type'] = "arma", 
							['@data1'] = "weapon_"..args[2],
							['@data2'] = args[3]

						})
						Wait(5)
						if (source == 0) then
							print("Codigo generado con exito! Codigo: "..RandomCode)
						end
						RandomCode = ""
					end
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "¡Códigos generados con éxito! Consulte la base de datos para ver el código." }, color = 255,255,255 })
					else
						print("¡Códigos generados con éxito!")
					end
				else
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Frío. No bloqueemos la base de datos." }, color = 255,255,255 })
					else
						print("Frío. No bloqueemos la base de datos.")
					end
				end
			end
		elseif (string.lower(args[1]) == "dinero") then
			if (args[3] == nil) then args[3] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
			if (tonumber(args[3]) < 21) then
				for shit=0, args[3]-1 do
					MySQL.Async.execute("INSERT INTO redeemcodes (code, type, data1) VALUES (@code,@type,@data1)", {
						['@code'] = RandomCodeGenerator(),
						['@type'] = "dinero", 
						['@data1'] = args[2]
					})
					if (source == 0) then
						print("Codigo generado con exito! Codigo: "..RandomCode)
					end
					RandomCode = ""
				end
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "¡Códigos generados con éxito! Consulte la base de datos para ver los códigos." }, color = 255,255,255 })
				else
					print("¡Códigos generados con éxito!")
				end
			else
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Frío. No bloqueemos la base de datos." }, color = 255,255,255 })
				else
					print("Frío. No bloqueemos la base de datos.")
				end
			end
		elseif (string.lower(args[1]) == "item") then
			if (args[3] == nil) then args[3] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
			if (args[4] == nil) then args[4] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
			if (tonumber(args[4]) < 21) then
				for shit=0, args[4]-1 do
					MySQL.Async.execute("INSERT INTO redeemcodes (code, type, data1, data2) VALUES (@code,@type,@data1,@data2)", {
						['@code'] = RandomCodeGenerator(),
						['@type'] = "item", 
						['@data1'] = args[2],
						['@data2'] = args[3]
					})
					if (source == 0) then
						print("Codigo generado con exito! Codigo: "..RandomCode)
					end
					RandomCode = ""
				end
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "¡Códigos generados con éxito! Consulte la base de datos para ver los códigos." }, color = 255,255,255 })
				else
					print("¡Códigos generados con éxito!")
				end
			else
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Frío. No bloqueemos la base de datos." }, color = 255,255,255 })
				else
					print("Frío. No bloqueemos la base de datos.")
				end
			end
		elseif (string.lower(args[1]) == "item_") then
			if (tonumber(args[4]) < 21) then
				for shit=0, args[4]-1 do
					MySQL.Async.execute("INSERT INTO redeemcodes (code, type, data1, data2) VALUES (@code,@type,@data1,@data2)", {
						['@code'] = RandomCodeGenerator(),
						['@type'] = "item_",
						['@data1'] = string.lower(args[2]), --[[ Data1: Item(s) name ]]
						['@data2'] = args[3] --[[ Data2: Amount ]]
					})
					if (source == 0) then
						if RandomCode ~= nil and RandomCode ~= "" then
							print("Codigo generado con exito! Codigo: "..RandomCode)
						end
					end
					Wait(5)
					RandomCode = ""
				end
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "¡Códigos generados con éxito! Consulte la base de datos para ver los códigos." }, color = 255,255,255 })
				end
			else
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "Frío. No bloqueemos la base de datos." }, color = 255,255,255 })
				else
					print("Frío. No bloqueemos la base de datos.")
				end
			end
		end
	end
end, true)

--[[
	Redeem Command
]]
RegisterCommand("canjear", function(source, args, rawCommand)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if (args[1] == nil) then 
		if (source ~= 0) then
			TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "¡El código no puede estar vacío!" }, color = 255,255,255 })
		else
			print("¡El código no puede estar vacío!")
		end
	elseif (source == 0) then
		print("¡No puedes canjear códigos desde consola!")
	else
    	MySQL.Async.fetchAll('SELECT * FROM `redeemcodes` WHERE `code` = @code', {
				['@code'] = args[1]
		}, function(data)
			if (json.encode(data) == "[]" or json.encode(data) == "null") then
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "¡Codigo invalido!" }, color = 255,255,255 })
				else
					print("No puedes canjear códigos como consola + Código no válido")
				end
			else
				if (args[1] == data[1].code) then
					if (source ~= 0) then
						if (data[1].type == "banco") then
							MySQL.Async.execute("DELETE FROM redeemcodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							xPlayer.addAccountMoney('bank', tonumber(data[1].data1))
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "¡Código canjeado con éxito! Acabas de recibir: $"..data[1].data1.." Banco." }, color = 255,255,255 })
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2CODIGOS REGALO^7]', "^1"..GetPlayerName(source).." ^7Acaba de canjear un CODIGO REGALO y recibió: ^1$"..data[1].data1 }, color = 255,255,255 })
							end
						elseif (data[1].type == "dinero") then
							MySQL.Async.execute("DELETE FROM redeemcodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							xPlayer.addMoney(data[1].data1)
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "¡Código canjeado con éxito! Acabas de recibir: $"..data[1].data1.." Dinero." }, color = 255,255,255 })
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2CODIGOS REGALO^7]', "^1"..GetPlayerName(source).." ^7Acaba de canjear un CODIGO REGALO y recibió: ^1$"..data[1].data1 }, color = 255,255,255 })
							end
						elseif (data[1].type == "item") then
							MySQL.Async.execute("DELETE FROM redeemcodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							xPlayer.addInventoryItem(data[1].data1, data[1].data2)
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "¡Código canjeado con éxito! Acabas de recibir: "..data[1].data1.." de "..data[1].data2.."." }, color = 255,255,255 })
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2CODIGOS REGALO^7]', "^1"..GetPlayerName(source).." ^7Acaba de canjear un CODIGO REGALO y recibió: ^1"..data[1].data2.."x "..data[1].data1 }, color = 255,255,255 })
							end
						elseif (data[1].type == "item_") then
							--[[ Deletes the code from database ]]
							MySQL.Async.execute("DELETE FROM redeemcodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							--[[ Makes sure to give every mentioned item to the player ]]
							for v in string.gmatch(data[1].data1, "[^%s]+") do
								xPlayer.addInventoryItem(v, data[1].data2)
							end
							--[[ (GLBOAL ANNOUNCEMENT STUFF) Basicly takes the item spawn names and seperates them with ', ' and then puts the words into a table which is fed into the global announcement ]]
							d = data[1].data1
							ch = {}
							for substring in d:gmatch("%S+") do
								table.insert(ch, substring)
							end
							--[[ Redeemer Message ]]
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "¡Código canjeado con éxito! Acabas de recibir: "..data[1].data1.." de "..data[1].data2.."." }, color = 255,255,255 })
							--[[ Check if global announcements are on if they are then announce the rewards globally ]]
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2CODIGOS REGALO^7]', "^1"..GetPlayerName(source).." ^7Acaba de canjear un CODIGO REGALO y recibió: ^1"..data[1].data2.."x de "..table.concat(ch, ", ") }, color = 255,255,255 })
							end
						elseif (data[1].type == "arma") then
							MySQL.Async.execute("DELETE FROM redeemcodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							xPlayer.addWeapon(tostring(data[1].data1), data[1].data2)
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "¡Código canjeado con éxito! Acabas de recibir: "..data[1].data1.." con "..data[1].data2.." balas." }, color = 255,255,255 })
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2CODIGOS REGALO^7]', "^1"..GetPlayerName(source).." ^7Acaba de canjear un CODIGO REGALO y recibió un ^1"..string.upper(string.gsub(data[1].data1, "weapon_", "")) }, color = 255,255,255 })
							end
						else
							MySQL.Async.execute("DELETE FROM redeemcodes WHERE code = @code;", {
								['@code'] = args[1],
							})
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2EXITO^7]^2', "Code redeemed successfully! Reward: Unknown" }, color = 255,255,255 })
							if Config.globalAnnouncements then
								TriggerClientEvent('chat:addMessage', -1, { args = { '^7[^2CODIGOS REGALO^7]', "^1"..GetPlayerName(source).." ^7Acaba de canjear un CODIGO REGALO y recibió unn unknown reward" }, color = 255,255,255 })
							end
						end
					end
				else
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1ERROR^7]^2', "¡Codigo invalido!" }, color = 255,255,255 })
					else
						print("Código no válido + No puedes canjear códigos como consola.")
					end
				end
			end
		end)
	end
end, false)

--[[
	Huge thanks to https://github.com/XvenDeR for helping with alot of stuff.
]]

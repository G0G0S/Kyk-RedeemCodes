AddEventHandler('onClientResourceStart', function (resourceName)
    if (GetCurrentResourceName() == resourceName) then
        TriggerEvent('chat:addSuggestion', '/generarVariosCodigos', 'Genera varios CODIGOS REGALO a la vez.', {
            { name="type", help="Qué CODIGO REGALO quieres generar. Por ejemplo: Dinero." },
            { name="amount", help="Cuánto (en este caso dinero) será recompensado el jugador. Por ejemplo: 200." },
            { name="count", help="Cuántos CODIGOS REGALO quieres generar. Por ejemplo: 20." }
        })
        TriggerEvent('chat:addSuggestion', '/generarCodigo', 'Genera un CODIGO REGALO.', {
            { name="type", help="Qué CODIGO REGALO quieres generar. Por ejemplo: Dinero." },
            { name="amount", help="Cuánto (en este caso dinero) será recompensado el jugador. Por ejemplo: 200." }
        })
        TriggerEvent('chat:addSuggestion', '/canjear', 'Canjear un CODIGO REGALO.', {
            { name="code", help="Ingrese el CODIGO REGALO que desea canjear." }
        })
    end
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        TriggerEvent('chat:removeSuggestion', '/generarCodigo')
        TriggerEvent('chat:removeSuggestion', '/generarVariosCodigos')
        TriggerEvent('chat:removeSuggestion', '/canjear')
    end
end)

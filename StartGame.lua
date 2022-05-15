function onload()
    lockout = false
    self.createButton({
        label="Start Game", click_function="Start", function_owner=self,
        position={0,0,0}, height=350, width=350
    })
end

function Start(o, color)
    Global.call('StartGame')
end
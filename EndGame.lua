function onload()
    lockout = false
    self.createButton({
        label="", click_function="End", function_owner=self,
        position={0,0,0}, height=350, width=350
    })
end

function End(o, color)
    Global.call('EndGame')
end
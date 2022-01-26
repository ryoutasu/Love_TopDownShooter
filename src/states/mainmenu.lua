local MainMenuState = {}

function MainMenuState:init()
    self.UI = Urutora:new()
end

function MainMenuState:enter()
    love.graphics.setBackgroundColor(0.6, 0.6, 0.6, 1)

    local text = Urutora.label({text = 'THE GAME ABOUT GUNS', x = 100, y = 100, w = 200, h = 40})

    local startGameBtn = Urutora.button({text = 'Start game', x = 100, y = 150, w = 200, h = 40})
    :action(function(e)
        Gamestate.switch(game)
    end)

    local editorBtn = Urutora.button({text = 'Start editor', x = 100, y = 200, w = 200, h = 40})
    :action(function(e)
        Gamestate.switch(editor)
    end)

    self.UI:add(text)
    :add(startGameBtn)
    :add(editorBtn)
end

function MainMenuState:update(dt)
    self.UI:update(dt)
end

function MainMenuState:draw()
    self.UI:draw()
end

function MainMenuState:keypressed(key, scancode, isrepeat) self.UI:keypressed(key, scancode, isrepeat) end
function MainMenuState:mousepressed(x, y, button) self.UI:pressed(x, y) end
function MainMenuState:mousemoved(x, y, dx, dy) self.UI:moved(x, y, dx, dy) end
function MainMenuState:mousereleased(x, y, button) self.UI:released(x, y) end
function MainMenuState:textinput(text) self.UI:textinput(text) end
function MainMenuState:wheelmoved(x, y) self.UI:wheelmoved(x, y) end

return MainMenuState
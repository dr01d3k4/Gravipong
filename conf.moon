love.conf = (t) ->
	t.title = "Gravipong"
	t.author = "dr01d3k4"

	t.url = nil
	t.identity = nil
	t.version = "0.8.0"

	t.console = true
	t.release = false

	t.screen.width = 900
	t.screen.height = 540
	t.screen.fullscreen = false
	t.screen.vsync = true
	t.screen.fsaa = 0

	t.modules.joystick = false
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = false
	t.modules.sound = true
	t.modules.physics = false
io.stdout:setvbuf('no')

function love.conf(config)
	config.identity = 'PrimitiveTechnology'
	config.version = '0.10.1'
	config.console = false

	config.window.title = 'Primitive Technology'
	config.window.icon = 'assets/images/icon.png'
	config.window.fullscreentype = 'desktop'
	config.window.msaa = 0
	config.window.vsync = true
	config.window.resizable = true
	config.window.minwidth = 320
	config.window.minheight = 200
	config.window.width = 640
	config.window.height = 400
end

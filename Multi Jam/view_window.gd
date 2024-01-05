extends Window

@onready var _Camera: Camera2D = $Camera2D
@onready var _MainWindow: Window = get_window()
@export_range(0, 19) var player_visibility_layer: int = 1
@export_range(0, 19) var world_visibility_layer: int = 0

var world_offset: = Vector2i.ZERO
var last_position: = Vector2i.ZERO
var velocity: = Vector2i.ZERO
var focused: = false

func _ready():
	# Set the anchor mode to "Fixed top-left"
	# Easier to work with since it corresponds to the window coordinates
	_Camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT

	transient = true # Make the window considered as a child of the main window
	#close_requested.connect(queue_free) # Actually close the window when clicking the close button

func _process(delta: float):
	velocity = position - last_position
	last_position = position
	_Camera.position = get_camera_pos_from_window()
	if Global.falling:
		transient = false
		#_MainWindow.always_on_top = true
		move_to_foreground()
		_MainWindow.set_canvas_cull_mask_bit(player_visibility_layer, true)
	else:
		_MainWindow.set_canvas_cull_mask_bit(player_visibility_layer, false)
		#_MainWindow.always_on_top = false
		transient = true

func get_camera_pos_from_window()->Vector2i:
	return (position + velocity) / Vector2i(_Camera.zoom)

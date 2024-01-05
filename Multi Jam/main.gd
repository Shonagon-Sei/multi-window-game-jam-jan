extends Node

@onready var _MainWindow: Window = get_window()

@export var player_size: Vector2i = Vector2i(64, 64)
@export_node_path("Camera2D") var main_camera: NodePath
@onready var _MainCamera: Camera2D = get_node(main_camera)
@export var view_window: PackedScene

@export_range(0, 19) var player_visibility_layer: int = 1
@export_range(0, 19) var world_visibility_layer: int = 0

var world_offset: = Vector2i.ZERO


func _ready():
	ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed", true)
	# Set the window settings - most of them can be set in the project settings
	_MainWindow.borderless = true		# Hide the edges of the window
	_MainWindow.unresizable = true		# Prevent resizing the window
	_MainWindow.always_on_top = true	# Force the window always be on top of the screen
	_MainWindow.gui_embed_subwindows = false # Make subwindows actual system windows <- VERY IMPORTANT
	_MainWindow.transparent = true		# Allow the window to be transparent
	# Settings that cannot be set in project settings
	_MainWindow.transparent_bg = true	# Make the window's background transparent
	_MainWindow.min_size = player_size * Vector2i(_MainCamera.zoom)
	_MainWindow.size = _MainWindow.min_size
	
	_MainWindow.set_canvas_cull_mask_bit(player_visibility_layer, true)
	_MainWindow.set_canvas_cull_mask_bit(world_visibility_layer, false)
	
	
	var spawn = Vector2i(450, 300)
	var windowSize = Vector2i(1100, 500)
	var closeable = false
	create_view_window(spawn, windowSize, closeable)


func _process(delta: float) -> void:
	_MainWindow.position = get_window_pos_from_camera()
	_MainWindow.move_to_foreground()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		create_view_window()
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func get_window_pos_from_camera()->Vector2i:
	return (Vector2i(_MainCamera.global_position + _MainCamera.offset) - player_size / 2) * Vector2i(_MainCamera.zoom)
	
func create_view_window(positionspawn:Vector2i = Vector2i.ZERO, size:Vector2i = Vector2i(500, 500), close:bool = true):
	var new_window: Window = view_window.instantiate()
	# Pass the main window's world to the new window
	# This is what makes it possible to show the same world in multiple windows
	new_window.world_2d = _MainWindow.world_2d
	# The new window needs to have the same world offset as the player
	new_window.world_offset = world_offset
	new_window.position = positionspawn
	new_window.size = size
	# Contrarily to the main window, hide the player and show the world
	new_window.set_canvas_cull_mask_bit(player_visibility_layer, false)
	new_window.set_canvas_cull_mask_bit(world_visibility_layer, true)
	add_child(new_window)



func _on_node_2d_falling():
	while Global.falling:
		_MainWindow.always_on_top = false
	_MainWindow.always_on_top = true
	_MainWindow.move_to_foreground()


func _on_node_2d_finish_falling():
	_MainWindow.always_on_top = true
	_MainWindow.move_to_foreground()

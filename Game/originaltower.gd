extends Sprite2D

signal drawtower

var dragging = false
var drag_offset = Vector2.ZERO
var tower_count = 0
var original_position = Vector2.ZERO
var can_drag_and_duplicate = true

func _ready():
	# Move the tower off-screen and hide it
	global_position = Vector2(-1000, -1000)
	visible = false
	connect("drawtower", Callable(self, "_on_drawtower"))

func _on_drawtower():
	print("Received drawtower signal")
	# Change texture based on Globals["tower"]["value"]
	var i = 0
	for tower_data in Globals.data["tower"]["value"]:
		texture = load("res://Pic/tower/tower_%d.png" % tower_data["type"])
		var new_tower = duplicate()
		new_tower.name = "tower_%d" % tower_data["type"]
		get_parent().add_child(new_tower)
		new_tower.global_position = Vector2(100 + Globals.data["coords"]["size"] * i, 80)  # Set the initial position as needed
		new_tower.visible = true
		new_tower.set_script(self.get_script())
		print("Added tower: ", new_tower.name, " at position: ", new_tower.global_position)
		i += 1

func _input(event):
	if can_drag_and_duplicate:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if get_global_mouse_position().distance_to(global_position) < 60: # Adjust the distance as needed
					dragging = true
					drag_offset = global_position - get_global_mouse_position()
					original_position = global_position
			elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if dragging:
					dragging = false
					snap_to_grid()  # Snap to grid when dragging stops
					_on_DragBegin()
					_create_new_tower_at_original_position()
					can_drag_and_duplicate = false  # Disable dragging and duplicating

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

func snap_to_grid():
	var grid_size = Globals.data["coords"]["size"]
	var grid_origin = Vector2(Globals.data["coords"]["origin"][0], Globals.data["coords"]["origin"][1])
	var closest_grid_point = Vector2(
		round((global_position.x - grid_origin.x) / grid_size) * grid_size + grid_origin.x,
		round((global_position.y - grid_origin.y) / grid_size) * grid_size + grid_origin.y
	)
	if global_position.distance_to(closest_grid_point) < Globals.data["coords"]["size"]: # Adjust the snap distance as needed
		global_position = closest_grid_point.round()  # Round to the nearest integer

func _on_DragBegin():
	var grid_size = Globals.data["coords"]["size"]
	var grid_origin = Vector2(Globals.data["coords"]["origin"][0], Globals.data["coords"]["origin"][1])
	var closest_grid_point = Vector2(
		round((global_position.x - grid_origin.x) / grid_size) * grid_size + grid_origin.x,
		round((global_position.y - grid_origin.y) / grid_size) * grid_size + grid_origin.y
	)
	if global_position.distance_to(closest_grid_point) < Globals.data["coords"]["size"]: # Adjust the snap distance as needed
		global_position = closest_grid_point.round()  # Round to the nearest integer
		print("Moved tower to position: ", global_position)

func _create_new_tower_at_original_position():
	var new_tower = duplicate()
	new_tower.name = "tower_%d" % tower_count
	tower_count += 1
	get_parent().add_child(new_tower)
	new_tower.global_position = original_position
	new_tower.visible = true
	new_tower.set_script(self.get_script())
	print("Created new tower at original position: ", new_tower.global_position)
	# Disable dragging and duplicating for the original tower
	self.disconnect("input_event", Callable(self, "_input"))

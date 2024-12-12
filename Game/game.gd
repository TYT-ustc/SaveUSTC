extends Node2D

var original_sprite : Sprite2D
var original_enemy_1 : Sprite2D
var data : Dictionary

func read_json(filepath: String) -> Dictionary:
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var json = JSON.new()
		var error = json.parse(content)
		if error == OK:
			return json.get_data()
		else:
			print("Error parsing JSON: ", json.get_error_message())
			return {}
	else:
		print("Failed to open file: ", filepath)
		return {}

func _ready():
	var game_num = Globals.current_scene_number
	print("Current game number: ", game_num)
	# 根据game_num确定读取的文件路径
	var file_path = "res://Game/game%d.json" % game_num
	print("Loading data from: ", file_path)
	original_sprite = $OriginalRoad  # 确认节点名是否准确
	original_enemy_1 = $enemy_1  # 确认节点名是否准确，并附加了 enemy_1.gd 脚本
	data = read_json(file_path)
	print("Data loaded: ", data)
	Globals.data = data
	drawmap()
	for i in range(data["enemy"]["num"]):
		drawenemy(i)
		await get_tree().create_timer(4.0).timeout  # 控制敌人生成的间隔

func drawmap():
	var num = data["map"]["num"]
	var val = data["map"]["value"]
	for i in range(num):
		var x = val[i][0]
		var y = val[i][1]
		var copied_sprite = original_sprite.duplicate() as Sprite2D
		copied_sprite.position = Vector2(200 + 180 * x, 300 + 180 * y)
		add_child(copied_sprite)

func drawenemy(id: int):
	var enemy_type = data["enemy"]["value"][id]["type"]
	var enemy_to_duplicate : Sprite2D
	if enemy_type == 1:
		enemy_to_duplicate = original_enemy_1
	else:
		print("未知的敌人类型：", enemy_type)
		return  # 跳过未知类型

	var copied_sprite = enemy_to_duplicate.duplicate(DUPLICATE_SCRIPTS) as Sprite2D
	copied_sprite.name = "Enemy_%d" % id  # 更改复制节点的名称
	copied_sprite.add_to_group("enemies")  # 将敌人节点加入“enemies”组
	copied_sprite.position = Vector2(200, 300)  # 设置初始位置
	add_child(copied_sprite)
	print("Added enemy: ", copied_sprite.name, " at position: ", copied_sprite.position)
	copied_sprite.emit_signal("start_1")  # 发射信号

func _process(delta: float) -> void:
	pass

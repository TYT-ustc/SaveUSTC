extends Node2D
# Called when the node enters the scene tree for the first time.
var file_path = "res://Game/map1.json"

var original_sprite : Sprite2D
var original_enemy : Sprite2D

func read_json(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()  # 读取文件内容为字符串
		file.close()  # 关闭文件
		# 创建 JSON 类的实例
		var json = JSON.new()
		# 使用实例调用 parse() 方法
		var parse_result = json.parse(content)  # 解析 JSON 字符串
		# 检查解析是否成功
		if parse_result == OK:
			return json.get_data()  # 获取解析后的数据
		else:
			print("Error parsing JSON: ", parse_result)
			return {}
	else:
		print("Failed to open file: ", file_path)
		return {}



func _ready():
	original_sprite = $OriginalRoad  # 请确认节点名是否准确
	original_enemy = $enemy  # 请确认节点名是否准确
	var data = read_json(file_path)
	drawmap(data)
	for i in range(3):
		drawenemy(data)
		await get_tree().create_timer(4.0).timeout

	
	
func drawmap(data: Dictionary):
		# 获取需要复制的原始精灵节点
	var num = data["num"]
	var val = data["value"]
	var x
	var y
	for i in range(num):
		x = val[i][0]
		y = val[i][1]
		# 复制精灵节点
		var copied_sprite = original_sprite.duplicate() as Sprite2D
		# 设置复制节点的位置
		copied_sprite.position = Vector2(200+200*x, 300+200*y)  # 替换为目标坐标
		# 添加到场景树中
		add_child(copied_sprite)

func drawenemy(data: Dictionary):
	var num = data["num"]
	var val = data["value"]
	var copied_sprite = original_enemy.duplicate() as Sprite2D
	var x
	var y
	# 设置复制节点的位置
	# 添加到场景树中
	add_child(copied_sprite)
	for i in range(num):
		x = val[i][0]
		y = val[i][1]
		copied_sprite.position = Vector2(200+200*x, 300+200*y)  # 替换为目标坐标
		# 等待 3 秒
		await get_tree().create_timer(2.0).timeout


func _process(delta: float) -> void:
	pass

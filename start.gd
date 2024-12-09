extends Node2D

var button : Button
var label : Label
var window : Window  # 使用 Window 控件而非 WindowDialog
# 声明一个变量用于 AudioStreamPlayer
@export var music_path : String = "res://BGM01.mp3"
# 当场景准备好时调用
func _ready():
	# 获取节点
	button = get_node("Node2D/Button")
	window = get_node("Node2D/Window")  # 获取窗口节点
	label = get_node("Node2D/Window/Label")  # 获取窗口中的 Label 控件
	
	# 默认隐藏整个窗口
	window.visible = false
	label.visible = false  # 确保 Label 初始状态也是隐藏的
	
	# 连接按钮的信号
	button.pressed.connect(Callable(self, "_on_Button_pressed"))

	# 连接 Window 的 close_requested 信号
	window.close_requested.connect(Callable(self, "_on_Window_close"))
	
	var music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	var music_stream = load(music_path)
	
	if music_stream is AudioStream:
		music_player.stream = music_stream
		music_player.play()  # 播放音乐
	else:
		print("无法加载音乐文件: ", music_path)
# 按钮被点击时执行的函数
func _on_Button_pressed():
	# 显示整个窗口和 Label
	window.visible = true
	label.visible = true
	
	# 弹出窗口
	window.popup_centered()  # 弹出窗口并居中

# 当窗口关闭按钮被点击时，调用的函数
func _on_Window_close():
	window.visible = false  # 隐藏窗口

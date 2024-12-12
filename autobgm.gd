extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 设置音频流
	stream = preload("res://BGM01.mp3")
	# 确保音频流未暂停
	stream_paused = false
	# 播放音频
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Control

var game = preload("res://Scenes/Game/Game.tscn")

func _physics_process(delta: float) -> void:
	if get_node_or_null("Square") != null:
		$Square.rotate(0.02)


func _on_CaptureArea_captured() -> void:
	$Timer.start()


func _on_Timer_timeout() -> void:
	ScoreManager.score = 0
	print("aaaaaaaaaa")
	get_tree().change_scene_to(game)

func _ready() -> void:
	$Score.text = "Score: %d" % ScoreManager.score

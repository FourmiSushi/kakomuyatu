extends Area2D

signal captured

var capture_start = Vector2()

# 初期化処理
func _ready():
	visible = false # 何もしていないときは見えない

# 物理演算が関係する、毎フレームごとの処理は_physics_processに書く
func _physics_process(delta):
	# 必要な入力情報を用意する
	var just_pressed = Input.is_action_just_pressed("action_main")
	var pressing = Input.is_action_pressed("action_main")
	var just_released = Input.is_action_just_released("action_main")
	var mouse_pos = get_viewport().get_mouse_position()
	
	if just_pressed:
		capture_start = mouse_pos # 矩形の始点
		visible = true # クリックすると見えるようになる
		Engine.set_time_scale(0.2)
		$CaptureSE.play()

	if pressing:
		# 左ボタンが押下されている間はCollisionPolygon2DとPolygon2Dを常に変更する
		var poly = [
			capture_start,
			Vector2(capture_start.x, mouse_pos.y),
			mouse_pos,
			Vector2(mouse_pos.x, capture_start.y)
			]
		$CollisionPolygon2D.polygon = poly
		$Polygon2D.polygon = poly
		
	if just_released:
		# はなされるとみえるようになり、ポリゴンはリセットされる
		emit_signal("captured")
		visible = false
		$CollisionPolygon2D.polygon = []
		$Polygon2D.polygon = []
		Engine.set_time_scale(1)
		if len(get_overlapping_bodies()) > 0:
			$ExplosionSE.play()


func _on_CaptureArea_body_entered(body: Node) -> void:
	connect("captured", body, "_on_captured")


func _on_CaptureArea_body_exited(body: Node) -> void:
	disconnect("captured", body, "_on_captured")

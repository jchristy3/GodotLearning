extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var dead = false
const SPEED = 50.0
const JUMP_VELOCITY = -200.0
@onready var anim = get_node("AnimationPlayer")

func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	#Gravity for Frog
	velocity.y += gravity * delta
	if chase:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Jump")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		elif direction.x < 0:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()

func _on_player_collision_body_entered(body):
	if body.name == "Player":
		Game.playerHP -= 3
		death()
		
func death():
	if not dead:
		Game.gold += 1
		Utils.saveGame()
		dead = true
		chase = false
		get_node("AnimatedSprite2D").play("Death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()

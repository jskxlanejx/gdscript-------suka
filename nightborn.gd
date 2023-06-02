extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null
var attack = false

var can_respawn = false
var can_die = false

var health = 100
var player_inattack_zone = false
var can_take_damage = true

func _physics_process(delta):
	deal_with_damage()
	update_health()
  
	if player_chase:
		position += (player.position - position)/speed
  
		$AnimatedSprite2D.play("walk")
  
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false

	if health <= 0:
		$death.start()
		$AnimatedSprite2D.play("death")
		print(global.nborn_die)
		if can_die == true:
			self.queue_free()

	elif player_inattack_zone and global.player_current_attack == true:
		$AnimatedSprite2D.play("attack")
	else:
		$AnimatedSprite2D.play("idle")

func _on_death_timeout():
	can_die = true

func _on_attack_cd_timeout():
	can_take_damage = true
	
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func enemy():
	pass
	
func slime():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
		
func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - global.playerdamage
			$take_damage_cooldown.start()
			can_take_damage = false
			print("nborn health: ", health)

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else: 
		healthbar.visible = true


func _on_attack_zone_body_entered(body):
	if body.has_method("player"):
		attack = true


func _on_attack_zone_body_exited(body):
	if body.has_method("player"):
		attack = false


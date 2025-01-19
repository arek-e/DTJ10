extends Area2D
class_name HurtboxComponent

@export var hit_effect: HitEffect # Drag the damage calculator node in the editor
@onready var audio_anim_player = %AudioAnimationPlayer

func trigger_hurt() -> Attack:
	if hit_effect:
		var attack = hit_effect.trigger_damage()
		audio_anim_player.play("hit_effect")
		return attack
	else:
		print("No DamageCalculator assigned to HurtComponent!")
		var attack = Attack.new()
		attack.attack_damage = 0
		return attack

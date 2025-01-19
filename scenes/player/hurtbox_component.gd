extends Area2D
class_name HurtboxComponent

@export var hit_effect: HitEffect # Drag the damage calculator node in the editor
@onready var audio_anim_player = %AudioAnimationPlayer

func trigger_hurt() -> float:
	if hit_effect:
		var damage = hit_effect.trigger_damage()
		audio_anim_player.play("hit_effect")
		return damage
	else:
		print("No DamageCalculator assigned to HurtComponent!")
		return 0

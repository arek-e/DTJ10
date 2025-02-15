extends Node2D
class_name HitboxComponent

@export var health_component: HealthComponent
@onready var animation_player: AnimationPlayer = $HitFlashAnimationPlayer

func take_damage(attack: Attack):
	if health_component is HealthComponent:
		animation_player.play("hit_flash")
		health_component.take_damage(attack)


func _on_hitbox_area_entered(area) -> void:
	if area is HurtboxComponent:
		var hurtbox: HurtboxComponent = area
		var damage_to_take = hurtbox.trigger_hurt()
		take_damage(damage_to_take)

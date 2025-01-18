extends Node2D
class_name HitboxComponent

@export var health_component: HealthComponent

func take_damage(damage: float):
	if health_component is HealthComponent:
		health_component.take_damage(damage)


func _on_hitbox_area_entered(area) -> void:
	if area is HurtboxComponent:
		var hurtbox: HurtboxComponent = area
		var damage_to_take = hurtbox.trigger_hurt()
		take_damage(damage_to_take)

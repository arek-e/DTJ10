extends Area2D
class_name HurtboxComponent

@export var hit_effect: HitEffect # Drag the damage calculator node in the editor
@onready var audio_anim_player = %AudioAnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $"../GPUParticles2D"

func trigger_hurt() -> Attack:
	if hit_effect:
		var attack = hit_effect.trigger_damage()
		
		# Check if `audio_anim_player` is null before playing
		if audio_anim_player:
			if attack.is_critical_hit:
				audio_anim_player.play("crit_hit_effect")
			else:
				audio_anim_player.play("hit_effect")
		
		if gpu_particles_2d:
			gpu_particles_2d.restart()
			gpu_particles_2d.emitting = true
		
		return attack
	else:
		print("No DamageCalculator assigned to HurtComponent!")
		var attack = Attack.new()
		attack.attack_damage = 0
		return attack

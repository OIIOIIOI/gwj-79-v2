extends Node2D
class_name Weapon


const WEAPON_IDLE_ROTATION = -70.0
const WEAPON_MAX_ROTATION = 17.5


func intro() -> Tween:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, ^"rotation_degrees", WEAPON_IDLE_ROTATION, 1.5)
	return tween


func hit(ratio: float = 0.0) -> Tween:
	var r = lerp(0.0, WEAPON_MAX_ROTATION, ratio)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, ^"rotation_degrees", r, 0.6)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, ^"rotation_degrees", WEAPON_IDLE_ROTATION, 0.4)
	return tween

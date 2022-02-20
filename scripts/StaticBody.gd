extends StaticBody

onready var shader = $MeshInstance.get_mesh().material.next_pass
var highlighted = false setget _glow

	
func _glow(val):
	highlighted = val
	if highlighted:
		shader.set_shader_param("strength", 0.6)
		pass
	else:
		shader.set_shader_param("strength", 0.0)
		pass

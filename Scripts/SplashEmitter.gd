extends GPUParticles3D

func _ready():
	self
	self.restart()

func _on_finished():
	self.queue_free()

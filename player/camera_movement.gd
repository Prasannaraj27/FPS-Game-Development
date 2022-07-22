extends Camera

### Node is the parent class of all node types
### so using it here allows target to be any node type
var target: Node = null;

func _physics_process(delta) -> void:
	### set local transform to zero which
	### snaps the camera to the parent node
	global_transform.origin = target.global_transform.origin;

extends Camera

### Spatial is the parent class of all node types
### so using it here allows target to be any node type
var target: Spatial = null;

func _physics_process(delta):
	### set local transform to zero which
	### snaps the camera to the parent node
	self.global_transform.origin = target.global_transform.origin;

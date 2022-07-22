extends RigidBody
class_name Interactable, "res://icon.png"

signal destructor(node);

onready var mesh = $mesh;
onready var notifier = $notifier;
onready var tooltip = $tooltip;

var in_view: bool = false;

func _ready():
	self.connect("tree_exiting", self, "_destructor");
	self.notifier.max_distance = 50.0;
	self.notifier.connect("camera_entered", self, "entered_view");
	self.notifier.connect("camera_exited", self, "exited_view");

func create_tooltip() -> String:
	return "[tooltip]"
	
func _physics_process(_delta):
	if self.in_view:
		self.tooltip.global_transform.origin = self.global_transform.origin + Vector3(0.0, self.mesh.global_transform.basis.y.length() * 1.5, 0.0);

func entered_view(camera: Camera):
	self.in_view = true;
	self.tooltip.text = self.create_tooltip();
	self.tooltip.visible = true;
	
func exited_view(camera: Camera):
	self.in_view = false;
	self.tooltip.visible = false;

func _destructor():
	self.emit_signal("destructor", self);

extends RigidBody
class_name Interactable, "res://assets/icon.png"

signal destructor(node);

onready var mesh = $mesh;
onready var notifier = $notifier;
onready var tooltip = $tooltip;

var in_view: bool = false;

func _ready() -> void:
	connect("tree_exiting", self, "_destructor");
	notifier.max_distance = 5.0;
	notifier.connect("camera_entered", self, "entered_view");
	notifier.connect("camera_exited", self, "exited_view");

func create_tooltip() -> String:
	return "[tooltip]"
	
func _physics_process(_delta) -> void:
	if in_view:
		tooltip.global_transform.origin = global_transform.origin + Vector3(0.0, mesh.global_transform.basis.y.length() * 1.5, 0.0);

func entered_view(camera: Camera) -> void:
	in_view = true;
	tooltip.text = self.create_tooltip();
	tooltip.visible = true;
	
func exited_view(camera: Camera) -> void:
	in_view = false;
	tooltip.visible = false;

func _destructor() -> void:
	emit_signal("destructor", self);

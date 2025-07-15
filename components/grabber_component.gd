@icon("res://icons/grabber_component.svg")
class_name GrabberComponent
extends Node2D

var is_grabbing: bool = false
var grabbed_obj: Node2D = null

func grab(obj: Node2D) -> void:
	if is_grabbing || grabbed_obj != null:
		return  # Already grabbing something
	
	var grabbable_component := _get_grabbable_component_or_null(obj)
	grabbable_component.get_grabbed_by(self)
	
	is_grabbing = true
	grabbed_obj = obj
	
	if !grabbable_component.stolen.is_connected(on_obj_stolen):
		grabbable_component.stolen.connect(on_obj_stolen)

func on_obj_stolen() -> void:
	is_grabbing = false
	grabbed_obj = null

func throw(force: Vector2) -> void:
	if !is_grabbing || grabbed_obj == null:
		return  # Not grabbing anything
	
	var grabbable_component := _get_grabbable_component_or_null(grabbed_obj)
	grabbable_component.get_thrown(force)
	
	is_grabbing = false
	grabbed_obj = null

func _get_grabbable_component_or_null(obj: Node2D) -> GrabbableComponent:
	if !obj.has_method("get_grabbable_component"):
		DebugLogger.error("Invalid grab object! Doesn't have 'get_grabbable_component' method")
		return null  # Not grabbable
	return obj.get_grabbable_component()

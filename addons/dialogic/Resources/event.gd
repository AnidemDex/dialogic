tool
extends Resource
class_name DialogicEvent

enum Category {
	MAIN,
	LOGIC,
	TIMELINE,
	AUDIOVISUAL,
	GODOT,
	OTHER,
}

# Hopefully we can replace this with a cleaner system
# maybe even generate them based on some markup? who knows, it is free to dream
export(Array, Resource) var header : Array
export(Array, Resource) var body : Array

export (String) var help_page_path

export (bool) var expand_by_default : bool = true
export (bool) var needs_indentation : bool = false
export (bool) var display_name : bool = true

export (int) var sorting_index : int

# -----------------------------------------
# Emilio:
# Stuff I yet don't understand made by Dex:
# -----------------------------------------

# This file is part of EventSystem, distributed under MIT license
# and modified to work with Dialogic.
# You can see the license of this file here
# https://github.com/AnidemDex/Godot-EventSystem/blob/main/LICENSE


## 
## Base class for all events.
##
## @desc: 
##    Every event relies on this class. 
##    If you want to do your own event, you should [code]extend[/code] this class.
##

## Emmited when the event starts.
## The signal is emmited with the event resource [code]event_resource[/code]
signal event_started(event_resource)

## Emmited when the event finish. 
## The signal is emmited with the event resource [code]event_resource[/code]
signal event_finished(event_resource)

##########
# Default Event Properties
##########

## Determines if the event will go to next event inmediatly or not. 
## If value is true, the next event will be executed when event ends.
export(bool) var continue_at_end:bool = true setget _set_continue

## The event icon that'll be displayed in the editor
var event_icon:Texture = load("res://addons/dialogic/Images/Event Icons/warning.svg")

## The event color that event node will take in the editor
var event_color:Color = Color("FBB13C")

## The event name that'll be displayed in the editor.
## If the resource name is different from the event name, resource_name is returned instead.
var event_name:String = "Event"


var event_category:int = Category.OTHER


# This exist to avoid errors with the editor. Can be safely removed
# when the editor works with the new property names.
# Why with the "event_" prefix? To know wich properties are related to
# the editor and avoid confusion with node properties.
func _get(property: String):
	if property == "name":
		return event_name
	if property == "icon":
		return event_icon
	if property == "color":
		return event_color
	if property == "category":
		return event_category


## Executes the event behaviour.
func execute() -> void:
	emit_signal("event_started", self)
	
	call_deferred("_execute")


## Ends the event behaviour.
func finish() -> void:
	emit_signal("event_finished", self)


func _execute() -> void:
	finish()


func _set_continue(value:bool) -> void:
	continue_at_end = value
	property_list_changed_notify()
	emit_changed()


func property_can_revert(property:String) -> bool:
	if property == "event_node_path":
		return true
	return false


func property_get_revert(property:String):
	if property == "event_node_path":
		return NodePath()


func _to_string() -> String:
	return "[{name}:{id}]".format({"name":event_name, "id":get_instance_id()})


func _hide_script_from_inspector():
	return true

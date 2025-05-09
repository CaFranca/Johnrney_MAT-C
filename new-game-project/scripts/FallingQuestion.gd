extends CharacterBody2D

var question = ""
var answer = 0
var speed = 100.0
var answered = false

signal question_failed

@onready var label = $Label

func _ready():
	label.text = question

func _physics_process(delta):
	if not answered:
		velocity = Vector2(0, speed)
		move_and_slide()

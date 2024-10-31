class_name ControlStore extends Node

var _store: Array[QubitControl]

func add_qubit(data):
	_store.push_back(QubitControl.new(data, %BlochSphere))
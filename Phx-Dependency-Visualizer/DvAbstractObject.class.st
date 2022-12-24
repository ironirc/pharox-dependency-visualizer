Class {
	#name : #DvAbstractObject,
	#superclass : #Model,
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #'instance creation' }
DvAbstractObject class >> newNamed: aName [

	| inst |
	inst := self new.
	inst name: aName.
	^ inst
]

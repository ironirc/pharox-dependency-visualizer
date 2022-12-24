Class {
	#name : #PhxDvAbstractObject,
	#superclass : #Model,
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #'instance creation' }
PhxDvAbstractObject class >> newNamed: aName [

	| inst |
	inst := self new.
	inst name: aName.
	^ inst
]

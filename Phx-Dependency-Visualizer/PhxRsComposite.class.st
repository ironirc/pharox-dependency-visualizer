Class {
	#name : #PhxRsComposite,
	#superclass : #RSComposite,
	#traits : 'DvInAndOutHighlitable',
	#classTraits : 'DvInAndOutHighlitable classTrait',
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #'instance creation' }
PhxRsComposite class >> newUnder: anObject [
	| object |
	object := super new.
	object parent: anObject.
	^ object
]

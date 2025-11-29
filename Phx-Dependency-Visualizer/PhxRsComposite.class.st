Class {
	#name : 'PhxRsComposite',
	#superclass : 'RSComposite',
	#traits : 'DvInAndOutHighlitable',
	#classTraits : 'DvInAndOutHighlitable classTrait',
	#category : 'Phx-Dependency-Visualizer-visualisation',
	#package : 'Phx-Dependency-Visualizer',
	#tag : 'visualisation'
}

{ #category : 'instance creation' }
PhxRsComposite class >> newUnder: anObject [
	| object |
	object := super new.
	object parent: anObject.
	^ object
]

{ #category : 'accessing' }
PhxRsComposite >> model: anObject [

	model ifNotNil: [ self removeDependent: self ].
	anObject ifNotNil: [ anObject addDependent: self ].
	model := anObject
]

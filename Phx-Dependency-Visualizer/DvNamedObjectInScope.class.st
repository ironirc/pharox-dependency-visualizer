Class {
	#name : #DvNamedObjectInScope,
	#superclass : #DvAbstractObject,
	#instVars : [
		'scope',
		'name'
	],
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #accessing }
DvNamedObjectInScope >> name [

	^ name
]

{ #category : #accessing }
DvNamedObjectInScope >> name: anObject [

	name := anObject.
	self changed: #name 
	
]

{ #category : #printing }
DvNamedObjectInScope >> printOn: ws [

	super printOn: ws.
	ws << ' ('.
	ws << self name. 
	ws << ')'
]

{ #category : #accessing }
DvNamedObjectInScope >> scope [

	^ scope
]

{ #category : #accessing }
DvNamedObjectInScope >> scope: anObject [

	scope ifNotNil: [ self removeMeFromScope: scope ].
	scope := anObject.
	scope ifNotNil: [ self addMeToScope: scope ].
	self changed: #scope
]

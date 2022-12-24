Class {
	#name : #PhxDvNamedObjectInScope,
	#superclass : #PhxDvAbstractObject,
	#instVars : [
		'scope',
		'name'
	],
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #accessing }
PhxDvNamedObjectInScope >> name [

	^ name
]

{ #category : #accessing }
PhxDvNamedObjectInScope >> name: anObject [

	name := anObject.
	self changed: #name 
	
]

{ #category : #printing }
PhxDvNamedObjectInScope >> printOn: ws [

	super printOn: ws.
	ws << ' ('.
	ws << self name. 
	ws << ')'
]

{ #category : #accessing }
PhxDvNamedObjectInScope >> scope [

	^ scope
]

{ #category : #accessing }
PhxDvNamedObjectInScope >> scope: anObject [

	scope := anObject.
	self changed: #scope
]

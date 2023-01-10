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

{ #category : #changing }
DvAbstractObject >> changed: aSymbol [

	super changed: aSymbol.
	"self announcer announce:
		(DvAnnouncementAspectChanged onModel: self aspect: aSymbol)"
]

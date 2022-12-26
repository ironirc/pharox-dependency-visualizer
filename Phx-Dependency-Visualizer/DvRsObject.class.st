Class {
	#name : #DvRsObject,
	#superclass : #DvRsModelShapesAdaptor,
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #'announcement handling' }
DvRsObject >> handleAnnouncementAspectChanged: a [
	self subclassResponsibility
]

{ #category : #actions }
DvRsObject >> leftClick: aRSMouseLeftClick [ 
	"self shouldBeImplemented."
]

{ #category : #'setUp-tearDown' }
DvRsObject >> setupListenersToModel [
	model announcer
		when: DvAnnouncementAspectChanged 
		do: [ :a | self handleAnnouncementAspectChanged: a ]
		for: self
]

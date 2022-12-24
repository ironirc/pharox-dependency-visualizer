Class {
	#name : #DvRoObject,
	#superclass : #RoassalModelShapesAdaptor,
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #'announcement handling' }
DvRoObject >> handleAnnouncementAspectChanged: a [
	self subclassResponsibility
]

{ #category : #'setUp-tearDown' }
DvRoObject >> setupListenersToModel [
	model announcer
		when: BT8AnnouncementAspectChanged
		do: [ :a | self handleAnnouncementAspectChanged: a ]
		for: self
]

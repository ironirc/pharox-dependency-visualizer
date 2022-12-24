Class {
	#name : #PhxDvRoObject,
	#superclass : #RoassalModelShapesAdaptor,
	#category : #'Phx-Dependency-Visualizer-viz gen2'
}

{ #category : #'announcement handling' }
PhxDvRoObject >> handleAnnouncementAspectChanged: a [
	self subclassResponsibility
]

{ #category : #'setUp-tearDown' }
PhxDvRoObject >> setupListenersToModel [
	model announcer
		when: BT8AnnouncementAspectChanged
		do: [ :a | self handleAnnouncementAspectChanged: a ]
		for: self
]

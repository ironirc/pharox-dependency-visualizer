Class {
	#name : #PhxDvAnnouncementAspectChanged,
	#superclass : #PhxDvAnnouncement,
	#instVars : [
		'aspect'
	],
	#category : #'Phx-Dependency-Visualizer-announcements'
}

{ #category : #'instance creation' }
PhxDvAnnouncementAspectChanged class >> onModel: aModel aspect: anAspect [
	^ (super onModel: aModel)
		aspect: anAspect;
		yourself
]

{ #category : #accessing }
PhxDvAnnouncementAspectChanged >> aspect [
	^ aspect
]

{ #category : #accessing }
PhxDvAnnouncementAspectChanged >> aspect: anObject [
	aspect := anObject
]

Class {
	#name : #DvAnnouncementAspectChanged,
	#superclass : #DvAnnouncement,
	#instVars : [
		'aspect'
	],
	#category : #'Phx-Dependency-Visualizer-announcements'
}

{ #category : #'instance creation' }
DvAnnouncementAspectChanged class >> onModel: aModel aspect: anAspect [
	^ (super onModel: aModel)
		aspect: anAspect;
		yourself
]

{ #category : #accessing }
DvAnnouncementAspectChanged >> aspect [
	^ aspect
]

{ #category : #accessing }
DvAnnouncementAspectChanged >> aspect: anObject [
	aspect := anObject
]

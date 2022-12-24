Class {
	#name : #PhxDvAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'model'
	],
	#category : #'Phx-Dependency-Visualizer-announcements'
}

{ #category : #'instance creation' }
PhxDvAnnouncement class >> onModel: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : #accessing }
PhxDvAnnouncement >> model [
	^ model
]

{ #category : #accessing }
PhxDvAnnouncement >> model: anObject [
	model := anObject
]

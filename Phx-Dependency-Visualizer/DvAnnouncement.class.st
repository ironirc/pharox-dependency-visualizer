Class {
	#name : #DvAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'model'
	],
	#category : #'Phx-Dependency-Visualizer-announcements'
}

{ #category : #'instance creation' }
DvAnnouncement class >> onModel: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : #accessing }
DvAnnouncement >> model [
	^ model
]

{ #category : #accessing }
DvAnnouncement >> model: anObject [
	model := anObject
]

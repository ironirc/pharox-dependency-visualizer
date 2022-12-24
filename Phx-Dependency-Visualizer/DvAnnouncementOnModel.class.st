Class {
	#name : #DvAnnouncementOnModel,
	#superclass : #Announcement,
	#instVars : [
		'model'
	],
	#category : #'Phx-Dependency-Visualizer-announcements'
}

{ #category : #'instance creation' }
DvAnnouncementOnModel class >> onModel: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : #accessing }
DvAnnouncementOnModel >> model [
	^ model
]

{ #category : #accessing }
DvAnnouncementOnModel >> model: anObject [
	model := anObject
]

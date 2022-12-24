Class {
	#name : #DvPackageGroup,
	#superclass : #DvNamedObjectInScope,
	#instVars : [
		'packages'
	],
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #'many relations' }
DvPackageGroup >> addMeToScope: aScope [  

	aScope addPackageGroup: self
]

{ #category : #accessing }
DvPackageGroup >> addPackage: aPackage [

 	self packages add: aPackage
]

{ #category : #accessing }
DvPackageGroup >> packages [

	packages ifNil: [ packages := OrderedCollection new ].
	^ packages
]

{ #category : #'many relations' }
DvPackageGroup >> removeMeFromScope: aScope [  

	aScope removePackageGroup: self
]

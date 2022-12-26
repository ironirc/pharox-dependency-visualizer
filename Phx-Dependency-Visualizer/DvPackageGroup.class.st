Class {
	#name : #DvPackageGroup,
	#superclass : #DvNamedObjectInScope,
	#instVars : [
		'packages'
	],
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #accessing }
DvPackageGroup >> addPackage: aPackage [

 	self packages add: aPackage
]

{ #category : #'many relations' }
DvPackageGroup >> addYourselfToScope: aScope [  

	aScope addPackageGroup: self
]

{ #category : #accessing }
DvPackageGroup >> packages [

	packages ifNil: [ packages := OrderedCollection new ].
	^ packages
]

{ #category : #'many relations' }
DvPackageGroup >> removeYourselfFromScope: aScope [  

	aScope removePackageGroup: self
]

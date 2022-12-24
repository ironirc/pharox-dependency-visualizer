Class {
	#name : #PhxDvPackageGroup,
	#superclass : #PhxDvNamedObjectInScope,
	#instVars : [
		'packages'
	],
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #accessing }
PhxDvPackageGroup >> addPackage: aPackage [

 	self packages add: aPackage
]

{ #category : #accessing }
PhxDvPackageGroup >> packages [

	packages ifNil: [ packages := OrderedCollection new ].
	^ packages
]

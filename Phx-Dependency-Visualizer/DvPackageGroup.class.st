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

{ #category : #accessing }
DvPackageGroup >> packages [

	packages ifNil: [ packages := OrderedCollection new ].
	^ packages
]

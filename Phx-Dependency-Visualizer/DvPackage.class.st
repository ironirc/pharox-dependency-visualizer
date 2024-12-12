Class {
	#name : 'DvPackage',
	#superclass : 'DvNamedObjectInScope',
	#category : 'Phx-Dependency-Visualizer-model',
	#package : 'Phx-Dependency-Visualizer',
	#tag : 'model'
}

{ #category : 'many relations' }
DvPackage >> addYourselfToScope: aScope [  

	aScope addPackage: self
]

{ #category : 'accessing' }
DvPackage >> computePackageGroupsYouDependOn [

	| all |
	all := Set new.
	self scope packageGroups do: [ :pg | 
		self packagesYouDependOn do: [ :myDepPckg | 
			(pg packages includes: myDepPckg) ifTrue: [ all add: pg ] ] ].
	^ all asOrderedCollection
]

{ #category : 'printing' }
DvPackage >> computePackagesDependingOnYou [

	^ self scope packages select: [ :p | 
		  p packagesYouDependOn includes: self ]
]

{ #category : 'printing' }
DvPackage >> computePackagesYouDependOn [

	^(self scope packagesDependedOnByPackageNamed: self name) collect: [ :p | 
		self scope packages detect: [ :wsP | wsP name = p name ] ]
]

{ #category : 'accessing' }
DvPackage >> packagesDependingOnYou [

	^ self computePackagesDependingOnYou
]

{ #category : 'many relations' }
DvPackage >> removeYourselfFromScope: aScope [  

	aScope removePackage: self
]

Class {
	#name : #DvPackage,
	#superclass : #DvNamedObjectInScope,
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #'many relations' }
DvPackage >> addMeToScope: aScope [  

	aScope addPackage: self
]

{ #category : #printing }
DvPackage >> computePackagesDependingOnYou [

	^ self scope packages select: [ :p | 
		  p packagesYouDependOn includes: self ]
]

{ #category : #printing }
DvPackage >> computePackagesYouDependOn [

	^(self scope packagesDependedOnByPackageNamed: self name) collect: [ :p | 
		self scope packages detect: [ :wsP | wsP name = p name ] ]
]

{ #category : #accessing }
DvPackage >> packagesDependingOnYou [

	^ self computePackagesDependingOnYou
]

{ #category : #accessing }
DvPackage >> packagesYouDependOn [

	^ self computePackagesYouDependOn
]

{ #category : #'many relations' }
DvPackage >> removeMeFromScope: aScope [  

	aScope removePackage: self
]

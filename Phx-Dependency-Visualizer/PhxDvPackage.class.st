Class {
	#name : #PhxDvPackage,
	#superclass : #PhxDvNamedObjectInScope,
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #printing }
PhxDvPackage >> computePackagesDependingOnYou [

	^ self scope packages select: [ :p | 
		  p packagesYouDependOn includes: self ]
]

{ #category : #printing }
PhxDvPackage >> computePackagesYouDependOn [

	^(self scope packagesDependedOnByPackageNamed: self name) collect: [ :p | 
		self scope packages detect: [ :wsP | wsP name = p name ] ]
]

{ #category : #accessing }
PhxDvPackage >> packagesDependingOnYou [

	^ self computePackagesDependingOnYou
]

{ #category : #accessing }
PhxDvPackage >> packagesYouDependOn [

	^ self computePackagesYouDependOn
]

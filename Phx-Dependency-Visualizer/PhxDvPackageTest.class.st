Class {
	#name : #PhxDvPackageTest,
	#superclass : #TestCase,
	#category : #'Phx-Dependency-Visualizer-testing'
}

{ #category : #tests }
PhxDvPackageTest >> test1 [

	| p |
	p := PhxDvPackage newNamed: self class package name.
]

{ #category : #tests }
PhxDvPackageTest >> test2 [

	| ws |
	ws := PhxDvWorkScope example1.
	ws packages do: [ :i | i packagesYouDependOn; computePackagesDependingOnYou ]
]

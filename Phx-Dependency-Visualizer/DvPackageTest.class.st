Class {
	#name : #DvPackageTest,
	#superclass : #TestCase,
	#category : #'Phx-Dependency-Visualizer-testing'
}

{ #category : #tests }
DvPackageTest >> test1 [

	| p |
	p := DvPackage newNamed: self class package name.
]

{ #category : #tests }
DvPackageTest >> test2 [

	| ws |
	ws := DvWorkScope example1.
	ws packages do: [ :i | i packagesYouDependOn; computePackagesDependingOnYou ]
]

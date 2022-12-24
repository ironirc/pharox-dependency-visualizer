"
Contains all parts of the project we want to take in consideration.
-packages, package groups (baselines, repo's)
"
Class {
	#name : #PhxDvWorkScope,
	#superclass : #PhxDvAbstractObject,
	#instVars : [
		'packageRelationGraph',
		'packages',
		'packageGroups'
	],
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #examples }
PhxDvWorkScope class >> example1 [

	"
PhxDependencyVisualizer allPhxPackages
self example1
"

	| patterns names ws |
	patterns := { 'phx*'. 'biti'. 'Pharo-home*'. '*ecg*' }.
	names := ((RPackageOrganizer default packages select: [ :p | 
		           patterns anySatisfy: [ :patt | patt match: p name ] ]) 
		          collect: #name) sorted.
	ws := self new.
	names do: [ :n | ws addPackageNamed: n ].
	ws groupPackages: [:p |  '*comp23*' match: p name ] as: 'C23'.
	^ ws
]

{ #category : #adding }
PhxDvWorkScope >> addPackage: aPackage [ 

	self packages add: aPackage.
	aPackage scope: self.
	self changed: #packages
]

{ #category : #adding }
PhxDvWorkScope >> addPackageGroup: aPackageGroup [

	self packageGroups add: aPackageGroup.
	aPackageGroup scope: self.
	self changed: #packageGroups
]

{ #category : #adding }
PhxDvWorkScope >> addPackageGroupNamed: aName [

	| p |
	p := PhxDvPackageGroup newNamed: aName.
	self addPackageGroup: p.
]

{ #category : #adding }
PhxDvWorkScope >> addPackageNamed: aName [

	| p |
	p := PhxDvPackage newNamed: aName.
	self addPackage: p.
]

{ #category : #accessing }
PhxDvWorkScope >> allPackageNamesDependedOnByPackageNamed: aPackageName [

	^ (self packageRelationGraph packageAt: aPackageName)
		  dependentPackages collect: [ :e | e packageName ]
]

{ #category : #accessing }
PhxDvWorkScope >> allPhxPackagesDependingOn: aPackageName [

	| pNames |
	pNames := self dependentPackageNamesOfPackageNamed: aPackageName.
	^ self packages select: [ :e | pNames includes: e name ]
]

{ #category : #roassal }
PhxDvWorkScope >> asRoassalVisualization [

	^ PhxDvVisWorkScope new model: self
]

{ #category : #adding }
PhxDvWorkScope >> groupPackages: aBlock as: aName [ 

	| pg |
	pg := self packageGroupNamedOrCreate: aName. 
	pg packages addAll: (self packages select: aBlock).
	
]

{ #category : #adding }
PhxDvWorkScope >> packageGroupNamed: aName isAbsentPut: aBlock [

	^ self packageGroups
		  detect: [ :pg | pg name = aName ]
		  ifNone: [ self packageGroups add: aBlock value ]
]

{ #category : #adding }
PhxDvWorkScope >> packageGroupNamedOrCreate: aName [

	^self packageGroupNamed: aName isAbsentPut: [ PhxDvPackageGroup newNamed: aName  ]
	
]

{ #category : #accessing }
PhxDvWorkScope >> packageGroups [

	packageGroups ifNil: [ packageGroups := OrderedCollection new ].
	^ packageGroups
]

{ #category : #adding }
PhxDvWorkScope >> packageNames [  
	^self packages collect: #name
]

{ #category : #adding }
PhxDvWorkScope >> packageRelationGraph [

	packageRelationGraph ifNil: [ 
		| g |
		g := DAPackageRelationGraph onPackagesNamed: self packageNames.
		g computeStaticDependencies.
		g removeInternalDependencies.
		g combineDependencies.
		packageRelationGraph := g ].
	^ packageRelationGraph
]

{ #category : #accessing }
PhxDvWorkScope >> packages [

	packages ifNil: [ packages := OrderedCollection new ].
	^ packages
]

{ #category : #accessing }
PhxDvWorkScope >> packagesDependedOnByPackageNamed: aPackageName [

	| pNames |
	pNames := self allPackageNamesDependedOnByPackageNamed: aPackageName.
	^ self packages select: [ :e | pNames includes: e name ]
]

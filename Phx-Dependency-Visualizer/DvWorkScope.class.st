"
Contains all parts of the project we want to take in consideration.
-packages, package groups (baselines, repo's)
"
Class {
	#name : #DvWorkScope,
	#superclass : #DvAbstractObject,
	#instVars : [
		'packageRelationGraph',
		'packages',
		'packageGroups'
	],
	#category : #'Phx-Dependency-Visualizer-model'
}

{ #category : #examples }
DvWorkScope class >> example1 [

"
self example1
"

	| patterns names ws |
	patterns := { 'phx*'. 'biti'. 'Pharo-home*'. '*ecg*' }.
	names := ((RPackageOrganizer default packages select: [ :p | 
		           patterns anySatisfy: [ :patt | patt match: p name ] ]) 
		          collect: #name) sorted.
	ws := self new.
	names do: [ :n | ws addPackageNamed: n ].
	ws groupPackages: [:p |  '*comp23*' match: p name ] as: 'Comp23'.
	ws groupPackages: [:p |  '*Phx-Pj-Core*' match: p name ] as: 'Phx-Pj-Core'.
	^ ws
]

{ #category : #examples }
DvWorkScope class >> example1Persist [

"
self example1 persistToClass: DvWorksScopeStorageForPhx
"

	| patterns names ws |
	patterns := { 'phx*'. 'biti'. 'Pharo-home*'. '*ecg*' }.
	names := ((RPackageOrganizer default packages select: [ :p | 
		           patterns anySatisfy: [ :patt | patt match: p name ] ]) 
		          collect: #name) sorted.
	ws := self new.
	names do: [ :n | ws addPackageNamed: n ].
	ws groupPackages: [:p |  '*comp23*' match: p name ] as: 'Comp23'.
	ws groupPackages: [:p |  '*Phx-Pj-Core*' match: p name ] as: 'Phx-Pj-Core'.
	^ ws
]

{ #category : #'as yet unclassified' }
DvWorkScope class >> readFromStorageClass: aClass [
"
	self readFromStorageClass: DvWorksScopeStorageForPhx
"
	^PhxJsonReader readFromString: (aClass json)
]

{ #category : #adding }
DvWorkScope >> addPackage: aPackage [ 

	self packages add: aPackage.
	self changed: #packages
]

{ #category : #adding }
DvWorkScope >> addPackageGroup: aPackageGroup [

	self packageGroups add: aPackageGroup.
	self changed: #packageGroups
]

{ #category : #adding }
DvWorkScope >> addPackageGroupNamed: aName [

	| p |
	p := DvPackageGroup newNamed: aName.
	p scope: self
]

{ #category : #adding }
DvWorkScope >> addPackageNamed: aName [

	| p |
	p := DvPackage newNamed: aName.
	p scope: self
]

{ #category : #accessing }
DvWorkScope >> allPackageNamesDependedOnByPackageNamed: aPackageName [

	^ (self packageRelationGraph packageAt: aPackageName)
		  dependentPackages collect: [ :e | e packageName ]
]

{ #category : #accessing }
DvWorkScope >> allPhxPackagesDependingOn: aPackageName [

	| pNames |
	pNames := self dependentPackageNamesOfPackageNamed: aPackageName.
	^ self packages select: [ :e | pNames includes: e name ]
]

{ #category : #roassal }
DvWorkScope >> asRoassalVisualization [

	^ DvRsWorkScope new model: self
]

{ #category : #adding }
DvWorkScope >> groupPackages: aBlock as: aName [ 

	| pg |
	pg := self packageGroupNamedOrCreate: aName. 
	pg packages addAll: (self packages select: aBlock).
	
]

{ #category : #adding }
DvWorkScope >> packageGroupNamed: aName isAbsentPut: aBlock [

	^ self packageGroups
		  detect: [ :pg | pg name = aName ]
		  ifNone: [ self packageGroups add: aBlock value ]
]

{ #category : #adding }
DvWorkScope >> packageGroupNamedOrCreate: aName [

	^self packageGroupNamed: aName isAbsentPut: [ DvPackageGroup newNamed: aName  ]
	
]

{ #category : #accessing }
DvWorkScope >> packageGroups [

	packageGroups ifNil: [ packageGroups := OrderedCollection new ].
	^ packageGroups
]

{ #category : #adding }
DvWorkScope >> packageNames [  
	^self packages collect: #name
]

{ #category : #adding }
DvWorkScope >> packageRelationGraph [

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
DvWorkScope >> packages [

	packages ifNil: [ packages := OrderedCollection new ].
	^ packages
]

{ #category : #accessing }
DvWorkScope >> packagesDependedOnByPackageNamed: aPackageName [

	| pNames |
	pNames := self allPackageNamesDependedOnByPackageNamed: aPackageName.
	^ self packages select: [ :e | pNames includes: e name ]
]

{ #category : #accessing }
DvWorkScope >> persistToClass: aClass [

	aClass class compile: 'json
	
	^''' ,  self asPhxJsonString , '''' classified: 'persistence'
]

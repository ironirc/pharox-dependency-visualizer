"
Contains all parts of the project we want to take in consideration.
-packages, package groups (baselines, repo's)
"
Class {
	#name : 'DvWorkScope',
	#superclass : 'DvAbstractObject',
	#instVars : [
		'packageRelationGraph',
		'packages',
		'packageGroups',
		'name'
	],
	#category : 'Phx-Dependency-Visualizer-model',
	#package : 'Phx-Dependency-Visualizer',
	#tag : 'model'
}

{ #category : 'file persistence' }
DvWorkScope class >> latestFileForName: aName [

	"
self latestFileForName: 'PhxAndOthers'
"

	^ ('.' asFileReference filesMatching: aName , '*.phxjson') sorted
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :coll | coll first ]
]

{ #category : 'examples' }
DvWorkScope class >> newForRoassal [

	"
self exampleRoassalPackages
"

	| patterns names wsc |
	patterns := { 'Roassal*' }.
	names := ((RPackageOrganizer default packages select: [ :p | 
		           patterns anySatisfy: [ :patt | patt match: p name ] ]) 
		          collect: #name) sorted.
	wsc := self new.
	wsc name: 'Roassal packages'.
	names do: [ :n | wsc addPackageNamed: n ].
	^ wsc
]

{ #category : 'examples' }
DvWorkScope class >> newForZincAndZodiac [

"
self exampleRoassalPackages
"

	| patterns names wsc |
	patterns := { 'Zinc*' . 'Zodiac*'}.
	names := ((RPackageOrganizer default packages select: [ :p | 
		           patterns anySatisfy: [ :patt | patt match: p name ] ]) 
		          collect: #name) sorted.
	wsc := self new.
	wsc name: 'Zinc packages'.
	names do: [ :n | wsc addPackageNamed: n ].
	^ wsc
]

{ #category : 'examples' }
DvWorkScope class >> newForZincAndZodiacGrouped [
	"
self exampleRoassalPackages
"

	| patterns names wsc |
	patterns := { 'Zinc*'. 'Zodiac*' }.
	names := ((RPackageOrganizer default packages select: [ :p |
		           patterns anySatisfy: [ :patt | patt match: p name ] ])
		          collect: #name) sorted.
	wsc := self new.
	wsc name: 'ZincAndZodiac'.
	names do: [ :n | wsc addPackageNamed: n ].

	wsc groupPackages: [ :p | 'Zinc*' match: p name ] as: 'Zinc'.
	wsc groupPackages: [ :p | 'Zodiac*' match: p name ] as: 'Zodiac'.

	^ wsc
]

{ #category : 'file persistence' }
DvWorkScope class >> persistPhxScope [

	self newForPhx saveAsPhxJsonFile
]

{ #category : 'examples' }
DvWorkScope class >> projects [
"NOT USED YET"
"#('PharoHomeAssistantApi' 'PharoX' 'PharoXPjBasics' 'PharoXDependencyVisualizer' 'PharoXPjVue' 'PharoXRIDE')"
	| searchStrings |
	searchStrings := #( 'PharoHomeAssistantApi' 'pharox*' ).
	^ ClySystemEnvironment currentImage projectManager projects select: [
		  :p | searchStrings anySatisfy: [ :ss | ss match: p name ] ]
]

{ #category : 'file persistence' }
DvWorkScope class >> readFromFileNamed: aFileName [

	^ PhxJsonReader readFromString: aFileName asFileReference contents
]

{ #category : 'file persistence' }
DvWorkScope class >> readFromStorageClass: aClass [
"
	self readFromStorageClass: DvWorksScopeStorageForPhx
"
	^PhxJsonReader readFromString: (aClass json)
]

{ #category : 'file persistence' }
DvWorkScope class >> readlatestFromFileForName: aName [

"
self readlatestFromFileForName: 'PhxAndOthers'
"

	^ self readFromFileNamed: (self latestFileForName: aName)
]

{ #category : 'adding' }
DvWorkScope >> addPackage: aPackage [ 

	self packages add: aPackage.
	self changed: #packages
]

{ #category : 'adding' }
DvWorkScope >> addPackageGroup: aPackageGroup [

	self packageGroups add: aPackageGroup.
	self changed: #packageGroups
]

{ #category : 'adding' }
DvWorkScope >> addPackageGroupNamed: aName [

	| p pg |
	pg := DvPackageGroup newNamed: aName.
	pg scope: self.
	^ pg
]

{ #category : 'adding' }
DvWorkScope >> addPackageNamed: aName [

	| p |
	p := DvPackage newNamed: aName.
	p scope: self
]

{ #category : 'accessing' }
DvWorkScope >> allPackageNamesDependedOnByPackageNamed: aPackageName [

	^ (self packageRelationGraph packageAt: aPackageName)
		  dependentPackages collect: [ :e | e packageName ]
]

{ #category : 'accessing' }
DvWorkScope >> baseForFilename [

	^ String streamContents: [ :ws | 
		  | now |
		  now := DateAndTime now.
		  ws << self name.
		  ws << '_'.
		  now printYMDOn: ws.
		  ws << '_'.
		  now printHMSWithDashesOn: ws.
		  ws << '.phxjson' ]
]

{ #category : 'adding' }
DvWorkScope >> groupPackages: aBlock as: aName [ 

	| pg |
	pg := self packageGroupNamedOrCreate: aName. 
	pg packages addAll: (self unGroupedPackages select: aBlock).
	
]

{ #category : 'adding' }
DvWorkScope >> groupsAndPackagesDo: aBlock [  

	self packageGroups do: [ :pg | aBlock value: pg ].
	self unGroupedPackages do: [:p | aBlock value: p   ]
]

{ #category : 'accessing' }
DvWorkScope >> name [

	^ name
]

{ #category : 'accessing' }
DvWorkScope >> name: anObject [

	name := anObject
]

{ #category : 'adding' }
DvWorkScope >> packageGroupNamed: aName ifAbsent: aBlock [

	^ self packageGroups
		  detect: [ :pg | pg name = aName ]
		  ifNone: [ aBlock value ]
]

{ #category : 'adding' }
DvWorkScope >> packageGroupNamedOrCreate: aName [

	^ self
		  packageGroupNamed: aName
		  ifAbsent: [ self addPackageGroupNamed: aName ]
]

{ #category : 'accessing' }
DvWorkScope >> packageGroups [

	packageGroups ifNil: [ packageGroups := OrderedCollection new ].
	^ packageGroups
]

{ #category : 'adding' }
DvWorkScope >> packageNames [  
	^self packages collect: #name
]

{ #category : 'adding' }
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

{ #category : 'accessing' }
DvWorkScope >> packages [

	packages ifNil: [ packages := OrderedCollection new ].
	^ packages
]

{ #category : 'accessing' }
DvWorkScope >> packagesDependedOnByPackageNamed: aPackageName [

	| pNames |
	pNames := self allPackageNamesDependedOnByPackageNamed: aPackageName.
	^ self packages select: [ :e | pNames includes: e name ]
]

{ #category : 'accessing' }
DvWorkScope >> persistToClass: aClass [

	aClass class compile: 'json
	
	^''' ,  self asPhxJsonString , '''' classified: 'persistence'
]

{ #category : 'accessing' }
DvWorkScope >> saveAsPhxJsonFile [

	| ws |
	ws := self baseForFilename asFileReference writeStream.
	[ ws << self asPhxJsonString ] ensure: [ ws close ]
]

{ #category : 'accessing' }
DvWorkScope >> unGroupedPackages [

	^ self packages reject: [ :p | 
		  self packageGroups anySatisfy: [ :pg | pg packages includes: p ] ]
]

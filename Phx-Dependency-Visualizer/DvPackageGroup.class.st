Class {
	#name : 'DvPackageGroup',
	#superclass : 'DvNamedObjectInScope',
	#instVars : [
		'packages'
	],
	#category : 'Phx-Dependency-Visualizer-model',
	#package : 'Phx-Dependency-Visualizer',
	#tag : 'model'
}

{ #category : 'accessing' }
DvPackageGroup >> addPackage: aPackage [

 	self packages add: aPackage
]

{ #category : 'many relations' }
DvPackageGroup >> addYourselfToScope: aScope [  

	aScope addPackageGroup: self
]

{ #category : 'accessing derived' }
DvPackageGroup >> computePackageGroupsYouDependOn [

	| all |
	all := Set new.
	self scope packageGroups do: [ :otherPg | 
		(self packagesYouDependOn anySatisfy: [ :myDepPckg | 
			 otherPg packages includes: myDepPckg ]) ifTrue: [ 
			all add: otherPg ] ].
	^ all asOrderedCollection
]

{ #category : 'accessing derived' }
DvPackageGroup >> computePackagesYouDependOn [

	| all |
	all := Set new.
	self packages do: [ :p | all addAll: p packagesYouDependOn ].
	^ all asOrderedCollection
]

{ #category : 'accessing' }
DvPackageGroup >> packageGroups [
	^{}
]

{ #category : 'accessing' }
DvPackageGroup >> packages [

	packages ifNil: [ packages := OrderedCollection new ].
	^ packages
]

{ #category : 'many relations' }
DvPackageGroup >> removeYourselfFromScope: aScope [  

	aScope removePackageGroup: self
]

{ #category : 'accessing' }
DvPackageGroup >> unGroupedPackages [
	^self packages
]

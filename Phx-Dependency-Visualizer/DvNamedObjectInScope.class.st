Class {
	#name : 'DvNamedObjectInScope',
	#superclass : 'DvAbstractObject',
	#instVars : [
		'scope',
		'name',
		'packagesYouDependOn',
		'packageGroupsYouDependOn'
	],
	#category : 'Phx-Dependency-Visualizer-model',
	#package : 'Phx-Dependency-Visualizer',
	#tag : 'model'
}

{ #category : 'accessing' }
DvNamedObjectInScope >> name [

	^ name
]

{ #category : 'accessing' }
DvNamedObjectInScope >> name: anObject [

	name := anObject.
	self changed: #name 
	
]

{ #category : 'accessing' }
DvNamedObjectInScope >> packageGroupsYouDependOn [

	packageGroupsYouDependOn ifNil: [ 
		packageGroupsYouDependOn := self computePackageGroupsYouDependOn ].
	^ packageGroupsYouDependOn
]

{ #category : 'accessing' }
DvNamedObjectInScope >> packagesYouDependOn [

	packagesYouDependOn ifNil: [ 
		packagesYouDependOn := self computePackagesYouDependOn ].
	^ packagesYouDependOn
]

{ #category : 'printing' }
DvNamedObjectInScope >> printOn: ws [

	super printOn: ws.
	ws << ' ('.
	ws << self name. 
	ws << ')'
]

{ #category : 'accessing' }
DvNamedObjectInScope >> scope [

	^ scope
]

{ #category : 'accessing' }
DvNamedObjectInScope >> scope: anObject [

	scope ifNotNil: [ self removeYourselfFromScope: scope ].
	scope := anObject.
	scope ifNotNil: [ self addYourselfToScope: scope ].
	self changed: #scope
]

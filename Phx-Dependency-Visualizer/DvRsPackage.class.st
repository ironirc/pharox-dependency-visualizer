Class {
	#name : #DvRsPackage,
	#superclass : #DvRsObject,
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #private }
DvRsPackage >> addToManyRelationOnParent [
	self parent rsPackages add: self
]

{ #category : #building }
DvRsPackage >> build [

	| compos label box |
	self mainShape ifNotNil: [ 
		^ self error: 'attempt to build mainShape twice' ].
	label := RSLabel new
		         text: model name;
		         color: Color black;
					model: #name;
		         yourself.
	box := RSBox new
		       extent: label extent + 10;
		       cornerRadius: 3;
		       yourself.
	compos := { 
		          box.
		          label } asShapeFor: model.
	"compos @ (RSPopup text: [ :neuron | neuron printStatisticDefinitions ])."
	compos draggable.
	compos when: RSMouseRightClick send: #showMenu: to: self.
	compos when: RSMouseLeftClick send: #leftClick: to: self.
	self mainShape: compos.
	self canvas add: compos
]

{ #category : #'announcement handling' }
DvRsPackage >> handleAnnouncementAspectChanged: a [

	| sh |
	sh := self mainShape.
	sh ifNil: [ ^ self ].
	a aspect == #name ifTrue: [ 
		| labelShape |
		labelShape := sh shapeFromModel: a aspect.
		labelShape text: a model name.
		self canvas signalUpdate ]
]

{ #category : #menu }
DvRsPackage >> handleBrowseEvent: evt [
	self top stopAndRemoveAllAnimations.
	(RPackageOrganizer default packageNamed: self model name) browse

]

{ #category : #menu }
DvRsPackage >> handleShowDependencyAnalyserEvent: anEvent [
	self top stopAndRemoveAllAnimations.
	(DAPackageDependenciesPresenter onPackagesNamed:
		 { self model name }) open
]

{ #category : #'initialize-release' }
DvRsPackage >> initialize [
	super initialize.

]

{ #category : #printing }
DvRsPackage >> printOn: ws [

	super printOn: ws.
	ws << ' ('.
	ws << self model name. 
	ws << ')'
]

{ #category : #private }
DvRsPackage >> removeFromManyRelationOnParent [
	self parent rsPackages remove: self
]

{ #category : #'setUp-tearDown' }
DvRsPackage >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : #menu }
DvRsPackage >> showMenu: evt [

	| menu |
	menu := MenuMorph new.
	menu
		add: 'browse'
		target: self
		selector: #handleBrowseEvent:
		argument: evt.
	menu addLine.
	menu
		add: 'open dependency analyzer'
		target: self
		selector: #handleShowDependencyAnalyserEvent:
		argument: evt.
	^ menu popUpInWorld
]

{ #category : #'setUp-tearDown' }
DvRsPackage >> tearDown [
	self mainShape ifNotNil: [ :ms | self canvas removeShape: ms ].
	self parent: nil.
	self model: nil
]

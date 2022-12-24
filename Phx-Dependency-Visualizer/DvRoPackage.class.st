Class {
	#name : #DvRoPackage,
	#superclass : #DvRoObject,
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #private }
DvRoPackage >> addToManyRelationOnParent [
	self parent packages add: self
]

{ #category : #building }
DvRoPackage >> build [

	| compos label box |
	self mainShape ifNotNil: [ 
		^ self error: 'attempt to build mainShape twice' ].
	label := RSLabel new
		         text: model name;
		         color: Color black;
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
DvRoPackage >> handleAnnouncementAspectChanged: a [
	| ns |
	ns := self mainShape.
	ns ifNil: [ ^ self ].
	a aspect == #shortCode
		ifTrue: [ | labelShape |
			labelShape := ns shapeFromModel: a aspect.
			labelShape text: a model shortCode ]
]

{ #category : #menu }
DvRoPackage >> handleBrowseEvent: evt [
	self top stopAndRemoveAllAnimations.
	(RPackageOrganizer default packageNamed: self model name) browse

]

{ #category : #menu }
DvRoPackage >> handleShowDependencyAnalyserEvent: anEvent [
	self top stopAndRemoveAllAnimations.
	(DAPackageDependenciesPresenter onPackagesNamed:
		 { self model name }) open
]

{ #category : #'initialize-release' }
DvRoPackage >> initialize [
	super initialize.

]

{ #category : #printing }
DvRoPackage >> printOn: ws [

	super printOn: ws.
	ws << ' ('.
	ws << self model name. 
	ws << ')'
]

{ #category : #private }
DvRoPackage >> removeFromManyRelationOnParent [
	self parent packages remove: self
]

{ #category : #'setUp-tearDown' }
DvRoPackage >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : #menu }
DvRoPackage >> showMenu: evt [

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
DvRoPackage >> tearDown [
	self mainShape ifNotNil: [ :ms | self canvas removeShape: ms ].
	self parent: nil.
	self model: nil
]

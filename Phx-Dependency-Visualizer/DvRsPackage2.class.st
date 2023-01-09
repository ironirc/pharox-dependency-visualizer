Class {
	#name : #DvRsPackage2,
	#superclass : #PhxRsComposite,
	#instVars : [
		'box'
	],
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #private }
DvRsPackage2 >> addToManyRelationOnParent [
	self parent rsPackages add: self
]

{ #category : #building }
DvRsPackage2 >> build [

	| label |
	label := RSLabel new
		         text: model name;
		         color: Color black;
		         model: #name;
		         yourself.
	border := RSBorder new
		          color: (Color gray alpha: 0.5);
		          yourself.
	box := RSBox new
		       border: border;
		       color: Color white;
		       extent: label extent + 10;
		       cornerRadius: 3;
		       yourself.
	self add: box.
	self add: label.
	self draggable.
	self when: RSMouseRightClick send: #showMenu: to: self.
	self when: RSMouseLeftClick send: #leftClick: to: self.
	self adjustToChildren
]

{ #category : #'announcement handling' }
DvRsPackage2 >> handleAnnouncementAspectChanged: a [

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
DvRsPackage2 >> handleBrowseEvent: evt [
	self  stopAndRemoveAllAnimations.
	(RPackageOrganizer default packageNamed: self model name) browse

]

{ #category : #menu }
DvRsPackage2 >> handleInspectEvent: evt [
	self  stopAndRemoveAllAnimations.
	evt shape inspect

]

{ #category : #menu }
DvRsPackage2 >> handleShowDependencyAnalyserEvent: anEvent [
	self stopAndRemoveAllAnimations.
	(DAPackageDependenciesPresenter onPackagesNamed:
		 { self model name }) open
]

{ #category : #'initialize-release' }
DvRsPackage2 >> initialize [
	super initialize.

]

{ #category : #actions }
DvRsPackage2 >> leftClick: evt [

	| isSelected |
	isSelected := self propertyAt: #isSelected ifAbsent: [ false ].
	isSelected := isSelected not.
	self propertyAt: #isSelected put: isSelected.
	isSelected
		ifTrue: [ box color: Color yellow ]
		ifFalse: [ box color: Color white ].
	self signalUpdate
]

{ #category : #printing }
DvRsPackage2 >> printOn: ws [

	super printOn: ws.
	ws << ' ('.
	ws << self model name. 
	ws << ')'
]

{ #category : #private }
DvRsPackage2 >> removeFromManyRelationOnParent [
	self parent rsPackages remove: self
]

{ #category : #'setUp-tearDown' }
DvRsPackage2 >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : #menu }
DvRsPackage2 >> showMenu: evt [

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
		menu
		add: 'inspect'
		target: self
		selector: #handleInspectEvent:
		argument: evt.
	^ menu popUpInWorld
]

{ #category : #'setUp-tearDown' }
DvRsPackage2 >> tearDown [
	self mainShape ifNotNil: [ :ms | self canvas removeShape: ms ].
	self parent: nil.
	self model: nil
]

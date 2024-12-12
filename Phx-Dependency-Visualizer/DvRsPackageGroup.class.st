Class {
	#name : 'DvRsPackageGroup',
	#superclass : 'PhxRsComposite',
	#instVars : [
		'box',
		'label'
	],
	#category : 'Phx-Dependency-Visualizer-visualisation',
	#package : 'Phx-Dependency-Visualizer',
	#tag : 'visualisation'
}

{ #category : 'build' }
DvRsPackageGroup >> addPackage: aPackage [

	| rsPackage |
	rsPackage := DvRsPackage new.
	rsPackage model: aPackage.
	rsPackage build.
	self add: rsPackage
]

{ #category : 'build' }
DvRsPackageGroup >> adjustBox: aBox on: someShapes [

	| rect |
	rect := someShapes encompassingRectangle.
	aBox
		extent: rect extent + (10 @ 10);
		position: rect floatCenter
]

{ #category : 'building' }
DvRsPackageGroup >> build [

	self buildPackages.
	RSGridLayout on: self nodes.
	label := RSLabel new
		         text: model name;
		         color: Color black;
		         yourself.
	border := RSBorder new
		          color: (Color gray alpha: 0.5);
		          yourself.
	box := RSBox new
		       extent: label extent + 10;
		       color: Color white;
		       border: border;
		       cornerRadius: 3;
		       yourself. "noPaint"
	RSLocation new
		offset: -5;
		above;
		center;
		stick: label on: self nodes.
	self add: label.
	self adjustBox: box on: self nodes.
	self add: box.
	box pushBack.
	self adjustToChildren.
	self @ RSDraggable new noValidateChildrenEvents.
	self when: RSMouseLeftClick send: #leftClick: to: self.
	self when: RSMouseRightClick send: #showMenu: to: self
]

{ #category : 'build' }
DvRsPackageGroup >> buildPackages [

	self model unGroupedPackages do: [ :p | self addPackage: p ]
]

{ #category : 'building' }
DvRsPackageGroup >> handleInspectEvent: evt [
	self  stopAndRemoveAllAnimations.
	evt shape inspect

]

{ #category : 'actions' }
DvRsPackageGroup >> handleRename [

	| aName |
	aName := UIManager default
		         request: 'Enter a new name'
		         initialAnswer: self model name.
	aName ifNil: [ ^ self ].
	self model name: aName
]

{ #category : 'building' }
DvRsPackageGroup >> handleShowDependencyAnalyserEvent: anEvent [

	self stopAndRemoveAllAnimations.
	(DAPackageDependenciesPresenter onPackagesNamed:
		 (self model packages collect: #name)) open
]

{ #category : 'building' }
DvRsPackageGroup >> leftClick: evt [

	| isSelected |
	isSelected := self propertyAt: #isSelected ifAbsent: [ false ].
	isSelected := isSelected not.
	self propertyAt: #isSelected put: isSelected.
	isSelected
		ifTrue: [ box color: Color yellow ]
		ifFalse: [ box color: Color white ].
	self signalUpdate
]

{ #category : 'building' }
DvRsPackageGroup >> showMenu: evt [

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
	menu
		add: 'rename'
		target: self
		selector: #handleRename.
	^ menu popUpInWorld
]

{ #category : 'accessing' }
DvRsPackageGroup >> update: aSymbol [

	super update: aSymbol.
	aSymbol == #name ifTrue: [ 
		self updateName.
		^ self ]
]

{ #category : 'accessing' }
DvRsPackageGroup >> updateName [

	label text: self model name.
	label signalUpdate.
	
]

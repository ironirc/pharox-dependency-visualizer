Class {
	#name : #DvRsPackageGroup2,
	#superclass : #PhxRsComposite,
	#instVars : [
		'box'
	],
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #build }
DvRsPackageGroup2 >> addPackage: aPackage [

	| rsPackage |
	rsPackage := DvRsPackage2 new.
	rsPackage model: aPackage.
	rsPackage build.
	self add: rsPackage
]

{ #category : #build }
DvRsPackageGroup2 >> adjustBox: aBox on: someShapes [

	| rect |
	rect := someShapes encompassingRectangle.
	aBox
		extent: rect extent + (10 @ 10);
		position: rect floatCenter
]

{ #category : #building }
DvRsPackageGroup2 >> build [

	| label |
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

{ #category : #build }
DvRsPackageGroup2 >> buildPackages [

	self model unGroupedPackages do: [ :p | self addPackage: p ]
]

{ #category : #building }
DvRsPackageGroup2 >> handleInspectEvent: evt [
	self  stopAndRemoveAllAnimations.
	evt shape inspect

]

{ #category : #building }
DvRsPackageGroup2 >> leftClick: evt [

	| isSelected |
	isSelected := self propertyAt: #isSelected ifAbsent: [ false ].
	isSelected := isSelected not.
	self propertyAt: #isSelected put: isSelected.
	isSelected
		ifTrue: [ box color: Color yellow ]
		ifFalse: [ box color: Color white ].
	self signalUpdate
]

{ #category : #building }
DvRsPackageGroup2 >> showMenu: evt [

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

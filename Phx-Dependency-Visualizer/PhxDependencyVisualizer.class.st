Class {
	#name : #PhxDependencyVisualizer,
	#superclass : #Object,
	#traits : 'PhxDvInAndOutHighlitable',
	#classTraits : 'PhxDvInAndOutHighlitable classTrait',
	#instVars : [
		'packageShapeSelections',
		'packageRelationGraph',
		'canvas'
	],
	#category : #'Phx-Dependency-Visualizer-viz gen1'
}

{ #category : #model }
PhxDependencyVisualizer class >> allPhxPackages [
"
PhxDependencyVisualizer allPhxPackages
"
	| patterns |
	patterns := { 'phx*'. 'biti'. 'Pharo-home*' . '*ecg*'}.
	^ (RPackageOrganizer default packages select: [ :p | 
		  patterns anySatisfy: [ :patt | patt match: p name ] ]) sortedAs: #name
]

{ #category : #model }
PhxDependencyVisualizer >> allPhxPackages [

	^self class allPhxPackages
]

{ #category : #model }
PhxDependencyVisualizer >> allPhxPackagesDependingOn: aPackageName [

	| pNames |
	pNames := self dependentPackageNamesOfPackageNamed: aPackageName.
	^ self allPhxPackages select: [ :e | pNames includes: e name ]
]

{ #category : #model }
PhxDependencyVisualizer >> allPhxRepositories [
"
self allPhxRepositories
"
	| all |
	all := Set new.
	self allPhxPackages do: [ :p | 
		all addAll: (self containingRepositoriesOfPackage: p) ].
	^ all asOrderedCollection
]

{ #category : #model }
PhxDependencyVisualizer >> allPhxRepositoriesWithoutPharoX [
"
self allPhxRepositoriesWithoutPharoX
"
	^self allPhxRepositories reject: [ :each | each name = 'PharoX' ]
]

{ #category : #menu }
PhxDependencyVisualizer >> browse: evt [
	self stopAndRemoveAllAnimations.
	evt shape model browse
]

{ #category : #visualisation }
PhxDependencyVisualizer >> canvas [

	canvas ifNil: [ 
		canvas := RSCanvas new.
		canvas addInteraction: (RSCanvasController new
				 in: [ :i | i configuration useBasicZoom ];
				 yourself) ].
	^ canvas
]

{ #category : #model }
PhxDependencyVisualizer >> containingRepositoriesOfPackage: aPackage [  

	^IceRepository registry select: [ :p | p includesPackageNamed:  aPackage name ]
]

{ #category : #model }
PhxDependencyVisualizer >> dependentPackageNamesOfPackageNamed: aPackageName [

	^ (self packageRelationGraph packageAt: aPackageName)
		  dependentPackages collect: [ :e | e packageName ]
]

{ #category : #'package selections' }
PhxDependencyVisualizer >> deselectPackageShape: sh [

	(self isPackageShapeSelected: sh) ifTrue: [ 
		self packageShapeSelections remove: sh.
		self unhighlitePackageShapeAsSelected: sh ]
]

{ #category : #visualisation }
PhxDependencyVisualizer >> graph [

	<script: 'self new graph'>
	| data boxes canv rsLayout |
	data := self allPhxPackages.
	boxes := data collect: [ :class | self newShapeFor: class ].
	canv := self canvas.
	canv addAll: boxes.
	self newLineBuilder
		canvas: canv;
		connectToAll: [ :p | self allPhxPackagesDependingOn: p name ].
	canv lines pushBack.
	rsLayout := PhxDvHorizontalTreeLayout new.
	rsLayout
		horizontalGap: 50;
		verticalGap: 5.
	rsLayout on: boxes.
	canv nodes @ self highlightable.
	canv @ RSCanvasController.
	canv open "or use?: canv inspect"
]

{ #category : #'package selections' }
PhxDependencyVisualizer >> highlitePackageShapeAsSelected: sh [

	sh shapes first color: Color yellow.
]

{ #category : #'package selections' }
PhxDependencyVisualizer >> isPackageShapeSelected: sh [

	^self packageShapeSelections includes: sh
]

{ #category : #menu }
PhxDependencyVisualizer >> leftClick: evt [

	evt shape ifNotNil: [:sh | (sh model isKindOf: RPackage) ifTrue: [ self shapeClicked: sh ] ]
]

{ #category : #visualisation }
PhxDependencyVisualizer >> marker [
	|  marker |
	marker := RSShapeFactory arrow.
	marker color: self textColor.
	marker size: 10.
	marker := marker asMarker.
	marker offset: 0.
	^ marker
]

{ #category : #visualisation }
PhxDependencyVisualizer >> newLineBuilder [

	| marker |
	marker := self marker.
	^ RSLineBuilder bezier
		  markerEnd: marker;
		  attachPoint: (RSHorizontalAttachPoint new
				   endOffset: marker shape height / -2;
				   yourself);
		  controlPointsController: RSHorizontalLeftRightController new;
		  color: self textColor;
		  yourself
]

{ #category : #visualisation }
PhxDependencyVisualizer >> newShapeFor: model [

	| label box shape |
	label := RSLabel new
		         text: model name;
		         color: Color black;
		         yourself.
	box := RSBox new
		       extent: label extent + 10;
		       "border: (self newBorderFor: model);"cornerRadius: 3;
		       yourself.
	shape := { 
		         box.
		         label } asShapeFor: model.
	shape draggable.
"	shape when: RSMouseDoubleClick send: #browse: to: self."
	shape when: RSMouseRightClick send: #showMenu: to: self.
	shape when: RSMouseLeftClick send: #leftClick: to: self.
	^ shape
]

{ #category : #model }
PhxDependencyVisualizer >> packageRelationGraph [

	packageRelationGraph ifNil: [ 
		| g |
		g := DAPackageRelationGraph onPackagesNamed:
			     (self allPhxPackages collect: [ :e | e name ]).
		g computeStaticDependencies.
		g removeInternalDependencies.
		g combineDependencies.
		packageRelationGraph := g ].
	^ packageRelationGraph
]

{ #category : #'package selections' }
PhxDependencyVisualizer >> packageShapeSelections [

	packageShapeSelections ifNil: [ 
		packageShapeSelections := OrderedCollection new ].
	^ packageShapeSelections
]

{ #category : #model }
PhxDependencyVisualizer >> packagesWithMultipleRepositories [

	^self allPhxPackages select: [ :p | (self containingRepositoriesOfPackage: p) size > 1 ]
]

{ #category : #model }
PhxDependencyVisualizer >> packagesWithoutRepositories [

	^self allPhxPackages select: [ :p | (self containingRepositoriesOfPackage: p) isEmpty ]
]

{ #category : #menu }
PhxDependencyVisualizer >> removeWithEvent: event [
"not OK yet... not used"
	self canvas removeShape: event shape
]

{ #category : #'transcript util' }
PhxDependencyVisualizer >> reportToTranscript [

	<script>
	Transcript clear.
	self allPhxPackages do: [ :e | 
		Transcript show: e name.

		(self containingRepositoriesOfPackage: e) do: [ :eRepo | 
			eRepo name = 'PharoX' ifFalse: [ 
				Transcript show: ' [' , eRepo name , ']' ] ].
		Transcript cr ]
]

{ #category : #'package selections' }
PhxDependencyVisualizer >> selectPackageShape: sh [

	(self isPackageShapeSelected: sh) ifFalse: [ 
		self packageShapeSelections add: sh.
		self highlitePackageShapeAsSelected: sh ]
]

{ #category : #'package selections' }
PhxDependencyVisualizer >> shapeClicked: sh [

	self toggleSelectionForPackageShape: sh
]

{ #category : #menu }
PhxDependencyVisualizer >> showDepencyAnalyzerWithDoubleClickEvent: anEvent [
	self stopAndRemoveAllAnimations.
	(DAPackageDependenciesPresenter onPackagesNamed:
		 { anEvent shape model name }) open
]

{ #category : #menu }
PhxDependencyVisualizer >> showMenu: evt [

	"	| menu newContext tool class |
	context ifNil: [ ^ self ].
	class := evt shape model baselineClass.
	class ifNil: [ ^ self ].
	newContext := context copy.
	tool := ClyFullBrowserMorph on: ClyNavigationEnvironment currentImage.
	tool prepareInitialStateBy: [ :b | b selectClass: class ].

	newContext tool: tool.
	menu := CmdContextMenuActivation
		        buildContextMenuFor: evt canvas morph
		        inContext: newContext.
	menu popUpInWorld: self currentWorld"

	| menu |
	menu := MenuMorph new.
	"menu buildTitle: [ :menuTitle | menuTitle onlyCloseAndPinable ]."
	"	menu
		add: 'remove'
		target: self
		selector: #removeWithEvent:
		argument: evt."
	menu
		add: 'browse'
		target: self
		selector: #browse:
		argument: evt.
	menu addLine.
	menu
		add: 'open dependency analyzer'
		target: self
		selector: #showDepencyAnalyzerWithDoubleClickEvent:
		argument: evt.

	^ menu popUpInWorld
]

{ #category : #visualisation }
PhxDependencyVisualizer >> textColor [

	^ Color lightGray 
]

{ #category : #'package selections' }
PhxDependencyVisualizer >> toggleSelectionForPackageShape: sh [

	(self isPackageShapeSelected: sh)
		ifTrue: [ self deselectPackageShape: sh ]
		ifFalse: [ self selectPackageShape: sh ]
]

{ #category : #'package selections' }
PhxDependencyVisualizer >> unhighlitePackageShapeAsSelected: sh [

	sh shapes first  color: Color lightGray.
]

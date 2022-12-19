Class {
	#name : #PhxDependencyVisualizer,
	#superclass : #Object,
	#instVars : [
		'canvas'
	],
	#category : #'Phx-Dependency-Visualizer'
}

{ #category : #model }
PhxDependencyVisualizer >> allPhxPackages [

	| patterns |
	patterns := { 'phx*'. 'biti'. 'Pharo-home*' . '*ecg*'}.
	^ (RPackageOrganizer default packages select: [ :p | 
		  patterns anySatisfy: [ :patt | patt match: p name ] ]) sortedAs: #name
]

{ #category : #model }
PhxDependencyVisualizer >> allPhxPackagesDependingOn: aPackageName [

	| pNames |
	pNames := self dependenciesOf: aPackageName.
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

{ #category : #highliting }
PhxDependencyVisualizer >> browse: evt [
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
PhxDependencyVisualizer >> dependenciesOf: aPackageName [

	^ DADependencyChecker new dependenciesOf: aPackageName
]

{ #category : #visualisation }
PhxDependencyVisualizer >> graph [

	<script: 'self new graph'>
	| data boxes canv rsLayout |
	data := self allPhxPackages.
	boxes := data collect: [ :class | 
		         | sh |
		         sh := self newShapeFor: class.
		         sh
			         when: RSMouseDoubleLeftClick
			         send: #showDepencyAnalyzerWithDoubleClickEvent:
			         to: self.
		         sh ].

	canv := self canvas.
	canv addAll: boxes.
	self newLineBuilder
		canvas: canv;
		connectToAll: [ :p | self allPhxPackagesDependingOn: p name ].
	canv lines pushBack.
	rsLayout := PhxDvHorizontalTreeLayout new.
	"	rsLayout := RSHorizontalTreeLayout new."

	rsLayout
		horizontalGap: 50;
		verticalGap: 5.
	rsLayout on: boxes.
	canv nodes @ self highlightable.
	canv "@ RSCanvasController".
	canv inspect
]

{ #category : #highliting }
PhxDependencyVisualizer >> highlight: evt [

	| box incomingLines outgoingLines incomingBoxes outgoingBoxes |
	box := evt shape.
	incomingLines := box incomingLines.
	outgoingLines := box outgoingLines.
	self
		highlightLines: incomingLines
		withColor: self incomingHighliteColor.
	self
		highlightLines: outgoingLines
		withColor: self outgoingHighliteColor.
	incomingBoxes := (incomingLines collect: #from) asOrderedCollection.
	self
		highlightBoxes: incomingBoxes
		withColor: self incomingHighliteColor.
	outgoingBoxes := (outgoingLines collect: #to) asOrderedCollection.
	self
		highlightBoxes: outgoingBoxes
		withColor: self outgoingHighliteColor.
	self canvas propertyAt: #highlightedBoxes put: incomingBoxes , outgoingBoxes.
	self canvas
		propertyAt: #highlightedLines
		put: incomingLines , outgoingLines
]

{ #category : #highliting }
PhxDependencyVisualizer >> highlightAnt: antBorder [

	| animation canv |
	canv := self canvas.
	antBorder dashArray: #( 7 3 ).
	animation := canv newAnimation
		             repeat;
		             from: 0;
		             to: antBorder dashArray sum negated;
		             duration: 1 second;
		             onStepDo: [ :t | 
			             antBorder dashOffset: t.
			             canv signalUpdate ].

	canv propertyAt: #ant put: animation
]

{ #category : #highliting }
PhxDependencyVisualizer >> highlightBoxes: boxes withColor: aColor [

	| canv  |
	canv := self canvas.
	boxes do: [ :box | 
		| shadow |
		shadow := self shadowFor: box.
		shadow color: aColor.
		box
			when: RSPositionChangedEvent
			do: [ :evt | shadow position: evt newPosition ].
		box propertyAt: #shadow put: shadow.
		canv addShape: shadow.
		shadow pushBack ].
	
]

{ #category : #highliting }
PhxDependencyVisualizer >> highlightLines: lines withColor: aColor [

	| antBorder |
	lines ifEmpty: [ ^ self ].
	antBorder := RSBorder new
		             width: 2;
		             yourself.
	lines do: [ :line | 
		| border |
		border := line border.
		line propertyAt: #oldBorder put: border.
		line border: antBorder.
		line color: aColor ].
	self highlightAnt: antBorder
]

{ #category : #highliting }
PhxDependencyVisualizer >> highlightable [
	^ RSHighlightable new
		when: RSHighlightEvent send: #highlight: to: self;
		when: RSUnHighlightEvent send: #unhighlight: to: self;
		yourself
]

{ #category : #highliting }
PhxDependencyVisualizer >> incomingHighliteColor [

	^ Color green darker darker
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
	shape when: RSMouseDoubleClick send: #browse: to: self.
	shape when: RSMouseRightClick send: #showMenu: to: self.
	^ shape
]

{ #category : #highliting }
PhxDependencyVisualizer >> outgoingHighliteColor [

	^ Color red darker darker
]

{ #category : #model }
PhxDependencyVisualizer >> packagesWithMultipleRepositories [

	^self allPhxPackages select: [ :p | (self containingRepositoriesOfPackage: p) size > 1 ]
]

{ #category : #model }
PhxDependencyVisualizer >> packagesWithoutRepositories [

	^self allPhxPackages select: [ :p | (self containingRepositoriesOfPackage: p) isEmpty ]
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

{ #category : #highliting }
PhxDependencyVisualizer >> shadowFor: box [
	^ RSBox new
		position: box position;
		extent: box extent + 3;
		cornerRadius: 3;
		yourself
]

{ #category : #visualisation }
PhxDependencyVisualizer >> showDepencyAnalyzerWithDoubleClickEvent: anEvent [

	(DAPackageDependenciesPresenter onPackagesNamed:
		 { anEvent shape model name }) open
]

{ #category : #highliting }
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
]

{ #category : #visualisation }
PhxDependencyVisualizer >> textColor [

	^ Color blue
]

{ #category : #highliting }
PhxDependencyVisualizer >> unhighlight: evt [
	evt canvas 
		propertyAt: #ant ifPresent: [ :anime | anime stop ];
		propertyAt: #highlightedLines ifPresent: [ :lines | self unhighlightLines: lines ];
		propertyAt: #highlightedBoxes ifPresent: [ :boxes | self unhighlightBoxes: boxes ].
	
]

{ #category : #highliting }
PhxDependencyVisualizer >> unhighlightBoxes: boxes [
	boxes do: [ :box | 
		box propertyAt: #shadow ifPresent: [ :shadow | shadow remove ] ]
	
]

{ #category : #highliting }
PhxDependencyVisualizer >> unhighlightLines: lines [
	lines do: [ :line | 
		line border: (line propertyAt: #oldBorder).
		line color: line border color.
		line removeKey: #oldBorder ]
	
]

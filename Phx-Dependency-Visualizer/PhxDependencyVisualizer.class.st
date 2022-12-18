Class {
	#name : #PhxDependencyVisualizer,
	#superclass : #Object,
	#category : #'Phx-Dependency-Visualizer'
}

{ #category : #model }
PhxDependencyVisualizer class >> allPhxPackages [

	| patterns |
	patterns := { 'phx*'. 'biti'. 'Pharo-home*' . '*ecg*'}.
	^ (RPackageOrganizer default packages select: [ :p | 
		  patterns anySatisfy: [ :patt | patt match: p name ] ]) sortedOnPaths: #(name)
]

{ #category : #model }
PhxDependencyVisualizer class >> allPhxPackagesDependingOn: aPackageName [

	| pNames |
	pNames := self dependenciesOf: aPackageName.
	^ self allPhxPackages select: [ :e | pNames includes: e name ]
]

{ #category : #model }
PhxDependencyVisualizer class >> allPhxRepositories [
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
PhxDependencyVisualizer class >> allPhxRepositoriesWithoutPharoX [
"
self allPhxRepositoriesWithoutPharoX
"
	^self allPhxRepositories reject: [ :each | each name = 'PharoX' ]
]

{ #category : #model }
PhxDependencyVisualizer class >> containingRepositoriesOfPackage: aPackage [  

	^IceRepository registry select: [ :p | p includesPackageNamed:  aPackage name ]
]

{ #category : #model }
PhxDependencyVisualizer class >> dependenciesOf: aPackageName [

	^ DADependencyChecker new dependenciesOf: aPackageName
]

{ #category : #visualisation }
PhxDependencyVisualizer class >> graph [

	<script>
	| data boxes canvas rslayout |
	data := self allPhxPackages.
	boxes := data collect: [ :class | self newShapeFor: class ].
	canvas := RSCanvas new.
	canvas addAll: boxes.

	self newLineBuilder
		canvas: canvas;
		connectToAll: [ :p | self allPhxPackagesDependingOn: p name ].
	canvas lines pushBack.


	"self allPhxRepositoriesWithoutPharoX do: [ :repo | 
		RSFlowLayout new
			gapSize: 2;
			on: (boxes select: [ :e | 
						 (self containingRepositoriesOfPackage: e model) anySatisfy: [ 
								 :r | r = repo ] ]) ]."
	rslayout := RSRectangleForceLayout new 
		          nodes: boxes;
		          edges: canvas lines;
		          charge: -400;
		          gravity: 0.8;
		          strength: 0.2;
		          alpha: 0.8;
		          friction: 0.9;
		          start;
		          yourself.

	canvas when: RSExtentChangedEvent do: [ :evt | 
		| camera origin corner |
		camera := canvas canvas camera.
		origin := camera fromPixelToSpace: 0 @ 0.
		corner := camera fromPixelToSpace: canvas canvas extent.
		rslayout enclosingRectangle: (origin corner: corner) ].
	"	canvas @ RSSimpleCanvasMonitorInteraction."

	"canvas newAnimation repeat onStepDo: [ :t | layout step ]."

	"	rsLayout := RSHorizontalTreeLayout new.
	rsLayout
		horizontalGap: 50;
		verticalGap: 5.
	rsLayout on: boxes."


	canvas @ RSCanvasController.
	canvas inspect
]

{ #category : #visualisation }
PhxDependencyVisualizer class >> marker [
	|  marker |
"	theme := self theme."
	marker := RSShapeFactory arrow.
	marker color: self textColor.
	marker size: 10.
	marker := marker asMarker.
	marker offset: 0.
	layout. 
	^ marker
]

{ #category : #visualisation }
PhxDependencyVisualizer class >> newLineBuilder [

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
PhxDependencyVisualizer class >> newShapeFor: model [
	| label box |
	label := RSLabel new
		text: model name;
		color: Color black;
		yourself.
	box := RSBox new
		extent: label extent + 10;
		"border: (self newBorderFor: model);"
		cornerRadius: 3;
		yourself.
	^ ({ box. label } asShapeFor: model) 
		draggable;
		yourself.
		
]

{ #category : #model }
PhxDependencyVisualizer class >> packagesWithMultipleRepositories [

	^self allPhxPackages select: [ :p | (self containingRepositoriesOfPackage: p) size > 1 ]
]

{ #category : #model }
PhxDependencyVisualizer class >> packagesWithoutRepositories [

	^self allPhxPackages select: [ :p | (self containingRepositoriesOfPackage: p) isEmpty ]
]

{ #category : #'transcript util' }
PhxDependencyVisualizer class >> reportToTranscript [

	<script>
	Transcript clear.
	self allPhxPackages do: [ :e | 
		Transcript show: e name.

		(self containingRepositoriesOfPackage: e) do: [ :eRepo | 
			eRepo name = 'PharoX' ifFalse: [ 
				Transcript show: ' [' , eRepo name , ']' ] ].
		Transcript cr ]
]

{ #category : #visualisation }
PhxDependencyVisualizer class >> textColor [

	^ Color blue
]

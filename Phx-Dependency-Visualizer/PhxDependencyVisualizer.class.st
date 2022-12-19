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
		  patterns anySatisfy: [ :patt | patt match: p name ] ]) sortedAs: #name
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
	| data boxes canvas rsLayout |
	data := self allPhxPackages.
	boxes := data collect: [ :class | 
		         | sh |
		         sh := self newShapeFor: class.
		         sh
			         when: RSMouseDoubleLeftClick
			         send: #showDepencyAnalyzerWithDoubleClickEvent:
			         to: self.
		         sh ].

	canvas := RSCanvas new.
	canvas addAll: boxes.
	self newLineBuilder
		canvas: canvas;
		connectToAll: [ :p | self allPhxPackagesDependingOn: p name ].
	canvas lines pushBack.
	rsLayout := PhxDvHorizontalTreeLayout new.
	"	rsLayout := RSHorizontalTreeLayout new."

	rsLayout
		horizontalGap: 50;
		verticalGap: 5.
	rsLayout on: boxes.
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
PhxDependencyVisualizer class >> showDepencyAnalyzerWithDoubleClickEvent: anEvent [

	(DAPackageDependenciesPresenter onPackagesNamed:
		 { anEvent shape model name }) open
]

{ #category : #visualisation }
PhxDependencyVisualizer class >> textColor [

	^ Color blue
]

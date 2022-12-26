Class {
	#name : #DvRsWorkScope,
	#superclass : #DvRsObject,
	#traits : 'DvInAndOutHighlitable',
	#classTraits : 'DvInAndOutHighlitable classTrait',
	#instVars : [
		'rsCanvas',
		'rsPackages',
		'rsPackageGroups'
	],
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #examples }
DvRsWorkScope class >> example1 [

	"
self example1
"

	| vis c window |
	vis := DvWorkScope example1 asRoassalVisualization.
	c := vis build canvas.
	window := c openWithTitle: 'Dependencies of the Phx project'.
	window extent: 2000 @ 1300.
	c zoomToFit
	"	vis inspect."
]

{ #category : #build }
DvRsWorkScope >> addAllRsPackageGroups [

	self model packageGroups do: [ :pg | self addPackageGroup: pg ]
]

{ #category : #build }
DvRsWorkScope >> addAllRsPackages [

	self model packages do: [:p |  self addPackage: p ]
]

{ #category : #build }
DvRsWorkScope >> addPackage: aPackage [

	| rsPackage |
	rsPackage := DvRsPackage newWithModel: aPackage under: self.
	rsPackage build.
	^ rsPackage
]

{ #category : #build }
DvRsWorkScope >> addPackageGroup: aPackageGroup [

	| rsPackageGroup |
	rsPackageGroup := DvRsPackageGroup
		                  newWithModel: aPackageGroup
		                  under: self.
	rsPackageGroup build
]

{ #category : #build }
DvRsWorkScope >> addRsPackageGroup: anObject [

	self model packageGroups add: anObject.
	
]

{ #category : #private }
DvRsWorkScope >> addToManyRelationOnParent [
	"no parent, no need"
]

{ #category : #build }
DvRsWorkScope >> applyLayoutHierarchical [

	| pckgs rsLayout |
	rsLayout := DvHorizontalTreeLayout new.
	rsLayout
		horizontalGap: 50;
		verticalGap: 5.
	pckgs := self rsPackages reject: [ :e | 
		         self rsPackageGroups contains: [ :pg | 
			         pg containedPackages includes: e ] ].
	rsLayout on: (pckgs collect: [ :p | p mainShape ])
]

{ #category : #build }
DvRsWorkScope >> build [

	self addAllRsPackages.
	self addAllRsPackageGroups.
	self connectAllPackages.
	self applyLayoutHierarchical.
	self canvas nodes @ self highlightable
]

{ #category : #build }
DvRsWorkScope >> connectAllPackages [

	| packageShapes |
	packageShapes := self rsPackages collect: #mainShape.
	self newLineBuilder
		fromShapes: packageShapes;
		toShapes: packageShapes;
		canvas: self canvas;
		connectToAll: [ :each | each packagesYouDependOn ]
]

{ #category : #'initialize-release' }
DvRsWorkScope >> initialize [
	super initialize.

]

{ #category : #build }
DvRsWorkScope >> marker [
	|  marker |
	marker := RSShapeFactory arrow.
	marker color: self textColor.
	marker size: 10.
	marker := marker asMarker.
	marker offset: 0.
	^ marker
]

{ #category : #build }
DvRsWorkScope >> newLineBuilder [

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

{ #category : #private }
DvRsWorkScope >> removeFromManyRelationOnParent [
	"no parent, no need"
]

{ #category : #accessing }
DvRsWorkScope >> rsCanvas [

	rsCanvas ifNil: [ 
		rsCanvas := RSCanvas new.
		rsCanvas addInteraction: (RSCanvasController new
				 in: [ :i | i configuration useBasicZoom ];
				 yourself) ].
	^ rsCanvas
]

{ #category : #accessing }
DvRsWorkScope >> rsPackageGroups [

	rsPackageGroups ifNil: [ rsPackageGroups := OrderedCollection new ].
	^ rsPackageGroups
]

{ #category : #accessing }
DvRsWorkScope >> rsPackages [

	rsPackages ifNil: [ rsPackages := OrderedCollection new ].
	^ rsPackages
]

{ #category : #'setUp-tearDown' }
DvRsWorkScope >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : #build }
DvRsWorkScope >> textColor [

	^ Color lightGray 
]

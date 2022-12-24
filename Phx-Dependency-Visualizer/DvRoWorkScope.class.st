Class {
	#name : #DvRoWorkScope,
	#superclass : #DvRoObject,
	#traits : 'DvInAndOutHighlitable',
	#classTraits : 'DvInAndOutHighlitable classTrait',
	#instVars : [
		'rsCanvas',
		'packages',
		'packageGroups'
	],
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #examples }
DvRoWorkScope class >> example1 [

	DvWorkScope example1 asRoassalVisualization build canvas open
]

{ #category : #build }
DvRoWorkScope >> addAllPackageGroups [

	self model packageGroups do: [ :pg | self addPackageGroup: pg ]
]

{ #category : #build }
DvRoWorkScope >> addAllPackages [

	self model packages do: [:p |  self addPackage: p ]
]

{ #category : #build }
DvRoWorkScope >> addPackage: aPackage [
	| vPackage |
	vPackage := DvRoPackage  newWithModel: aPackage under: self.
	vPackage build.
	
	self rsCanvas zoomToFit.
	^vPackage
]

{ #category : #build }
DvRoWorkScope >> addPackageGroup: aPackageGroup [

	| pg |
	pg := DvRoPackageGroup newWithModel: aPackageGroup under: self.
	pg build
]

{ #category : #private }
DvRoWorkScope >> addToManyRelationOnParent [
	"no parent, no need"
]

{ #category : #build }
DvRoWorkScope >> applyLayoutHierarchical [

	| rsLayout |
	rsLayout := DvHorizontalTreeLayout new.
	rsLayout
		horizontalGap: 50;
		verticalGap: 5.
	rsLayout on: (self packages collect: [ :p | p mainShape ])
]

{ #category : #build }
DvRoWorkScope >> build [

	self addAllPackages.
	self addAllPackageGroups.


		self connectAllPackages.
	self applyLayoutHierarchical.
	self canvas nodes @ self highlightable
]

{ #category : #build }
DvRoWorkScope >> connectAllPackages [

	self newLineBuilder
		fromShapes: (self packages collect: #mainShape);
		toShapes: (self packages collect: #mainShape);
		canvas: self canvas;
		connectToAll: [ :each | each packagesYouDependOn ]
]

{ #category : #'initialize-release' }
DvRoWorkScope >> initialize [
	super initialize.

]

{ #category : #build }
DvRoWorkScope >> marker [
	|  marker |
	marker := RSShapeFactory arrow.
	marker color: self textColor.
	marker size: 10.
	marker := marker asMarker.
	marker offset: 0.
	^ marker
]

{ #category : #build }
DvRoWorkScope >> newLineBuilder [

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

{ #category : #accessing }
DvRoWorkScope >> packageGroups [

	packageGroups ifNil: [ packageGroups := OrderedCollection new ].
	^ packageGroups
]

{ #category : #accessing }
DvRoWorkScope >> packages [

	packages ifNil: [ packages := OrderedCollection new ].
	^ packages
]

{ #category : #private }
DvRoWorkScope >> removeFromManyRelationOnParent [
	"no parent, no need"
]

{ #category : #accessing }
DvRoWorkScope >> rsCanvas [

	rsCanvas ifNil: [ 
		rsCanvas := RSCanvas new.
		rsCanvas addInteraction: (RSCanvasController new
				 in: [ :i | i configuration useBasicZoom ];
				 yourself) ].
	^ rsCanvas
]

{ #category : #'setUp-tearDown' }
DvRoWorkScope >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : #build }
DvRoWorkScope >> textColor [

	^ Color lightGray 
]

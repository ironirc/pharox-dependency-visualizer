Class {
	#name : #PhxDvVisWorkScope,
	#superclass : #PhxDvRoObject,
	#traits : 'PhxDvInAndOutHighlitable',
	#classTraits : 'PhxDvInAndOutHighlitable classTrait',
	#instVars : [
		'rsCanvas',
		'packages',
		'packageGroups'
	],
	#category : #'Phx-Dependency-Visualizer-viz gen2'
}

{ #category : #build }
PhxDvVisWorkScope >> addAllPackageGroups [

	self model packageGroups do: [ :pg | self addPackageGroup: pg ]
]

{ #category : #build }
PhxDvVisWorkScope >> addAllPackages [

	self model packages do: [:p |  self addPackage: p ]
]

{ #category : #build }
PhxDvVisWorkScope >> addPackage: aPackage [
	| vPackage |
	vPackage := PhxDvVisPackage  newWithModel: aPackage under: self.
	vPackage build.
	
	self rsCanvas zoomToFit.
	^vPackage
]

{ #category : #build }
PhxDvVisWorkScope >> addPackageGroup: aPackageGroup [

	| pg |
	pg := PhxDvVisPackageGroup newWithModel: aPackageGroup under: self.
	pg build
]

{ #category : #private }
PhxDvVisWorkScope >> addToManyRelationOnParent [
	"no parent, no need"
]

{ #category : #build }
PhxDvVisWorkScope >> applyLayoutHierarchical [

	| rsLayout |
	rsLayout := PhxDvHorizontalTreeLayout new.
	rsLayout
		horizontalGap: 50;
		verticalGap: 5.
	rsLayout on: (self packages collect: [ :p | p mainShape ])
]

{ #category : #build }
PhxDvVisWorkScope >> build [

	self addAllPackages.
	self addAllPackageGroups.


		self connectAllPackages.
	self applyLayoutHierarchical.
	self canvas nodes @ self highlightable
]

{ #category : #build }
PhxDvVisWorkScope >> connectAllPackages [

	self newLineBuilder
		fromShapes: (self packages collect: #mainShape);
		toShapes: (self packages collect: #mainShape);
		canvas: self canvas;
		connectToAll: [ :each | each packagesYouDependOn ]
]

{ #category : #'initialize-release' }
PhxDvVisWorkScope >> initialize [
	super initialize.

]

{ #category : #build }
PhxDvVisWorkScope >> marker [
	|  marker |
	marker := RSShapeFactory arrow.
	marker color: self textColor.
	marker size: 10.
	marker := marker asMarker.
	marker offset: 0.
	^ marker
]

{ #category : #build }
PhxDvVisWorkScope >> newLineBuilder [

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
PhxDvVisWorkScope >> packageGroups [

	packageGroups ifNil: [ packageGroups := OrderedCollection new ].
	^ packageGroups
]

{ #category : #accessing }
PhxDvVisWorkScope >> packages [

	packages ifNil: [ packages := OrderedCollection new ].
	^ packages
]

{ #category : #private }
PhxDvVisWorkScope >> removeFromManyRelationOnParent [
	"no parent, no need"
]

{ #category : #accessing }
PhxDvVisWorkScope >> rsCanvas [

	rsCanvas ifNil: [ 
		rsCanvas := RSCanvas new.
		rsCanvas addInteraction: (RSCanvasController new
				 in: [ :i | i configuration useBasicZoom ];
				 yourself) ].
	^ rsCanvas
]

{ #category : #'setUp-tearDown' }
PhxDvVisWorkScope >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : #build }
PhxDvVisWorkScope >> textColor [

	^ Color lightGray 
]

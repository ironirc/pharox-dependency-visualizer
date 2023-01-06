Class {
	#name : #DvRsWorkScope2,
	#superclass : #DvRsPackageGroup2,
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #examples }
DvRsWorkScope2 class >> example1 [

"
self example1
"

	| vis c window |
	c := RSCanvas new.
	c addInteraction: (RSCanvasController new
			 in: [ :i | i configuration useBasicZoom ];
			 yourself).
	vis := DvRsWorkScope2 new model: DvWorkScope example1.
	vis build.
	c add: vis.
"		layout := RSForceBasedLayout new
		autoRepulse: true;
		charge: 300;
		nodes: vis nodes;
		edges: vis edges;
		start.
	c newAnimation repeat onStepDo: [ :t | 
		layout step ]."

	window := c openWithTitle: 'Dependencies of the Phx project'.
	window extent: 2000 @ 1300.
	
	"c zoomToFit"
	"	c inspect."
]

{ #category : #private }
DvRsWorkScope2 >> addToManyRelationOnParent [
	"no parent, no need"
]

{ #category : #build }
DvRsWorkScope2 >> applyLayoutHierarchical [

		| rsLayout |
	rsLayout := DvHorizontalTreeLayout new.
	rsLayout
		horizontalGap: 50;
		verticalGap: 5.
	rsLayout on: self nodes

	"; on: self nodes"

	 "RSForceBasedLayout new
		doNotUseProgressBar; 
		autoRepulse: true;
		alpha: 0.1;
		charge: -1300;
		nodes: self nodes;
		edges: self edges;
		iterations: 100;
		runLayoutSimply.
"
]

{ #category : #build }
DvRsWorkScope2 >> build [

	self buildPackages.
	self buildPackageGroups.
	self connectAllPackages.
	self applyLayoutHierarchical.
	self nodes @ self highlightable.
	self adjustToChildren.
	lines pushBack
	"self addAllRsPackageGroups.
	"
]

{ #category : #build }
DvRsWorkScope2 >> buildPackageGroups [

	self model packageGroups do: [ :pg | 
		| pgComp |
		pgComp := DvRsPackageGroup2 new.
		pgComp model: pg.
		pgComp build.
		self add: pgComp ]
]

{ #category : #build }
DvRsWorkScope2 >> connectAllPackages [

	self newLineBuilder
		fromShapes: self nodes;
		toShapes: self nodes;
		canvas: self;
		connectFromAll: [ :each | each packagesYouDependOn , each packageGroupsYouDependOn ] 
]

{ #category : #'initialize-release' }
DvRsWorkScope2 >> initialize [
	super initialize.

]

{ #category : #build }
DvRsWorkScope2 >> marker [
	|  marker |
	marker := RSShapeFactory arrow.
	marker color: self textColor.
	marker size: 10.
	marker := marker asMarker.
	marker offset: 0.
	^ marker
]

{ #category : #build }
DvRsWorkScope2 >> newLineBuilder [

	| marker |
	marker := self marker.
	^ RSLineBuilder bezier
		  markerStart: marker;
		  attachPoint: (RSHorizontalAttachPoint new
				   endOffset: marker shape height / -2;
				   yourself);
		  controlPointsController: RSHorizontalLeftRightController new;
		  color: self textColor;
		  yourself
]

{ #category : #private }
DvRsWorkScope2 >> removeFromManyRelationOnParent [
	"no parent, no need"
]

{ #category : #'setUp-tearDown' }
DvRsWorkScope2 >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : #build }
DvRsWorkScope2 >> textColor [

	^ Color lightGray 
]

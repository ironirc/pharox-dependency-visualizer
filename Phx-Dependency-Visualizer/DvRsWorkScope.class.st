Class {
	#name : 'DvRsWorkScope',
	#superclass : 'DvRsPackageGroup',
	#category : 'Phx-Dependency-Visualizer-visualisation',
	#package : 'Phx-Dependency-Visualizer',
	#tag : 'visualisation'
}

{ #category : 'examples' }
DvRsWorkScope class >> exampleWithRoassal [

	<script>
	| vis c window |
	c := RSCanvas new.
	c addInteraction: (RSCanvasController new
			 in: [ :i | i configuration useBasicZoom ];
			 yourself).
	vis := DvRsWorkScope new model: DvWorkScope newForRoassal.
	vis build.
	c add: vis.
	window := c openWithTitle: 'Dependencies inside Roassal'.
	window extent: 2000 @ 1300
]

{ #category : 'examples' }
DvRsWorkScope class >> exampleWithZincAndZodiac [

	<script>
	| vis c window |
	c := RSCanvas new.
	c addInteraction: (RSCanvasController new
			 in: [ :i | i configuration useBasicZoom ];
			 yourself).
	vis := DvRsWorkScope new model: DvWorkScope newForZincAndZodiac.
	vis build.
	c add: vis.
	window := c openWithTitle: 'Dependencies inside Zinc/Zodiac'.
	window extent: 2000 @ 1300
]

{ #category : 'examples' }
DvRsWorkScope class >> exampleWithZincAndZodiacGrouped [

	<script>
	| vis c window |
	c := RSCanvas new.
	c addInteraction: (RSCanvasController new
			 in: [ :i | i configuration useBasicZoom ];
			 yourself).
	vis := DvRsWorkScope new model: DvWorkScope newForZincAndZodiacGrouped.
	vis build.
	c add: vis.
	window := c openWithTitle: 'Dependencies between Zinc and Zodiac'.
	window extent: 2000 @ 1300
]

{ #category : 'private' }
DvRsWorkScope >> addToManyRelationOnParent [
	"no parent, no need"
]

{ #category : 'build' }
DvRsWorkScope >> applyLayoutHierarchical [

		| rsLayout |
	rsLayout := DvHorizontalTreeLayout new.
	rsLayout
		horizontalGap: 50;
		verticalGap: 5.
	rsLayout on: self nodes
	
	"rsLayout:=	RSCircleLayout new.
	rsLayout ""	horizontalGap: 20;
		verticalGap: 10;""
		on: self nodes."

	"; on: self nodes"

"	 RSForceBasedLayout new
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

{ #category : 'build' }
DvRsWorkScope >> build [

	self buildPackages.
	self buildPackageGroups.
	self connectAllPackages.
	self applyLayoutHierarchical.
	"self nodes do: [ :n |
		n
			when: RSPositionChangedEvent
			do: [ self adjustToChildren ]
			for: self ]."
	self nodes @ self highlightable.
	self adjustToChildren.
	lines pushBack
	"self addAllRsPackageGroups.
	"
]

{ #category : 'build' }
DvRsWorkScope >> buildPackageGroups [

	self model packageGroups do: [ :pg | 
		| pgComp |
		pgComp := DvRsPackageGroup new.
		pgComp model: pg.
		pgComp build.
		self add: pgComp ]
]

{ #category : 'build' }
DvRsWorkScope >> connectAllPackages [

	self newLineBuilder
		fromShapes: self nodes;
		toShapes: self nodes;
		canvas: self;
		connectFromAll: [ :each | each packagesYouDependOn , each packageGroupsYouDependOn ] 
]

{ #category : 'initialize-release' }
DvRsWorkScope >> initialize [
	super initialize.

]

{ #category : 'build' }
DvRsWorkScope >> marker [
	|  marker |
	marker := RSShapeFactory arrow.
	marker color: self textColor.
	marker size: 10.
	marker := marker asMarker.
	marker offset: 0.
	^ marker
]

{ #category : 'build' }
DvRsWorkScope >> newLineBuilder [

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

{ #category : 'private' }
DvRsWorkScope >> removeFromManyRelationOnParent [
	"no parent, no need"
]

{ #category : 'setUp-tearDown' }
DvRsWorkScope >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : 'build' }
DvRsWorkScope >> textColor [

	^ Color lightGray 
]

Class {
	#name : #DvHorizontalTreeLayout,
	#superclass : #RSAbstractHorizontalTreeLayout,
	#instVars : [
		'layers',
		'elementsToBeLayedOut'
	],
	#category : #'Phx-Dependency-Visualizer-visualisation'
}

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> distributeChildrenInLayers [

	| candidates newLayer |
	candidates := self nextChildren.
	candidates ifEmpty: [ ^ self ].
	newLayer := OrderedCollection new.
	(self
		 selectNodesFrom: candidates
		 forWhichAllPrerequisiteNodesArePresentIn: self nodesInLayers)
		ifNotEmpty: [ :selectedCandidates | 
		newLayer addAll: selectedCandidates ]
		ifEmpty: [ 


			(self
				 selectMostSuitableNodeFrom: candidates
				 forWhichMostPrerequisiteNodesArePresentIn: self nodesInLayers) 
				ifNotNil: [ :n | 
					newLayer add: n.
					candidates remove: n.
					[ 
					| selectedCandidates |
					selectedCandidates := self
						                      selectNodesFrom: candidates
						                      forWhichAllPrerequisiteNodesArePresentIn:
						                      self nodesInLayers , candidates.
					newLayer addAll: selectedCandidates.
					candidates removeAll: selectedCandidates.
					selectedCandidates notEmpty ] whileTrue ] ].
	newLayer ifEmpty: [ ^self ].
	nodesByLayer add: newLayer.
	self distributeChildrenInLayers.

	" ifNotNilOrEmpty: [ 
		:coll | 
		nodesByLayer add: coll.
		self distributeChildrenInLayers ].
	self nextChildrenToBreakTheCycle"
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> doExecute: elements [

	| rootNodes leftOvers |
	elementsToBeLayedOut := elements.
	nodesByLayer := OrderedCollection new.
	rootNodes := self rootNodesFor: elements.
	nodesByLayer add: rootNodes.
	self distributeChildrenInLayers.
	"leftOvers are probably circular chains?"
	leftOvers := elements reject: [ :e | 
		             self isAlreadyInAPreviousLayer: e ].
	leftOvers ifNotEmpty: [ nodesByLayer add: leftOvers ].
	self layoutLayers
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> filterCandidatesForWhichDependenciesArePresent: candidates [

	^ candidates select: [ :candidate | 
		  (self numberOfMissingDependenciesFor: candidate) isZero ]
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> heightOfLayer: layer [

	^ layer inject: 0 into: [ :sum :each | sum + (each height * 2) ]
]

{ #category : #initialization }
DvHorizontalTreeLayout >> initialize [
	super initialize.

]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> isAlreadyInAPreviousLayer: aNode [

	nodesByLayer do: [ :layer | layer do: [ :n | aNode = n ifTrue: [ ^true ] ] ].
	^false
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> layoutLayers [

	| maxLayerHeight layerX |
	maxLayerHeight := self maxLayerHeight.
	layerX := 0.
	nodesByLayer keysAndValuesDo: [ :layerIdx :layer | 
		| shiftX |
		shiftX := layerIdx = 1
			          ifTrue: [ 0 ]
			          ifFalse: [ 
			          (RSGroup withAll: (nodesByLayer at: layerIdx - 1)) width
			          + 50 ].
		layerX := layerX + shiftX.

		RSVerticalLineLayout new
			alignCenter;
			gapSize: 30;
			on: layer.
		layer do: [ :each | each translateBy: layerX @ 0 ] ]
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> maxLayerHeight [

	^ nodesByLayer
		  inject: 0
		  into: [ :max :layer | max max: (self heightOfLayer: layer) ]
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> nextChildWithLeastMissingDependencies [

	^ self nextChildren ifEmpty: [ nil ] ifNotEmpty: [ :results | 
		  (results sorted: [ :a :b | 
			   a outgoingLines size >= b outgoingLines size  ])
			  first ]
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> nextChildWithLeastMissingDependenciesNot [

	^ self nextChildren ifEmpty: [ nil ] ifNotEmpty: [ :results | 
		  (results sorted: [ :a :b | 
			   | mda mdb |
			   mda := self numberOfMissingDependenciesFor: a.
			   mdb := self numberOfMissingDependenciesFor: b.
			   mda = mdb
				   ifFalse: [ mda <= mdb ]
				   ifTrue: [ a outgoingLines size >= b outgoingLines size ] ])
			  first ]
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> nextChildren [

	| results |
	results := Set new.
	self nodesInLayers do: [ :each | 
		results addAll: (self childrenFor: each) ].
	"filter out nodes already handled"
	results := results reject: [ :e | self isAlreadyInAPreviousLayer: e ].
	^ results asOrderedCollection
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> nextChildrenForWhichDependenciesArePresent [

	^ self filterCandidatesForWhichDependenciesArePresent:
		  self nextChildren
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> nextChildrenToBreakTheCycle [

	| results |
	results := OrderedCollection new.
	nodesByLayer add: results.
	self nextChildWithLeastMissingDependencies ifNotNil: [ :n | 
		results add: n ].
	self next
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> nodesInLayers [

	| all |
	all := OrderedCollection new.
	nodesByLayer do: [ :layer | layer do: [ :n | all add: n ] ].
	^ all
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> numberOfMissingDependenciesFor: aNode [

	^ (aNode incomingLines reject: [ :cl | 
		   self isAlreadyInAPreviousLayer: cl from ]) size
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> selectMostSuitableNodeFrom: candidates forWhichMostPrerequisiteNodesArePresentIn: prerequisites [

	candidates ifEmpty: [ ^ nil ].
	^ (candidates sorted: [ :a :b | 
		   a outgoingLines size >= b outgoingLines size ]) first
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> selectNodesFrom: candidates forWhichAllPrerequisiteNodesArePresentIn: prequisites [

	^ candidates select: [ :candidate | 
		  candidate incomingLines allSatisfy: [ :prereqLine | 
			  prequisites includes: prereqLine from ] ]
]

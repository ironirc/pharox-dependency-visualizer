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
DvHorizontalTreeLayout >> childrenFor_obsolete: aNode [

	| all |
	all := super childrenFor: aNode.
	all := all reject: [ :e | self isAlreadyInAPreviousLayer: e ].
	^ all select: [ :e | 
		  e connectedLines allSatisfy: [ :cl | 
			  cl to ~= e or: [ self isAlreadyInAPreviousLayer: cl from ] ] ]
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> distributeChildrenInLayers: dummy [

	| nextLayer |
	nextLayer := self nextChildrenForWhichDependenciesArePresent 
		             ifEmpty: [ self nextChildrenToBreakTheCycle ].

	nextLayer ifEmpty: [ ^ self ].

	"	self nodesAlreadyInLayers do: [ :el | nextLayer addAll: (self childrenFor: el) ].
	nextLayer ifEmpty: [ 
		| unusedEls elWithMaxOuts |
		unusedEls := alreadyInLayers reject: [ :el | 
			             self isAlreadyInAPreviousLayer: el ].
		unusedEls ifEmpty: [ ^ self ].
		elWithMaxOuts := (unusedEls sortedOnPaths:
			                  #( #( outgoingLines size ) )) last.
		nextLayer add: elWithMaxOuts ].
	nextLayer := nextLayer asOrderedCollection."
	nodesByLayer add: nextLayer.
	self distributeChildrenInLayers: nil
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> doExecute: elements [

	| rootNodes leftOvers |
	elementsToBeLayedOut := elements.
	nodesByLayer := OrderedCollection new.
	rootNodes := self rootNodesFor: elements.
	nodesByLayer add: rootNodes.


	self distributeChildrenInLayers: nil.
	"leftOvers are probably circular chains?"
	leftOvers := elements reject: [ :e | 
		             self isAlreadyInAPreviousLayer: e ].
	leftOvers ifNotEmpty: [ nodesByLayer add: leftOvers ].
	self layoutLayers
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> heightOfLayer: layer [

	^ layer inject: 0 into: [ :sum :each | sum + (each height * 2) ]
]

{ #category : #initialization }
DvHorizontalTreeLayout >> initialize [
	super initialize.
	layers := OrderedCollection new
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
DvHorizontalTreeLayout >> nextChildren [

	| results |
	results := Set new.
	self nodesInLayers do: [ :each | 
		results addAll: (self childrenFor: each) ].
	results := results reject: [ :e | self isAlreadyInAPreviousLayer: e ].
	^ results asOrderedCollection
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> nextChildrenForWhichDependenciesArePresent [

	| results |
	results := self nextChildren.
	^ results select: [ :candidate | 
		  candidate incomingLines allSatisfy: [ :cl | 
			  self isAlreadyInAPreviousLayer: cl from ] ]
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> nextChildrenToBreakTheCycle [

	^ self nextChildren ifNotEmpty: [ :results | 
		  { (results sorted: [ :a :b | 
			   a outgoingLines size <= b outgoingLines size ]) last } ]
]

{ #category : #'private - hook' }
DvHorizontalTreeLayout >> nodesInLayers [

	| all |
	all := OrderedCollection new.
	nodesByLayer do: [ :layer | layer do: [ :n | all add: n ] ].
	^ all
]

Class {
	#name : #PhxDvHorizontalTreeLayout,
	#superclass : #RSAbstractHorizontalTreeLayout,
	#instVars : [
		'layers'
	],
	#category : #'Phx-Dependency-Visualizer'
}

{ #category : #'private - hook' }
PhxDvHorizontalTreeLayout >> childrenFor: aNode [

	| all |
	all := super childrenFor: aNode.
	all := all reject: [ :e | self isAlreadyInAPreviousLayer: e ].
	^ all select: [ :e | 
		  e connectedLines allSatisfy: [ :cl | 
			  cl to ~= e or: [ self isAlreadyInAPreviousLayer: cl from ] ] ]
]

{ #category : #'private - hook' }
PhxDvHorizontalTreeLayout >> computeChildrenFor: aNode [
	^ self childrenFor: aNode except: alreadyLayoutedNodes
]

{ #category : #'private - hook' }
PhxDvHorizontalTreeLayout >> distributeChildrenInLayers: elements [

	| nextLayer |
	nextLayer := Set new.
	elements do: [ :el | nextLayer addAll: (self childrenFor: el) ].
	nextLayer ifEmpty: [ ^ self ].
	nextLayer := nextLayer asOrderedCollection.
	nodesByLayer add: nextLayer asOrderedCollection.
	self distributeChildrenInLayers: elements , nextLayer
]

{ #category : #'private - hook' }
PhxDvHorizontalTreeLayout >> doExecute: elements [

	| unConnectedNodes rootNodes leftOvers |
	alreadyLayoutedNodes := OrderedCollection new.
	rootNodes := self rootNodesFor: elements.
	self validateCachedParents.
	nodesByLayer := OrderedCollection new.

	unConnectedNodes := rootNodes select: [ :each | 
		                    each connectedLines isEmpty ].
	nodesByLayer add: unConnectedNodes.
	nodesByLayer add:
		(rootNodes reject: [ :e | unConnectedNodes includes: e ]).
	self distributeChildrenInLayers: rootNodes.
	self nodeCountContainedInLayers inspect.
	leftOvers := elements reject: [ :e | 
		             self isAlreadyInAPreviousLayer: e ].
	nodesByLayer add: leftOvers.

	self layoutLayers
	"	self
		layout: rootNodes
		atPoint: self leftGap @ self topGap
		atLayer: 1.
	self isLayered ifTrue: [
		self rearrangeByLayers: elements ]"
]

{ #category : #'private - hook' }
PhxDvHorizontalTreeLayout >> heightOfLayer: layer [

	^ layer inject: 0 into: [ :sum :each | sum + (each height * 2) ]
]

{ #category : #initialization }
PhxDvHorizontalTreeLayout >> initialize [
	super initialize.
	layers := OrderedCollection new
]

{ #category : #'private - hook' }
PhxDvHorizontalTreeLayout >> isAlreadyInAPreviousLayer: aNode [

	nodesByLayer do: [ :layer | layer do: [ :n | aNode = n ifTrue: [ ^true ] ] ].
	^false
]

{ #category : #'private - hook' }
PhxDvHorizontalTreeLayout >> layout: aNodeCollection atPoint: aPoint atLayer: aNumber [
	| treeSize childrenPosition x y middleOfTree |
	aNodeCollection isEmpty ifTrue: [ ^ 0 ].
	x := aPoint x.
	y := aPoint y.
	alreadyLayoutedNodes addAll: aNodeCollection.
	self atLayer: aNumber add: aNodeCollection.
	alreadyLayoutedNodes copy do: [ :each | 
		childrenPosition := x + each width + self horizontalGap.
		treeSize := each height
			max: (self layout: (self computeChildrenFor: each) atPoint: childrenPosition @ y atLayer: aNumber + 1).
		middleOfTree := y + (treeSize / 2.0) - (each height / 2.0).
		translator translateTopLeftOf: each to: (x @ middleOfTree).
		y := y + treeSize + self verticalGap.
		self step ].
	^ y - aPoint y - self verticalGap
]

{ #category : #'private - hook' }
PhxDvHorizontalTreeLayout >> layoutLayers [

	| maxLayerHeight |
	maxLayerHeight := self maxLayerHeight.
	nodesByLayer keysAndValuesDo: [ :layerIdx :layer | 
		| layerX layerSlotHeight |
		layerX := layerIdx - 1 * 200.
		layerSlotHeight := maxLayerHeight / layer size.
		layer keysAndValuesDo: [ :idxOfNodeInLayer :each | 
			translator
				translateTopLeftOf: each
				to: layerX @ (idxOfNodeInLayer * layerSlotHeight) ] ]
]

{ #category : #'private - hook' }
PhxDvHorizontalTreeLayout >> maxLayerHeight [

	^ nodesByLayer
		  inject: 0
		  into: [ :max :layer | max max: (self heightOfLayer: layer) ]
]

{ #category : #'private - hook' }
PhxDvHorizontalTreeLayout >> nodeCountContainedInLayers [

	| all |
	all := OrderedCollection new.
	nodesByLayer do: [ :layer | layer do: [ :n | all add: n ] ].
	^ all size
]

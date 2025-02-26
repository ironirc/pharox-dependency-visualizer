Class {
	#name : 'DvForceBasedLayout',
	#superclass : 'RSRectangleForceLayout',
	#category : 'Phx-Dependency-Visualizer-visualisation',
	#package : 'Phx-Dependency-Visualizer',
	#tag : 'visualisation'
}

{ #category : 'hook' }
DvForceBasedLayout >> step [
	nodes ifEmpty: [ ^ self ].
	self stepEdgeForces.
	self stepGravityForce.
	self stepNodeRepulsion.
	self stepFriction.
	nodes do: [ :node | node applyToRealElement ]
]

{ #category : 'hook' }
DvForceBasedLayout >> stepEdgeForces [
	"Apply forces of edges."
	lines do: [ :each |
		| from to fp tp len k pd |
		from := each from.
		to := each to.
		fp := from position.
		tp := to position.
		pd := tp - fp.
		len := tp distanceTo: fp.
		(len closeTo: 0) ifFalse: [
			len := alpha * (each strength) * (len - (each length)) / len.
			pd := pd * len.
			k := from weight / (from weight + to weight).
			to translateTo: tp - (pd * k).
			k := 1 - k.
			from translateTo: fp + (pd * k).]
	]
]

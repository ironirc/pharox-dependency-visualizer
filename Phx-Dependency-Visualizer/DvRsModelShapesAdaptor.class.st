Class {
	#name : #DvRsModelShapesAdaptor,
	#superclass : #Object,
	#instVars : [
		'model',
		'parent',
		'shapes'
	],
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #'instance creation' }
DvRsModelShapesAdaptor class >> newWithModel: aModel under: aParent [
	"Ivo: setting order of model and parent matters I think"

	^ self new
		model: aModel;
		parent: aParent;
		yourself
]

{ #category : #private }
DvRsModelShapesAdaptor >> addToManyRelationOnParent [
	self subclassResponsibility
]

{ #category : #'accessing derived' }
DvRsModelShapesAdaptor >> canvas [
	^ self top rsCanvas
]

{ #category : #'initialize-release' }
DvRsModelShapesAdaptor >> initialize [ 
	shapes := Dictionary new
]

{ #category : #'accessing derived' }
DvRsModelShapesAdaptor >> mainShape [
	^ self shapeAt: #mainShape
]

{ #category : #'accessing derived' }
DvRsModelShapesAdaptor >> mainShape: anObject [
	^ self shapeAt: #mainShape put: anObject
]

{ #category : #accessing }
DvRsModelShapesAdaptor >> model [
	^ model
]

{ #category : #accessing }
DvRsModelShapesAdaptor >> model: anObject [
	model ifNotNil: [ self teardownListenersToModel model ].
	model := anObject.
	model ifNotNil: [ self setupListenersToModel model ]
]

{ #category : #accessing }
DvRsModelShapesAdaptor >> parent [
	^ parent
]

{ #category : #accessing }
DvRsModelShapesAdaptor >> parent: aParent [
	parent ifNotNil: [  self removeFromManyRelationOnParent].
	parent := aParent.
	parent ifNotNil: [  self addToManyRelationOnParent].
]

{ #category : #private }
DvRsModelShapesAdaptor >> removeFromManyRelationOnParent [
	self subclassResponsibility
]

{ #category : #'setUp-tearDown' }
DvRsModelShapesAdaptor >> setupListenersToModel [
	self subclassResponsibility.
]

{ #category : #'accessing derived' }
DvRsModelShapesAdaptor >> shapeAt: aSymbol [
	^ self shapes at: aSymbol ifAbsent: [ nil ]
]

{ #category : #'accessing derived' }
DvRsModelShapesAdaptor >> shapeAt: aSymbol put: anObject [
	^ self shapes at: aSymbol put: anObject
]

{ #category : #accessing }
DvRsModelShapesAdaptor >> shapes [
	^ shapes
]

{ #category : #accessing }
DvRsModelShapesAdaptor >> shapes: anObject [
	shapes := anObject
]

{ #category : #'setUp-tearDown' }
DvRsModelShapesAdaptor >> teardownListenersToModel [
	model announcer unsubscribe: self
]

{ #category : #'accessing derived' }
DvRsModelShapesAdaptor >> top [
	^ self parent ifNotNil: [ :p | p top ] ifNil: [ self ]
]

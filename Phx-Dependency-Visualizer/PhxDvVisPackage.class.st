Class {
	#name : #PhxDvVisPackage,
	#superclass : #PhxDvRoObject,
	#category : #'Phx-Dependency-Visualizer-viz gen2'
}

{ #category : #private }
PhxDvVisPackage >> addToManyRelationOnParent [
	self parent packages add: self
]

{ #category : #building }
PhxDvVisPackage >> build [

	| compos label box |
	self mainShape ifNotNil: [ 
		^ self error: 'attempt to build mainShape twice' ].
	label := RSLabel new
		         text: model name;
		         color: Color black;
		         yourself.
	box := RSBox new
		       extent: label extent + 10;
		       cornerRadius: 3;
		       yourself.
	compos := { 
		          box.
		          label } asShapeFor: model.
	"compos @ (RSPopup text: [ :neuron | neuron printStatisticDefinitions ])."
	compos draggable.
	compos when: RSMouseRightClick send: #showMenu: to: self.
	compos when: RSMouseLeftClick send: #leftClick: to: self.
	self mainShape: compos.
	self canvas add: compos
]

{ #category : #'announcement handling' }
PhxDvVisPackage >> handleAnnouncementAspectChanged: a [
	| ns |
	ns := self mainShape.
	ns ifNil: [ ^ self ].
	a aspect == #shortCode
		ifTrue: [ | labelShape |
			labelShape := ns shapeFromModel: a aspect.
			labelShape text: a model shortCode ]
]

{ #category : #'initialize-release' }
PhxDvVisPackage >> initialize [
	super initialize.

]

{ #category : #printing }
PhxDvVisPackage >> printOn: ws [

	super printOn: ws.
	ws << ' ('.
	ws << self model name. 
	ws << ')'
]

{ #category : #private }
PhxDvVisPackage >> removeFromManyRelationOnParent [
	self parent packages remove: self
]

{ #category : #'setUp-tearDown' }
PhxDvVisPackage >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : #'setUp-tearDown' }
PhxDvVisPackage >> tearDown [
	self mainShape ifNotNil: [ :ms | self canvas removeShape: ms ].
	self parent: nil.
	self model: nil
]

Class {
	#name : #DvRsPackageGroup,
	#superclass : #DvRsObject,
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #private }
DvRsPackageGroup >> addToManyRelationOnParent [

	self parent rsPackageGroups add: self
]

{ #category : #building }
DvRsPackageGroup >> adjustBox: box on: someShapes [

	| rect |
	rect := someShapes encompassingRectangle.
	box
		extent: rect extent + (10 @ 20);
		position: rect floatCenter
]

{ #category : #building }
DvRsPackageGroup >> build [

	| pckgs compos label border box |
	self mainShape ifNotNil: [ 
		^ self error: 'attempt to build mainShape twice' ].
	pckgs := RSGroup withAll: self containedPackageShapes.
	RSGridLayout on: pckgs.
	label := RSLabel new
		         text: model name;
		         color: Color black;
		         yourself.
	border := RSBorder new
		          color: (Color gray alpha: 0.5);
		          yourself.
	box := RSBox new noPaint
		       extent: label extent + 10;
		       border: border;
		       cornerRadius: 3;
		       yourself.
	self adjustBox: box on: pckgs.
	compos := ({ 
		          box.
		          label } , pckgs)  asShapeFor: model.
	"compos @ (RSPopup text: [ :neuron | neuron printStatisticDefinitions ])."
	
	compos @ (RSDraggable new noValidateChildrenEvents).
	compos when: RSMouseRightClick send: #showMenu: to: self.
	compos when: RSMouseLeftClick send: #leftClick: to: self.
	self mainShape: compos.
	self canvas add: compos
]

{ #category : #building }
DvRsPackageGroup >> containedPackageShapes [

	^ self containedPackages collect: #mainShape
]

{ #category : #building }
DvRsPackageGroup >> containedPackages [

	^ self model packages collect: [ :eachModelPckg | 
		  self parent rsPackages detect: [ :eachVisPckg | 
			  eachVisPckg model = eachModelPckg ] ]
]

{ #category : #'announcement handling' }
DvRsPackageGroup >> handleAnnouncementAspectChanged: a [
	
]

{ #category : #'initialize-release' }
DvRsPackageGroup >> initialize [
	super initialize.

]

{ #category : #printing }
DvRsPackageGroup >> printOn: ws [

	super printOn: ws.
	ws << ' ('.
	ws << self model name. 
	ws << ')'
]

{ #category : #private }
DvRsPackageGroup >> removeFromManyRelationOnParent [
	self parent rsPackageGroups remove: self
]

{ #category : #'setUp-tearDown' }
DvRsPackageGroup >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : #'setUp-tearDown' }
DvRsPackageGroup >> tearDown [
	self mainShape ifNotNil: [ :ms | self canvas removeShape: ms ].
	self parent: nil.
	self model: nil
]

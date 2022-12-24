Class {
	#name : #PhxDvVisPackageGroup,
	#superclass : #PhxDvRoObject,
	#category : #'Phx-Dependency-Visualizer-viz gen2'
}

{ #category : #private }
PhxDvVisPackageGroup >> addToManyRelationOnParent [
	self parent packageGroups add: self
]

{ #category : #building }
PhxDvVisPackageGroup >> adjustBox: box on: someShapes [

	| rect |
	rect := someShapes encompassingRectangle.
	box
		extent: rect extent + (10 @ 20);
		position: rect floatCenter
]

{ #category : #building }
PhxDvVisPackageGroup >> build [

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
	compos draggable.
	compos when: RSMouseRightClick send: #showMenu: to: self.
	compos when: RSMouseLeftClick send: #leftClick: to: self.
	self mainShape: compos.
	self canvas add: compos
]

{ #category : #building }
PhxDvVisPackageGroup >> containedPackageShapes [

	^ self containedPackages collect: #mainShape
]

{ #category : #building }
PhxDvVisPackageGroup >> containedPackages [

	^ self model packages collect: [ :eachModelPckg | 
		  self parent packages detect: [ :eachVisPckg | 
			  eachVisPckg model = eachModelPckg ] ]
]

{ #category : #'announcement handling' }
PhxDvVisPackageGroup >> handleAnnouncementAspectChanged: a [
	
]

{ #category : #'initialize-release' }
PhxDvVisPackageGroup >> initialize [
	super initialize.

]

{ #category : #printing }
PhxDvVisPackageGroup >> printOn: ws [

	super printOn: ws.
	ws << ' ('.
	ws << self model name. 
	ws << ')'
]

{ #category : #private }
PhxDvVisPackageGroup >> removeFromManyRelationOnParent [
	self parent packageGroups remove: self
]

{ #category : #'setUp-tearDown' }
PhxDvVisPackageGroup >> setupListenersToModel [
	super setupListenersToModel.

]

{ #category : #'setUp-tearDown' }
PhxDvVisPackageGroup >> tearDown [
	self mainShape ifNotNil: [ :ms | self canvas removeShape: ms ].
	self parent: nil.
	self model: nil
]
Class {
	#name : #DvRsPackageGroup2,
	#superclass : #PhxRsComposite,
	#category : #'Phx-Dependency-Visualizer-visualisation gen2'
}

{ #category : #build }
DvRsPackageGroup2 >> addPackage: aPackage [

	| rsPackage |
	rsPackage := DvRsPackage2 new.
	rsPackage model: aPackage.
	rsPackage build.
	self add: rsPackage
]

{ #category : #build }
DvRsPackageGroup2 >> adjustBox: box on: someShapes [

	| rect |
	rect := someShapes encompassingRectangle.
	box
		extent: rect extent + (10 @ 20);
		position: rect floatCenter
]

{ #category : #building }
DvRsPackageGroup2 >> build [

	| label box |
	self buildPackages.
	RSGridLayout on: self nodes.
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
	self add: label.
	self adjustBox: box on: self nodes.
	self add: box.
	self adjustToChildren.
	"self draggable. "
	self @ RSDraggable new noValidateChildrenEvents
	"compos when: RSMouseRightClick send: #showMenu: to: self.
	compos when: RSMouseLeftClick send: #leftClick: to: self."
]

{ #category : #build }
DvRsPackageGroup2 >> buildPackages [

	self model unGroupedPackages do: [ :p | self addPackage: p ]
]

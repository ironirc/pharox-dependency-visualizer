Trait {
	#name : 'DvInAndOutHighlitable',
	#category : 'Phx-Dependency-Visualizer-visualisation',
	#package : 'Phx-Dependency-Visualizer',
	#tag : 'visualisation'
}

{ #category : 'highliting' }
DvInAndOutHighlitable >> antAnimations [
	^self canvas propertyAt: #antAnimations ifAbsentPut: [ OrderedCollection new ]
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> conflictingHighliteColor [

	^ Color orange darker darker
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> highlight: evt [

	| box incomingLines outgoingLines incomingBoxes outgoingBoxes conflictingBoxes |
	box := evt shape.
	incomingLines := box incomingLines.
	outgoingLines := box outgoingLines.
	self
		highlightLines: incomingLines
		withColor: self incomingHighliteColor.
	self
		highlightLines: outgoingLines
		withColor: self outgoingHighliteColor.
	incomingBoxes := (incomingLines collect: #from) asOrderedCollection.
	outgoingBoxes := (outgoingLines collect: #to) asOrderedCollection.
	conflictingBoxes := incomingBoxes intersection: outgoingBoxes.
	incomingBoxes := incomingBoxes difference: conflictingBoxes.
	outgoingBoxes := outgoingBoxes difference: conflictingBoxes.
	self
		highlightBoxes: incomingBoxes
		withColor: self incomingHighliteColor.
	self
		highlightBoxes: outgoingBoxes
		withColor: self outgoingHighliteColor.
	self
		highlightBoxes: conflictingBoxes
		withColor: self conflictingHighliteColor.
	self canvas
		propertyAt: #highlightedBoxes
		put: incomingBoxes , outgoingBoxes , conflictingBoxes.
	self canvas
		propertyAt: #highlightedLines
		put: incomingLines , outgoingLines
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> highlightAnt: antBorder [

	| animation canv |
	canv := self canvas.
	antBorder dashArray: #( 7 3 ).
	animation := canv newAnimation
		             repeat;
		             from: 0;
		             to: antBorder dashArray sum negated;
		             duration: 1 second;
		             onStepDo: [ :t | 
			             antBorder dashOffset: t.
			             canv signalUpdate ].

	self antAnimations add: animation
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> highlightBoxes: boxes withColor: aColor [

	| canv |
	canv := self canvas.
	boxes do: [ :box |
		| shadow |
		shadow := self shadowFor: box.
		shadow color: aColor.
		box
			when: RSPositionChangedEvent
			do: [ :evt | shadow position: evt newPosition ].
		box propertyAt: #shadow put: shadow.
		canv addShape: shadow.
		shadow pushBack ]
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> highlightLines: lines withColor: aColor [

	| antBorder |
	lines ifEmpty: [ ^ self ].
	antBorder := RSBorder new
		             width: 2;
		             yourself.
	lines do: [ :line | 
		| border |
		border := line border.
		line propertyAt: #oldBorder put: border.
		line border: antBorder.
		line color: aColor ].
	"self highlightAnt: antBorder"
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> highlightable [
	^ RSHighlightable new
		when: RSHighlightEvent send: #highlight: to: self;
		when: RSUnHighlightEvent send: #unhighlight: to: self;
		yourself
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> incomingHighliteColor [

	^ Color green darker darker
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> outgoingHighliteColor [

	^ Color red darker darker
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> shadowFor: box [
	^ RSBox new
		position: box positionInCanvas;
		extent: box extent + 7;
		cornerRadius: 3;
		yourself
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> stopAndRemoveAllAnimations [

	self antAnimations do: [ :anim | anim stop ].
	self antAnimations removeAll
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> unhighlight: evt [

	self stopAndRemoveAllAnimations.
	evt canvas
		propertyAt: #highlightedLines
		ifPresent: [ :lines | self unhighlightLines: lines ];
		propertyAt: #highlightedBoxes
		ifPresent: [ :boxes | self unhighlightBoxes: boxes ]
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> unhighlightBoxes: boxes [
	boxes do: [ :box | 
		box propertyAt: #shadow ifPresent: [ :shadow | shadow remove ] ]
	
]

{ #category : 'highliting' }
DvInAndOutHighlitable >> unhighlightLines: lines [

	lines do: [ :line | 

		line border: (line propertyAt: #oldBorder).
		line color: line border color.
		line removeKey: #oldBorder ]
]

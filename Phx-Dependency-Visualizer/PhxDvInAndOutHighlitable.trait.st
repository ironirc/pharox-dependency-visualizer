Trait {
	#name : #PhxDvInAndOutHighlitable,
	#category : #'Phx-Dependency-Visualizer-viz gen1'
}

{ #category : #highliting }
PhxDvInAndOutHighlitable >> antAnimations [
	^self canvas propertyAt: #antAnimations ifAbsentPut: [ OrderedCollection new ]
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> highlight: evt [

	| box incomingLines outgoingLines incomingBoxes outgoingBoxes |
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
	self
		highlightBoxes: incomingBoxes
		withColor: self incomingHighliteColor.
	outgoingBoxes := (outgoingLines collect: #to) asOrderedCollection.
	self
		highlightBoxes: outgoingBoxes
		withColor: self outgoingHighliteColor.
	self canvas propertyAt: #highlightedBoxes put: incomingBoxes , outgoingBoxes.
	self canvas
		propertyAt: #highlightedLines
		put: incomingLines , outgoingLines
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> highlightAnt: antBorder [

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

{ #category : #highliting }
PhxDvInAndOutHighlitable >> highlightBoxes: boxes withColor: aColor [

	| canv  |
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
		shadow pushBack ].
	
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> highlightLines: lines withColor: aColor [

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
	self highlightAnt: antBorder
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> highlightable [
	^ RSHighlightable new
		when: RSHighlightEvent send: #highlight: to: self;
		when: RSUnHighlightEvent send: #unhighlight: to: self;
		yourself
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> incomingHighliteColor [

	^ Color green darker darker
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> outgoingHighliteColor [

	^ Color red darker darker
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> shadowFor: box [
	^ RSBox new
		position: box position;
		extent: box extent + 3;
		cornerRadius: 3;
		yourself
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> stopAndRemoveAllAnimations [

	self antAnimations do: [ :anim | anim stop ].
	self antAnimations removeAll
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> unhighlight: evt [

	self stopAndRemoveAllAnimations.
	evt canvas
		propertyAt: #highlightedLines
		ifPresent: [ :lines | self unhighlightLines: lines ];
		propertyAt: #highlightedBoxes
		ifPresent: [ :boxes | self unhighlightBoxes: boxes ]
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> unhighlightBoxes: boxes [
	boxes do: [ :box | 
		box propertyAt: #shadow ifPresent: [ :shadow | shadow remove ] ]
	
]

{ #category : #highliting }
PhxDvInAndOutHighlitable >> unhighlightLines: lines [

	lines do: [ :line | 

		line border: (line propertyAt: #oldBorder).
		line color: line border color.
		line removeKey: #oldBorder ]
]

Extension { #name : #DAPackageRelationGraph }

{ #category : #'*Phx-Dependency-Visualizer' }
DAPackageRelationGraph >> combineDependencies [
	"Combine all dependencies with the same source and target into one composite
	dependency."
	self packages 
		do: [ :each | self combineDependencies: each ]
		"displayingProgress: 'Combining Dependencies'"
]

{ #category : #'*Phx-Dependency-Visualizer' }
DAPackageRelationGraph >> removeInternalDependencies [
	"Remove all dependencies from a package to itself"
	
	self includedPackages
		do: [ :each | each removeAllInternal ]
		"displayingProgress: 'Removing internal Dependencies'"
]

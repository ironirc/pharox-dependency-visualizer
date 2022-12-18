Class {
	#name : #BaselineOfPharoXDependencyVisualizer,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoXDependencyVisualizer
}

{ #category : #baselines }
BaselineOfPharoXDependencyVisualizer >> baseline: spec [
	<baseline>

	self compatibility: spec.
		
	spec for: #'common' do: [
		spec postLoadDoIt: #'postload:package:'.
		self 
			prerequisites: spec;		
			packages: spec;
			groups: spec	
	]
]

{ #category : #'private - accessing' }
BaselineOfPharoXDependencyVisualizer >> compatibility: spec [
	"Define a 'Compatibility' group that can be used as a dependency later to overcome differences in Pharo releases"
	
	
"	spec for: #('pharo9.x') do: [ spec package: 'PharoJs-Compatibility-Pharo9';
				     							   group: 'Compatibility' with: #('PharoJs-Compatibility-Pharo9') ].
					
	spec for: #('pharo8.x') do: [ spec package: 'PharoJs-Compatibility-Pharo8';
				     							   group: 'Compatibility' with: #('PharoJs-Compatibility-Pharo8') ].

	spec for: #('pharo7.x') do: [ spec package: 'PharoJs-Compatibility-Pharo7';
				     							   group: 'Compatibility' with: #('PharoJs-Compatibility-Pharo7') ].
"
]

{ #category : #'private - accessing' }
BaselineOfPharoXDependencyVisualizer >> groups: spec [

]

{ #category : #'private - accessing' }
BaselineOfPharoXDependencyVisualizer >> packages: spec [


	spec package: 'Phx-Dependency-Visualizer'.
]

{ #category : #baselines }
BaselineOfPharoXDependencyVisualizer >> postload: aLoader package: aPackageSpec [
	
]

{ #category : #'private - accessing' }
BaselineOfPharoXDependencyVisualizer >> prerequisites: spec [
]

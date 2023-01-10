"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestPhxDependencyVisualizer,
	#superclass : #PackageManifest,
	#category : #'Phx-Dependency-Visualizer-Manifest'
}

{ #category : #'meta-data - dependency analyser' }
ManifestPhxDependencyVisualizer class >> manuallyResolvedDependencies [
	^ #(#'Phx-Pharo-Extensions')
]

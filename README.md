# pharox-dependency-visualizer
This tool is built on top of great existing software like Roassal and Pharo's internal dependency tools.  
This tool helps understand/untangle dependencies.

# Install
```Smalltalk
Metacello new
  baseline: 'PharoXDependencyVisualizer';
  repository: 'github://ironirc/pharox-dependency-visualizer:main/';
  load.
```
Should work in Pharo 11 and 12  

# Install
To start exploring you could try:
```Smalltalk
DvRsWorkScope exampleWithZincAndZodiac
```

This gives you something like:
![image](https://github.com/user-attachments/assets/0f7861e1-96b2-41de-8aa4-3130ca8e6b65)
Observe there's a cycle between Zinc-HTTP and Zinc-Resource-Meta-Core.

Interact to get more insight:
- hover and drag nodes.
- right click to open the already well known dependency browser
- right click to browser the package in system browser
- click node to temp highlite it in yellow ( just a temp marker without further functionality)

# TO-DO
- Better default layout (force based?)
- Immediate indication of cycles (now already easy to detect on sight)
- Hovering line to display actual dependencies
- Update without re-opening the window
- 
- ...

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

# Simple example on Zinc en Zodiac packages
To start exploring you could try:
```Smalltalk
DvRsWorkScope exampleWithZincAndZodiac
```
This gives you something like:
![image](https://github.com/user-attachments/assets/0f7861e1-96b2-41de-8aa4-3130ca8e6b65)
Observe there's a cycle between Zinc-HTTP and Zinc-Resource-Meta-Core.  
Should Zinc-Resource-Meta-Core depend on Zinc-HTTP?  

Interact to get more insight:
- Hover a node: green lines show de packages depended upon, red lines show packages depending on hovered node
- If other nodes turn orange (while hovering), there's a cycle somewhere
- Right click to open the already well known dependency browser
- Right click to browser the package in system browser
- Click node to temp highlite it in yellow ( just a temp marker without further functionality)

# Example on Zinc en Zodiac packages with grouping
```Smalltalk
DvRsWorkScope exampleWithZincAndZodiacGrouped
```
![image](https://github.com/user-attachments/assets/1a2f1441-e2da-454f-a5c8-cfa122a6905e)


# TO-DO
- Better default layout (force based?)
- Immediate indication of cycles (now already easy to detect on sight)
- Hovering line to display actual dependencies
- Grouping/Ungrouping manipulation directly in graph
- Update without re-opening the window
- ...

All OpenScad libraries are designed to be very easy to use in your projects:

- any library is composed of modules to make containers and boards or ADDON to add things to a main board.
- all modules are fully parameterized, but for the user convenience, many parameters have "reasonable" default values which can
  be ok almost everywhere.
- all parameter values are checked, with specific error messages
- the use of Doxigen gives us the help e3DHWref.1.2.chm, a complete e3DHW library reference, indispensable for the e3DHW users.
- any library as a xxxx_examples.scad file, to show the use. All examples are also with the STL files, to preview the results.

How to use "e3DHW_xxxxxx.scad" libraries? 
- In your OpenSCAD file add on top "include <e3DHW_xxxxxxxxx.x.x.scad>;" for all files you need for your project (see 
documentation and examples files).
- put all required libraries in the same directory as your project.
- create also the dir ./contrib, and copy there all the required files.
- Then you can use all public modules as you like.

How to use e3DHWref.1.2.chm?
- Download it and use a help viewer (MS help viewer, Sumatra PDF, etc) 
- If you see the index, but not the content, it has been because windows security has "blocked" the chm file. To see it try the following:
  - From windows explorer, Right click the dowloated .chm file and select properties.
  - On the General tab, if you see an Unblock button, click it.
  - Close the dialog and open the .chm file.

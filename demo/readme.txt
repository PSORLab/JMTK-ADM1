Hello and thank you for downloading the JMTK ADM1 demo!

To set up this demo you simply need to install the current version of Julia
and retrieve the directory of the demo file.

To install Julia visit the following link and download the appropriate stable release:
https://julialang.org/downloads/

To retrieve the directory of the demo file on windows simply right click the folder
and click properties. The file name will be given next to "Location:". 

To run the demo notebook open up the install version of Julia and run the following command:
julia> cd("FILENAME"); using Pkg; Pkg.add("IJulia"); using IJulia; notebook(dir=pwd())

where FILENAME is the directory for your installed demo file.
If you are windows you will need to replace each \ with \\ for this to work properly.

Once the jupyter notebook gui is open simply navigate to the JMTK_ADM1_Demo.ipynb file and run the notebook.
All package set up is taken care of within that file.

For any assistance feel free to email Samuel Morgenstern at:
samuel.morgenstern@uconn.edu
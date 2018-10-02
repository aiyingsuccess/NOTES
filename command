1 cd /data/aiying/Nova/build
make -j 8
./bin/point_process
cd ../Projects/Adaptive_Poisson_Systems/point_process/gnuplot
mv ../../../../build/Ca.txt .
./make_plots.pl
display Ca_values.png


2 cd /data/aiying/Nova/build
make -j 8
./bin/astrocytes_2d -geometry /data/aiying/Astrocytes/star_geometry1.txt
  ls Resolution_864/0/
 ./bin/opengl Resolution_864/




#Plugin=libplugin_Embedded_Deformables
Plugin=libplugin_Adaptive_Poisson_Systems

Minor-Mercury Package
===============================
A version to handle Asteroids and Comets.
---------------------------------

``Minor-Mercury package`` is an N-body code which allows the user to performer N-body numerical integrations in the irregular gravity field around a minor body, such an Asteroid and a Comet. It is based on the [original Mercury code](http://www.arm.ac.uk/~jec/home.html) from Chambers (1999) and works in the same way. Note that minor bodies simulations only work with the ``Bulirsch-Stoer`` algorithm integrator of original Mercury (``mdt_bs1.for`` subroutine). If you don't know how original Mercury works, I invite you to download the original one and read ``mercury6.man``.

The Minor-Mercury version can also work for either ``single stars`` (central), ``binary stars`` (close/wide) and ``triple stars`` (S(AB)-P) (see, e.g., Barbosa et al. (2020) and Amarante et al. (2020)). The ``Solar Radiation Pressure`` (Mignard, 1984) can also take into account over numerical integration time (subroutine ``mfo_pr.for``). This version uses a slightly different input/output formats from the original package. For example, the user can place the initial conditions of the bodies around any body of the system and not only around central one, for the inertial or the rotating reference frames, choosing asteroidal or cartesian styles for each body separately. The input/output ``Geometric Elements`` computational conversions (Renner and Sicardy, 2006) were also implemented in this version (subroutines ``geo_car.for`` and ``car_geo.for``). A full explanation of all inputs and outputs is given in ``mercury6.man``.

N.B. I've implemented a modified version of the original POLYHEDRON code from D. Tsoulis into the Minor-Mercury package, that can compute the gravitational potential, and its first and second derivatives of a homogenous polyhedron, according to Petrovic (J of G, 1996). The main gravitational implementations are made in the subroutines ``mfo_all.for`` and ``mfo_grav.for`` through subroutine ``polyhedron.for``. Additionally, mascons approach was also implemented into this subroutine.

Notable contents of this repository
---------------------------

*    ``minor-mercury.for:`` The main program file.  It requires ``mercury.inc`` and ``swift.inc`` to compile.
*    ``command.for:`` Additional source file to get overall CPU % usage.
*    ``dhms.for:`` Additional source file to find the approximately remaining time of the integration.
*    ``get_pid.for:`` Additional source file to get PID process of the main program.
*    ``timestamp.for:`` Additional source file to print out the current YMDHMS date as a timestamp.
*    ``mfo_user.for:`` Applies an arbitrary force, defined by the user.
*    ``geo_car.for:`` Converts geometric elements to xv coords.
*    ``moyen_mouvement.for:`` Additional source file for geometric element conversion.
*    ``./output/element-minor.for:`` This programme converts an output file created by main program file into a set of files containing Keplerian orbital elements for each of the objects in the integration. These files allow you to see how object's orbits change with time, and can be used as the basis for making graphs or movies using a graphics package, as ``GNUPlot``.
*    ``./output/close-minor.for:`` This programme converts an output file produced by main program file into a set of files containing details of close encounters between objects during the integration. This version also appends in ce.out file the collisions between the bodies, ejections of the system, collisions with central body, prune collisions, prune ejections, and the Poincare Surface Section. You can manage these options through ``close.in`` file.
*    ``./output/car_geo.for:`` Converts xv coords to geometric elements.
*    ``./output/moyen_mouvement.for:`` Additional source file for geometric element conversion.
*    ``./output/freq_n0.for:`` Additional source file for geometric element conversion.

 Input Files
 ---------------

*    ``files.in:`` This should contain a list of names for the input and output files used by main program file. List each file name on a separate line.
*    ``param.in:`` This file contains parameters that control how an integration is carried out. Any lines beginning with the ``)`` character are assumed to be comments, and will be ignored by main program file. All initial parameters of this file are set for the application of the asteroid Bennu.
*    ``./in/vertex.in:`` This file contains the coordinates x, y and z of the vertices of the polyhedron.
*    ``./in/face.in:`` This file contains the index of the vertices belonging at each given facet, in such an order that the plane normal is always pointing outside the body.
*    ``./in/cube.in:`` (optional) This file is used from gravitational potential of a cubic grid computed previously through the mascons technique (see, ``param.in``).
*    ``./in/message.in:`` This file contains the text of various messages output by main program file, together with an index number and the number of characters in the string (including spaces used for alignment).
*    ``./in/big.in:`` A file containing initial data for the Big bodies in the integration (e.g. minor bodies satellites).
*    ``./in/small.in:`` A file containing initial data for the Small bodies in the integration (e.g. massless particles around surface of the minor bodies that you want to include).
*    ``./output/element.in:`` This file contains parameters and options used by ``element-minor.for``. Any lines beginning with the ``)`` character are assumed to be comments, and will be ignored by the source.
*    ``./output/close.in:`` This file contains parameters and options used by ``close-minor.for``. Any lines beginning with the ``)`` character are assumed to be comments, and will be ignored by the source. Don't delete the first comment line though.

 Dump files
 ---------------

If your computer crashes while Minor-Mercury is doing an integration, all is not lost. You can continue the integration from the point at whichy main source last saved data in dump files, rather than having to redo the whole calculation. The user can manage the periodic time that the dump files it will be created through dump interval option from ``param.in`` file.

*    ``big.dmp:`` A dump file containing data for the Big bodies. You can use this to continue the integration if your computer crashes or the programme is interupted.
*    ``small.dmp:`` A dump file containing data for the Small bodies.
*    ``param.dmp:`` A dump file containing the integration parameters.
*    ``restart.dmp:`` An additional dump file containing other variables used by main program file.
*    ``chk.dmp:`` An additional dump file containing informations about Chariklo problem (ignore it).

N.B. If for some reason one of the dump files has become corrupted, look to see if you still have a set of files with the extension ``.tmp`` produced during the original integration (if you have subsequently used main program file to do another integration in the same directory, you will have lost these unfortunately). These ``.tmp`` files are duplicate copies of the dump files. Copy each one so that they form a set of uncorrupted dump files, and then run the compiled version of main program file. It is important that you replace all the dump files with the ``.tmp`` files in this way, rather than just the file that is corrupted.

 Output files
 ---------------

*    ``./out/xv.out:`` Position and velocity information for the objects in the integration, produced at periodic intervals.
*    ``./out/ce.out:`` Details of close encounters, collisions and ejections that occur during the integration.
*    ``info.out:`` A summary of the integration parameters used in by the integrator, and a list of any events that took place (e.g. collisions between objects, remaining bodies and ejections).
*    ``infocpu.out:`` A summary of the computational integration process (e.g. remaining integration time, overall CPU % usage, etc).

How to compile and run
----------------------

In the current directory, you should have all files needed to compile and execute the program. Don't hesitate to contact me if any problem arises when trying to use it.
Current package is preconfigured for Linux and Mac OS X users with compile and clean tasks. Use your favorite FORTRAN compiler, such as ``gfortran``, ``f77`` or ``ifort``, to create an executable.  For instance, on Linux or Mac, try:

   ``gfortran minor-mercury.for command.for dhms.for get_pid.for timestamp.for geo_car.for moyen_mouvement.for mfo_user.for -o minor-mercury``

There will likely be warnings due to the code being written in FORTRAN77, but it should compile.  Copy or link the executable wherever you want (wherever your input files are) to run your code using ``./minor-mercury``.

Or use ifort compiler instead:

   ``ifort minor-mercury.for command.for dhms.for get_pid.for timestamp.for geo_car.for moyen_mouvement.for mfo_user.for -o minor-mercury``

Or use the ``Makefile:``

   To compile on Linux or Mac OS X just run ``make`` on the terminal at current directory. You need to have gfortran compiler. If you don't have you need to install it. For other compilers change the corresponding lines in ``Makefile``. This file can be changed if you want to use another compiler as the default one (gfortran). Usually I use the compiler ifort, which leads to faster integration time.

   To clean the directory *.o files run ``make clean``.

Or use the executable files ``minor-mercury_gfort`` or ``minor-mercury_ifort`` for Linux and Mac OS X compilers ``gfortran`` or ``ifort``, respectively:

   First type ``chmod +x minor-mercury_gfort`` and after that to run your code using ``./minor-mercury_gfort``.

Tricks and Caveats
------------------

Unfortunately, the code needs to be recompiled any time parameters in the ``mercury.inc`` and ``swift.inc`` files get changed.

Disclaimers
------------

* The minor version changes have only been tested with the ``MAS`` and ``POL`` algorithms to integrate particle orbits around the irregular gravity field of an asteroid. Use other integrators at your own risk.
* I've fixed all the errors I've found.  If you find a bug, let me know so we can try to fix it.
* Any feedback is appreciated, especially bugs, suggestions, or possible contributions.
* Are you going to publish? Please acknowledge the use of my code in any publication referencing:

   ``Amarante, A., Winter, O. C., Sfair, R. (2020), Stability and Evolution of Fallen Particles Around the Surface of Asteroid (101955) Bennu. JGR Planets.``

* The source codes of this repository are available on reasonable request.


Minor-Mercury Package
===============================
A version to handle Asteroids and Comets.
-----------------------------------------

``Minor-Mercury package`` is an N-body code which allows the user to performer N-body numerical integrations in the irregular gravitational field around a minor body, such an Asteroid and a Comet. It is based on the [original Mercury code](https://github.com/a-amarante/mercury) from Chambers (1999) and works in the same way. Note that minor bodies simulations only work with the ``Bulirsch-Stoer`` algorithm integrator of original Mercury (``mdt_bs1.for`` subroutine). If you don't know how original Mercury works, I invite you to download the original one and read ``mercury6.man``.

The Minor-Mercury version can also work for either ``single stars`` (central -> Chambers, 1999), ``binary stars`` (close/wide -> Chambers et al., 2002) and ``triple stars`` (S(AB)-P ->  Verrier and Evans, 2013) (see, e.g., Barbosa et al. (2020) and Amarante et al. (2020)). The ``Solar Radiation Pressure`` (Burns et al., 1979; Mignard, 1984) can also take into account over numerical integration time (subroutine ``mfo_pr.for``).

This version uses a slightly different input/output formats from the original package:

Some Minor Version Features
---------------------------------

Input (``big.in`` and ``small.in`` files):

- for example, the user can place the initial conditions of the bodies around any body of the system and not only around central one.
- the user can choose between inertial or rotating reference frames.
- the user can set an asteroidal or a cartesian coordinate style for each body separately.
- additionally, the input/output ``Geometric Elements`` computational conversions (Renner and Sicardy, 2006; Borderies-Rappaport and Longaretti, 1994) were also implemented in this version (subroutines ``geo_car.for`` and ``car_geo.for``).

Output (``element.in`` and ``close.in`` files):

- the previously input features were also implemented for the output data style.
- the user can manage the initial and the final output times.
- there is a possibility to generate an extra body containing the system center of mass coordinates over the integration time.
- the user can sort output data by any tag of the output format.
- the output data can be written using ``state*.dat`` files style (organized through output interval files), instead traditional ``*.aei`` one (organized through body files).
- this version also appends in ``ce.out`` file the informations about collisions between the bodies, ejections of the system, collisions with central body, prune collisions, prune ejections, and the Poincare Surface Section. The user can manage these options through ``close.in`` file.
- for minor body integrations, the subroutine ``mce_cent.for`` appends the exact facet locations, where the collisions with the central polyhedric triangular mesh occurs.
- the output data is written in a single ASCII characters line (subroutines ``mio_out.for``, ``mio_re2c2.for``, ``mio_c2re2.for`` and ``mio_c2fl2.for``), which significantly decreases the size of the output files ``xv.out`` and ``ce.out``.
- in addition, an extra summary ``infocpu.out`` file of the computational integration process, that shows remaining integration time, overall CPU % usage, among others.

Parameters (``param.in`` file):

- added the option of the minimum ejection distance.
- choice of bodies that will not be ejected from the system.
- choice of bodies that will not be experiment a close encounter, which significantly decreases the size of the output file ``ce.out``.
- for example, stop integration by the number of remaining bodies, among others.
- dump interval.
- Solar Radiation Perturbation options.

A full explanation of all inputs and outputs is given in ``mercury6.man``.

N.B. I've implemented a modified version of the original POLYHEDRON code from D. Tsoulis into the Minor-Mercury package, that can compute the gravitational potential, and its first and second derivatives of a homogenous polyhedron, according to Petrovic (J of G, 1996). The main gravitational implementations were made in the subroutines ``mfo_all.for`` and ``mfo_grav.for`` through subroutine ``polyhedron.for``. Additionally, mascons approach was also implemented into this subroutine.

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

   First type ``chmod +x minor-mercury_gfort`` and after that run your code using ``./minor-mercury_gfort``.

Tricks and Caveats
------------------

Unfortunately, the code needs to be recompiled any time parameters in the ``mercury.inc`` and ``swift.inc`` files get changed.

Disclaimers
------------

* The minor body integrators of this version have only been tested for ``MAS`` and ``POL`` algorithms to integrate particle orbits around the irregular gravity field of an asteroid. Use other integrators of this type at your own risk. The previously integrators from Original Mercury code worked fine.
* I've fixed all the errors I've found, such as De Souza Torres & Anderson (2008) bug fix (see, e.g., [Mercury Adaptations and some bugs fixed](#mercury-adaptations-and-some-bugs-fixed)).  If you find a bug, let me know so we can try to fix it.
* Any feedback is appreciated, especially bugs, suggestions, or possible contributions.
* Are you going to publish? Please acknowledge the use of my code in any publication referencing:

   ``Amarante, A., Winter, O. C., Sfair, R. (2020), Stability and Evolution of Fallen Particles Around the Surface of Asteroid (101955) Bennu. JGR Planets.``

* The source codes of this repository are available on reasonable request.

Recent Publications
-------------------

The code was used in the following recent studies:

* Amarante, A., Winter, O. C., Sfair, R. (2020), Stability and Evolution of Fallen Particles Around the Surface of Asteroid (101955) Bennu. JGR Planets.
* G. O. Barbosa, O. C. Winter, A. Amarante, A. Izidoro, R. C. Domingos, E. E. N. Macau (2020), Earth-size planet formation in the habitable zone of circumbinary stars. MNRAS.
* T. S. Moura, O. C. Winter, A. Amarante, R. Sfair, G. Borderes-Motta, G. Valvano (2019), Dynamical environment and surface characteristics of asteroid (16) Psyche. MNRAS.

#Mercury Adaptations and some bugs fixed
----------------------------------------

These are adaptations that I made into original Mercury code through the years (in Brazilian Portuguese):

The changes were made through labels ##Am,n## and the corrections of the bugs through labels ##Em,n##.

Please send your comments to a.amarante.br@gmail.com or andre.amarante@unesp.br.

c 26/11/13
c ##E1,n## Corrige o erro para adicionar parâmetros de forças
c não-gravitacionais nos dados de entrada dos corpos nos arquivos big.in e
c small.in.
c
c------------------------------------------------------------------------------

c 28/11/13
c ##A1,n## Adiciona ao arquivo param.in a opção do limite de teste de colisão
c com o corpo central.
c
c------------------------------------------------------------------------------

c 04/12/13
c ##A2,n## Adiciona ao arquivo param.in a opção do número máximo de despejo no
c arquivo ce.out.
c
c------------------------------------------------------------------------------

c 05/12/13
c ##A3,n## Adiciona ao arquivo param.in a opção da distância mínima de ejeção.
c
c------------------------------------------------------------------------------

c 05/12/13
c ##A4,n## Adiciona ao arquivo param.in a opção dos índices dos corpos que NÃO
c serão ejetados do sistema.
c
c------------------------------------------------------------------------------

c 10/12/13
c ##A5,n## Adiciona ao arquivo param.in a opção dos índices dos corpos que
c serão salvos seus encontros próximos. Também escreve no arquivo ce.out os
c dados referentes a colisões (inclusive com o corpo central) e ejeções do
c sistema de forma com que o tamanho do arquivo ce.out seja minimizado (salva
c somente os dados dos corpos envolvidos em situações de encontros próximos,
c colisões e ejeções do sistema).
c OBS-1: as coordenadas dos dados do arquivo de saída ce.out neste caso serão
c sempre em relação ao corpo central.
c OBS-2: faz a modificação para os integradores de passo variável (subrotina
c mal_hvar).
c
c------------------------------------------------------------------------------

c 18/12/13
c ##A6,n## Adiciona ao arquivo param.in a opção dos índices dos corpos que
c serão salvos seus encontros próximos. Também escreve no arquivo ce.out os
c dados referentes a colisões (inclusive com o corpo central) e ejeções do
c sistema de forma com que o tamanho do arquivo ce.out seja minimizado (salva
c somente os dados dos corpos envolvidos em situações de encontros próximos,
c colisões e ejeções do sistema).
c OBS-1: as coordenadas dos dados do arquivo de saída ce.out neste caso serão
c sempre em relação ao corpo central.
c OBS-2: faz a modificação para os integradores de passo fixo (subrotina
c mal_hcon).
c
c------------------------------------------------------------------------------

c 23/12/13
c ##E2,n## Corrige o erro da escrita dos dados de saída no arquivo ce.out
c quando ocorrem encontros próximos seguidos de ejeções.
c
c------------------------------------------------------------------------------

c 28/12/13
c ##E3,n## Corrige o erro do cálculo do instante de colisão de um corpo com o
c corpo central quando a excentricidade do corpo é nula e quando o módulo do
c cosseno da anomalia excêntrica do corpo é maior do que 1.
c
c------------------------------------------------------------------------------

c 07/01/14
c ##E4,n## Corrige o erro da variável colflag NÃO ser inicializada em zero na
c subrotina mdt_mvs.
c
c------------------------------------------------------------------------------

c 10/01/14
c ##E5,n## Corrige o erro das massas dos corpos serem sempre colocadas como
c nulas na subrotina mco_x2ov quando eles sofrem encontros próximos ou colisões.
c
c------------------------------------------------------------------------------

c 15/01/14
c ##A7,n## Adiciona ao arquivo param.in a opção para usar a região caótica como
c região de ejeção do sistema.
c OBS: somente para sistemas coorbitais.
c
c------------------------------------------------------------------------------

c 22/02/14
c ##A8,n## Adiciona ao arquivo param.in as opções de interrupção da
c integração.
c
c------------------------------------------------------------------------------

c 25/02/14
c ##A9,n## Faz com que a subrotina mio_log NÃO escreva na tela.
c
c------------------------------------------------------------------------------

c 25/02/14
c ##E6,n## Corrige o erro do alerta e da interrupção da integração quando NÃO
c existem corpos grandes no arquivo big.in.
c
c------------------------------------------------------------------------------

c 27/02/14
c ##E7,n## Corrige o erro da escrita do número total inicial de corpos grandes
c e pequenos no arquivo info.out para um número de corpos com mais de 4
c algarismos.
c
c------------------------------------------------------------------------------

c 01/03/14
c ##A10,n## Adiciona informações relevantes ao arquivo info.out.
c
c------------------------------------------------------------------------------

c 04/03/14
c ##A11,n## Adiciona contadores para o número de corpos, colisões, ejeções e
c colisões com o corpo central nas informações de colisões e ejeções no arquivo
c info.out.
c
c------------------------------------------------------------------------------

c 10/03/14
c ##E8,n## Corrige o erro para poder gerar arquivos de saída com nomes
c diferentes (xv.out e ce.out) no arquivo files.in a cada reinício da
c integração.
c
c------------------------------------------------------------------------------

c 15/03/14
c ##A12,n## Escreve na tela algumas informações relevantes.
c
c------------------------------------------------------------------------------

c 23/03/14
c ##A13,n## Faz com que os dados sejam gravados em uma única linha nos arquivos
c de saída xv.out e ce.out.
c
c------------------------------------------------------------------------------

c 22/04/14
c ##E9,n## Corrige o erro para o mercury rodar a 100% de CPU no cluster.
c
c------------------------------------------------------------------------------

c 15/05/14
c ##A14,n## Corrige o erro do passo de integração da estrela binária quando o
c integrador close-binary (CLO) é usado com apenas 2 corpos (as duas estrelas).
c
c------------------------------------------------------------------------------

c 18/07/14
c ##AAR1,n## Implementa o integrador híbrido simplético para sistemas hierárquicos
c triplos de estrelas com órbita do tipo S(AB)-P. As implementações foram
c feitas por A. Amarante, A. Izidoro e R. C. Domingos.
c Ref: [1] Planetary Stability Zones in Hierarchical Triple Star Systems - P. E.
c Verrier and N. W. Evans, 2007.
c      [2] Symplectic Integrator Algorithms for Modeling Planetary Accretion in
c Binary Star Systems - John E. Chambers, Elisa V. Quintana, Martin J. Duncan,
c and Jack J. Lissauer, 2002.
c      [3] N-Body Integrators for Planets in Binary Star Systems - John E.
c Chambers, 2007.
c      [4] Symplectic integrators for solar system dynamics - Saha, P.;
c Tremaine, S., 1992.
c      [5] Long-term planetary integration with individual time steps - Saha,
c Prasenjit; Tremaine, Scott, 1994.
c
c------------------------------------------------------------------------------

c 18/07/14
c ##E10,n## Corrige o erro para escrever uma mensagem de alerta no arquivo
c info.out quando o raio do corpo central rcen é muito pequeno.
c
c------------------------------------------------------------------------------

c 22/07/14
c ##A15,n## Adiciona ao arquivo param.in novas opções para o tipo dos elementos.
c
c------------------------------------------------------------------------------

c 27/12/14
c ##A16,n## Converte as coordenadas e velocidades de todos os corpos para um
c corpo de referência. Adiciona aos arquivos big.in e small.in novas opções.
c
c------------------------------------------------------------------------------

c 13/01/15
c ##A17,n## Adiciona ao arquivo param.in a opção para usar uma distância real
c para os encontros próximos (NÃO em raios de Hill).
c
c------------------------------------------------------------------------------

c 22/01/15
c ##A18,n## Adiciona ao arquivo param.in uma nova opção de coordenada definida
c pelo usuário para sistemas hierárquicos triplos de estrelas com órbita do
c tipo S(AB)-P.
c
c------------------------------------------------------------------------------

c 04/03/15
c ##E11,n## Corrige o erro para as massas dos corpos ejetados não serem salvas
c como nulas.
c
c------------------------------------------------------------------------------

c 06/03/16
c ##A19,n## Implementa o integrador para um potencial central de um asteroide.
c
c------------------------------------------------------------------------------

c 28/04/16
c ##A20,n## Print out elapsed time, integration time remaining and size of
c Mercury outfiles.
c
c------------------------------------------------------------------------------

c 29/04/16
c ##A21,n## Coloca os arquivos vertex.in, face.in e message.in em um diretório
c diferente do principal.
c
c------------------------------------------------------------------------------

c 06/05/16
c ##A22,n## Adiciona ao arquivo param.in novas opções para colisões e ejeções
c usando encontros próximos.
c
c------------------------------------------------------------------------------

c 16/05/16
c ##E12,n## Erros encontrados por dcarrera e ajm.
c
c------------------------------------------------------------------------------

c 08/06/16
c ##E13,n## Corrige o erro para que seja guardada a distância real do corpo e
c não a distância de ejeção quando há ejeções no sistema.
c
c------------------------------------------------------------------------------

c 28/06/16
c ##E14,n## Corrige o erro para que seja adicionado o tempo extra de interrupção
c da integração corretamente no momento exato que acontece uma colisão ou ejeção.
c
c------------------------------------------------------------------------------

c 08/07/16
c ##A23,n## Faz com que sejam gravados no arquivo ce.out os dados de cabeçalho
c (subrotina mce_header) referentes a todos os corpos do sistema e NÃO apenas
c dos corpos envolvidos em situações de encontros próximos, colisões e ejeções.
c
c------------------------------------------------------------------------------

c 20/07/16
c ##A24,n## Adiciona ao arquivo param.in a opção de salvar encontros próximos,
c colisões e ejeções após um critério.
c
c------------------------------------------------------------------------------

c 06/09/16
c ##A25,n## Implementa os métodos Ray-casting e do Tetraedro para saber se um
c ponto está fora ou dentro de um poliedro.
c
c------------------------------------------------------------------------------

c 07/09/16
c ##A26,n## Implementa a opção das coordenadas de entrada no referencial girante.
c
c------------------------------------------------------------------------------

c 21/09/16
c ##EAN15,n## Corrige o erro para quando vscal(k)=0 ou xscal(k)=0 nas subrotinas
c mdt_bs1 e mdt_bs2. As implementações foram feitas por A. Amarante e
c N. C. S. Araújo.
c
c------------------------------------------------------------------------------

c 22/09/16
c ##ANEO27,n## Implementa o integrador hibrído para o Gauss-Radau. As implementações
c foram feitas por A. Amarante, N. C. S. Araújo, E. V. Neto e O. C. Winter.
c
c------------------------------------------------------------------------------

c 23/09/16
c ##EAN16,n## Corrige o erro para que o Mercury pule linhas em branco na
c leitura de arquivos de entrada. As implementações foram feitas por
c A. Amarante e N. C. S. Araújo.
c
c------------------------------------------------------------------------------

c 24/09/16
c ##AN28,n## Faz com que as constantes do arquivo mercury.inc sejam lidas a partir
c de um arquivo permitindo que o Mercury não tenha que ser compilado toda vez que
c uma dessas constantes seja alterada. As implementações foram feitas por
c A. Amarante e N. C. S. Araújo.
c
c------------------------------------------------------------------------------

c 11/10/16
c ##ANO29,n## Implementa o algoritmo da seção de Poincaré e expoente de Lyapunov.
c As implementações foram feitas por A. Amarante, N. C. S. Araújo e O. C. Winter.
c
c------------------------------------------------------------------------------

c 14/10/16
c ##E17,n## Corrige o erro na escrita para quando a energia en(1) ou o momento
c angular am(1) inicial do sistema for igual a zero.
c
c------------------------------------------------------------------------------

c 14/10/16
c ##A30,n## Imprime as informações do erro da energia e do momento angular do
c sistema no arquivo infocpu.out.
c
c------------------------------------------------------------------------------

c 18/10/16
c ##A31,n## Força o passo dos integradores de passo variável a ter também o
c o mesmo passo dos integradores de passo constante.
c
c------------------------------------------------------------------------------

c 20/10/16
c ##A32,n## Implementa as equações para o decaimento/aumento da massa e do
c período de rotação do asteroide no decorrer do tempo.
c
c------------------------------------------------------------------------------

c 22/10/16
c ##E18,n## Corrige o erro para que não seja computada colisões fictícias em um
c mesmo intervalo de tempo.
c
c------------------------------------------------------------------------------

c 04/11/16
c ##A33,n## Implementa o local da superfície do corpo central que o corpo colidiu.
c OBS: para o potencial de um asteroide.
c
c------------------------------------------------------------------------------

c 14/01/17
c ##A34,n## Implementa um anel de ejeção ao redor de corpos escolhidos do sistema.
c
c------------------------------------------------------------------------------

c 16/01/17
c ##A35,n## Adiciona um vetor de índices dos corpos.
c
c------------------------------------------------------------------------------

c 17/01/17
c ##A36,n## Implementa colisões para o integrador MVS.
c
c------------------------------------------------------------------------------

c 17/01/17
c ##A37,n## Colisões com o corpo central opcional.
c
c------------------------------------------------------------------------------

c 20/01/17
c ##E19,n## Corrige o erro da distância máxima do sistema rmax. Coloca uma
c distância máxima igual a 10*rmax nas variáveis de output do Mercury. E também
c coloca uma distância mínima igual a 0.1*rcen quando é usado o potencial de um
c asteroide.
c
c------------------------------------------------------------------------------

c 22/04/17
c ##A38,n## Implementa a força de Pressão de Radiação Solar (SRP) e o arrasto de
c Poynting-Robertson (P-R).
c
c------------------------------------------------------------------------------

c 25/05/17
c ##A39,n## Implementa o problema de Chariklo.
c
c------------------------------------------------------------------------------

c 15/06/17
c ##A40,n## Implementa uma esfera de ejeção ao redor de corpos escolhidos do
c sistema.
c
c------------------------------------------------------------------------------

c 07/10/17
c ##A41,n## Implementa o método de mascons cúbicos.
c
c------------------------------------------------------------------------------

c 01/08/18
c ##A42,n## Implementa a conversão de elementos geométricos para coordenadas
c cartesianas.
c
c------------------------------------------------------------------------------

c 11/11/19
c ##A43,n## Implementa o critério de colisão com o corpo central para asteroides
c usando o Laplaciano.
c
c------------------------------------------------------------------------------

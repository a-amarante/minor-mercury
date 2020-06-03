c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MERCURY.INC    (ErikSoft   4 March 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers (adapted by A. Amarante - 23 April 2017)
c
c Parameters that you may want to alter at some point:
c
c NMAX  = maximum number of bodies
c CMAX  = maximum number of close-encounter minima monitored simultaneously
c NMESS = maximum number of messages in message.in
c HUGE  = an implausibly large number
c NFILES = maximum number of files that can be open at the same time
c FMAX  = maximum number of flush interval
c novmax = maximum number of vertices
c nopmax = maximum number of faces
c noed   = maximum number of vertices per face
c nocen  = maximum number of centroids (nopmax*layer)
c nopotx  = maximum number of x pontentials per dihedral
c nopoty  = maximum number of y pontentials per dihedral
c nopotz  = maximum number of z pontentials per dihedral
c TINY  = a small number
c
      integer NMAX, CMAX, NMESS, NFILES, FMAX
      integer novmax, nopmax, noed, nocen
      integer nopotx,nopoty,nopotz
      real*8 HUGE,TINY
c
      parameter (NMAX = 20100)
      parameter (CMAX = 5000)
c      parameter (NMAX = 2000)
c      parameter (CMAX = 50)
      parameter (NMESS = 460)
      parameter (HUGE = 9.9d29)
      parameter (NFILES = 1000)
      parameter (FMAX = 999)
      parameter (novmax = 200000)
      parameter (nopmax = 200000)
      parameter (noed = 10)
      parameter (nocen = 500000)
      parameter (nopotx = 50)
      parameter (nopoty = 50)
      parameter (nopotz = 15)
c      parameter (nopotx = 401)
c      parameter (nopoty = 401)
c      parameter (nopotz = 21)
      parameter (TINY = 4.D-15)
c
c------------------------------------------------------------------------------
c
c Constants:
c
c DR = conversion factor from degrees to radians
c K2 = Gaussian gravitational constant squared in AU^3/MSUN/day^2
c AU = astronomical unit in cm
c MSUN = mass of the Sun in g
c
      real*8 PI,TWOPI,PIBY2,DR
c
      parameter (PI = 3.141592653589793d0)
      parameter (TWOPI = PI * 2.d0)
      parameter (PIBY2 = PI * .5d0)
      parameter (DR = PI / 180.d0)
cc      parameter (K2 = 2.959122082855911d-4)
cc      parameter (AU = 1.4959787e13)
cc      parameter (MSUN = 1.9891e33)
ccc      parameter (K2 = 6.6719842229637d-20)
ccc      parameter (AU = 1.0e5)
ccc      parameter (MSUN = 1.0e3)

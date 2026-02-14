c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      FREQ_N0.FOR    (FEG   24 NOV 2018)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante (A.   Amarante)   andre.amarante@unesp.br
c
c Date: 11/24/2018
c Last modification: 11/24/2018
c
c Description: refining values of n squared.
c
c------------------------------------------------------------------------------
c
      subroutine freq_n0 (obla,a,n0)
c
      implicit none
c
c Input/Output
      real*8 obla(4),a,n0
c
c Local
      real*8 GM,J2,J4,J6
      real*8 a_2,a_4,a_6
      real*8 n2
c
c------------------------------------------------------------------------------
c
      GM  = obla(1)
      J2  = obla(2)
      J4  = obla(3)
      J6  = obla(4)
c
      a_2  = 1.d0 / (a * a)
      a_4  = a_2 * a_2
      a_6  = a_4 * a_2
c
      n2   = GM / (a * a * a)
c
      n0    = n2 * (1.d0
     %	 +   1.5d0      * J2 * a_2
     %   -   1.875d0    * J4 * a_4
     %   +   2.1875d0   * J6 * a_6 )
c
c------------------------------------------------------------------------------
c
      return
c
      end
c

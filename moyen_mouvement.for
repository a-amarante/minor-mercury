c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MOYEN_MOUVEMENT.FOR    (FEG   5 JAN 2018)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante (A.   Amarante)   andre.amarante@unesp.br
c
c Date: 01/05/2018
c Last modification: 11/25/2021
c
c Description: refining values of n, kappa, nu.
c
c------------------------------------------------------------------------------
c
      subroutine moyen_mouvement (obla,a,e,I,freq)
c
      implicit none
c
c Input/Output
      real*8 obla(4),a,e,I,freq(5)
c
c Local
      real*8 GM,J2,J4,J6
      real*8 a_2,a_4,a_6
      real*8 J22,J23,e2,I2,n2,n0
      real*8 n,pperi,pnoeu,eta2,chi2
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
      J22 = J2 * J2
      J23 = J2 * J22
      e2  = e * e
      I2  = I * I
c
      n2   = GM / (a * a * a)
      n0   = dsqrt( n2 )
c
      n    = n0 * (1.d0
     %	 +   0.75d0      * J2 * a_2
     %   -   0.9375d0    * J4 * a_4
     %   +   1.09375d0   * J6 * a_6
     %   -   0.28125d0   * J22* a_4
     %   +   0.703125d0  * J2 * J4 * a_6
     %   +   0.2109375d0 * J23* a_6
     %   +   3.d0   * J2 * e2 * a_2 
     %   -   12.d0  * J2 * I2 * a_2 )
c
      pperi= n0 * (1.d0
     %	 -   0.75d0      * J2 * a_2
     %   +   2.8125d0    * J4 * a_4
     %   -   5.46875d0   * J6 * a_6
     %   -   0.28125d0   * J22* a_4
     %   +   2.109375d0  * J2 * J4 * a_6
     %   -   0.2109375d0 * J23* a_6
     %   -   9.d0   * J2 * I2 * a_2 )
c
      pnoeu= n0 * (1.d0
     %	 +   2.25d0       * J2 * a_2
     %   -   4.6875d0     * J4 * a_4
     %   +   7.65625d0    * J6 * a_6
     %   -   2.53125d0    * J22* a_4
     %   +   10.546875d0  * J2 * J4 * a_6
     %   +   5.6953125d0  * J23* a_6
     %   +   6.0d0   * J2 * e2 * a_2 
     %   -   12.75d0 * J2 * I2 * a_2 )
c
      eta2 = n2 * (1.d0 
     %   -   2.d0     * J2 * a_2 
     %   +   9.375d0  * J4 * a_4 
     %   -   21.875d0 * J6 * a_6 )
c     
      chi2 = n2 * (1.d0
     %   +   7.5d0     * J2 * a_2 
     %   -   21.875d0  * J4 * a_4 
     %   +   45.9375d0 * J6 * a_6 )
c
      freq(1) = n
      freq(2) = pperi
      freq(3) = pnoeu
      freq(4) = eta2
      freq(5) = chi2
c
c------------------------------------------------------------------------------
c
      return
c
      end
c

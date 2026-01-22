c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      GEO_CAR.FOR    (FEG   5 JAN 2018)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante (A.   Amarante)   andre.amarante@unesp.br
c
c Date: 01/05/2018
c Last modification: 01/08/2018
c
c Description: Convert J6-corrected orbital elements to xv coords.
c PS: Uses paper Sicardy/Renner second order method.
c
c------------------------------------------------------------------------------
c
      subroutine geo_car (obla,el,xv)
c
      implicit none
      include 'mercury.inc'
c
c Input/Output
      real*8 obla(4),xv(6),el(6)
c
c Local
      real*8 a,e,I,freq(5)
      real*8 p1,p2,lambda,aaa,tomega,bbb,gomega
      real*8 e2,I2,kappa2,n2
      real*8 n,pperi,pnoeu,eta2,chi2
      real*8 kappa,nu
      real*8 alpha1,alpha2,alph2
      real*8 x,y,z,vx,vy,vz
      real*8 r,L,vr,vL
      real*8 aux
c
c------------------------------------------------------------------------------
c
      aux = el(4)
      el(4) = el(5)
      el(5) = aux + el(5)
      el(5) = mod (el(5), 360.d0)
      if (el(5).lt.0.d0) el(5) = el(5) + 360.d0
      el(6) = el(6) + el(5)
      el(6) = mod (el(6), 360.d0)
      if (el(6).lt.0.d0) el(6) = el(6) + 360.d0
c
      a = el(1)
      e = el(2)
      I = el(3)
      gomega = el(4)
      tomega = el(5)
      lambda = el(6)
c
      I = mod(I*DR,TWOPI)
      if (I.lt.0.d0) I = I + TWOPI
      gomega = mod(gomega*DR,TWOPI)
      if (gomega.lt.0.d0) gomega = gomega + TWOPI
      tomega = mod(tomega*DR,TWOPI)
      if (tomega.lt.0.d0) tomega = tomega + TWOPI
      lambda = mod(lambda*DR,TWOPI)
      if (lambda.lt.0.d0) lambda = lambda + TWOPI
c
c refining values of n, kappa, nu
      call moyen_mouvement (obla,a,e,I,freq)
c
      n     = freq(1)
      pperi = freq(2)
      pnoeu = freq(3)
      eta2  = freq(4)
      chi2  = freq(5)
c
c      kappa = n - pperi
c      nu    = n - pnoeu
      kappa = pperi
      nu    = pnoeu
c
      alpha1= (1.d0/3.d0) * (2.d0 * nu + kappa)
      alpha2= 2.d0 * nu - kappa
      alph2 = alpha1 * alpha2
c
      e2 = e * e
      I2 = I * I
      kappa2 = kappa * kappa
      n2 = n * n
c
      aaa = lambda - tomega
      bbb = lambda - gomega
c
      r = a*(1.d0 - e*cos(aaa)  
     %  + (1.5d0*(eta2/kappa2) - 1.d0 )*e2 
     %  -  0.5d0*(eta2/kappa2)*(e2)*cos(2.d0*aaa))
      r = r + a*(I2)*(0.75d0*(chi2/kappa2) - 1.d0 
     %  + 0.25d0*(chi2/alph2)*cos(2.d0*bbb))
c
      L = lambda + 2.d0*(n/kappa)*e*sin(aaa) 
     %  + (0.75d0 + 0.5d0*eta2/kappa2)
     %  * (n/kappa)*(e2)*sin(2.d0*aaa)
      L = L - (0.25d0)*(chi2/alph2)*(n/nu)*(I2)*sin(2.d0*bbb)
c
      vr= a*kappa*(e*sin(aaa) + (eta2/kappa2)*(e2)*sin(2.d0*aaa))
      vr= vr - a*(I2)*(0.5d0*(chi2*nu)/alph2)*sin(2.d0*bbb)
c
      vL= n*(1.d0 + 2.d0*e*cos(aaa) + (3.5d0 - 3.d0*(eta2/kappa2)
     %  - 0.5d0*(kappa2/n2))*e2
     %  + (1.5d0 + eta2/kappa2)*e2*cos(2.d0*aaa))
      vL= vL + n*(I2)*(2.d0 - 0.5d0*(kappa2/n2)
     %  - 1.5d0*(chi2/kappa2)
     %  - 0.5d0*(chi2/alph2)*cos(2.d0*bbb))
c
      x = r  * cos(L)
      y = r  * sin(L)
      z = a*I*(sin(bbb) 
     %  + 0.5d0*(chi2/(kappa*alpha1))*e*sin(aaa+bbb) 
     %  - 1.5d0*(chi2/(kappa*alpha2))*e*sin(bbb-aaa))
      vx= vr * cos(L) - r * sin(L) * vL
      vy= vr * sin(L) + r * cos(L) * vL
      vz= a*I*nu*(cos(bbb) 
     %  + 0.5d0*((chi2*(kappa+nu))/(kappa*alpha1*nu))
     %  *e*cos(aaa+bbb) + 1.5d0*((chi2*(kappa-nu))/(kappa*alpha2*nu))
     %  *e*cos(bbb-aaa))
c
      xv(1) = x
      xv(2) = y
      xv(3) = z
      xv(4) = vx
      xv(5) = vy
      xv(6) = vz
c
c------------------------------------------------------------------------------
c
      return
c
      end
c

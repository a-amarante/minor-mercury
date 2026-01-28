c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      CAR_GEO.FOR    (FEG   5 JAN 2018)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante (A.   Amarante)   andre.amarante@unesp.br
c
c Date: 01/05/2018
c Last modification: 11/24/2018
c
c Description: Convert xv coords to J6-corrected orbital elements.
c PS: Uses paper Sicardy/Renner second order method.
c
c------------------------------------------------------------------------------
c
      subroutine car_geo (obla,xv,el,mem,lmem,id,opt)
c
      implicit none
      include 'mercury.inc'
      real*8 epsilon,prec
      integer imax
      character*8 id
      parameter (epsilon = 1.d-12)
      parameter (imax = 1000)
      parameter (prec = 1.d-10)
c
c Input/Output
      real*8 obla(4),xv(6),el(6)
      integer lmem(NMESS)
      character*80 mem(NMESS)
      integer opt
c
c Local
      real*8 x,y,z,vx,vy,vz
      real*8 hz,r,L,vr,vL
      real*8 a,e,I,freq(5)
      real*8 n,pperi,pnoeu,eta2,chi2
      real*8 kappa,nu
      real*8 alpha1,alpha2,alph2
      real*8 a0,rcor,Lcor,vrcor,vLcor,zcor,vzcor
      integer iter
      real*8 p1,p2,lambda,aaa,X0,Y0,tomega,bbb,gomega
      real*8 e2,I2,kappa2,n2
      character*5 c5
      real*8 aux
      real*8 n0,r0,r0c
c
c------------------------------------------------------------------------------
c
      x = xv(1)
      y = xv(2)
      z = xv(3)
      vx = xv(4)
      vy = xv(5)
      vz = xv(6)
c
      hz = x * vy - y * vx
      r = dsqrt(x * x + y * y)
      L = atan2(y, x)
c      if (L.lt.0.d0) L = L + TWOPI
      vr=   vx * cos(L) + vy * sin(L)
      vL= (-vx * sin(L) + vy * cos(L)) / r
c
c initial estimates of a, e, I, n, kappa, nu...
      a = r      
      e = 0.d0
      I = 0.d0
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
      iter = 0
      a0   = HUGE
      rcor = 0.d0
      Lcor = 0.d0
      vrcor= 0.d0
      vLcor= 0.d0
      zcor = 0.d0
      vzcor= 0.d0 
c
      do while (dabs((a-a0)/a).ge.epsilon)
        a0 = a
        a = ( r - rcor )/( 1.d0 - (vL - n - vLcor)/(2.d0 * n) )
        p1= (vL - n - vLcor)/(2.d0 * n)
        p2= (vr - vrcor)/(a * kappa)
        e = dsqrt( p1*p1 + p2*p2 )
        p1=(z-zcor)/a
        p2=(vz-vzcor)/(a*nu)
        I = dsqrt( p1*p1 + p2*p2 )
c
        lambda= L - Lcor - 2.d0*(n/kappa)*(vr - vrcor)/(a*kappa)
        lambda= mod(lambda, TWOPI)
        if (lambda.lt.0.d0) lambda = lambda + TWOPI
c
        aaa   = atan2((vr - vrcor)/(a*kappa), 1.d0 - (r - rcor)/a)
c        x = 1.d0 - (r - rcor)/a
c        if (dabs(x).le.prec) aaa = lambda
        tomega= lambda - aaa
        tomega= mod(tomega, TWOPI)
        if (tomega.lt.0.d0) tomega = tomega + TWOPI
c
        bbb   = atan2(z-zcor, (vz - vzcor)/nu)
c        x = (vz - vzcor)/nu
c        if (dabs(x).le.prec) bbb = lambda
        gomega=lambda - bbb
        gomega= mod(gomega, TWOPI)
        if (gomega.lt.0.d0) gomega = gomega + TWOPI
c
        e2 = e * e
        I2 = I * I
        kappa2 = kappa * kappa
        n2 = n * n
c
        rcor= a*(e2)*(1.5d0*(eta2/kappa2) - 1.d0
     %    - 0.5d0*(eta2/kappa2)*cos(2.d0*aaa))
        rcor=rcor+a*(I2)*(0.75d0*(chi2/kappa2) - 1.d0
     %    + 0.25d0*(chi2/alph2)*cos(2.d0*bbb))
c
        Lcor= (0.75d0+0.5d0*(eta2/kappa2))*(n/kappa)*(e2)*sin(2.d0*aaa)
        Lcor= Lcor - 0.25d0*(chi2/alph2)*(n/nu)*(I2)*sin(2.d0*bbb)
c
        vrcor= a*kappa*(eta2/kappa2)*(e2)*sin(2.d0*aaa)
        vrcor= vrcor - a*(I2)*0.5d0*((chi2*nu)/alph2)*sin(2.d0*bbb)
c
        vLcor= n*(e2)*(3.5d0 - 3.d0*(eta2/kappa2) 
     %    - 0.5d0*(kappa2/n2)+(1.5d0 + (eta2/kappa2))*cos(2.d0*aaa))
        vLcor= vLcor + n*(I2)*(2.d0 - 0.5d0*(kappa2/n2)
     %    - 1.5d0*(chi2/kappa2) - 0.5d0*(chi2/alph2)*cos(2.d0*bbb))
c
        zcor = a*I*e*(0.5d0*(chi2/(kappa*alpha1))*sin(aaa+bbb) 
     %    - 1.5d0*(chi2/(kappa*alpha2))*sin(bbb-aaa))
        vzcor= a*I*e*(0.5d0*((chi2*(kappa+nu))/(kappa*alpha1))
     %    *cos(aaa+bbb) + 1.5d0*((chi2*(kappa-nu))/(kappa*alpha2))
     %    *cos(bbb-aaa))
c
        iter = iter + 1
c
        if (iter.ge.imax) then
          write (c5,'(i5)') imax
          call mio_err (6,mem(81),lmem(81),mem(451),lmem(451),c5,5,
     %      mem(452),lmem(452))
          write(6,'(1x,a16,1x,1p,e35.25,1x,a19)') 'Relative Error: ',
     %      dabs((a-a0)/a),'(Second correction)'
        end if
c
        if (a.lt.0.d0) then
          call mio_err (6,mem(81),lmem(81),mem(453),lmem(453),' ',1,
     %      id,8)
        end if
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
c        kappa = n - pperi
c        nu    = n - pnoeu
        kappa = pperi
        nu    = pnoeu
c
        alpha1= (1.d0/3.d0) * (2.d0 * nu + kappa)
        alpha2= 2.d0 * nu - kappa
        alph2 = alpha1 * alpha2
      end do
c
      if (dabs(e).le.TINY) e = 0.d0
      if (dabs(I).le.TINY) I = 0.d0
c    
      el(1) = a
      el(2) = e
      el(3) = mod (I, TWOPI)
      if (el(3).lt.0.d0) el(3) = el(3) + TWOPI
      el(4) = mod (gomega, TWOPI)
      if (el(4).lt.0.d0) el(4) = el(4) + TWOPI
      el(5) = mod (tomega, TWOPI)
      if (el(5).lt.0.d0) el(5) = el(5) + TWOPI
      el(6) = mod (lambda, TWOPI)
      if (el(6).lt.0.d0) el(6) = el(6) + TWOPI
c
      aux = el(5)
      el(5) = el(4)
      el(4) = aux - el(4)
      el(4) = mod (el(4), TWOPI)
      if (el(4).lt.0.d0) el(4) = el(4) + TWOPI
      el(6) = el(6) - (el(4) + el(5))
      el(6) = mod (el(6), TWOPI)
      if (el(6).lt.0.d0) el(6) = el(6) + TWOPI
c
c      el(3) = el(3) / DR
c      el(4) = el(4) / DR
c      el(5) = el(5) / DR
c      el(6) = el(6) / DR
c
      if (opt.eq.1) then
c calcul du demi grand-axe a partir du moment cinetique vertical
c
        r0   = r
        r0c  = 0.0
        iter = 0
c
        do while (dabs((r0c-r0)/r0).ge.epsilon)
          r0c = r0
          iter = iter + 1
          call freq_n0 (obla,r0,n0)
          n0 = dsqrt(n0)
          r0 = dsqrt(dabs(hz)/n0)
c
          if (iter.ge.imax) then
            write (c5,'(i5)') imax
            call mio_err (6,mem(81),lmem(81),mem(451),lmem(451),c5,5,
     %        mem(452),lmem(452))
            write(6,'(1x,a16,1x,1p,e35.25,1x,a18)') 'Relative Error: ',
     %        dabs((r0c-r0)/r0),'(Third correction)'
          end if
        end do
c
        el(1) = r0 * (1.d0 + el(2)*el(2) + el(3)*el(3))
      end if
c
c------------------------------------------------------------------------------
c
      return
c
      end
c

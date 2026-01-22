c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MFO_USER.FOR    (ErikSoft   2 March 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Authors: Andre Amarante       (A. Amarante)     - andre.amarante@unesp.br
c          John E. Chambers     (J. E. Chambers)  - chambers@agamemnon.ciw.edu
c
c Applies an arbitrary force, defined by the user.
c
c If using with the symplectic algorithm MAL_MVS, the force should be
c small compared with the force from the central object.
c If using with the conservative Bulirsch-Stoer algorithm MAL_BS2, the
c force should not be a function of the velocities.
c
c N.B. All coordinates and velocities must be with respect to central body
c ===
c------------------------------------------------------------------------------
c
c ##A38,144##
      subroutine mfo_user (time,jcen,nbod,nbig,m,x,v,a,opt,optr,ngf,
     %  opti,K2,AU,MSUN)
c ##A38,144##
c
      implicit none
      include 'mercury.inc'
c
c Input/Output
      integer nbod, nbig
      real*8 time,jcen(3),m(nbod),x(3,nbod),v(3,nbod),a(3,nbod)
c ##A38,145##
      integer opt(9)
      real*8 optr(76)
      real*8 ngf(4,nbod)
      integer opti(90)
      real*8 K2,AU,MSUN
c ##A38,145##
c
c Local
      integer j
      real*8 c,c2,r,r2,r3,FGR
      real*8 aind(3)
      real*8 xs(3),vs(3),rs,r_s2,beta,dot,rsh,ns,temp,q
      real*8 coef,Ca,Cb,Cc,Cd,Ra,Rb,Rc
      integer sflag
c
c------------------------------------------------------------------------------
c
      do j = 2, nbod
        a(1,j) = 0.d0
        a(2,j) = 0.d0
        a(3,j) = 0.d0
      end do
c
c------------------------------------------------------------------------------
c
!     Doing GR perturbation (see. eq. 30 of Saha & Tremaine 1992)
c      c = 173.144483 !speed of light in AU/day
c      c2 = c*c
c
c      aind(1) = 0.0d0
c      aind(2) = 0.0d0
c      aind(3) = 0.0d0
c      
c      do j = 2,nbod
c         r2 = x(1,j) * x(1,j) + x(2,j) * x(2,j) + x(3,j) * x(3,j)
c         r = sqrt(r2)
c         r3 = r2 * r
c         FGR = 6.0d0 * m(1) *m(1) / c2 / r3
c
c         a(1,j) = a(1,j) + FGR * x(1,j) / r
c         a(2,j) = a(2,j) + FGR * x(2,j) / r
c         a(3,j) = a(3,j) + FGR * x(3,j) / r
c
c         aind(1) = aind(1) + a(1,j)*m(j)/m(1)
c         aind(2) = aind(2) + a(2,j)*m(j)/m(1)
c         aind(3) = aind(3) + a(3,j)*m(j)/m(1)
c      enddo
c
c      do j = 2,nbod
c         a(1,j) = a(1,j) + aind(1)
c         a(2,j) = a(2,j) + aind(2)
c         a(3,j) = a(3,j) + aind(3)
c      enddo
c
c------------------------------------------------------------------------------
c
!     Doing Solar Radiation Pressure and Poynting–Robertson drag with cylindrical shadow (see. (Burns et al., 1979); (Sfair and Giuliatti Winter, 2009))
c      c = 29979219744.2722 !speed of light in cm/s
c      c = c / AU
c      c = 1.d0 / c
c      c = 1.d0 / optr(61)
c      coef   = (optr(54)-m(1)) * optr(53)
c
c     SUN state vectors
c      xs(1) = -dcos(optr(52)*time)
c      xs(2) = -dcos(optr(51))*dsin(optr(52)*time)
c      xs(3) = -dsin(optr(51))*dsin(optr(52)*time)
c      vs(1) =  optr(52)*dsin(optr(52)*time)
c      vs(2) = -dcos(optr(51))*optr(52)*dcos(optr(52)*time)
c      vs(3) = -dsin(optr(51))*optr(52)*dcos(optr(52)*time)
c
c      ns = mod(optr(52) * time, TWOPI)
c      Ra = dcos(ns)
c      Rb = dcos(optr(51))*dsin(ns)
c      Rc = dsin(optr(51))*dsin(ns)
c
c      q = optr(55) * (1.d0 - optr(56))
c      call mco_el2x (optr(54),q,optr(56),optr(57),optr(58),optr(59),ns,
c     %  xs(1),xs(2),xs(3),vs(1),vs(2),vs(3))
c
c      xs(1) = -xs(1)
c      xs(2) = -xs(2)
c      xs(3) = -xs(3)
c      vs(1) = -vs(1)
c      vs(2) = -vs(2)
c      vs(3) = -vs(3)
c
c      r_s2 = xs(1)*xs(1)+xs(2)*xs(2)+xs(3)*xs(3)
c      rs   = dsqrt(r_s2)
c      r_s2 = 1.d0 / r_s2
c      coef = (optr(54)-m(1)) * r_s2
c      Ca   = xs(1) * xs(1) * r_s2
c      Cb   = xs(2) * xs(2) * r_s2
c      Cc   = xs(3) * xs(3) * r_s2
c
c      do j = 2, nbod
c shadow analysis
c        if (j.lt.opti(77).or.j.gt.opti(78)) then
c          sflag = 0
c          r   = dsqrt(x(1,j)*x(1,j)+x(2,j)*x(2,j)+x(3,j)*x(3,j))
c          dot = xs(1)*x(1,j)+xs(2)*x(2,j)+xs(3)*x(3,j)
c          beta= acos(dot / (r * rs))
c          if (beta.gt.PI*0.5) then
c            rsh = r * dsin(PI-beta)
c            if (rsh.le.optr(53)) sflag = 1
c          end if
c          if (sflag.eq.0) then
c SRP and P-R components
c            Cd = coef * ngf(4,j)
c            a(1,j) = Cd*(Ra-c*(vs(1)+v(1,j))*(Ca+1))
c            a(2,j) = Cd*(Rb-c*(vs(2)+v(2,j))*(Cb+1))
c            a(3,j) = Cd*(Rc-c*(vs(3)+v(3,j))*(Cc+1))
c          end if
c        end if
c      end do
c
c------------------------------------------------------------------------------
c
      return
      end
c

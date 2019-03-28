!-----subroutine---------------------------------------------g.guidati--
! 
     subroutine STREAM(dt,str1,str2,ps)
! 
!-----------------------------------------------------------------------
!               
!     franco guidati    IAG
!                       Uni Stuttgart
!
! 
!     scope             determine streamlines
! 
!.......................................................................
!               declarations
!.......................................................................

      USE TINoiseGeneric
      USE TINoiseInput
      USE TINoiseGeo
      USE TINoiseDDD
      USE TINoiseVsside
      USE TIPrecision                                      
                                                     
IMPLICIT                        NONE                 
                                                     
                                                     
   ! Local variables.                                
                                                     
INTEGER(4)                   :: nvar, istr,nok,nbad       
                                                     
REAL(DbKi)                   :: eps,h1,hmin,dipok,dv1,dv2,dv1d1,dv1d2
REAL(DbKi)                   :: dv2d1,dv2d2,v1,v2,v11,v12,v22,dt
REAL(DbKi)                   :: phif(6), str1(mstr),str2(mstr),ps(mstr) 

EXTERNAL          :: SIG,rkqs

      nvar    =  6
      eps     =  1.0D-07
      h1      =  0.1d0
      hmin    =  0.0d0
     
!.......................................................................
!              
!.......................................................................
  
      s1 = 0.0d0
      s2 = swork(n+1)

!.......................................................................
!     determine streamline
!.......................................................................

      do istr = 1,nstr
        x1 = str1(istr)
        x2 = str2(istr)

        phif(1) = str1(istr)
        phif(2) = 1.0d0
        phif(3) = 0.0d0
	phif(4) = 0.0
	phif(5) = 0.0
	phif(6) = 0.0

        call odeint(phif,nvar,s1,s2,eps,h1,hmin,nok,nbad,SIG,rkqs)
	!print*, phif,nvar,s1,s2,eps,h1,hmin,nok,nbad
        call calll(x1,x2,yc1(1),yc2(1),ywinf1,ywinf2,ywn1,ywn2,dipok,dv1,dv2,dv1d1,dv1d2,dv2d1,dv2d2)
     
        phif(1) = phif(1) + rhs(n+2)*dipok
        phif(2) = phif(2) + rhs(n+2)*dv1
        phif(3) = phif(3) + rhs(n+2)*dv2
        phif(4) = phif(4) + rhs(n+2)*dv1d1
        phif(5) = phif(5) + rhs(n+2)*dv1d2
        phif(6) = phif(6) + rhs(n+2)*dv2d2

        
        v1  = phif(2)
        v2  = phif(3)
	v11 = phif(4)
	v12 = phif(5)
	v22 = phif(6)
	
	ps(istr)   = phif(1)
	

	if(istr.ne.nstr) then
  	  str1(istr+1) = str1(istr) + v1*dt + 0.5*(v11*v1+v12*v2)*dt**2
	  str2(istr+1) = str2(istr) + v2*dt + 0.5*(v12*v1+v22*v2)*dt**2
	endif
        
      enddo

!.......................................................................
!               end of subroutine
!.......................................................................
      return
!***********************************************************************
      end 

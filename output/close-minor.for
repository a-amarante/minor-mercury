c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      CLOSE-MINOR.FOR    (FEG   2 June 2020)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante    (A. Amarante) - andre.amarante@unesp.br
c
c Makes output files containing details of close encounters that occurred
c during an integration using Minor-Mercury version or higher.
c
c The user specifies the names of the required objects in the file close.in
c
c******************************************************************************
c CHANGES IN VERSION MINOR v3 (IFSP   17 March 2022)
c******************************************************************************
c
c Author: Andre Amarante (A. Amarante)
c
c As alterações foram feitas através dos marcadores ##Am,n## e as correções dos
c erros através dos marcadores ##Em,n##.
c
c Please, send your comments to andre.amarante@unesp.br.
c
c------------------------------------------------------------------------------
c
c 05/03/14
c ##E1,n## Corrige o erro para procurar o próximo pedaço de tempo não
c corrompido no mesmo arquivo de saída e NÃO no próximo arquivo de saída.
c
c------------------------------------------------------------------------------
c
c 06/03/14
c ##A1,n## Adiciona a subrotina m_format (output format no arquivo close.in)
c adaptada para a escolha de uma tag de um elemento com até três caracteres,
c para a escolha do número de casas decimais no formato exponencial e para o
c aumento da quantidade de elementos (colunas) a serem impressos.
c Também adiciona ao arquivo close.in as opções do tipo de descompressão dos
c dados do arquivo de saída ce.out.
c
c------------------------------------------------------------------------------
c
c 07/03/14
c ##A2,n## Escreve na tela algumas informações relevantes.
c
c------------------------------------------------------------------------------
c
c 07/03/14
c ##A3,n## Adiciona ao arquivo close.in a opção do mínimo intervalo de saída de
c dados.
c
c------------------------------------------------------------------------------
c
c 08/03/14
c ##A4,n## Adiciona ao arquivo close.in as opções do intervalo de saída de
c dados.
c
c------------------------------------------------------------------------------
c
c 21/03/14
c ##A5,n## Faz com que sejam lidos do arquivo ce.out os dados de cabeçalho
c referentes a todos os corpos do sistema e NÃO apenas dos corpos envolvidos em
c situações de encontros próximos, colisões e ejeções.
c
c------------------------------------------------------------------------------
c
c 21/03/14
c ##A6,n## Adiciona ao arquivo close.in a opção do tipo dos elementos.
c
c------------------------------------------------------------------------------
c
c 23/03/14
c ##A7,n## Adiciona ao arquivo close.in as opções para que os elementos sejam
c referenciados no referencial girante.
c
c------------------------------------------------------------------------------
c
c 23/03/14
c ##A8,n## Faz com que os dados do arquivo de saída ce.out sejam lidos de uma
c única linha apenas.
c
c------------------------------------------------------------------------------
c
c 05/01/15
c ##A9,n## Adiciona ao arquivo close.in novas opções para o tipo dos elementos.
c
c------------------------------------------------------------------------------
c
c 06/01/15
c ##A10,n## Converte as coordenadas e velocidades de um corpo para um corpo de
c referência. Adiciona ao arquivo close.in novas opções.
c
c------------------------------------------------------------------------------
c
c 08/07/16
c ##A11,n## Adiciona ao arquivo close.in as opções de ejeções e colisões a partir
c de encontros próximos.
c
c------------------------------------------------------------------------------
c
c 08/07/16
c ##E2,n## Corrige o erro para que seja guardada a distância real do corpo e
c não a distância de ejeção quando há ejeções no sistema.
c
c------------------------------------------------------------------------------
c
c 28/07/16
c ##A12,n## Adiciona ao arquivo close.in as opções dos raios físicos dos corpos,
c do raio de Hill, do parâmetro de impacto e das posições e velocidades relativas.
c
c------------------------------------------------------------------------------
c
c 03/08/16
c ##A13,n## Adiciona ao arquivo element.in a opção de saída do tempo com relação
c ao tempo inicial escolhido.
c
c------------------------------------------------------------------------------
c
c 11/08/16
c ##A14,n## Coloca o arquivo message.in em um diretório diferente do principal.
c
c------------------------------------------------------------------------------
c
c 25/09/16
c ##AN15,n## Faz com que as constantes do arquivo mercury.inc sejam lidas a partir
c de um arquivo permitindo que o Close não tenha que ser compilado toda vez que
c uma dessas constantes seja alterada. As implementações foram feitas por
c A. Amarante e N. C. S. Araújo.
c
c------------------------------------------------------------------------------
c
c 12/10/16
c ##ANO16,n## Implementa as opções da seção de Poincaré. As implementações foram
c feitas por A. Amarante, N. C. S. Araújo e O. C. Winter.
c
c------------------------------------------------------------------------------
c
c 13/10/16
c ##A17,n## Implementa o período de rotação dentro do output e como opção de
c saída no arquivo element.in.
c
c------------------------------------------------------------------------------
c
c 10/11/16
c ##A18,n## Implementa o local da superfície do corpo central que o corpo colidiu.
c OBS: para o potencial de um asteroide.
c
c------------------------------------------------------------------------------
c
c 16/01/17
c ##A19,n## Adiciona um vetor de índices dos corpos e faz com que os cabeçalhos
c dos arquivos gerados pelo Mercury sejam comentados com #.
c
c------------------------------------------------------------------------------
c
c 20/01/17
c ##E3,n## Corrige o erro da distância máxima do sistema rmax. Coloca uma
c distância máxima igual a 10*rmax nas variáveis de output do Mercury. E também
c coloca uma distância mínima igual a 0.1*rcen quando é usado o potencial de um
c asteroide.
c
c------------------------------------------------------------------------------
c
c 04/02/17
c ##A20,n## Faz com que um corpo seja referenciado com relação a um outro corpo
c secundário (para sistemas coorbitais).
c
c------------------------------------------------------------------------------
c
c 01/08/18
c ##A21,n## Implementa a conversão de coordenadas cartesianas para elementos
c geométricos.
c
c------------------------------------------------------------------------------
c
c 04/04/18
c ##A22,n## Adiciona os elementos equinociais.
c
c------------------------------------------------------------------------------
c
c 06/21/18
c ##A24,n## Implementa o rotational breakup.
c
c------------------------------------------------------------------------------
c
c 16/07/18
c ##A23,n## Intervalo de índices de corpos para aplicar os elementos geométricos.
c
c------------------------------------------------------------------------------
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      CLOSE6.FOR    (ErikSoft   5 June 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Makes output files containing details of close encounters that occurred
c during an integration using Mercury6 or higher.
c
c The user specifies the names of the required objects in the file close.in
c
c------------------------------------------------------------------------------
c
      implicit none
      include 'mercury.inc'
c ##A12,10##
c ##A21,7##
      real*8 THIRD,EPS
      parameter (THIRD=.3333333333333333d0)
c ##A12,10##
      parameter (EPS =1.0d-10)
c ##A21,7##
c
c ##A8,1##
      integer itmp,i,j,k,l,iclo,jclo,lenin
c ##A8,1##
c ##Ubuntu-22-LTS##
c      integer nmaster,nopen,nwait,nbig,nsml,nsub,lim(2,100)
      integer nmaster,nopen,nwait,nbig,nsml,nsub,lim(2,1000)
c ##Ubuntu-22-LTS##
c ##A8,2##
      integer year,month,timestyle,lenhead,lmem(NMESS)
c ##A8,2##
      integer nchar,algor,allflag,firstflag,ninfile
      integer unit(NMAX),master_unit(NMAX)
      real*8 time,t0,t1,rmax,rcen,rfac,dclo,mcen,jcen(3)
      real*8 mio_c2re, mio_c2fl,fr,theta,phi,fv,vtheta,vphi,gm
c ##A1,60##
      real*8 x(3,NMAX),v(3,NMAX),xh(3,NMAX),vh(3,NMAX),m(NMAX)
c      real*8 x1(3),x2(3),v1(3),v2(3),m(NMAX)
c      real*8 a1,a2,e1,e2,i1,i2,p1,p2,n1,n2,l1,l2,q1,q2
c ##A1,60##
      logical test
c ##A1,1##
c      character*250 string,fout,header,infile(50)
      character*250 string,infile(50)
      character*1000 fout,header
c ##A1,1##
c      character*80 mem(NMESS),cc,c(NMAX)
      character*80 mem(NMESS),c(NMAX)
      character*160 cc
      character*8 master_id(NMAX),id(NMAX)
c ##A1,51##
      character*9 fin
c ##A1,51##
      character*1 check,style,type,c1
c ##A1,2##
      integer nst,nstored
      character*1 ce
      character*4 ext
      integer list
      character*2 c2
      character*250 str
c ##A12,5##
c ##A18,8##
c ##A19,7##
c ##A24,9##
c ##A22,5##
      integer centre,nel,iel(44)
c ##A22,5##
c ##A24,9##
c ##A19,7##
c ##A18,8##
c ##A12,5##
      integer lenin2,ijclo(2),jiclo(2),i1,i2,i3
      character*8 fin2
c ##A12,6##
c ##A18,9##
c ##A19,8##
c ##A24,10##
c ##A22,6##
      real*8 el(44,NMAX),s(3),is(NMAX),ns(NMAX)
c ##A22,6##
c ##A24,10##
c ##A19,8##
c ##A18,9##
c ##A12,6##
      real*8 rhocgs,temp
c ##A1,2##
c ##A2,1##
      integer nopent,nopen2
c ##A2,1##
c ##A3,1##
      real*8 teval,tprevious
      integer nidt,ind(2)
      character*8 idt(NMAX)
      real*8 tprev(NMAX)
      integer stflag(NMAX)
c ##A3,1##
c ##A4,1##
      real*8 ti,tf,ti2,tf2
c ##A4,1##
c ##A6,1##
      integer nbod1,nbig1
c ##A6,1##
c ##A7,1##
      integer synflag
c ##A7,1##
c ##A8,3##
      integer*8 line_num,nc,nct
      character*1 precision
      integer leni
      real*8 nbr
      integer ex
      character*12 ferr
      character*2 c2algor
c ##A8,3##
c ##A9,4##
      character*5 c5
      real*8 nn,msum
      character*8 idc
      integer i0
      real*8 omega
c ##A9,4##
c ##A10,1##
      integer oidcont,icen,oi,flagorb,nbod
      character*8 oid(2,NMAX-1)
c ##A10,1##
c ##A12,7##
      real*8 a(NMAX),vec(3),ncross
      integer l0,l1,k0,k1
c ##A12,7##
c ##A13,1##
      integer timestyle2,flagstyle
c ##A13,1##
c ##AN15,4##
      real*8 K2,AU,MSUN
c ##AN15,4##
c ##A18,1##
      integer face
c ##A18,1##
c ##A20,4##
      real*8 r,sg,cg
c ##A20,4##
c ##A21,3##
      real*8 icoor(6),ocoor(6),obla(4)
c ##A21,3##
c ##A22,7##
      integer eq
      real*8 varpi0,varpi
c ##A22,7##
c ##A23,1##
      integer opti(5)
      character*80 c80
c ##A23,1##
c
c------------------------------------------------------------------------------
c
      allflag = 0
c ##A1,3##
      nst = 0
      nstored = 0
c ##AN15,1##
c      rhocgs = AU * AU * AU * K2 / MSUN
c ##AN15,1##
c ##A1,3##
c ##A2,2##
      nopent = 0
      nopen2 = 0
c ##A2,2##
c ##A3,2##
      teval = 0.d0
      tprevious = 0.d0
c ##A3,2##
c ##A7,2##
      synflag = 0
c ##A7,2##
c ##A10,2##
      oidcont = 0
c ##A10,2##
c ##A12,15##
      do i = 1, NMAX
        do j = 1, 34
          el(j,i) = 0.0d0
        end do
      end do
c ##A12,15##
c
c Read in output messages
c ##A14,1##
c      inquire (file='message.in', exist=test)
c      if (.not.test) then
c        write (*,'(/,2a)') ' ERROR: This file is needed to continue: ',
c     %    ' message.in'
c        stop
c      end if
c      open (14, file='message.in', status='old')
c  10  continue
c        read (14,'(i3,1x,i2,1x,a80)',end=20) j,lmem(j),mem(j)
c      goto 10
c  20  close (14)
c
c Read in filenames and check for duplicate filenames
      inquire (file='files.in', exist=test)
c      if (.not.test) call mio_err (6,mem(81),lmem(81),mem(88),lmem(88),
c     %  ' ',1,'files.in',8)
      if (.not.test) then
        write (*,'(/,2a)') ' ERROR: This file is needed to start',
     %    ' the integration:  files.in'
        stop
      end if
c
      open (15, file='files.in', status='old')
      do j = 1, 6
 400    read (15,'(a150)') string
        call mio_spl (150,string,nsub,lim)
        if (lim(1,1).eq.-1) goto 400
        if (j.eq.6) then
          infile(1)(1:(lim(2,1)-lim(1,1)+1)) = string(lim(1,1):lim(2,1))
        end if
      end do
      close(15)
c
c Read in output messages
      inquire (file=infile(1), exist=test)
      if (.not.test) then
        write (*,'(/,3a)') ' ERROR: This file is needed to start',
     %    ' the integration:  ',infile(1)
        stop
      end if
      open (16, file=infile(1), status='old')
  10  read (16,'(i3,1x,i2,1x,a80)',end=20) j,lmem(j),mem(j)
      goto 10
  20  close (16)
c
      do j = 1, 250
        infile(1)(j:j) = ' '
      end do
c
c ##A14,1##
c
c Open file containing parameters for this programme
      inquire (file='close.in', exist=test)
      if (test) then
        open (10, file='close.in', status='old')
      else
        call mio_err (6,mem(81),lmem(81),mem(88),lmem(88),' ',1,
     %    'close.in',9)
      end if
c
c Read number of input files
  30  read (10,'(a250)') string
      if (string(1:1).eq.')') goto 30
      call mio_spl (250,string,nsub,lim)
      if (lim(1,1).eq.-1) goto 30
      read (string(lim(1,nsub):lim(2,nsub)),*) ninfile
c
c Make sure all the input files exist
      do j = 1, ninfile
  40    read (10,'(a250)') string
        if (string(1:1).eq.')') goto 40
        call mio_spl (250,string,nsub,lim)
        if (lim(1,1).eq.-1) goto 40
        infile(j)(1:(lim(2,1)-lim(1,1)+1)) = string(lim(1,1):lim(2,1))
        inquire (file=infile(j), exist=test)
        if (.not.test) call mio_err (6,mem(81),lmem(81),mem(88),
     %    lmem(88),' ',1,infile(j),80)
      end do
c ##A1,4##
c
c What type elements does the user want?
c ##A6,2##
      centre = 0
  45  read (10,'(a250)') string
      if (string(1:1).eq.')') goto 45
      call mio_spl (250,string,nsub,lim)
      if (lim(1,1).eq.-1) goto 45
c ##A9,5##
      c5 = string(lim(1,nsub):(lim(1,nsub)+4))
      if (c5(1:2).eq.'ce'.or.c5(1:2).eq.'CE'
     %  .or.c5(1:2).eq.'Ce') then
        centre = 0
      else if (c5(1:2).eq.'ba'.or.c5(1:2).eq.'BA'
     %  .or.c5(1:2).eq.'Ba') then
        centre = 1
      else if (c5(1:2).eq.'ja'.or.c5(1:2).eq.'JA'
     %  .or.c5(1:2).eq.'Ja') then
        centre = 2
c ##A7,3##
      else if (c5(1:2).eq.'sy'.or.c5(1:2).eq.'SY'
     %  .or.c5(1:2).eq.'Sy') then
        centre = 3
c ##A7,3##
      else if (c5(1:3).eq.'clo'.or.c5(1:3).eq.'CLO'
     %  .or.c5(1:3).eq.'Clo'.or.c5(1:2).eq.'CB'
     %  .or.c5(1:2).eq.'cb'.or.c5(1:2).eq.'Cb') then
        centre = 4
      else if (c5(1:3).eq.'wid'.or.c5(1:3).eq.'WID'
     %  .or.c5(1:3).eq.'Wid'.or.c5(1:2).eq.'WB'
     %  .or.c5(1:2).eq.'wb'.or.c5(1:2).eq.'Wb') then
        centre = 5
      else if (c5(1:4).eq.'sabp'.or.c5(1:4).eq.'SABP'
     %  .or.c5(1:4).eq.'Sabp'.or.c5(1:3).eq.'SAB'
     %  .or.c5(1:3).eq.'sab'.or.c5(1:3).eq.'Sab') then
        centre = 6
      else if (c5(1:4).eq.'uclo'.or.c5(1:4).eq.'UCLO'
     %  .or.c5(1:4).eq.'Uclo'.or.c5(1:3).eq.'UCB'
     %  .or.c5(1:3).eq.'ucb'.or.c5(1:3).eq.'Ucb') then
        centre = 7
      else if (c5.eq.'usabp'.or.c5.eq.'USABP'.or.c5.eq.'Usabp'
     %  .or.c5(1:4).eq.'USAB'.or.c5(1:4).eq.'usab'
     %  .or.c5(1:4).eq.'Usab') then
        centre = 7
      else if (c5(1:4).eq.'star'.or.c5(1:4).eq.'STAR'
     %  .or.c5(1:4).eq.'Star') then
        centre = 8
      else if (c5(1:3).eq.'ast'.or.c5(1:3).eq.'AST'
     %  .or.c5(1:3).eq.'Ast') then
        centre = 9
c ##A20,1##
      else if (c5(1:3).eq.'coo'.or.c5(1:3).eq.'COO'
     %  .or.c5(1:3).eq.'Coo') then
        centre = 10
c ##A20,1##
c ##A21,1##
      else if (c5(1:3).eq.'geo'.or.c5(1:3).eq.'GEO'
     %  .or.c5(1:3).eq.'Geo') then
        centre = 11
c ##A21,1##
      else
        call mio_err (6,mem(81),lmem(81),mem(107),lmem(107),
     %    mem(120),lmem(120),'       Check close.in',21)
c ##A9,5##
      end if
c ##A6,2##
c
      ce = 'b'
      ext = '.clo'
      list = 0
  41  read (10,'(a250)') string
      if (string(1:1).eq.')') goto 41
      call mio_spl (250,string,nsub,lim)
      if (lim(1,1).eq.-1) goto 41
      c1 = string(lim(1,nsub):lim(2,nsub))
      if (c1.eq.'y'.or.c1.eq.'Y') list = 1
c
  42  read (10,'(a250)') string
      if (string(1:1).eq.')') goto 42
      call mio_spl (250,string,nsub,lim)
      if (lim(1,1).eq.-1) goto 42
      c2 = string(lim(1,nsub):(lim(1,nsub)+1))
      if (c2.eq.'ce'.or.c2.eq.'CE'.or.c2.eq.'Ce') then
        ce = 'b'
        ext = '.clo'
        str = 'close'
      else if (c2.eq.'co'.or.c2.eq.'CO'.or.c2.eq.'Co') then
        ce = 'c'
        ext = '.col'
        str = 'collisions'
      else if (c2.eq.'ej'.or.c2.eq.'EJ'.or.c2.eq.'Ej') then
        ce = 'e'
        str = 'ejections'
        list = 1
      else if (c2.eq.'cb'.or.c2.eq.'CB'.or.c2.eq.'Cb') then
        ce = 'h'
        str = 'central'
        list = 1
c ##A11,1##
      else if (c2.eq.'pc'.or.c2.eq.'PC'.or.c2.eq.'Pc') then
        ce = 'd'
        ext = '.clc'
        str = 'prunecol'
      else if (c2.eq.'pe'.or.c2.eq.'PE'.or.c2.eq.'Pe') then
        ce = 'f'
        ext = '.cle'
        str = 'prunejec'
c ##A11,1##
c ##ANO16,1##
      else if (c2.eq.'ps'.or.c2.eq.'PS'.or.c2.eq.'Ps') then
        ce = 'p'
        ext = '.pss'
        str = 'pss'
c        list = 1
c ##ANO16,1##
c ##A24,1##
      else if (c2.eq.'ro'.or.c2.eq.'RO'.or.c2.eq.'Ro') then
        ce = 'r'
        str = 'breakup'
        list = 1
c ##A24,1##
      else
        call mio_err (6,mem(81),lmem(81),mem(108),lmem(108),
     %    mem(109),lmem(109),'       Check close.in',21)
      end if
c ##A1,4##
c
c Read parameters used by this programme
      timestyle = 1
c ##A13,2##
      timestyle2 = 0
c ##A13,2##
c ##A1,5##
c ##A23,2##
      opti(5) = 0
      do j = 1, 12
c ##A23,2##
c ##A1,5##
  50    read (10,'(a250)') string
        if (string(1:1).eq.')') goto 50
        call mio_spl (250,string,nsub,lim)
        if (lim(1,1).eq.-1) goto 50
        c1 = string(lim(1,nsub):lim(2,nsub))
c ##A23,3##
        if (j.eq.1.and.(c1.eq.'y'.or.c1.eq.'Y')) opti(5) = 1
        if (j.eq.2) then
          if (c1.eq.'b'.or.c1.eq.'h') then
            opti(2) = -2
          else if (c1.eq.'s'.or.c1.eq.'l') then
            opti(2) = -3
          else if (c1.eq.'a') then
            opti(2) = -4
          else if (c1.eq.'n') then
            opti(2) = -5
          else 
            call mio_spl2 (150,string,nsub,lim)
            c80 = string(lim(1,nsub-1):lim(2,nsub-1))
            read (c80,*) opti(1)
            c80 = string(lim(1,nsub):lim(2,nsub))
            read (c80,*) opti(2)
          end if
          opti(1) = abs(opti(1)) + 1
          opti(2) = opti(2) + 1
        end if
        if (j.eq.3) then
          if (c1.eq.'b'.or.c1.eq.'h') then
            opti(4) = -2
          else if (c1.eq.'s'.or.c1.eq.'l') then
            opti(4) = -3
          else if (c1.eq.'a') then
            opti(4) = -4
          else if (c1.eq.'n') then
            opti(4) = -5
          else 
            call mio_spl2 (150,string,nsub,lim)
            c80 = string(lim(1,nsub-1):lim(2,nsub-1))
            read (c80,*) opti(3)
            c80 = string(lim(1,nsub):lim(2,nsub))
            read (c80,*) opti(4)
          end if
          opti(3) = abs(opti(3)) + 1
          opti(4) = opti(4) + 1
        end if
c ##A23,3##
c ##A9,9##
        if (j.eq.4) then
          read (string(lim(1,nsub):lim(2,nsub)),*) nn
          nn = nn * DR / 365.25d0
        end if
c ##A17,1##
c        if (j.eq.2) then
c          read (string(lim(1,nsub):lim(2,nsub)),*) omega
c          omega = TWOPI / omega
c        end if
c ##A17,1##
        if (j.eq.5) read (string(lim(1,nsub):lim(2,nsub)),*) idc(1:8)
c ##A9,9##
c ##A4,2##
        if (j.eq.6) read (string(lim(1,nsub):lim(2,nsub)),*) ti
        if (j.eq.7) read (string(lim(1,nsub):lim(2,nsub)),*) tf
c ##A4,2##
c ##A3,3##
        if (j.eq.8) then
          read (string(lim(1,nsub):lim(2,nsub)),*) teval
          teval = abs(teval) * .999d0
        end if
c ##A3,3##
        if (j.eq.9.and.(c1.eq.'d'.or.c1.eq.'D')) timestyle = 0
        if (j.eq.10.and.(c1.eq.'y'.or.c1.eq.'Y')) timestyle =timestyle+2
c ##A13,3##
        if (j.eq.11.and.(c1.eq.'y'.or.c1.eq.'Y')) then
          if (timestyle.eq.2.or.timestyle.eq.0) timestyle2 = 1
          if (timestyle.eq.3.or.timestyle.eq.1) timestyle2 = 2
        end if
c ##A13,3##
c ##AN15,2##
c        if (j.eq.9) read (string(lim(1,nsub):lim(2,nsub)),*) K2
c        if (j.eq.10) read (string(lim(1,nsub):lim(2,nsub)),*) AU
c        if (j.eq.11) read (string(lim(1,nsub):lim(2,nsub)),*) MSUN
c ##AN15,2##

c ##A1,6##
c ##ANO16,14##
        if (j.eq.12) call m_format (string,timestyle,nel,iel,fout,
     %    header,lenhead,mem,lmem,ce,list)
c ##ANO16,14##
c ##A1,6##
      end do
c ##A4,3##
c      ti = abs(ti) * 0.999d0
c      tf = abs(tf) * 1.001d0
c ##A4,3##
c ##AN15,3##
c      rhocgs = AU * AU * AU * K2 / MSUN
c ##AN15,3##
c
c Read in the names of the objects for which orbital elements are required
      nopen = 0
      nwait = 0
      nmaster = 0
c ##A1,30##
c      call m_formce (timestyle,fout,header,lenhead)
      if (list.eq.1) then
        ext = '.dat'
        string = str
        call mio_spl (250,string,nsub,lim)
        goto 65
      end if
c ##A1,30##
  60  continue
        read (10,'(a250)',end=70) string
        call mio_spl (250,string,nsub,lim)
        if (string(1:1).eq.')'.or.lim(1,1).eq.-1) goto 60
c
c Either open an aei file for this object or put it on the waiting list
c ##A1,31##
  65    nmaster = nmaster + 1
c ##A1,31##
        itmp = min(7,lim(2,1)-lim(1,1))
        master_id(nmaster)='        '
        master_id(nmaster)(1:itmp+1) = string(lim(1,1):lim(1,1)+itmp)
        if (nopen.lt.NFILES) then
          nopen = nopen + 1
          master_unit(nmaster) = 10 + nopen
c ##A1,38##
          call mio_aei (master_id(nmaster),ext,master_unit(nmaster),
     %      header,lenhead,mem,lmem,ce,list)
c ##A1,38##
        else
          nwait = nwait + 1
          master_unit(nmaster) = -2
        end if
c ##A10,3##
        oid(1,nmaster) = string(lim(1,1):lim(1,1)+itmp)
        oid(2,nmaster)(1:8) = idc(1:8)
        itmp = min(7,lim(2,2)-lim(1,2))
        if (nsub.gt.1) oid(2,nmaster) = string(lim(1,2):lim(1,2)+itmp)
        oidcont = nmaster
c Check if another object has the same name
        do k = 1, nmaster - 1
          if (master_id(k).eq.master_id(nmaster)) call mio_err (6,
     %      mem(81),lmem(81),mem(103),lmem(103),master_id(nmaster),8,
     %      '       Check close.in',21)
        end do
c ##A10,3##
c ##A1,39##
      if (list.eq.0) then
        goto 60
      else if (list.eq.1) then
        goto 70
      end if
c ##A1,39##
c
  70  continue
c If no objects are listed in CLOSE.IN assume that all objects are required
      if (nopen.eq.0) allflag = 1
      close (10)
c
c------------------------------------------------------------------------------
c
c  LOOP  OVER  EACH  INPUT  FILE  CONTAINING  INTEGRATION  DATA
c
  90  continue
      firstflag = 0
c ##A13,4##
      flagstyle = 0
c ##A13,4##
c ##A3,4##
      nidt = 0
      do j = 1, NMAX
        tprev(j) = 0.d0
        stflag(j) = 0
      end do
c ##A3,4##
      do i = 1, ninfile
        line_num = 0
c ##A2,3##
        write (*,'(2a)') mem(204)(1:lmem(204)),infile(i)
c ##A2,3##
c ##A8,4##
        open (10, file=infile(i), status='old', access='sequential')
c ##A8,4##
c
c Loop over each time slice
 100    continue
c ##A8,5##
        nc = 0
c ##A8,5##
        line_num = line_num + 1
c ##A1,40##
c        read (10,'(3a1)',end=900,err=666) check,style,type
c ##A8,6##
c        read (10,'(2a1)',end=900,err=666) check,type
        read (10,'(a1)',end=900,eor=900,err=666,advance='no') check
        if (ichar(check).ne.12) then
          type = check
c ##A11,2##
c ##ANO16,2##
c ##A24,2##
          if ((type.ne.'b').and.(type.ne.'c').and.(type.ne.'d')
     %      .and.(type.ne.'f').and.(type.ne.'e')
     %      .and.(type.ne.'h').and.(type.ne.'p')
     %      .and.(type.ne.'r')) goto 666
c ##A24,2##
c ##ANO16,2##
c ##A11,2##
        else if (nst.lt.nstored) then
          nc = 1
          line_num = line_num - 1
          backspace 10
          do nct = 1, line_num + nc - 1
            read (10,'(a1)',advance='no') c1
          end do
          goto 666
        else
          line_num = line_num + 1
          read (10,'(a1)',end=666,eor=666,err=666,advance='no') type
        end if
c ##A1,40##
c        line_num = line_num - 1
c        backspace 10
c
c Check if this is an old style input file
c ##A1,41##
c        if (ichar(check).eq.12.and.(style.eq.'0'.or.style.eq.'1'.or.
c     %    style.eq.'2'.or.style.eq.'3'.or.style.eq.'4')) then
c          write (*,'(/,2a)') ' ERROR: This is an old style data file',
c     %      '        Try running m_close5.for instead.'
c          stop
c        end if
c        if (ichar(check).ne.12) then
c          goto 666
c        else if (type.eq.'a'.and.nst.lt.nstored) then
c          goto 666
c        end if
c ##A8,6##
c ##A1,41##
c
c------------------------------------------------------------------------------
c
c  IF  SPECIAL  INPUT,  READ  TIME,  PARAMETERS,  NAMES,  MASSES  ETC.
c
        if (type.eq.'a') then
c ##A8,7##
c          line_num = line_num + 1
c ##A8,7##
c ##A1,42##
          nst = 0
c          read (10,'(3x,i2,a62,i1)') algor,cc(1:62),precision
c ##A5,1##
c          read (10,'(2x,a62,i1)') cc(1:62),precision
c ##A8,8##
c          read (10,'(2x,i2,a65,i1)') algor,cc(1:65),precision
          do nc = 1, 2
            read (10,'(a1)',end=666,eor=666,err=666,advance='no')
     %        c2algor(nc:nc)
            if (ichar(c2algor(nc:nc)).eq.12) then
              backspace 10
              do nct = 1, line_num + nc - 1
                read (10,'(a1)',advance='no') c1
              end do
              goto 666
            end if
          end do
          line_num = line_num + nc - 1
          nc = 0
          read (c2algor,'(i2)',end=666,err=666) algor
c
c ##A17,2##
c ##AN15,5##
c          do nc = 1, 65
c          do nc = 1, 73
          do nc = 1, 97
c ##AN15,5##
c ##A17,2##
            read (10,'(a1)',end=666,eor=666,err=666,advance='no')
     %        cc(nc:nc)
            if (ichar(cc(nc:nc)).eq.12) then
              backspace 10
              do nct = 1, line_num + nc - 1
                read (10,'(a1)',advance='no') c1
              end do
              goto 666
            end if
          end do
          line_num = line_num + nc - 1
          nc = 0
          line_num = line_num + 1
          read (10,'(a1)',end=666,eor=666,err=666,advance='no')
     %      precision
          if (precision.eq.'1') then
            nchar = 2
          else if (precision.eq.'2') then
            nchar = 4
          else if (precision.eq.'3') then
            nchar = 7
          else if (ichar(precision).eq.12) then
            nc = 1
            line_num = line_num - 1
            backspace 10
            do nct = 1, line_num + nc - 1
              read (10,'(a1)',advance='no') c1
            end do
            goto 666
          else
            goto 666
          end if
c ##A8,8##
c ##A5,1##
c ##A1,42##
c
c Decompress the time, number of objects, central mass and J components etc.
c ##A1,47##
          time = mio_c2fl (cc(1:8),7)
c ##A1,47##
          if (firstflag.eq.0) then
c ##A13,5##
            if (flagstyle.eq.0) t0 = time
            if (timestyle2.eq.0) flagstyle = 1
c ##A13,5##
c ##A3,5##
c ##A4,7##
            firstflag = 1
c ##A4,7##
c ##A3,5##
          end if
          nbig = int(.5d0 + mio_c2re(cc(9:16), 0.d0, 11239424.d0, 3))
c ##A1,48##
c          nsml = int(.5d0 + mio_c2re(cc(12:19),0.d0, 11239424.d0, 3))
c ##A5,2##
c          nsml = 0
c          mcen = mio_c2fl (cc(15:22)) * K2
c          mcen = mio_c2fl (cc(12:19),7)
c          m(1) = mcen * K2
c          jcen(1) = mio_c2fl (cc(20:27),7)
c          jcen(2) = mio_c2fl (cc(28:35),7)
c          jcen(3) = mio_c2fl (cc(36:43),7)
c          rcen = mio_c2fl (cc(44:51),7)
c          rmax = mio_c2fl (cc(52:59),7)
c          nstored = int(.5d0+mio_c2re(cc(60:67),0.d0,11239424.d0,3))
          nsml = int(.5d0 + mio_c2re(cc(12:19),0.d0, 11239424.d0, 3))
          mcen = mio_c2fl (cc(15:22),7)
c          m(1) = mcen * K2
          jcen(1) = mio_c2fl (cc(23:30),7)
          jcen(2) = mio_c2fl (cc(31:38),7)
          jcen(3) = mio_c2fl (cc(39:46),7)
          rcen = mio_c2fl (cc(47:54),7)
          rmax = mio_c2fl (cc(55:62),7)
          nstored = int(.5d0+mio_c2re(cc(63:70),0.d0,11239424.d0,3))
c ##A17,3##
          omega = mio_c2fl (cc(66:73),7)
          omega = TWOPI / omega
c ##A17,3##
c ##A5,2##
c ##A1,48##
          rfac = log10 (rmax / rcen)
c ##AN15,6##
          K2   = mio_c2fl (cc(74:81),7)
          AU   = mio_c2fl (cc(82:89),7)
          MSUN = mio_c2fl (cc(90:97),7)
          rhocgs = AU * AU * AU * K2 / MSUN
          m(1) = mcen * K2
c ##AN15,6##
c
c ##A23,4##
          nbod = nbig + nsml
          nbod1 = nbod + 1
          nbig1 = nbig + 1
          if (opti(2).eq.-1) then
            opti(1) = 2
            opti(2) = nbig1
          else if (opti(2).eq.-2) then
            opti(1) = nbig1+1
            opti(2) = nbod1
          else if (opti(2).eq.-3) then
            opti(1) = 2
            opti(2) = nbod1
          else if (opti(2).eq.-4) then
            opti(1) = 1
            opti(2) = 1
          end if
          if (centre.ne.11) then
            opti(1) = 2
            opti(2) = nbod1
          end if
c
          if (opti(4).eq.-1) then
            opti(3) = 2
            opti(4) = nbig1
          else if (opti(4).eq.-2) then
            opti(3) = nbig1+1
            opti(4) = nbod1
          else if (opti(4).eq.-3) then
            opti(3) = 2
            opti(4) = nbod1
          else if (opti(4).eq.-4) then
            opti(3) = 1
            opti(4) = 1
          end if
c ##A23,4##
c
c Read in strings containing compressed data for each object
          do j = 1, nbig + nsml
c ##A8,9##
c            line_num = line_num + 1
c ##A1,49##
c            read (10,'(a)',err=666) c(j)(1:48)
c ##A1,49##
c ##A19,1##
c            do nc = 1, 48
            do nc = 1, 56
c ##A19,1##
              read (10,'(a1)',end=666,eor=666,err=666,advance='no')
     %          c(j)(nc:nc)
              if (ichar(c(j)(nc:nc)).eq.12) then
                backspace 10
                do nct = 1, line_num + nc - 1
                  read (10,'(a1)',advance='no') c1
                end do
                goto 666
              end if
            end do
            line_num = line_num + nc - 1
c ##A8,9##
          end do
c
c Create input format list
c ##A1,50##
c          if (precision.eq.1) nchar = 2
c          if (precision.eq.2) nchar = 4
c          if (precision.eq.3) nchar = 7
c ##A8,10##
c          if (precision.eq.1) then
c            nchar = 2
c          else if (precision.eq.2) then
c            nchar = 4
c          else if (precision.eq.3) then
c            nchar = 7
c          else
c            goto 666
c          end if
c ##A8,10##
          lenin = 16+13*nchar+1 - 1 - 1
          fin(1:9) = '(2x,a000)'
          if (lenin.lt.100) write (fin(7:8),'(i2)') lenin
          if (lenin.ge.100) write (fin(6:8),'(i3)') lenin
c
c ##A18,2##
c          lenin2 = 13+6*nchar - 1 - 1
c          lenin2 = 13+7*nchar - 1 - 1
          lenin2 = 16+6*nchar - 1 - 1
c ##A18,2##
          fin2(1:8) = '(2x,a00)'
          write (fin2(6:7),'(i2)') lenin2
c ##A1,50##
c
c For each object decompress its name, code number, mass, spin and density
          do j = 1, nbig + nsml
c ##A1,52##
c            k = int(.5d0 + mio_c2re(c(j)(1:8),0.d0,11239424.d0,3))
            k = j
            id(k) = c(j)(1:8)
c ##A10,18##
            if (list.eq.1) then
              oid(1,j) = id(k)(1:8)
              oid(2,j) = idc(1:8)
            end if
c ##A10,18##
c            m(k)  = mio_c2fl (c(j)(12:19)) * K2
            el(18,k) = mio_c2fl (c(j)(9:16),7)
            l = j + 1
            m(l) = el(18,k) * K2
            s(1) = mio_c2fl (c(j)(17:24),7)
            s(2) = mio_c2fl (c(j)(25:32),7)
            s(3) = mio_c2fl (c(j)(33:40),7)
            el(21,k) = mio_c2fl (c(j)(41:48),7)
c ##A19,2##
            el(36,k) = int(.5d0 + mio_c2re(c(j)(49:56),0.d0,
     %        11239424.d0,3))*1.d0
c ##A19,2##
c
c Calculate spin rate and longitude & inclination of spin vector
            temp = sqrt(s(1)*s(1) + s(2)*s(2) + s(3)*s(3))
            if (temp.gt.0) then
              call mce_spin (1.d0,el(18,k)*K2,temp*K2,el(21,k)*
     %            rhocgs,el(20,k))
              temp = s(3) / temp
              if (abs(temp).lt.1) then
                is(k) = acos (temp)
                ns(k) = atan2 (s(1), -s(2))
              else
                if (temp.gt.0) is(k) = 0.d0
                if (temp.lt.0) is(k) = PI
                ns(k) = 0.d0
              end if
            else
              el(20,k) = 0.d0
              is(k) = 0.d0
              ns(k) = 0.d0
            end if
c ##A1,52##
c
c Find the object on the master list
            unit(k) = 0
            do l = 1, nmaster
              if (id(k).eq.master_id(l)) unit(k) = master_unit(l)
            end do
c ##A1,54##
            if (list.eq.1) unit(k) = master_unit(nmaster)
c ##A1,54##
c
c If object is not on the master list, add it to the list now
            if (unit(k).eq.0) then
              nmaster = nmaster + 1
              master_id(nmaster) = id(k)
c
c Either open an aei file for this object or put it on the waiting list
              if (allflag.eq.1) then
                if (nopen.lt.NFILES) then
                  nopen = nopen + 1
                  master_unit(nmaster) = 10 + nopen
c ##A1,55##
                  call mio_aei (master_id(nmaster),ext,
     %              master_unit(nmaster),header,lenhead,mem,lmem,ce,
     %              list)
c ##A1,55##
                else
                  nwait = nwait + 1
                  master_unit(nmaster) = -2
                end if
              else
                master_unit(nmaster) = -1
              end if
              unit(k) = master_unit(nmaster)
            end if
          end do
c ##A10,5##
          nbod = nbig + nsml
          if (list.eq.1) oidcont = nbod
          if (firstflag.eq.1) call orb_verif2 (nbod,oidcont,id,
     %      oid,idc,icen,lmem,mem)
c ##A10,5##
c ##A2,4##
          if (nopen2.eq.0) then
            write (*,'(2(a,i7))') mem(206)(1:lmem(206)),nopent+1,
     %        mem(207)(1:lmem(207)),nopen
            nopent = nopen
          end if
          if (nopen.ge.NFILES.or.list.eq.1) nopen2 = 1
c ##A2,4##
c
c------------------------------------------------------------------------------
c
c  IF  NORMAL  INPUT,  READ  COMPRESSED  DATA  ON  THE  CLOSE  ENCOUNTER
c
c ##A1,56##
c ##A11,3##
        else if (((type.eq.'b'.or.type.eq.'c').or.(type.eq.'d'
     %    .or.type.eq.'f')).and.type.eq.ce) then
c ##A11,3##
c ##A1,56##
c ##A8,11##
c          line_num = line_num + 1
c ##A8,11##
c ##A1,57##
          nst = nst + 1
c          read (10,'(3x,a70)',err=666) cc(1:70)
c ##A8,12##
c          read (10,fin,err=666) cc(1:lenin)
          do nc = 1, lenin
            read (10,'(a1)',end=666,eor=666,err=666,advance='no')
     %        cc(nc:nc)
            if (ichar(cc(nc:nc)).eq.12) then
              backspace 10
              do nct = 1, line_num + nc - 1
                read (10,'(a1)',advance='no') c1
              end do
              goto 666
            end if
          end do
          line_num = line_num + nc - 1
c ##A8,12##
c ##A1,57##
c
c Decompress time, distance and orbital variables for each object
c ##A1,58##
          time = mio_c2fl (cc(1:8),7)
c ##A1,58##
c ##A13,6##
          if (firstflag.eq.1) then
            if (flagstyle.eq.0) t0 = time
            if (timestyle2.eq.0) flagstyle = 1
          end if
c ##A13,6##
          iclo = int(.5d0 + mio_c2re(cc(9:16),  0.d0, 11239424.d0, 3))
          jclo = int(.5d0 + mio_c2re(cc(12:19), 0.d0, 11239424.d0, 3))
c ##A3,7##
          call idbcloo (nidt,idt,id(iclo),ind(1))
          call idbcloo (nidt,idt,id(jclo),ind(2))
c ##A3,7##
          if (iclo.gt.NMAX.or.jclo.gt.NMAX) then
            write (*,'(/,2a)') mem(81)(1:lmem(81)),
     %        mem(90)(1:lmem(90))
            stop
          end if
c ##A1,59##
c
          dclo = mio_c2fl (cc(15:22),nchar)
c
c------------------------------------------------------------------------------
c
          l = iclo + 1
          k = l - 1
c ##A12,11##
          l0 = l
          k0 = k
c ##A12,11##
          ijclo(1) = k
          el(22,k) = dclo
          fr     = mio_c2re (cc(15+  nchar+1:22+  nchar+1), 0.d0, rfac,
     %    nchar)
          theta  = mio_c2re (cc(15+2*nchar+1:22+2*nchar+1), 0.d0, PI,
     %    nchar)
          phi    = mio_c2re (cc(15+3*nchar+1:22+3*nchar+1), 0.d0,
     %    TWOPI, nchar)
          fv     = mio_c2re (cc(15+4*nchar+1:22+4*nchar+1), 0.d0, 1.d0,
     %    nchar)
          vtheta = mio_c2re (cc(15+5*nchar+1:22+5*nchar+1), 0.d0, PI,
     %    nchar)
          vphi   = mio_c2re (cc(15+6*nchar+1:22+6*nchar+1), 0.d0, TWOPI,
     %    nchar)
          call mco_ov2x (rcen,rmax,m(1),m(l),fr,theta,phi,fv,
     %      vtheta,vphi,x(1,l),x(2,l),x(3,l),v(1,l),v(2,l),v(3,l))
            el(16,k) = sqrt(x(1,l)*x(1,l) + x(2,l)*x(2,l)
     %                     + x(3,l)*x(3,l))
c
c------------------------------------------------------------------------------
c
          l = jclo + 1
          k = l - 1
c ##A12,12##
          l1 = l
          k1 = k
c ##A12,12##
          ijclo(2) = k
          el(22,k) = dclo
          fr     = mio_c2re (cc(15+7*nchar+1:22+7*nchar+1), 0.d0, rfac,
     %    nchar)
          theta  = mio_c2re (cc(15+8*nchar+1:22+8*nchar+1), 0.d0, PI,
     %    nchar)
          phi    = mio_c2re (cc(15+9*nchar+1:22+9*nchar+1), 0.d0, TWOPI,
     %    nchar)
          fv     = mio_c2re (cc(15+10*nchar+1:22+10*nchar+1),0.d0, 1.d0,
     %    nchar)
          vtheta = mio_c2re (cc(15+11*nchar+1:22+11*nchar+1), 0.d0, PI,
     %    nchar)
          vphi   = mio_c2re (cc(15+12*nchar+1:22+12*nchar+1),0.d0,TWOPI,
     %    nchar)
          call mco_ov2x (rcen,rmax,m(1),m(l),fr,theta,phi,fv,
     %      vtheta,vphi,x(1,l),x(2,l),x(3,l),v(1,l),v(2,l),v(3,l))
            el(16,k) = sqrt(x(1,l)*x(1,l) + x(2,l)*x(2,l)
     %                     + x(3,l)*x(3,l))
c
c ##A12,13##
c Calculate the Hill radii
          call mce_hill (m(1),m(l0),x(1,l0),x(2,l0),x(3,l0),v(1,l0),
     %      v(2,l0),v(3,l0),el(23,k0),a(l0))
          call mce_hill (m(1),m(l1),x(1,l1),x(2,l1),x(3,l1),v(1,l1),
     %      v(2,l1),v(3,l1),el(23,k1),a(l1))
c Determine the physical radii
          el(24,k0) = el(23,k0)/a(l0)*((2.25d0*m(1)/PI)
     %      /(el(21,k0)*rhocgs))**THIRD
          if (el(24,k0).eq.0.d0) el(24,k0) = el(21,k0)
     %      / AU
          el(24,k1) = el(23,k1)/a(l1)*((2.25d0*m(1)/PI)
     %      /(el(21,k1)*rhocgs))**THIRD
          if (el(24,k1).eq.0.d0) el(24,k1) = el(21,k1)
     %      / AU
c Calculate Relative Position and Velocity
          el(26,k0) = x(1,l0) - x(1,l1)
          el(27,k0) = x(2,l0) - x(2,l1)
          el(28,k0) = x(3,l0) - x(3,l1)
          el(29,k0) = v(1,l0) - v(1,l1)
          el(30,k0) = v(2,l0) - v(2,l1)
          el(31,k0) = v(3,l0) - v(3,l1)
          el(26,k1) = -el(26,k0)
          el(27,k1) = -el(27,k0)
          el(28,k1) = -el(28,k0)
          el(29,k1) = -el(29,k0)
          el(30,k1) = -el(30,k0)
          el(31,k1) = -el(31,k0)
c Determine magnitude of relative velocity
          el(32,k0) = sqrt(el(29,k0)*el(29,k0) + el(30,k0)*el(30,k0)
     %      + el(31,k0)*el(31,k0))
          el(32,k1) = el(32,k0)
c Determine magnitude of relative position
          el(34,k0) = sqrt(el(26,k0)*el(26,k0) + el(27,k0)*el(27,k0)
     %      + el(28,k0)*el(28,k0))
          el(34,k1) = el(34,k0)
c Determine the impact parameter
          vec(1) = el(27,k0) * el(31,k0) - el(28,k0) * el(30,k0)
          vec(2) = el(28,k0) * el(29,k0) - el(26,k0) * el(31,k0)
          vec(3) = el(26,k0) * el(30,k0) - el(27,k0) * el(29,k0)
          ncross = sqrt(vec(1)*vec(1) + vec(2)*vec(2) +
     %      vec(3)*vec(3))
          el(25,k0) = ncross / (el(32,k0) * el(34,k0))
          el(25,k1) = el(25,k0)
c Calculate the impact angle
          el(33,k0) = asin( ncross / (el(34,k0) * el(32,k0))) / DR
          el(33,k1) = el(33,k0)
c ##A12,13##
c ##A10,12##
          x(1,1) = 0.d0
          x(2,1) = 0.d0
          x(3,1) = 0.d0
          v(1,1) = 0.d0
          v(2,1) = 0.d0
          v(3,1) = 0.d0
c ##A10,12##
c
c Convert to barycentric, Jacobi or close-binary coordinates if desired
c ##A6,3##
          nbod1 = nbig + nsml + 1
          nbig1 = nbig + 1
          call mco_iden (jcen,nbod1,nbig1,temp,m,x,v,xh,vh)
c ##A21,5##
c          if (centre.eq.1.or.centre.eq.11) call mco_h2b (jcen,nbod1,
c     %      nbig1,temp,m,xh,vh,x,v)
          if (centre.eq.1.or.centre.eq.11) call mco_h2b3 (jcen,nbod1,
     %      nbig1,temp,m,xh,vh,x,v,opti(3),opti(4))
c ##A21,5##
          if (centre.eq.2) call mco_h2j (jcen,nbod1,nbig1,temp,m,xh,vh,
     %      x,v)
c ##A9,6##
          if (centre.eq.4) call mco_h2cb (jcen,nbod1,nbig1,temp,m,xh,vh,
     %      x,v)
c ##A6,3##
c ##A7,4##
          if (centre.eq.3) then
c            call mco_h2b (jcen,nbod1,nbig1,temp,m,xh,vh,x,v)
            call mco_h2b3 (jcen,nbod1,nbig1,temp,m,xh,vh,x,v,
     %        opti(3),opti(4))
            call mco_iden (jcen,nbod1,nbig1,temp,m,x,v,xh,vh)
            itmp = 2
            if (algor.eq.11) itmp = 3
            if (algor.eq.5) itmp = 4
            call mco_h2syn (itmp,synflag,time,nbod1,m,xh,vh,x,v,nn)
          end if
c ##A7,4##
          if (centre.eq.5) call mco_h2wb (jcen,nbod1,nbig1,temp,m,xh,vh,
     %      x,v)
          if (centre.eq.6) call mco_h2sabp (jcen,nbod1,nbig1,temp,m,
     %      xh,vh,x,v)
          if (centre.eq.7.or.centre.eq.8) call mco_h2ub (algor,jcen,
     %      nbod1,nbig1,temp,m,xh,vh,x,v)
          if (centre.eq.9) call mco_h2ast (time,jcen,nbod1,nbig1,
     %      omega,m,xh,vh,x,v)
c ##A9,6##
c ##A10,8##
          nbod = nbod1 - 1
          call mco_iden (jcen,nbod1,nbig1,temp,m,x,v,xh,vh)
c ##A10,8##
c
c Put Cartesian coordinates into element arrays
          do j = 1, 2
c            k = code(j)
            k = ijclo(j)
            l = k + 1
c ##A20,2##
            el(37,k) = 0.d0
            call orb_oi2 (j,nbod,oidcont,icen,id,oid,idc,oi,flagorb)
            if (centre.eq.10.and.oi.ne.1) then
              phi = mod(atan2(xh(2,l),xh(1,l)), TWOPI) -
     %          mod(atan2(xh(2,oi),xh(1,oi)), TWOPI)
              r   = dsqrt(xh(1,l)*xh(1,l)+xh(2,l)*xh(2,l))
              call mco_sine (phi,sg,cg)
              x(1,l) = r*cg
              x(2,l) = r*sg
              x(3,l) = xh(3,l)
              v(1,l) = vh(1,l)
              v(2,l) = vh(2,l)
              v(3,l) = vh(3,l)
              el(37,k) = phi / DR
            else
c ##A10,9##
c              call orb_oi2 (j,nbod,oidcont,icen,id,oid,idc,oi,flagorb)
              call mco_x2orb (j,nbod,flagorb,oi,xh,vh,x,v)
c              if (oi.ne.1) mcen = el(18,oi-1)
c ##A10,9##
            end if
            if (oi.ne.1) mcen = el(18,oi-1)
c ##A20,2##
            el(10,k) = x(1,l)
            el(11,k) = x(2,l)
            el(12,k) = x(3,l)
            el(13,k) = v(1,l)
            el(14,k) = v(2,l)
            el(15,k) = v(3,l)
c
c Convert to Keplerian orbital elements
            gm = (mcen + el(18,k)) * K2
c ##A9,10##
c ##A10,10##
            if (oi.eq.1) then
c ##A10,10##
              msum = 0.d0
c
              if (centre.eq.8) then
                msum = gm
                if ((algor.eq.11.or.algor.eq.5)
     %            .and.l.ne.2) msum = msum + m(2)
                if (algor.eq.5.and.l.eq.2) then
                  msum = m(1)**3 / (m(1) + m(2))**2
                end if
                if (algor.eq.5.and.l.eq.3) then
                  do i0 = 4, nbod1
                    msum = msum + m(i0)
                  end do
                end if
                if (algor.eq.12.and.l.eq.2) then
                  do i0 = 3, nbod1
                    msum = msum + m(i0)
                  end do
                end if
                gm = msum
              end if
c
              if (centre.eq.4) then
                gm = gm + m(2)
                if (l.eq.2) gm = m(1) * m(1) / (m(1) + m(2))
              end if
              if (centre.eq.5.and.l.eq.2) then
                do i0 = 3, nbod1
                  msum = msum + m(i0)
                end do
                gm = (m(1) + msum) * (m(1) + msum) / (m(1) +
     %          msum + m(2)) 
              end if
              if (centre.eq.6) then
                gm = gm + m(2)
                if (l.eq.2) gm = m(1) * m(1) / (m(1) + m(2))
                if (l.eq.3) then
                  do i0 = 4, nbod1
                    msum = msum + m(i0)
                  end do
                  gm = (m(1) + m(2) + msum) * (m(1) + m(2) +
     %            msum) / (m(1) + m(2) + m(3) + msum)
                end if
              end if
c ##A10,11##
            end if
c ##A10,11##
c ##A9,10##
c ##A21,2##
            if (centre.ne.11) then
              call mco_x2el (gm,el(10,k),el(11,k),el(12,k),el(13,k),
     %          el(14,k),el(15,k),el(8,k),el(2,k),el(3,k),el(7,k),
     %          el(5,k),el(6,k))
            else if (centre.eq.11) then
c ##A23,5##
            if ((l.ge.opti(1).and.l.le.opti(2))
     %        .and.(dabs(jcen(1)).ge.EPS.or.dabs(jcen(2)).ge.EPS
     %        .or.dabs(jcen(3)).ge.EPS)) then
c ##A23,5##
            obla(1) = gm
            obla(2) = jcen(1) * rcen * rcen
            obla(3) = jcen(2) * rcen * rcen * rcen * rcen
            obla(4) = jcen(3) * rcen * rcen * rcen * rcen * rcen * rcen
            icoor(1) = el(10,k)
            icoor(2) = el(11,k)
            icoor(3) = el(12,k)
            icoor(4) = el(13,k)
            icoor(5) = el(14,k)
            icoor(6) = el(15,k)
            call car_geo (obla,icoor,ocoor,mem,lmem,id(k),opti(5))
            el(8,k) = ocoor(1) * (1.d0 - ocoor(2))
            el(2,k) = ocoor(2)
            el(3,k) = ocoor(3)
            el(7,k) = ocoor(4) + ocoor(5)
            el(5,k) = ocoor(5)
            el(6,k) = ocoor(6)
c ##A23,6##
            else
              call mco_x2el (gm,el(10,k),el(11,k),el(12,k),el(13,k),
     %          el(14,k),el(15,k),el(8,k),el(2,k),el(3,k),el(7,k),
     %          el(5,k),el(6,k))
            end if
c ##A23,6##
            end if
c ##A21,2##
            el(1,k) = el(8,k) / (1.d0 - el(2,k))
            el(9,k) = el(1,k) * (1.d0 + el(2,k))
            el(4,k) = mod(el(7,k) - el(5,k) + TWOPI, TWOPI)
c Calculate true anomaly
            if (el(2,k).eq.0) then
              el(17,k) = el(6,k)
            else
              temp = (el(8,k)*(1.d0 + el(2,k))/el(16,k) - 1.d0) /el(2,k)
              temp = sign (min(abs(temp), 1.d0), temp)
              el(17,k) = acos(temp)
              if (sin(el(6,k)).lt.0) el(17,k) = TWOPI - el(17,k)
            end if
c Calculate obliquity
            el(19,k) = acos (cos(el(3,k))*cos(is(k))
     %        + sin(el(3,k))*sin(is(k))*cos(ns(k) - el(5,k)))
c
c ##A22,8##
            if (el(3,k).lt.0.5d0*PI) eq =  1.0
            if (el(3,k).ge.0.5d0*PI) eq = -1.0
            varpi0 =mod(el(7,k) - el(5,k) + eq * el(5,k) + TWOPI, TWOPI)
c            varpi  = atan2(sin(varpi0),cos(varpi0))
            varpi = varpi0
            if (el(2,k).lt.3.d-8) then
              el(38,k) = 1.d0 * sin (varpi)
              el(39,k) = 1.d0 * cos (varpi)
            else
              el(38,k) = el(2,k) * sin (varpi)
              el(39,k) = el(2,k) * cos (varpi)
            end if
            el(40,k) = tan(el(3,k)*0.5d0)**eq * sin (el(5,k))
            el(41,k) = tan(el(3,k)*0.5d0)**eq * cos (el(5,k))
            el(42,k) = mod(el(6,k) + varpi0 + TWOPI, TWOPI)
            el(43,k) = el(8,k) * cos(el(42,k))
            el(44,k) = el(8,k) * sin(el(42,k))
c ##A22,8##
c
c Convert angular elements from radians to degrees
            do l = 3, 7
              el(l,k) = mod(el(l,k) / DR, 360.d0)
            end do
            el(17,k) = el(17,k) / DR
            el(19,k) = el(19,k) / DR
c ##A22,9##
            el(42,k) = el(42,k) / DR
c ##A22,9##
          end do
c
c Convert to Keplerian elements
c          gm = mcen + m(iclo)
c          call mco_x2el (gm,x1(1),x1(2),x1(3),v1(1),v1(2),v1(3),
c     %      q1,e1,i1,p1,n1,l1)
c          a1 = q1 / (1.d0 - e1)
c          gm = mcen + m(jclo)
c          call mco_x2el (gm,x2(1),x2(2),x2(3),v2(1),v2(2),v2(3),
c     %      q2,e2,i2,p2,n2,l2)
c          a2 = q2 / (1.d0 - e2)
c          i1 = i1 / DR
c          i2 = i2 / DR
c ##A1,59##
c
c Convert time to desired format
          if (timestyle.eq.0) t1 = time
          if (timestyle.eq.1) call mio_jd_y (time,year,month,t1)
c ##A13,7##
          if (timestyle.eq.2.or.timestyle2.eq.1) t1=time-t0
          if (timestyle.eq.3.or.timestyle2.eq.2) t1=(time-t0)/365.25d0
c ##A13,7##
c ##A4,8##
          ti2 = ti
          tf2 = tf
          if (ti.gt.0.and.tf.lt.0.or.ti.lt.0.and.tf.gt.0) then
            ti2 = ti
            tf2 = 0
            if (time*sign(1.d0,tf-ti).gt.0) then
              ti2 = 0
              tf2 = tf
            end if
          end if
c
          if (abs(tf2)-abs(ti2).gt.0) then
            ti2 = ti2 * 0.99999999d0
            tf2 = tf2 * 1.00000001d0
          else
            ti2 = ti2 * 1.00000001d0
            tf2 = tf2 * 0.99999999d0
          end if
c ##A4,8##
c
c ##A1,61##
c
c Write required elements to the appropriate clo file
          jiclo(1) = ijclo(2)
          jiclo(2) = ijclo(1)
          if (list.eq.0) then
            i3 = 1
          else if (list.eq.1) then
            i3 = 2
          end if
          do j = i3, 2
            i1 = ijclo(j)
            i2 = jiclo(j)
            if (list.eq.0) then
c ##A3,8##
c ##A4,4##
c              if (stflag(ind(j)).eq.0.or.(abs(time-tprev(ind(j))))
c     %          .ge.teval) then
              if ((time*sign(1.d0,tf2-ti2).ge.ti2*sign(1.d0,tf2-ti2)
     %          .and.time*sign(1.d0,tf2-ti2).le.tf2*sign(1.d0,tf2-ti2))
     %          .and.((stflag(ind(j)).eq.0)
     %          .or.(abs(time-tprev(ind(j))).ge.teval))) then
                stflag(ind(j)) = 1
c ##A4,4##
                tprev(ind(j)) = time
c ##A3,8##
                if (unit(i1).ge.10) then
                  if (timestyle.eq.1) then
                    write (unit(i1),fout) year,month,t1,id(i2),
     %                (el(iel(l),i2),l=1,nel),id(i1),(el(iel(l),i1),
     %                l=1,nel)
                  else
                    write (unit(i1),fout) t1,id(i2),
     %                (el(iel(l),i2),l=1,nel),id(i1),(el(iel(l),i1),
     %                l=1,nel)
                  end if
                end if
c ##A3,9##
              end if
c ##A3,9##
            else if (list.eq.1) then
c ##A3,10##
c ##A4,5##
c              if (firstflag.eq.0.or.abs(time-tprevious).ge.teval) then
                if ((time*sign(1.d0,tf2-ti2).ge.ti2*sign(1.d0,tf2-ti2)
     %          .and.time*sign(1.d0,tf2-ti2).le.tf2*sign(1.d0,tf2-ti2))
     %          .and.((firstflag.eq.1)
     %          .or.(abs(time-tprevious).ge.teval))) then
                firstflag = 2
c ##A4,5##
                tprevious = time
c ##A3,10##
                if (unit(i1).ge.10) then
                  if (timestyle.eq.1) then
                    write (unit(i1),fout) year,month,t1,id(i2),
     %                (el(iel(l),i2),l=1,nel),id(i1),(el(iel(l),i1),
     %                l=1,nel)
                  else
                    write (unit(i1),fout) t1,id(i2),
     %                (el(iel(l),i2),l=1,nel),id(i1),(el(iel(l),i1),
     %                l=1,nel)
                  end if
                end if
c ##A3,11##
              end if
c ##A3,11##
            end if
          end do
c
c Write encounter details to appropriate files
c          if (timestyle.eq.1) then
c            if (unit(iclo).ge.10) write (unit(iclo),fout) year,month,
c     %        t1,id(jclo),dclo,a1,e1,i1,a2,e2,i2
c
c            if (unit(jclo).ge.10) write (unit(jclo),fout) year,month,
c     %        t1,id(iclo),dclo,a2,e2,i2,a1,e1,i1
c          else
c            if (unit(iclo).ge.10) write (unit(iclo),fout) t1,id(jclo),
c     %        dclo,a1,e1,i1,a2,e2,i2
c            if (unit(jclo).ge.10) write (unit(jclo),fout) t1,id(iclo),
c     %        dclo,a2,e2,i2,a1,e1,i1
c          end if
c
c ##ANO16,3##
c ##A24,3##
        else if ((type.eq.'e'.or.type.eq.'h'.or.type.eq.'p'
     %    .or.type.eq.'r').and.type.eq.ce) then
c ##A24,3##
c ##ANO16,3##
c ##A8,13##
c          line_num = line_num + 1
c ##A8,13##
          nst = nst + 1
c ##A8,14##
c          read (10,fin2,err=666) cc(1:lenin2)
          do nc = 1, lenin2
            read (10,'(a1)',end=666,eor=666,err=666,advance='no')
     %        cc(nc:nc)
            if (ichar(cc(nc:nc)).eq.12) then
              backspace 10
              do nct = 1, line_num + nc - 1
                read (10,'(a1)',advance='no') c1
              end do
              goto 666
            end if
          end do
          line_num = line_num + nc - 1
c ##A8,14##
c
c Decompress time, distance and orbital variables for each object
          time = mio_c2fl (cc(1:8),7)
          jclo = int(.5d0 + mio_c2re(cc(9:16), 0.d0, 11239424.d0, 3))
          if (jclo.gt.NMAX) then
            write (*,'(/,2a)') mem(81)(1:lmem(81)),
     %        mem(90)(1:lmem(90))
            stop
          end if
c ##A18,10##
          face = int(.5d0 + mio_c2re(cc(12:19), 0.d0, 11239424.d0, 3))
c ##A18,10##
          l = jclo + 1
          k = l - 1
          ijclo(2) = k
          dclo = 0.d0
          el(22,k) = dclo
c ##A18,11##
c ##E2,1##
c          fr     = mio_c2re (cc(12:19), 0.d0,log10(HUGE/TINY),
c     %    nchar)
c ##E3,1##
c          fr     = mio_c2re (cc(15:22), 0.d0,log10(HUGE/TINY),
c     %    nchar)
          fr     = mio_c2re (cc(15:22), 0.d0,rfac,nchar)
c ##E3,1##
c ##E2,1##
c          theta  = mio_c2re (cc(12+  nchar:19+  nchar), 0.d0, PI,
c     %    nchar)
c          phi    = mio_c2re (cc(12+2*nchar:19+2*nchar), 0.d0,
c     %    TWOPI, nchar)
c          fv     = mio_c2re (cc(12+3*nchar:19+3*nchar), 0.d0, 1.d0,
c     %    nchar)
c          vtheta = mio_c2re (cc(12+4*nchar:19+4*nchar), 0.d0, PI,
c     %    nchar)
c          vphi   = mio_c2re (cc(12+5*nchar:19+5*nchar), 0.d0, TWOPI,
c     %    nchar)
c
          theta  = mio_c2re (cc(15+  nchar:22+  nchar), 0.d0, PI,
     %    nchar)
          phi    = mio_c2re (cc(15+2*nchar:22+2*nchar), 0.d0,
     %    TWOPI, nchar)
          fv     = mio_c2re (cc(15+3*nchar:22+3*nchar), 0.d0, 1.d0,
     %    nchar)
          vtheta = mio_c2re (cc(15+4*nchar:22+4*nchar), 0.d0, PI,
     %    nchar)
          vphi   = mio_c2re (cc(15+5*nchar:22+5*nchar), 0.d0, TWOPI,
     %    nchar)
c ##E2,2##
c ##E3,2##
c          call mco_ov2x (TINY,HUGE,m(1),m(l),fr,theta,phi,fv,
c     %      vtheta,vphi,x(1,l),x(2,l),x(3,l),v(1,l),v(2,l),v(3,l))
c            el(16,k) = sqrt(x(1,l)*x(1,l) + x(2,l)*x(2,l)
c     %                     + x(3,l)*x(3,l))
          call mco_ov2x (rcen,rmax,m(1),m(l),fr,theta,phi,fv,
     %      vtheta,vphi,x(1,l),x(2,l),x(3,l),v(1,l),v(2,l),v(3,l))
            el(16,k) = sqrt(x(1,l)*x(1,l) + x(2,l)*x(2,l)
     %                     + x(3,l)*x(3,l))
c ##E3,2##
c ##E2,2##
c ##A18,11##
c
          el(22,k) = el(16,k)
c
c ##A18,3##
c          face = int(.5d0 + mio_c2re(cc(12+6*nchar:19+6*nchar), 0.d0,
c     %      11239424.d0, 3))
          el(35,k) = face*1.d0
c ##A18,3##
c ##A12,14##
c Calculate the Hill radii
          call mce_hill (m(1),m(l),x(1,l),x(2,l),x(3,l),v(1,l),
     %      v(2,l),v(3,l),el(23,k),a(l))
c Determine the physical radii
          el(24,k) = el(23,k)/a(l)*((2.25d0*m(1)/PI)
     %      /(el(21,k)*rhocgs))**THIRD
          if (el(24,k).eq.0.d0) el(24,k) = el(21,k)
     %      / AU
c ##A12,14##
c ##A10,17##
          x(1,1) = 0.d0
          x(2,1) = 0.d0
          x(3,1) = 0.d0
          v(1,1) = 0.d0
          v(2,1) = 0.d0
          v(3,1) = 0.d0
c ##A10,17##
c
c Convert to barycentric, Jacobi or close-binary coordinates if desired
c ##A6,4##
          nbod1 = nbig + nsml + 1
          nbig1 = nbig + 1
          call mco_iden (jcen,nbod1,nbig1,temp,m,x,v,xh,vh)
c ##A21,6##
c          if (centre.eq.1.or.centre.eq.11) call mco_h2b (jcen,nbod1,
c     %      nbig1,temp,m,xh,vh,x,v)
          if (centre.eq.1.or.centre.eq.11) call mco_h2b3 (jcen,nbod1,
     %      nbig1,temp,m,xh,vh,x,v,opti(3),opti(4))
c ##A21,6##
          if (centre.eq.2) call mco_h2j (jcen,nbod1,nbig1,temp,m,xh,vh,
     %      x,v)
c ##A9,7##
          if (centre.eq.4) call mco_h2cb (jcen,nbod1,nbig1,temp,m,xh,vh,
     %      x,v)
c ##A6,4##
c ##A7,5##
          if (centre.eq.3) then
c            call mco_h2b (jcen,nbod1,nbig1,temp,m,xh,vh,x,v)
            call mco_h2b3 (jcen,nbod1,nbig1,temp,m,xh,vh,x,v,
     %        opti(3),opti(4))
            call mco_iden (jcen,nbod1,nbig1,temp,m,x,v,xh,vh)
            itmp = 2
            if (algor.eq.11) itmp = 3
            if (algor.eq.5) itmp = 4
            call mco_h2syn (itmp,synflag,time,nbod1,m,xh,vh,x,v,nn)
          end if
c ##A7,5##
          if (centre.eq.5) call mco_h2wb (jcen,nbod1,nbig1,temp,m,xh,vh,
     %      x,v)
          if (centre.eq.6) call mco_h2sabp (jcen,nbod1,nbig1,temp,m,
     %      xh,vh,x,v)
          if (centre.eq.7.or.centre.eq.8) call mco_h2ub (algor,jcen,
     %      nbod1,nbig1,temp,m,xh,vh,x,v)
c ##ANO16,7##
          if (centre.eq.9) call mco_h2ast (time,jcen,nbod1,nbig1,
     %      omega,m,xh,vh,x,v)
c ##ANO16,7##
c ##A9,7##
c ##A10,13##
          nbod = nbod1 - 1
          call mco_iden (jcen,nbod1,nbig1,temp,m,x,v,xh,vh)
c ##A10,13##
c
c Put Cartesian coordinates into element arrays
          do j = 2, 2
            k = ijclo(j)
            l = k + 1
c ##A20,3##
            el(37,k) = 0.d0
            call orb_oi2 (j,nbod,oidcont,icen,id,oid,idc,oi,flagorb)
            if (centre.eq.10.and.oi.ne.1) then
              phi = mod(atan2(xh(2,l),xh(1,l)), TWOPI) -
     %          mod(atan2(xh(2,oi),xh(1,oi)), TWOPI)
              r   = dsqrt(xh(1,l)*xh(1,l)+xh(2,l)*xh(2,l))
              call mco_sine (phi,sg,cg)
              x(1,l) = r*cg
              x(2,l) = r*sg
              x(3,l) = xh(3,l)
              v(1,l) = vh(1,l)
              v(2,l) = vh(2,l)
              v(3,l) = vh(3,l)
              el(37,k) = phi / DR
            else
c ##A10,14##
c              call orb_oi2 (j,nbod,oidcont,icen,id,oid,idc,oi,flagorb)
              call mco_x2orb (j,nbod,flagorb,oi,xh,vh,x,v)
c              if (oi.ne.1) mcen = el(18,oi-1)
c ##A10,14##
            end if
            if (oi.ne.1) mcen = el(18,oi-1)
c ##A20,3##
            el(10,k) = x(1,l)
            el(11,k) = x(2,l)
            el(12,k) = x(3,l)
            el(13,k) = v(1,l)
            el(14,k) = v(2,l)
            el(15,k) = v(3,l)
c
c Convert to Keplerian orbital elements
            gm = (mcen + el(18,k)) * K2
c ##A9,11##
c ##A10,15##
            if (oi.eq.1) then
c ##A10,15##
              msum = 0.d0
c
              if (centre.eq.8) then
                msum = gm
                if ((algor.eq.11.or.algor.eq.5)
     %            .and.l.ne.2) msum = msum + m(2)
                if (algor.eq.5.and.l.eq.2) then
                  msum = m(1)**3 / (m(1) + m(2))**2
                end if
                if (algor.eq.5.and.l.eq.3) then
                  do i0 = 4, nbod1
                    msum = msum + m(i0)
                  end do
                end if
                if (algor.eq.12.and.l.eq.2) then
                  do i0 = 3, nbod1
                    msum = msum + m(i0)
                  end do
                end if
                gm = msum
              end if
c
              if (centre.eq.4) then
                gm = gm + m(2)
                if (l.eq.2) gm = m(1) * m(1) / (m(1) + m(2))
              end if
              if (centre.eq.5.and.l.eq.2) then
                do i0 = 3, nbod1
                  msum = msum + m(i0)
                end do
                gm = (m(1) + msum) * (m(1) + msum) / (m(1) +
     %          msum + m(2)) 
              end if
              if (centre.eq.6) then
                gm = gm + m(2)
                if (l.eq.2) gm = m(1) * m(1) / (m(1) + m(2))
                if (l.eq.3) then
                  do i0 = 4, nbod1
                    msum = msum + m(i0)
                  end do
                  gm = (m(1) + m(2) + msum) * (m(1) + m(2) +
     %            msum) / (m(1) + m(2) + m(3) + msum)
                end if
              end if
c ##A10,16##
            end if
c ##A10,16##
c ##A9,11##
c ##A21,4##
            if (centre.ne.11) then
              call mco_x2el (gm,el(10,k),el(11,k),el(12,k),el(13,k),
     %          el(14,k),el(15,k),el(8,k),el(2,k),el(3,k),el(7,k),
     %          el(5,k),el(6,k))
            else if (centre.eq.11) then
c ##A23,7##
            if ((l.ge.opti(1).and.l.le.opti(2))
     %        .and.(dabs(jcen(1)).ge.EPS.or.dabs(jcen(2)).ge.EPS
     %        .or.dabs(jcen(3)).ge.EPS)) then
c ##A23,7##
            obla(1) = gm
            obla(2) = jcen(1) * rcen * rcen
            obla(3) = jcen(2) * rcen * rcen * rcen * rcen
            obla(4) = jcen(3) * rcen * rcen * rcen * rcen * rcen * rcen
            icoor(1) = el(10,k)
            icoor(2) = el(11,k)
            icoor(3) = el(12,k)
            icoor(4) = el(13,k)
            icoor(5) = el(14,k)
            icoor(6) = el(15,k)
            call car_geo (obla,icoor,ocoor,mem,lmem,id(k),opti(5))
            el(8,k) = ocoor(1) * (1.d0 - ocoor(2))
            el(2,k) = ocoor(2)
            el(3,k) = ocoor(3)
            el(7,k) = ocoor(4) + ocoor(5)
            el(5,k) = ocoor(5)
            el(6,k) = ocoor(6)
c ##A23,8##
            else
              call mco_x2el (gm,el(10,k),el(11,k),el(12,k),el(13,k),
     %          el(14,k),el(15,k),el(8,k),el(2,k),el(3,k),el(7,k),
     %          el(5,k),el(6,k))
            end if
c ##A23,8##
            end if
c ##A21,4##
            el(1,k) = el(8,k) / (1.d0 - el(2,k))
            el(9,k) = el(1,k) * (1.d0 + el(2,k))
            el(4,k) = mod(el(7,k) - el(5,k) + TWOPI, TWOPI)
c Calculate true anomaly
            if (el(2,k).eq.0) then
              el(17,k) = el(6,k)
            else
              temp = (el(8,k)*(1.d0 + el(2,k))/el(16,k) - 1.d0) /el(2,k)
              temp = sign (min(abs(temp), 1.d0), temp)
              el(17,k) = acos(temp)
              if (sin(el(6,k)).lt.0) el(17,k) = TWOPI - el(17,k)
            end if
c Calculate obliquity
            el(19,k) = acos (cos(el(3,k))*cos(is(k))
     %        + sin(el(3,k))*sin(is(k))*cos(ns(k) - el(5,k)))
c
c ##A22,10##
            if (el(3,k).lt.0.5d0*PI) eq =  1.0
            if (el(3,k).ge.0.5d0*PI) eq = -1.0
            varpi0 =mod(el(7,k) - el(5,k) + eq * el(5,k) + TWOPI, TWOPI)
c            varpi  = atan2(sin(varpi0),cos(varpi0))
            varpi = varpi0
            if (el(2,k).lt.3.d-8) then
              el(38,k) = 1.d0 * sin (varpi)
              el(39,k) = 1.d0 * cos (varpi)
            else
              el(38,k) = el(2,k) * sin (varpi)
              el(39,k) = el(2,k) * cos (varpi)
            end if
            el(40,k) = tan(el(3,k)*0.5d0)**eq * sin (el(5,k))
            el(41,k) = tan(el(3,k)*0.5d0)**eq * cos (el(5,k))
            el(42,k) = mod(el(6,k) + varpi0 + TWOPI, TWOPI)
            el(43,k) = el(8,k) * cos(el(42,k))
            el(44,k) = el(8,k) * sin(el(42,k))
c ##A22,10##
c
c Convert angular elements from radians to degrees
            do l = 3, 7
              el(l,k) = mod(el(l,k) / DR, 360.d0)
            end do
            el(17,k) = el(17,k) / DR
            el(19,k) = el(19,k) / DR
c ##A22,11##
            el(42,k) = el(42,k) / DR
c ##A22,11##
          end do
c
c Convert time to desired format
          if (timestyle.eq.0) t1 = time
          if (timestyle.eq.1) call mio_jd_y (time,year,month,t1)
c ##A13,8##
          if (timestyle.eq.2.or.timestyle2.eq.1) t1=time-t0
          if (timestyle.eq.3.or.timestyle2.eq.2) t1=(time-t0)/365.25d0
c ##A13,8##
c ##A4,9##
          ti2 = ti
          tf2 = tf
          if (ti.gt.0.and.tf.lt.0.or.ti.lt.0.and.tf.gt.0) then
            ti2 = ti
            tf2 = 0
            if (time*sign(1.d0,tf-ti).gt.0) then
              ti2 = 0
              tf2 = tf
            end if
          end if
c
          if (abs(tf2)-abs(ti2).gt.0) then
            ti2 = ti2 * 0.99999999d0
            tf2 = tf2 * 1.00000001d0
          else
            ti2 = ti2 * 1.00000001d0
            tf2 = tf2 * 0.99999999d0
          end if
c ##A4,9##
c
c ##ANO16,8##
          if (ce.eq.'p') then
c Write required elements to the appropriate clo file
          i3 = 2
          do j = i3, 2
            i1 = ijclo(j)
            if (list.eq.0) then
              if ((time*sign(1.d0,tf2-ti2).ge.ti2*sign(1.d0,tf2-ti2)
     %          .and.time*sign(1.d0,tf2-ti2).le.tf2*sign(1.d0,tf2-ti2))
     %          .and.((stflag(ind(j)).eq.0)
     %          .or.(abs(time-tprev(ind(j))).ge.teval))) then
                stflag(ind(j)) = 1
                tprev(ind(j)) = time
                if (unit(i1).ge.10) then
                  if (timestyle.eq.1) then
                    write (unit(i1),fout) year,month,t1,
     %                (el(iel(l),i1),l=1,nel)
                  else
                    write (unit(i1),fout) t1,
     %                (el(iel(l),i1),l=1,nel)
                  end if
                end if
              end if
            else if (list.eq.1) then
              if ((time*sign(1.d0,tf2-ti2).ge.ti2*sign(1.d0,tf2-ti2)
     %          .and.time*sign(1.d0,tf2-ti2).le.tf2*sign(1.d0,tf2-ti2))
     %          .and.((firstflag.eq.1)
     %          .or.(abs(time-tprevious).ge.teval))) then
                firstflag = 2
                tprevious = time
                if (unit(i1).ge.10) then
                  if (timestyle.eq.1) then
                    write (unit(i1),fout) year,month,t1,id(i1),
     %                (el(iel(l),i1),l=1,nel)
                  else
                    write (unit(i1),fout) t1,id(i1),
     %                (el(iel(l),i1),l=1,nel)
                  end if
                end if
              end if
            end if
          end do
          else
c
c ##A3,12##
c
c If output is required at this epoch, write elements to appropriate files
c ##A4,6##
c          if (firstflag.eq.0.or.abs(time-tprevious).ge.teval) then
          if ((time*sign(1.d0,tf2-ti2).ge.ti2*sign(1.d0,tf2-ti2)
     %      .and.time*sign(1.d0,tf2-ti2).le.tf2*sign(1.d0,tf2-ti2))
     %      .and.((firstflag.eq.1)
     %      .or.(abs(time-tprevious).ge.teval))) then
            firstflag = 2
c ##A4,6##
            tprevious = time
c ##A3,12##
c
c Write required elements to the appropriate clo file
            i3 = 2
            do j = i3, 2
              i1 = ijclo(j)
              if (unit(i1).ge.10) then
                if (timestyle.eq.1) then
                  write (unit(i1),fout) year,month,t1,id(i1),
     %              (el(iel(l),i1),l=1,nel)
                else
                  write (unit(i1),fout) t1,id(i1),
     %              (el(iel(l),i1),l=1,nel)
                end if
              end if
            end do
c ##A3,13##
          end if
c ##A3,13##
        end if
c ##ANO16,8##
c
c ##A11,4##
c ##ANO16,4##
c ##A24,4##
        else if (((type.eq.'b'.or.type.eq.'c')
     %    .or.(type.eq.'d'.or.type.eq.'f'))
     %    .or.(type.eq.'e'.or.type.eq.'h'.or.type.eq.'p')
     %    .or.type.eq.'r') then
c ##A24,4##
c ##ANO16,4##
c ##A11,4##
          nst = nst + 1
c ##A8,15##
c          read (10,'(2a1)',end=900,err=666) check,type
c ##A11,5##
          if ((type.eq.'b'.or.type.eq.'c').or.(type.eq.'d'
     %      .or.type.eq.'f')) then
c ##A11,5##
            leni = lenin
c ##ANO16,5##
c ##A24,5##
          else if (type.eq.'e'.or.type.eq.'h'.or.type.eq.'p'
     %      .or.type.eq.'r') then
c ##A24,5##
c ##ANO16,5##
            leni = lenin2
          end if
          do nc = 1, leni
            read (10,'(a1)',end=666,eor=666,err=666,advance='no')
     %        c1
            if (ichar(c1).eq.12) then
              backspace 10
              do nct = 1, line_num + nc - 1
                read (10,'(a1)',advance='no') c1
              end do
              goto 666
            end if
          end do
          line_num = line_num + nc - 1
c ##A8,15##
          goto 100
c ##A1,61##
c
c------------------------------------------------------------------------------
c
c  IF  TYPE  IS  NOT  'a'  OR  'b',  THE  INPUT  FILE  IS  CORRUPTED
c
c ##A8,16##
        else if (ichar(type).eq.12) then
          nc = 1
          line_num = line_num - 1
          backspace 10
          do nct = 1, line_num + nc - 1
            read (10,'(a1)',advance='no') c1
          end do
          goto 666
c ##A8,16##
        else
          goto 666
        end if
c
c Move on to the next time slice
        goto 100
c
c If input file is corrupted, try to continue from next uncorrupted time slice
 666    continue
c ##A8,17##
        nbr = line_num + nc
        if (nbr.ne.0) then
          ex = int(log10(nbr))
        else
          ex = 0
        end if
        ex = ex + 1
        ferr(1:12) = '(2a,/,a,i  )'
        if (ex.lt.10) write (ferr(10:10),'(i1)') ex
        if (ex.ge.10) write (ferr(10:11),'(i2)') ex
        write (*,ferr) mem(121)(1:lmem(121)),
     %    infile(i)(1:60),mem(104)(1:lmem(104)),line_num + nc
c ##A8,17##
        c1 = ' '
        do while (ichar(c1).ne.12)
          line_num = line_num + 1
c ##A8,18##
          read (10,'(a1)',end=900,eor=900,advance='no') c1
c ##A8,18##
        end do
        line_num = line_num - 1
        backspace 10
c ##A8,19##
        if (nc.eq.0) nc = 1
        do nct = 1, line_num + nc - 1
          read (10,'(a1)',advance='no') c1
        end do
        line_num = line_num + nc - 1
        nstored = 0
        nst = 0
c ##A8,19##
c ##A1,62##
        nst = 0
        nstored = 0
c ##A1,62##
c ##E1,1##
        goto 100
c ##E1,1##
c
c Move on to the next file containing close encounter data
 900    continue
        close (10)
      end do
c
c Close clo files
      do j = 1, nopen
        close (10+j)
      end do
      nopen = 0
c
c If some objects remain on waiting list, read through input files again
      if (nwait.gt.0) then
        do j = 1, nmaster
          if (master_unit(j).ge.10) master_unit(j) = -1
          if (master_unit(j).eq.-2.and.nopen.lt.NFILES) then
            nopen = nopen + 1
            nwait = nwait - 1
            master_unit(j) = 10 + nopen
c ##A1,63##
            call mio_aei (master_id(j),ext,master_unit(j),header,
     %        lenhead,mem,lmem,ce,list)
c ##A1,63##
          end if
        end do
c ##A2,5##
        nopen2 = nopent + nopen
        write (*,'(2(a,i7))') mem(206)(1:lmem(206)),nopent+1,
     %    mem(207)(1:lmem(207)),nopen2
        nopent = nopent + nopen
c ##A2,5##
        goto 90
      end if
c ##A2,6##
      write (*,'(a)') mem(205)(1:lmem(205))
c ##A2,6##
c
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      M_FORMCE.FOR    (ErikSoft  30 November 1999)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c
c------------------------------------------------------------------------------
c
      subroutine m_formce (timestyle,fout,header,lenhead)
c
      implicit none
c
c Input/Output
      integer timestyle,lenhead
      character*250 fout,header
c
c------------------------------------------------------------------------------
c
      if (timestyle.eq.0.or.timestyle.eq.2) then
        header(1:19) = '    Time (days)    '
        header(20:58) = '  Object   dmin (AU)     a1       e1    '
        header(59:90) = '   i1       a2       e2       i2'
        lenhead = 90
        fout = '(1x,f18.5,1x,a8,1x,f10.8,2(1x,f9.4,1x,f8.6,1x,f7.3))'
      else
        if (timestyle.eq.1) then
          header(1:23) = '     Year/Month/Day    '
          header(24:62) = '  Object   dmin (AU)     a1       e1    '
          header(63:94) = '   i1       a2       e2       i2'
          lenhead = 94
          fout(1:37) = '(1x,i10,1x,i2,1x,f8.5,1x,a8,1x,f10.8,'
          fout(38:64) = '2(1x,f9.4,1x,f8.6,1x,f7.3))'
        else
          header(1:19) = '    Time (years)   '
          header(20:58) = '  Object   dmin (AU)     a1       e1    '
          header(59:90) = '   i1       a2       e2       i2'
          fout = '(1x,f18.7,1x,a8,1x,f10.8,2(1x,f9.4,1x,f8.6,1x,f7.3))'
          lenhead = 90
        end if
      end if
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_OV2X.FOR    (ErikSoft   28 February 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Converts output variables for an object to coordinates and velocities.
c The output variables are:
c  r = the radial distance
c  theta = polar angle
c  phi = azimuthal angle
c  fv = 1 / [1 + 2(ke/be)^2], where be and ke are the object's binding and
c                             kinetic energies. (Note that 0 < fv < 1).
c  vtheta = polar angle of velocity vector
c  vphi = azimuthal angle of the velocity vector
c
c------------------------------------------------------------------------------
c
      subroutine mco_ov2x (rcen,rmax,mcen,m,fr,theta,phi,fv,vtheta,
     %  vphi,x,y,z,u,v,w)
c
      implicit none
      include 'mercury.inc'
c
c Input/Output
      real*8 rcen,rmax,mcen,m,x,y,z,u,v,w,fr,theta,phi,fv,vtheta,vphi
c
c Local
      real*8 r,v1,temp
c
c------------------------------------------------------------------------------
c
        r = rcen * 10.d0**fr
        temp = sqrt(.5d0*(1.d0/fv - 1.d0))
        v1 = sqrt(2.d0 * temp * (mcen + m) / r)
c
        x = r * sin(theta) * cos(phi)
        y = r * sin(theta) * sin(phi)
        z = r * cos(theta)
        u = v1 * sin(vtheta) * cos(vphi)
        v = v1 * sin(vtheta) * sin(vphi)
        w = v1 * cos(vtheta)
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_EL2X.FOR    (ErikSoft  7 July 1999)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Calculates Cartesian coordinates and velocities given Keplerian orbital
c elements (for elliptical, parabolic or hyperbolic orbits).
c
c Based on a routine from Levison and Duncan's SWIFT integrator.
c
c  mu = grav const * (central + secondary mass)
c  q = perihelion distance
c  e = eccentricity
c  i = inclination                 )
c  p = longitude of perihelion !!! )   in
c  n = longitude of ascending node ) radians
c  l = mean anomaly                )
c
c  x,y,z = Cartesian positions  ( units the same as a )
c  u,v,w =     "     velocities ( units the same as sqrt(mu/a) )
c
c------------------------------------------------------------------------------
c
      subroutine mco_el2x (mu,q,e,i,p,n,l,x,y,z,u,v,w)
c
      implicit none
      include 'mercury.inc'
c
c Input/Output
      real*8 mu,q,e,i,p,n,l,x,y,z,u,v,w
c
c Local
      real*8 g,a,ci,si,cn,sn,cg,sg,ce,se,romes,temp
      real*8 z1,z2,z3,z4,d11,d12,d13,d21,d22,d23
      real*8 mco_kep, orbel_fhybrid, orbel_zget
c
c------------------------------------------------------------------------------
c
c Change from longitude of perihelion to argument of perihelion
      g = p - n
c
c Rotation factors
      call mco_sine (i,si,ci)
      call mco_sine (g,sg,cg)
      call mco_sine (n,sn,cn)
      z1 = cg * cn
      z2 = cg * sn
      z3 = sg * cn
      z4 = sg * sn
      d11 =  z1 - z4*ci
      d12 =  z2 + z3*ci
      d13 = sg * si
      d21 = -z3 - z2*ci
      d22 = -z4 + z1*ci
      d23 = cg * si
c
c Semi-major axis
      a = q / (1.d0 - e)
c
c Ellipse
      if (e.lt.1.d0) then
        romes = sqrt(1.d0 - e*e)
        temp = mco_kep (e,l)
        call mco_sine (temp,se,ce)
        z1 = a * (ce - e)
        z2 = a * romes * se
        temp = sqrt(mu/a) / (1.d0 - e*ce)
        z3 = -se * temp
        z4 = romes * ce * temp
      else
c Parabola
        if (e.eq.1.d0) then
          ce = orbel_zget(l)
          z1 = q * (1.d0 - ce*ce)
          z2 = 2.d0 * q * ce
          z4 = sqrt(2.d0*mu/q) / (1.d0 + ce*ce)
          z3 = -ce * z4
        else
c Hyperbola
          romes = sqrt(e*e - 1.d0)
          temp = orbel_fhybrid(e,l)
          call mco_sinh (temp,se,ce)
          z1 = a * (ce - e)
          z2 = -a * romes * se
          temp = sqrt(mu/abs(a)) / (e*ce - 1.d0)
          z3 = -se * temp
          z4 = romes * ce * temp
        end if
      endif
c
      x = d11*z1 + d21*z2
      y = d12*z1 + d22*z2
      z = d13*z1 + d23*z2
      u = d11*z3 + d21*z4
      v = d12*z3 + d22*z4
      w = d13*z3 + d23*z4
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_KEP.FOR    (ErikSoft  7 July 1999)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Solves Kepler's equation for eccentricities less than one.
c Algorithm from A. Nijenhuis (1991) Cel. Mech. Dyn. Astron. 51, 319-330.
c
c  e = eccentricity
c  l = mean anomaly      (radians)
c  u = eccentric anomaly (   "   )
c
c------------------------------------------------------------------------------
c
      function mco_kep (e,oldl)
      implicit none
c
c Input/Outout
      real*8 oldl,e,mco_kep
c
c Local
      real*8 l,pi,twopi,piby2,u1,u2,ome,sign
      real*8 x,x2,sn,dsn,z1,z2,z3,f0,f1,f2,f3
      real*8 p,q,p2,ss,cc
      logical flag,big,bigg
c
c------------------------------------------------------------------------------
c
      pi = 3.141592653589793d0
      twopi = 2.d0 * pi
      piby2 = .5d0 * pi
c
c Reduce mean anomaly to lie in the range 0 < l < pi
      if (oldl.ge.0) then
        l = mod(oldl, twopi)
      else
        l = mod(oldl, twopi) + twopi
      end if
      sign = 1.d0
      if (l.gt.pi) then
        l = twopi - l
        sign = -1.d0
      end if
c
      ome = 1.d0 - e
c
      if (l.ge..45d0.or.e.lt..55d0) then
c
c Regions A,B or C in Nijenhuis
c -----------------------------
c
c Rough starting value for eccentric anomaly
        if (l.lt.ome) then
          u1 = ome
        else
          if (l.gt.(pi-1.d0-e)) then
            u1 = (l+e*pi)/(1.d0+e)
          else
            u1 = l + e
          end if
        end if
c
c Improved value using Halley's method
        flag = u1.gt.piby2
        if (flag) then
          x = pi - u1
        else
          x = u1
        end if
        x2 = x*x
        sn = x*(1.d0 + x2*(-.16605 + x2*.00761) )
        dsn = 1.d0 + x2*(-.49815 + x2*.03805)
        if (flag) dsn = -dsn
        f2 = e*sn
        f0 = u1 - f2 - l
        f1 = 1.d0 - e*dsn
        u2 = u1 - f0/(f1 - .5d0*f0*f2/f1)
      else
c
c Region D in Nijenhuis
c ---------------------
c
c Rough starting value for eccentric anomaly
        z1 = 4.d0*e + .5d0
        p = ome / z1
        q = .5d0 * l / z1
        p2 = p*p
        z2 = exp( log( dsqrt( p2*p + q*q ) + q )/1.5 )
        u1 = 2.d0*q / ( z2 + p + p2/z2 )
c
c Improved value using Newton's method
        z2 = u1*u1
        z3 = z2*z2
        u2 = u1 - .075d0*u1*z3 / (ome + z1*z2 + .375d0*z3)
        u2 = l + e*u2*( 3.d0 - 4.d0*u2*u2 )
      end if
c
c Accurate value using 3rd-order version of Newton's method
c N.B. Keep cos(u2) rather than sqrt( 1-sin^2(u2) ) to maintain accuracy!
c
c First get accurate values for u2 - sin(u2) and 1 - cos(u2)
      bigg = (u2.gt.piby2)
      if (bigg) then
        z3 = pi - u2
      else
        z3 = u2
      end if
c
      big = (z3.gt.(.5d0*piby2))
      if (big) then
        x = piby2 - z3
      else
        x = z3
      end if
c
      x2 = x*x
      ss = 1.d0
      cc = 1.d0
c
      ss = x*x2/6.*(1. - x2/20.*(1. - x2/42.*(1. - x2/72.*(1. -
     %   x2/110.*(1. - x2/156.*(1. - x2/210.*(1. - x2/272.)))))))
      cc =   x2/2.*(1. - x2/12.*(1. - x2/30.*(1. - x2/56.*(1. -
     %   x2/ 90.*(1. - x2/132.*(1. - x2/182.*(1. - x2/240.*(1. -
     %   x2/306.))))))))
c
      if (big) then
        z1 = cc + z3 - 1.d0
        z2 = ss + z3 + 1.d0 - piby2
      else
        z1 = ss
        z2 = cc
      end if
c
      if (bigg) then
        z1 = 2.d0*u2 + z1 - pi
        z2 = 2.d0 - z2
      end if
c
      f0 = l - u2*ome - e*z1
      f1 = ome + e*z2
      f2 = .5d0*e*(u2-z1)
      f3 = e/6.d0*(1.d0-z2)
      z1 = f0/f1
      z2 = f0/(f2*z1+f1)
      mco_kep = sign*( u2 + f0/((f3*z1+f2)*z2+f1) )
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_SINE.FOR    (ErikSoft  17 April 1997)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Calculates sin and cos of an angle X (in radians).
c
c------------------------------------------------------------------------------
c
      subroutine mco_sine (x,sx,cx)
c
      implicit none
c
c Input/Output
      real*8 x,sx,cx
c
c Local
      real*8 pi,twopi
c
c------------------------------------------------------------------------------
c
      pi = 3.141592653589793d0
      twopi = 2.d0 * pi
c
      if (x.gt.0) then
        x = mod(x,twopi)
      else
        x = mod(x,twopi) + twopi
      end if
c
      cx = cos(x)
c
      if (x.gt.pi) then
        sx = -sqrt(1.d0 - cx*cx)
      else
        sx =  sqrt(1.d0 - cx*cx)
      end if
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_SINH.FOR    (ErikSoft  12 June 1998)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Calculates sinh and cosh of an angle X (in radians)
c
c------------------------------------------------------------------------------
c
      subroutine mco_sinh (x,sx,cx)
c
      implicit none
c
c Input/Output
      real*8 x,sx,cx
c
c------------------------------------------------------------------------------
c
      sx = sinh(x)
      cx = sqrt (1.d0 + sx*sx)
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MIO_AEI.FOR    (ErikSoft   31 January 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers (adapted by Andre Amarante - 6 March 2014)
c
c Creates a filename and opens a file to store aei information for an object.
c The filename is based on the name of the object.
c
c------------------------------------------------------------------------------
c
c ##A1,32##
      subroutine mio_aei (id,extn,unitnum,header,lenhead,mem,lmem,ce,
     %  list)
c ##A1,32##
c
      implicit none
      include 'mercury.inc'
c
c Input/Output
      integer unitnum,lenhead,lmem(NMESS)
      character*4 extn
c ##A1,33##
      character*28 id
      character*1000 header
c ##A1,33##
      character*80 mem(NMESS)
c ##A1,34##
      character*1 ce
      integer list
c ##A1,34##
c
c Local
c ##Ubuntu-22-LTS##
c      integer j,k,itmp,nsub,lim(2,4)
      integer j,k,itmp,nsub,lim(2,1000)
c ##Ubuntu-22-LTS##
      logical test
      character*1 bad(5)
      character*250 filename
c ##A1,35##
c ##A19,10##
c      character*16 fout
      character*29 fout
c ##A19,10##
c ##A1,35##
c
c------------------------------------------------------------------------------
c
      data bad/ '*', '/', '.', ':', '&'/
c
c Create a filename based on the object's name
      call mio_spl (8,id,nsub,lim)
      itmp = min(7,lim(2,1)-lim(1,1))
      filename(1:itmp+1) = id(1:itmp+1)
      filename(itmp+2:itmp+5) = extn
      do j = itmp + 6, 250
        filename(j:j) = ' '
      end do
c
c Check for inappropriate characters in the filename
      do j = 1, itmp + 1
        do k = 1, 5
          if (filename(j:j).eq.bad(k)) filename(j:j) = '_'
        end do
      end do
c ##A1,36##
c ##A19,9##
c      fout(1:16) = '(/,30x,a8 ,//,a)'
      fout(1:29) = '(a1,/,a1,30x,a8 ,/,a1,/,a1,a)'
      if (list.eq.1) then
        if (ce.eq.'b') then
          id = 'CLOSE ENCOUNTERS'
          write (fout(15:16),'(i2)') 16
        else if (ce.eq.'c') then
          id = 'COLLISIONS'
          write (fout(15:16),'(i2)') 10
        else if (ce.eq.'e') then
          id = 'EJECTIONS'
          write (fout(15:16),'(i2)') 9
        else if (ce.eq.'h') then
          id = 'COLLISIONS WITH CENTRAL BODY'
          write (fout(15:16),'(i2)') 28
c ##A11,6##
        else if (ce.eq.'d') then
          id = 'PRUNE COLLISIONS'
          write (fout(15:16),'(i2)') 16
        else if (ce.eq.'f') then
          id = 'PRUNE EJECTIONS'
          write (fout(15:16),'(i2)') 15
c ##A11,6##
c ##ANO16,6##
        else if (ce.eq.'p') then
          id = 'POINCARE SURFACE SECTION'
          write (fout(15:16),'(i2)') 24
c ##ANO16,6##
c ##A19,9##
c ##A24,6##
        else if (ce.eq.'r') then
          id = 'ROTATIONAL BREAKUP'
          write (fout(15:16),'(i2)') 18
c ##A24,6##
        end if
      end if
c ##A1,36##
c
c If the file exists already, give a warning and don't overwrite it
      inquire (file=filename, exist=test)
      if (test) then
        write (*,'(/,3a)') mem(121)(1:lmem(121)),mem(87)(1:lmem(87)),
     %    filename(1:80)
        unitnum = -1
      else
        open (unitnum, file=filename, status='new')
c ##A1,37##
c ##A19,11##
c        write (unitnum,fout) id,header(1:lenhead)
        write (unitnum,fout) '#','#',id,'#','#',header(1:lenhead)
c ##A19,11##
c ##A1,37##
      end if
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MIO_C2FL.FOR    (ErikSoft   5 June 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers (adapted by Andre Amarante - 6 March 2014)
c
c CHARACTER*8 ASCII string into a REAL*8 variable.
c
c N.B. X will lie in the range -1.e112 < X < 1.e112
c ===
c
c------------------------------------------------------------------------------
c
c ##A1,43##
      function mio_c2fl (c,nchar)
c ##A1,43##
c
      implicit none
c
c Input/Output
      real*8 mio_c2fl
      character*8 c
c ##A1,44##
      integer nchar
c ##A1,44##
c
c Local
      real*8 x,mio_c2re
      integer ex
c
c------------------------------------------------------------------------------
c
c ##A1,45##
      x = mio_c2re (c(1:nchar+1), 0.d0, 1.d0, nchar)
c ##A1,45##
      x = x * 2.d0 - 1.d0
c ##A1,46##
      ex = mod(ichar(c(nchar+1:nchar+1)) + 256, 256) - 32 - 112
c ##A1,46##
      mio_c2fl = x * (10.d0**dble(ex))
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MIO_C2RE.FOR    (ErikSoft   5 June 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Converts an ASCII string into a REAL*8 variable X, where XMIN <= X < XMAX,
c using the new format compression:
c
c X is assumed to be made up of NCHAR base-224 digits, each one represented
c by a character in the ASCII string. Each digit is given by the ASCII
c number of the character minus 32.
c The first 32 ASCII characters (CTRL characters) are avoided, because they
c cause problems when using some operating systems.
c
c------------------------------------------------------------------------------
c
      function mio_c2re (c,xmin,xmax,nchar)
c
      implicit none
c
c Input/output
      integer nchar
      real*8 xmin,xmax,mio_c2re
      character*8 c
c
c Local
      integer j
      real*8 y
c
c------------------------------------------------------------------------------
c
      y = 0
      do j = nchar, 1, -1
        y = (y + dble(mod(ichar(c(j:j)) + 256, 256) - 32)) / 224.d0
      end do
c
      mio_c2re = xmin  +  y * (xmax - xmin)
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MIO_ERR.FOR    (ErikSoft  6 December 1999)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Writes out an error message and terminates Mercury.
c
c------------------------------------------------------------------------------
c
      subroutine mio_err (unit,s1,ls1,s2,ls2,s3,ls3,s4,ls4)
c
      implicit none
c
c Input/Output
      integer unit,ls1,ls2,ls3,ls4
      character*80 s1,s2,s3,s4
c
c------------------------------------------------------------------------------
c
      write (*,'(a)') ' ERROR: Programme terminated.'
      write (unit,'(/,3a,/,2a)') s1(1:ls1),s2(1:ls2),s3(1:ls3),
     %  ' ',s4(1:ls4)
      stop
c
c------------------------------------------------------------------------------
c
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_H2B.FOR    (ErikSoft   2 November 2000)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Converts coordinates with respect to the central body to barycentric
c coordinates.
c
c------------------------------------------------------------------------------
c
      subroutine mco_h2b (jcen,nbod,nbig,h,m,xh,vh,x,v)
c
      implicit none
c
c Input/Output
      integer nbod,nbig
      real*8 jcen(3),h,m(nbod),xh(3,nbod),vh(3,nbod),x(3,nbod),v(3,nbod)
c
c Local
      integer j
      real*8 mtot,temp
c
c------------------------------------------------------------------------------
c
      mtot = 0.d0
      x(1,1) = 0.d0
      x(2,1) = 0.d0
      x(3,1) = 0.d0
      v(1,1) = 0.d0
      v(2,1) = 0.d0
      v(3,1) = 0.d0
c
c Calculate coordinates and velocities of the central body
      do j = 2, nbod
        mtot = mtot  +  m(j)
        x(1,1) = x(1,1)  +  m(j) * xh(1,j)
        x(2,1) = x(2,1)  +  m(j) * xh(2,j)
        x(3,1) = x(3,1)  +  m(j) * xh(3,j)
        v(1,1) = v(1,1)  +  m(j) * vh(1,j)
        v(2,1) = v(2,1)  +  m(j) * vh(2,j)
        v(3,1) = v(3,1)  +  m(j) * vh(3,j)
      enddo
c
      temp = -1.d0 / (mtot + m(1))
      x(1,1) = temp * x(1,1)
      x(2,1) = temp * x(2,1)
      x(3,1) = temp * x(3,1)
      v(1,1) = temp * v(1,1)
      v(2,1) = temp * v(2,1)
      v(3,1) = temp * v(3,1)
c
c Calculate the barycentric coordinates and velocities
      do j = 2, nbod
        x(1,j) = xh(1,j) + x(1,1)
        x(2,j) = xh(2,j) + x(2,1)
        x(3,j) = xh(3,j) + x(3,1)
        v(1,j) = vh(1,j) + v(1,1)
        v(2,j) = vh(2,j) + v(2,1)
        v(3,j) = vh(3,j) + v(3,1)
      enddo
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_H2CB.FOR    (ErikSoft   2 November 2000)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Convert coordinates with respect to the central body to close-binary
c coordinates.
c
c------------------------------------------------------------------------------
c
      subroutine mco_h2cb (jcen,nbod,nbig,h,m,xh,vh,x,v)
c
      implicit none
c
c Input/Output
      integer nbod,nbig
      real*8 jcen(3),h,m(nbod),xh(3,nbod),vh(3,nbod),x(3,nbod),v(3,nbod)
c
c Local
      integer j
      real*8 msum,mvsum(3),temp,mbin,mbin_1,mtot_1
c
c------------------------------------------------------------------------------
c
      msum = 0.d0
      mvsum(1) = 0.d0
      mvsum(2) = 0.d0
      mvsum(3) = 0.d0
      mbin = m(1) + m(2)
      mbin_1 = 1.d0 / mbin
c
      x(1,2) = xh(1,2)
      x(2,2) = xh(2,2)
      x(3,2) = xh(3,2)
      temp = m(1) * mbin_1
      v(1,2) = temp * vh(1,2)
      v(2,2) = temp * vh(2,2)
      v(3,2) = temp * vh(3,2)
c
      do j = 3, nbod
        msum = msum + m(j)
        mvsum(1) = mvsum(1)  +  m(j) * vh(1,j)
        mvsum(2) = mvsum(2)  +  m(j) * vh(2,j)
        mvsum(3) = mvsum(3)  +  m(j) * vh(3,j)
      end do
      mtot_1 = 1.d0 / (msum + mbin)
      mvsum(1) = mtot_1 * (mvsum(1) + m(2)*vh(1,2))
      mvsum(2) = mtot_1 * (mvsum(2) + m(2)*vh(2,2))
      mvsum(3) = mtot_1 * (mvsum(3) + m(2)*vh(3,2))
c
      temp = m(2) * mbin_1
      do j = 3, nbod
        x(1,j) = xh(1,j)  -  temp * xh(1,2)
        x(2,j) = xh(2,j)  -  temp * xh(2,2)
        x(3,j) = xh(3,j)  -  temp * xh(3,2)
        v(1,j) = vh(1,j)  -  mvsum(1)
        v(2,j) = vh(2,j)  -  mvsum(2)
        v(3,j) = vh(3,j)  -  mvsum(3)
      end do
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_H2J.FOR    (ErikSoft   2 November 2000)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Converts coordinates with respect to the central body to Jacobi coordinates.
c Note that the Jacobi coordinates of all small bodies are assumed to be the
c same as their coordinates with respect to the central body.
c
c------------------------------------------------------------------------------
c
      subroutine mco_h2j (jcen,nbod,nbig,h,m,xh,vh,x,v)
c
      implicit none
c
c Input/Output
      integer nbod,nbig
      real*8 jcen(3),h,m(nbig),xh(3,nbig),vh(3,nbig),x(3,nbig),v(3,nbig)
c
c Local
      integer j
      real*8 mtot, mx, my, mz, mu, mv, mw, temp
c
c------------------------------------------------------------------------------c
      mtot = m(2)
      x(1,2) = xh(1,2)
      x(2,2) = xh(2,2)
      x(3,2) = xh(3,2)
      v(1,2) = vh(1,2)
      v(2,2) = vh(2,2)
      v(3,2) = vh(3,2)
      mx = m(2) * xh(1,2)
      my = m(2) * xh(2,2)
      mz = m(2) * xh(3,2)
      mu = m(2) * vh(1,2)
      mv = m(2) * vh(2,2)
      mw = m(2) * vh(3,2)
c
      do j = 3, nbig - 1
        temp = 1.d0 / (mtot + m(1))
        mtot = mtot + m(j)
        x(1,j) = xh(1,j)  -  temp * mx
        x(2,j) = xh(2,j)  -  temp * my
        x(3,j) = xh(3,j)  -  temp * mz
        v(1,j) = vh(1,j)  -  temp * mu
        v(2,j) = vh(2,j)  -  temp * mv
        v(3,j) = vh(3,j)  -  temp * mw
        mx = mx  +  m(j) * xh(1,j)
        my = my  +  m(j) * xh(2,j)
        mz = mz  +  m(j) * xh(3,j)
        mu = mu  +  m(j) * vh(1,j)
        mv = mv  +  m(j) * vh(2,j)
        mw = mw  +  m(j) * vh(3,j)
      enddo
c
      if (nbig.gt.2) then
        temp = 1.d0 / (mtot + m(1))
        x(1,nbig) = xh(1,nbig)  -  temp * mx
        x(2,nbig) = xh(2,nbig)  -  temp * my
        x(3,nbig) = xh(3,nbig)  -  temp * mz
        v(1,nbig) = vh(1,nbig)  -  temp * mu
        v(2,nbig) = vh(2,nbig)  -  temp * mv
        v(3,nbig) = vh(3,nbig)  -  temp * mw
      end if
c
      do j = nbig + 1, nbod
        x(1,j) = xh(1,j)
        x(2,j) = xh(2,j)
        x(3,j) = xh(3,j)
        v(1,j) = vh(1,j)
        v(2,j) = vh(2,j)
        v(3,j) = vh(3,j)
      end do
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_IDEN.FOR    (ErikSoft   2 November 2000)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Makes a new copy of a set of coordinates.
c
c------------------------------------------------------------------------------
c
      subroutine mco_iden (jcen,nbod,nbig,h,m,xh,vh,x,v)
c
      implicit none
c
c Input/Output
      integer nbod,nbig
      real*8 jcen(3),h,m(nbod),x(3,nbod),v(3,nbod),xh(3,nbod),vh(3,nbod)
c
c Local
      integer j
c
c------------------------------------------------------------------------------
c
      do j = 1, nbod
        x(1,j) = xh(1,j)
        x(2,j) = xh(2,j)
        x(3,j) = xh(3,j)
        v(1,j) = vh(1,j)
        v(2,j) = vh(2,j)
        v(3,j) = vh(3,j)
      enddo
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_X2EL.FOR    (ErikSoft  20 February 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Calculates Keplerian orbital elements given relative coordinates and
c velocities, and GM = G times the sum of the masses.
c
c The elements are: q = perihelion distance
c                   e = eccentricity
c                   i = inclination
c                   p = longitude of perihelion (NOT argument of perihelion!!)
c                   n = longitude of ascending node
c                   l = mean anomaly (or mean longitude if e < 1.e-8)
c
c------------------------------------------------------------------------------
c
      subroutine mco_x2el (gm,x,y,z,u,v,w,q,e,i,p,n,l)
c
      implicit none
      include 'mercury.inc'
c
c Input/Output
      real*8 gm,q,e,i,p,n,l,x,y,z,u,v,w
c
c Local
      real*8 hx,hy,hz,h2,h,v2,r,rv,s,true
      real*8 ci,to,temp,tmp2,bige,f,cf,ce
c
c------------------------------------------------------------------------------
c
      hx = y * w  -  z * v
      hy = z * u  -  x * w
      hz = x * v  -  y * u
      h2 = hx*hx + hy*hy + hz*hz
      v2 = u * u  +  v * v  +  w * w
      rv = x * u  +  y * v  +  z * w
      r = sqrt(x*x + y*y + z*z)
      h = sqrt(h2)
      s = h2 / gm
c
c Inclination and node
      ci = hz / h
      if (abs(ci).lt.1) then
        i = acos (ci)
        n = atan2 (hx,-hy)
        if (n.lt.0) n = n + TWOPI
      else
        if (ci.gt.0) i = 0.d0
        if (ci.lt.0) i = PI
        n = 0.d0
      end if
c
c Eccentricity and perihelion distance
      temp = 1.d0  +  s * (v2 / gm  -  2.d0 / r)
      if (temp.le.0) then
        e = 0.d0
      else
        e = sqrt (temp)
      end if
      q = s / (1.d0 + e)
c
c True longitude
      if (hy.ne.0) then
        to = -hx/hy
        temp = (1.d0 - ci) * to
        tmp2 = to * to
        true = atan2((y*(1.d0+tmp2*ci)-x*temp),(x*(tmp2+ci)-y*temp))
      else
        true = atan2(y * ci, x)
      end if
      if (ci.lt.0) true = true + PI
c
      if (e.lt.3.d-8) then
        p = 0.d0
        l = true
      else
        ce = (v2*r - gm) / (e*gm)
c
c Mean anomaly for ellipse
        if (e.lt.1) then
          if (abs(ce).gt.1) ce = sign(1.d0,ce)
          bige = acos(ce)
          if (rv.lt.0) bige = TWOPI - bige
          l = bige - e*sin(bige)
        else
c
c Mean anomaly for hyperbola
          if (ce.lt.1) ce = 1.d0
          bige = log( ce + sqrt(ce*ce-1.d0) )
          if (rv.lt.0) bige = - bige
          l = e*sinh(bige) - bige
        end if
c
c Longitude of perihelion
        cf = (s - r) / (e*r)
        if (abs(cf).gt.1) cf = sign(1.d0,cf)
        f = acos(cf)
        if (rv.lt.0) f = TWOPI - f
        p = true - f
        p = mod (p + TWOPI + TWOPI, TWOPI)
      end if
c
      if (l.lt.0.and.e.lt.1) l = l + TWOPI
      if (l.gt.TWOPI.and.e.lt.1) l = mod (l, TWOPI)
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MIO_JD_Y.FOR    (ErikSoft  2 June 1998)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Converts from Julian day number to Julian/Gregorian Calendar dates, assuming
c the dates are those used by the English calendar.
c
c Algorithm taken from `Practical Astronomy with your calculator' (1988)
c by Peter Duffett-Smith, 3rd edition, C.U.P.
c
c Algorithm for negative Julian day numbers (Julian calendar assumed) by
c J. E. Chambers.
c
c N.B. The output date is with respect to the Julian Calendar on or before
c ===  4th October 1582, and with respect to the Gregorian Calendar on or 
c      after 15th October 1582.
c
c
c------------------------------------------------------------------------------
c
      subroutine mio_jd_y (jd0,year,month,day)
c
      implicit none
c
c Input/Output
      real*8 jd0,day
      integer year,month
c
c Local
      integer i,a,b,c,d,e,g
      real*8 jd,f,temp,x,y,z
c
c------------------------------------------------------------------------------
c
      if (jd0.le.0) goto 50
c
      jd = jd0 + 0.5d0
      i = sign( dint(dabs(jd)), jd )
      f = jd - 1.d0*i
c
c If on or after 15th October 1582
      if (i.gt.2299160) then
        temp = (1.d0*i-1867216.25d0) / 36524.25d0
        a = sign( dint(dabs(temp)), temp )
        temp = .25d0 * a
        b = i + 1 + a - sign( dint(dabs(temp)), temp )
      else
        b = i
      end if
c
      c = b + 1524
      temp = (1.d0*c - 122.1d0) / 365.25d0
      d = sign( dint(dabs(temp)), temp )
      temp = 365.25d0 * d
      e = sign( dint(dabs(temp)), temp )
      temp = (c-e) / 30.6001d0
      g = sign( dint(dabs(temp)), temp )
c
      temp = 30.6001d0 * g
      day = 1.d0*(c-e) + f - 1.d0*sign( dint(dabs(temp)), temp )
c
      if (g.le.13) month = g - 1
      if (g.gt.13) month = g - 13
c
      if (month.gt.2) year = d - 4716
      if (month.le.2) year = d - 4715
c
      if (day.gt.32) then
        day = day - 32
        month = month + 1
      end if
c
      if (month.gt.12) then
        month = month - 12
        year = year + 1
      end if
      return
c
  50  continue
c
c Algorithm for negative Julian day numbers (Duffett-Smith won't work)
      x = jd0 - 2232101.5
      f = x - dint(x)
      if (f.lt.0) f = f + 1.d0
      y = dint(mod(x,1461.d0) + 1461.d0)
      z = dint(mod(y,365.25d0))
      month = int((z + 0.5d0) / 30.61d0)
      day = dint(z + 1.5d0 - 30.61d0*dble(month)) + f
      month = mod(month + 2, 12) + 1
c
      year = 1399 + int (x / 365.25d0)
      if (x.lt.0) year = year - 1
      if (month.lt.3) year = year + 1
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MIO_SPL.FOR    (ErikSoft  14 November 1999)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Given a character string STRING, of length LEN bytes, the routine finds 
c the beginnings and ends of NSUB substrings present in the original, and 
c delimited by spaces. The positions of the extremes of each substring are 
c returned in the array DELIMIT.
c Substrings are those which are separated by spaces or the = symbol.
c
c------------------------------------------------------------------------------
c
      subroutine mio_spl (len,string,nsub,delimit)
c
      implicit none
c
c Input/Output
c ##Ubuntu-22-LTS##
c      integer len,nsub,delimit(2,100)
      integer len,nsub,delimit(2,1000)
c ##Ubuntu-22-LTS##
      character*1 string(len)
c
c Local
      integer j,k
      character*1 c
c
c------------------------------------------------------------------------------
c
      nsub = 0
      j = 0
      c = ' '
      delimit(1,1) = -1
c
c Find the start of string
  10  j = j + 1
      if (j.gt.len) goto 99
      c = string(j)
      if (c.eq.' '.or.c.eq.'=') goto 10
c
c Find the end of string
      k = j
  20  k = k + 1
      if (k.gt.len) goto 30
      c = string(k)
      if (c.ne.' '.and.c.ne.'=') goto 20
c
c Store details for this string
  30  nsub = nsub + 1
      delimit(1,nsub) = j
      delimit(2,nsub) = k - 1
c
      if (k.lt.len) then
        j = k
        goto 10
      end if
c
  99  continue
c
c------------------------------------------------------------------------------
c
      return
      end
c
***********************************************************************
c                    ORBEL_FHYBRID.F
***********************************************************************
*     PURPOSE:  Solves Kepler's eqn. for hyperbola using hybrid approach.  
*
*             Input:
*                           e ==> eccentricity anomaly. (real scalar)
*                           n ==> hyperbola mean anomaly. (real scalar)
*             Returns:
*               orbel_fhybrid ==>  eccentric anomaly. (real scalar)
*
*     ALGORITHM: For abs(N) < 0.636*ecc -0.6 , use FLON 
*	         For larger N, uses FGET
*     REMARKS: 
*     AUTHOR: M. Duncan 
*     DATE WRITTEN: May 26,1992.
*     REVISIONS: 
*     REVISIONS: 2/26/93 hfl
***********************************************************************

	real*8 function orbel_fhybrid(e,n)

      include 'swift.inc'

c...  Inputs Only: 
	real*8 e,n

c...  Internals:
	real*8 abn
        real*8 orbel_flon,orbel_fget

c----
c...  Executable code 

	abn = n
	if(n.lt.0.d0) abn = -abn

	if(abn .lt. 0.636d0*e -0.6d0) then
	  orbel_fhybrid = orbel_flon(e,n)
	else 
	  orbel_fhybrid = orbel_fget(e,n)
	endif   

	return
	end  ! orbel_fhybrid
c-------------------------------------------------------------------
c
***********************************************************************
c                    ORBEL_FGET.F
***********************************************************************
*     PURPOSE:  Solves Kepler's eqn. for hyperbola using hybrid approach.  
*
*             Input:
*                           e ==> eccentricity anomaly. (real scalar)
*                        capn ==> hyperbola mean anomaly. (real scalar)
*             Returns:
*                  orbel_fget ==>  eccentric anomaly. (real scalar)
*
*     ALGORITHM: Based on pp. 70-72 of Fitzpatrick's book "Principles of
*           Cel. Mech. ".  Quartic convergence from Danby's book.
*     REMARKS: 
*     AUTHOR: M. Duncan 
*     DATE WRITTEN: May 11, 1992.
*     REVISIONS: 2/26/93 hfl
c     Modified by JEC
***********************************************************************

	real*8 function orbel_fget(e,capn)

      include 'swift.inc'

c...  Inputs Only: 
	real*8 e,capn

c...  Internals:
	integer i,IMAX
	real*8 tmp,x,shx,chx
	real*8 esh,ech,f,fp,fpp,fppp,dx
	PARAMETER (IMAX = 10)

c----
c...  Executable code 

c Function to solve "Kepler's eqn" for F (here called
c x) for given e and CAPN. 

c  begin with a guess proposed by Danby	
	if( capn .lt. 0.d0) then
	   tmp = -2.d0*capn/e + 1.8d0
	   x = -log(tmp)
	else
	   tmp = +2.d0*capn/e + 1.8d0
	   x = log( tmp)
	endif

	orbel_fget = x

	do i = 1,IMAX
	  call mco_sinh (x,shx,chx)
	  esh = e*shx
	  ech = e*chx
	  f = esh - x - capn
c	  write(6,*) 'i,x,f : ',i,x,f
	  fp = ech - 1.d0  
	  fpp = esh 
	  fppp = ech 
	  dx = -f/fp
	  dx = -f/(fp + dx*fpp/2.d0)
	  dx = -f/(fp + dx*fpp/2.d0 + dx*dx*fppp/6.d0)
	  orbel_fget = x + dx
c   If we have converged here there's no point in going on
	  if(abs(dx) .le. TINY) RETURN
	  x = orbel_fget
	enddo	

	write(6,*) 'FGET : RETURNING WITHOUT COMPLETE CONVERGENCE' 
	return
	end   ! orbel_fget
c------------------------------------------------------------------
c
***********************************************************************
c                    ORBEL_FLON.F
***********************************************************************
*     PURPOSE:  Solves Kepler's eqn. for hyperbola using hybrid approach.  
*
*             Input:
*                           e ==> eccentricity anomaly. (real scalar)
*                        capn ==> hyperbola mean anomaly. (real scalar)
*             Returns:
*                  orbel_flon ==>  eccentric anomaly. (real scalar)
*
*     ALGORITHM: Uses power series for N in terms of F and Newton,s method
*     REMARKS: ONLY GOOD FOR LOW VALUES OF N (N < 0.636*e -0.6)
*     AUTHOR: M. Duncan 
*     DATE WRITTEN: May 26, 1992.
*     REVISIONS: 
***********************************************************************

	real*8 function orbel_flon(e,capn)

      include 'swift.inc'

c...  Inputs Only: 
	real*8 e,capn

c...  Internals:
	integer iflag,i,IMAX
	real*8 a,b,sq,biga,bigb
	real*8 x,x2
	real*8 f,fp,dx
	real*8 diff
	real*8 a0,a1,a3,a5,a7,a9,a11
	real*8 b1,b3,b5,b7,b9,b11
	PARAMETER (IMAX = 10)
	PARAMETER (a11 = 156.d0,a9 = 17160.d0,a7 = 1235520.d0)
	PARAMETER (a5 = 51891840.d0,a3 = 1037836800.d0)
	PARAMETER (b11 = 11.d0*a11,b9 = 9.d0*a9,b7 = 7.d0*a7)
	PARAMETER (b5 = 5.d0*a5, b3 = 3.d0*a3)

c----
c...  Executable code 


c Function to solve "Kepler's eqn" for F (here called
c x) for given e and CAPN. Only good for smallish CAPN 

	iflag = 0
	if( capn .lt. 0.d0) then
	   iflag = 1
	   capn = -capn
	endif

	a1 = 6227020800.d0 * (1.d0 - 1.d0/e)
	a0 = -6227020800.d0*capn/e
	b1 = a1

c  Set iflag nonzero if capn < 0., in which case solve for -capn
c  and change the sign of the final answer for F.
c  Begin with a reasonable guess based on solving the cubic for small F	


	a = 6.d0*(e-1.d0)/e
	b = -6.d0*capn/e
	sq = sqrt(0.25*b*b +a*a*a/27.d0)
	biga = (-0.5*b + sq)**0.3333333333333333d0
	bigb = -(+0.5*b + sq)**0.3333333333333333d0
	x = biga + bigb
c	write(6,*) 'cubic = ',x**3 +a*x +b
	orbel_flon = x
c If capn is tiny (or zero) no need to go further than cubic even for
c e =1.
	if( capn .lt. TINY) go to 100

	do i = 1,IMAX
	  x2 = x*x
	  f = a0 +x*(a1+x2*(a3+x2*(a5+x2*(a7+x2*(a9+x2*(a11+x2))))))
	  fp = b1 +x2*(b3+x2*(b5+x2*(b7+x2*(b9+x2*(b11 + 13.d0*x2)))))   
	  dx = -f/fp
c	  write(6,*) 'i,dx,x,f : '
c	  write(6,432) i,dx,x,f
432	  format(1x,i3,3(2x,1p1e22.15))
	  orbel_flon = x + dx
c   If we have converged here there's no point in going on
	  if(abs(dx) .le. TINY) go to 100
	  x = orbel_flon
	enddo	

c Abnormal return here - we've gone thru the loop 
c IMAX times without convergence
	if(iflag .eq. 1) then
	   orbel_flon = -orbel_flon
	   capn = -capn
	endif
	write(6,*) 'FLON : RETURNING WITHOUT COMPLETE CONVERGENCE' 
	  diff = e*sinh(orbel_flon) - orbel_flon - capn
	  write(6,*) 'N, F, ecc*sinh(F) - F - N : '
	  write(6,*) capn,orbel_flon,diff
	return

c  Normal return here, but check if capn was originally negative
100	if(iflag .eq. 1) then
	   orbel_flon = -orbel_flon
	   capn = -capn
	endif

	return
	end     ! orbel_flon
c------------------------------------------------------------------
c
***********************************************************************
c                    ORBEL_ZGET.F
***********************************************************************
*     PURPOSE:  Solves the equivalent of Kepler's eqn. for a parabola 
*          given Q (Fitz. notation.)
*
*             Input:
*                           q ==>  parabola mean anomaly. (real scalar)
*             Returns:
*                  orbel_zget ==>  eccentric anomaly. (real scalar)
*
*     ALGORITHM: p. 70-72 of Fitzpatrick's book "Princ. of Cel. Mech."
*     REMARKS: For a parabola we can solve analytically.
*     AUTHOR: M. Duncan 
*     DATE WRITTEN: May 11, 1992.
*     REVISIONS: May 27 - corrected it for negative Q and use power
*	      series for small Q.
***********************************************************************

	real*8 function orbel_zget(q)

      include 'swift.inc'

c...  Inputs Only: 
	real*8 q

c...  Internals:
	integer iflag
	real*8 x,tmp

c----
c...  Executable code 

	iflag = 0
	if(q.lt.0.d0) then
	  iflag = 1
	  q = -q
	endif

	if (q.lt.1.d-3) then
	   orbel_zget = q*(1.d0 - (q*q/3.d0)*(1.d0 -q*q))
	else
	   x = 0.5d0*(3.d0*q + sqrt(9.d0*(q**2) +4.d0))
	   tmp = x**(1.d0/3.d0)
	   orbel_zget = tmp - 1.d0/tmp
	endif

	if(iflag .eq.1) then
           orbel_zget = -orbel_zget
	   q = -q
	endif
	
	return
	end    ! orbel_zget
c----------------------------------------------------------------------
c
c ##A1,7##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      M_FORMAT.FOR    (ErikSoft   31 January 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers (adapted by Andre Amarante - 6 March 2014)
c
c Makes an output format list and file header for the orbital-element files
c created by M_ELEM3.FOR
c Also identifies which orbital elements will be output for each object.
c
c------------------------------------------------------------------------------
c
c ##A1,8##
c ##ANO16,13##
      subroutine m_format (string,timestyle,nel,iel,fout,header,lenhead,
     %  mem,lmem,ce,list)
c ##ANO16,13##
c ##A1,8##
c
      implicit none
      include 'mercury.inc'
c
c Input/Output
c ##A12,3##
c ##A18,6##
c ##A19,5##
c ##A24,7##
c ##A22,3##
      integer timestyle,nel,iel(44),lenhead
c ##A22,3##
c ##A24,7##
c ##A19,5##
c ##A18,6##
c ##A12,3##
c ##A1,9##
c      character*250 string,header,fout
      character*250 string
      character*1000 header,fout
      integer lmem(NMESS)
      character*80 mem(NMESS)
      character*1 ce
c ##A1,9##
c ##ANO16,12##
      integer list
c ##ANO16,12##
c
c Local
c ##A1,10##
c      integer i,j,pos,nsub,lim(2,40),formflag,lenfout,f1,f2,itmp
      integer i,j,pos,nsub,lim(2,1000),formflag,lenfout,f1,f2,itmp
c ##A12,2##
c ##A18,5##
c ##A19,4##
c ##A20,6##
c ##A22,2##
      character*80 elcode(44)
c ##A1,10##
      character*9 elhead(44)
c ##A22,2##
c ##A20,6##
c ##A19,4##
c ##A18,5##
c ##A12,2##
c ##A1,11##
      integer k,posc
      character*80 c80
      integer lostfout,losthead
      character*2000 header2,fout2
c ##A1,11##
c
c------------------------------------------------------------------------------
c
c ##A1,12##
c ##A12,1##
c ##A18,4##
c ##A19,3##
c ##A20,5##
c ##A22,1##
      data elcode/ 'a','e','i','g','n','l','p','q','b','x','y','z',
     %  'u','v','w','r','f','m','o','s','d','dce','hil','rad','imp',
     %  'rx','ry','rz','ru','rv','rw','vel','ang','dis','fac','id',
     %  'coo','elh','elk','elp','elq','ell','elac','elas'/
      data elhead/ '    a    ','    e    ','    i    ','   peri  ',
     %  '   node  ','    M    ','   long  ','    q    ','    Q    ',
     %  '    x    ','    y    ','    z    ','    vx   ','    vy   ',
     %  '    vz   ','    r    ','    f    ','   mass  ','   oblq  ',
     %  '   spin  ','   dens  ','   dmin  ','   hill  ','  radius ',
     %  '  impact ','    rx   ','    ry   ','    rz   ','   rvx   ',
     %  '   rvy   ','   rvz   ',' velocity','  angle  ',' distance',
     %  '   face  ','  idtag  ','libration','   elh   ','   elk   ',
     %  '   elp   ','   elq   ','  lambda ','   elac  ','   elas  '/
c ##A22,1##
c ##A20,5##
c ##A19,3##
c ##A18,4##
c ##A12,1##
c ##A1,12##
c
c Initialize header to a blank string
c ##A1,13##
      do i = 1, 1000
c ##A1,13##
        header(i:i) = ' '
      end do
c
c Create part of the format list and header for the required time style
      if (timestyle.eq.0.or.timestyle.eq.2) then
        fout(1:9) = '(1x,f18.5'
c ##A1,14##
c ##ANO16,9##
        header(1:19) = '    Time (days)    '
        if (ce.ne.'p'.or.list.eq.1) then
        fout(10:15) = ',1x,a8'
        lenfout = 15
        header(20:28) = '  Object '
        lenhead = 28
        else if (list.eq.0) then
        fout(10:12) = ',1x'
        lenfout = 12
        lenhead = 19
        end if
c ##ANO16,9##
        lostfout = 9
        losthead = 19
c ##A1,14##
      else if (timestyle.eq.1) then
        fout(1:21) = '(1x,i10,1x,i2,1x,f8.5'
c ##A1,15##
c ##ANO16,10##
        header(1:23) = '    Year/Month/Day     '
        if (ce.ne.'p'.or.list.eq.1) then
        fout(22:27) = ',1x,a8'
        lenfout = 27
        header(24:32) = '  Object '
        lenhead = 32
        else if (list.eq.0) then
        fout(22:24) = ',1x'
        lenfout = 24
        lenhead = 23
        end if
c ##ANO16,10##
        lostfout = 21
        losthead = 23
c ##A1,15##
      else if (timestyle.eq.3) then
        fout(1:9) = '(1x,f18.7'
c ##A1,16##
c ##ANO16,11##
        header(1:19) = '    Time (years)   '
        if (ce.ne.'p'.or.list.eq.1) then
        fout(10:15) = ',1x,a8'
        lenfout = 15
        header(20:28) = '  Object '
        lenhead = 28
        else if (list.eq.0) then
        fout(10:12) = ',1x'
        lenfout = 12
        lenhead = 19
        end if
c ##ANO16,11##
        lostfout = 9
        losthead = 19
c ##A1,16##
      end if
c
c Identify the required elements
      call mio_spl (250,string,nsub,lim)
c ##A1,17##
      do i = 1, nsub
        iel(i) = 0
      end do
c ##A1,17##
      do i = 1, nsub
c ##A12,4##
c ##A18,7##
c ##A19,6##
c ##A24,8##
c ##A22,4##
        do j = 1, 44
c ##A22,4##
c ##A24,8##
c ##A19,6##
c ##A18,7##
c ##A12,4##
c ##A1,18##
c          if (string(lim(1,i):lim(1,i)).eq.elcode(j)) iel(i) = j
          do k = lim(1,i), lim(2,i)
            if (.not.(LGT(string(k:k),'9'))) then
              posc = k
              goto 10
            end if
          end do
          posc = k
  10      do k = 1, 80
            c80(k:k) = ' '
          end do
          c80(1:(posc-lim(1,i))) = string(lim(1,i):(posc-1))
          if (LLE(c80(1:80),elcode(j)(1:80))
     %      .and.LGE(c80(1:80),elcode(j)(1:80))) iel(i) = j
c ##A1,18##
        end do
c ##A1,19##
        if (iel(i).eq.0) then
          goto 666
        end if
c ##A1,19##
      end do
      nel = nsub
c
c For each element, see whether normal or exponential notation is required
      do i = 1, nsub
        formflag = 0
c ##A1,20##
        do k = lim(1,i), lim(2,i)
          if (.not.(LGT(string(k:k),'9'))) then
            posc = k
            goto 20
          end if
        end do
        posc = 0
        goto 50
  20    do j = posc, lim(2,i)
c ##A1,20##
          if (formflag.eq.0) pos = j
c ##A1,21##
          if (string(j:j).eq.'.'.or.string(j:j).eq.',') formflag = 1
          if (string(j:j).eq.'e'.or.string(j:j).eq.'E') formflag = 2
c ##A1,21##
        end do
c ##A1,22##
        if (pos.eq.lim(2,i)) then
  50      j = 7
          if (formflag.eq.2) then
            pos = pos - 1
            goto 30
          else if (formflag.eq.0.and.posc.eq.0) then
            f1 = 13
            goto 40
          end if
        end if
c ##A1,22##
c
c Create the rest of the format list and header
        if (formflag.eq.1) then
c ##A1,23##
          j = 3
          read (string(posc:pos-1),'(i2)',err=666) f1
          read (string(pos+1:lim(2,i)),'(i2)',err=666) f2
          f1 = abs(f1)
          f2 = abs(f2)
c ##A1,23##
          write (fout(lenfout+1:lenfout+10),'(a10)') ',1x,f  .  '
          write (fout(lenfout+6:lenfout+7),'(i2)') f1
          write (fout(lenfout+9:lenfout+10),'(i2)') f2
          lenfout = lenfout + 10
        else if (formflag.eq.2) then
c ##A1,24##
          j = 7
          read (string(posc:pos-1),'(i2)',err=666) f1
          read (string(pos+1:lim(2,i)-1),'(i2)',err=666) f2
          f1 = abs(f1)
          f2 = abs(f2)
c ##A1,24##
          write (fout(lenfout+1:lenfout+16),'(a16)') ',1x,1p,e  .  ,0p'
          write (fout(lenfout+9:lenfout+10),'(i2)') f1
c ##A1,25##
          write (fout(lenfout+12:lenfout+13),'(i2)') f2
c ##A1,25##
          lenfout = lenfout + 16
c ##A1,26##
        else if (formflag.eq.0) then
          j = 7
  30      read (string(posc:pos),'(i2)',err=666) f1
          f1 = abs(f1)
  40      f2 = f1 - 7
          f2 = abs(f2)
          write (fout(lenfout+1:lenfout+16),'(a16)') ',1x,1p,e  .  ,0p'
          write (fout(lenfout+9:lenfout+10),'(i2)') f1
          write (fout(lenfout+12:lenfout+13),'(i2)') f2
          lenfout = lenfout + 16
c ##A1,26##
        end if
c ##A1,27##
        if (f1.lt.f2+j) then
          write(*,'(3a,/,2a,i1,a2)') mem(121)(1:lmem(121)),
     %      mem(110)(1:lmem(110)),string(lim(1,i):lim(2,i)),
     %      mem(140)(1:lmem(140)),mem(141)(1:lmem(141)),j,'".'
        end if
c ##A1,27##
        itmp = (f1 - 9) / 2
        header(lenhead+itmp+2:lenhead+itmp+10) = elhead(iel(i))
        lenhead = lenhead + f1 + 1
      end do
c ##A1,28##
c ##A11,7##
      if ((ce.eq.'b'.or.ce.eq.'c').or.(ce.eq.'d'.or.ce.eq.'f')) then
c ##A11,7##
        fout2 = fout(1:lenfout)//fout(lostfout+1:lenfout)
        fout = fout2
        lenfout = 2*lenfout - lostfout
        header2 = header(1:lenhead)//header(losthead+1:lenhead)
        header = header2
        lenhead = 2*lenhead - losthead
        call mio_spl (1000,header,nsub,lim)
        if ((timestyle.eq.0.or.timestyle.eq.2)
     %    .or.timestyle.eq.3) then
          j = 3
        else if (timestyle.eq.1) then
          j = 2
        end if
        do i = j + 1, nel + j
          header(lim(2,i)+1:lim(2,i)+1) = '1'
        end do
        do i = nel + j + 2, nsub
          header(lim(2,i)+1:lim(2,i)+1) = '2'
        end do
      end if
c ##A1,28##
c
      lenfout = lenfout + 1
      fout(lenfout:lenfout) = ')'
c
c------------------------------------------------------------------------------
c
      return
c ##A1,29##
 666  call mio_err (6,mem(81),lmem(81),mem(110),lmem(110),
     %  string(lim(1,i):lim(2,i)),lim(2,i)-lim(1,i)+1,
     %  mem(111),lmem(111))
c ##A1,29##
      end
c
c ##A1,7##
c
c ##A1,53##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCE_SPIN.FOR    (ErikSoft  2 December 1999)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Calculates the spin rate (in rotations per day) for a fluid body given
c its mass, spin angular momentum and density. The routine assumes the
c body is a MacClaurin ellipsoid, whose axis ratio is defined by the
c quantity SS = SQRT(A^2/C^2 - 1), where A and C are the
c major and minor axes.
c
c OBS: o spin rate (rote) é dado como uma frequência f, ou seja, w=2*pi/T ->
c T=2*pi/w -> 1/T=w/(2*pi) -> f=w/(2*pi) -> rote=w/(2*pi) -> w=rote*(2*pi),
c onde w é a velocidade de rotação, que é dada na mesma unidade de tempo que o K2.
c
c------------------------------------------------------------------------------
c
      subroutine mce_spin (g,mass,spin,rho,rote)
c
      implicit none
      include 'mercury.inc'
c
c Input/Output
      real*8 g,mass,spin,rho,rote
c
c Local
      integer k
      real*8 ss,s2,f,df,z,dz,tmp0,tmp1,t23
c
c------------------------------------------------------------------------------
c
      t23 = 2.d0 / 3.d0
      tmp1 = spin * spin / (2.d0 * PI * rho * g) 
     %     * ( 250.d0*PI*PI*rho*rho / (9.d0*mass**5) )**t23
c
c Calculate SS using Newton's method
      ss = 1.d0
      do k = 1, 20
        s2 = ss * ss
        tmp0 = (1.d0 + s2)**t23
        call m_sfunc (ss,z,dz)
        f = z * tmp0  -  tmp1
        df = tmp0 * ( dz  +  4.d0 * ss * z / (3.d0*(1.d0 + s2)) )
        ss = ss - f/df
      end do
c
c A Eq. 5-141 de 140_the_Maclaurin_Ellipsoid.pdf diz que (com ss=e', subrotina m_sfunc):
c w^2 / (2 * pi * g * rho) = [ (3 + ss^2) * arctan(ss) - 3 * ss ] / ss^3 = z (subrotina m_sfunc); w é a velocidade de rotação, g a constante gravitacional e rho a densidade.
c Logo, w^2 / (2 * pi * g * rho) = z -> w^2 = 2 * pi * g * rho * z -> w = (2 * pi * g * rho * z)^(1/2).
c Mas, w=2*pi/T -> T=2*pi/w -> 1/T=w/(2*pi) -> f=w/(2*pi) -> rote=w/(2*pi) ->
c rote=(2 * pi * g * rho * z)^(1/2) / (2*pi), onde w é a velocidade de rotação, que é dada na mesma unidade de tempo que o K2. Pois, da equação
c w^2 / (2 * pi * g * rho) = z, se fizermos a análise dimensional com d=distância, m=massa, t=tempo, temos:
c w^2 / (2 * pi * [d^3/m/t^2] * [m/d^3]) = z -> w^2 / (2 * pi) * [t^2] = z. Como w tem dimensão de [1/t]. Então,
c [1/t]^2 / (2 * pi) * [t^2] = z -> z = 1 / (2 * pi), ou seja, z é um parâmetro adimensional.
c Da equação w^2 / (2 * pi) * [t^2] = z, temos que: w^2 = 2 * pi * z / [t^2] -> w = (2 * pi * z)^(1/2) / [t], isto é,
c w tem dimensão de inverso de tempo, como era esperado. Como, este tempo vem da constante gravitacional g, que por sua vez
c está relacionada com o K2, então a velocidade de rotação também estará na mesma unidade de tempo que o K2.
c No caso dessa subrotina g = 1.0, pois o K2 já está embutido na densidade rho por meio da constante rhocgs = AU * AU * AU * K2 / MSUN,
c que converte a densidade rho de g/cm^3 nas unidades convenientes escolhidas do Mercury, além de multiplicar a densidade por K2.
c
c rote = f = w / (2 * pi) = (2 * pi * g * rho * z)^(1/2) / (2 * pi) -> w = rote * (2 * pi)
      rote = sqrt(TWOPI * g * rho * z) / TWOPI
c
c------------------------------------------------------------------------------
c
      return
      end
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      M_SFUNC.FOR     (ErikSoft  14 November 1998)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Calculates Z = [ (3 + S^2)arctan(S) - 3S ] / S^3 and its derivative DZ,
c for S > 0.
c
c------------------------------------------------------------------------------
c
      subroutine m_sfunc (s,z,dz)
c
      implicit none
c
c Input/Output
      real*8 s, z, dz
c
c Local
      real*8 s2,s4,s6,s8,a
c
c------------------------------------------------------------------------------
c
      s2 = s * s
c
      if (s.gt.1.d-2) then
        a  = atan(s)
        z  = ((3.d0 + s2)*a - 3.d0*s) / (s * s2)
        dz = (2.d0*s*a - 3.d0 + (3.d0+s2)/(1.d0+s2)) / (s * s2)
     %     - 3.d0 * z / s
      else
        s4 = s2 * s2
        s6 = s2 * s4
        s8 = s4 * s4
        z  = - .1616161616161616d0*s8
     %       + .1904761904761905d0*s6
     %       - .2285714285714286d0*s4
     %       + .2666666666666667d0*s2
        dz = s * (- 1.292929292929293d0*s6
     %            + 1.142857142857143d0*s4
     %            - 0.914285714285714d0*s2
     %            + 0.533333333333333d0)
      end if
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A1,53##
c
c ##A3,6##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      IDBCLOO.FOR    (8 March 2014)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante (A. Amarante)
c
c Dados um vetor de caracteres e uma string, a subrotina verifica se essa
c string encontra-se no vetor. Caso ela não se encontre no vetor a subrotina
c anexa-a ao final do mesmo.
c
c------------------------------------------------------------------------------
c
      subroutine idbcloo (nidt,idt,id,i)
c
      implicit none
      include 'mercury.inc'
c
c Input/Output
      integer nidt,i
      character*8 idt(NMAX),id
c
c Local
      integer flag,k
c
c------------------------------------------------------------------------------
c
      if (nidt.eq.0) then
        nidt = 1
        i = nidt
        idt(nidt) = id
      else
        flag = 0
        do k = 1, nidt
          if (id.eq.idt(k)(1:8)) then
            i = k
            flag = 1
          end if
        end do
        if (flag.eq.0) then
          nidt = nidt + 1
          i = nidt
          idt(nidt) = id
        end if
      end if
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A3,6##
c
c ##A7,6##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_H2SYN.FOR    (18 March 2014)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante (A. Amarante) - andre.amarante@unesp.br
c
c Converts barycentric coordinates to synodic coordinates.
c
c------------------------------------------------------------------------------
c
      subroutine mco_h2syn (i0,flag,t,nbod,m,xh,vh,x,v,n)
c
      implicit none
      include 'mercury.inc'
c
c Input/Output
      integer nbod
      integer i0,flag
      real*8 t,n
      real*8 m(nbod),xh(3,nbod),vh(3,nbod),x(3,nbod),v(3,nbod)
c
c Local
      real*8 a0,mbin,gm,nn,gama,sg,cg
      integer j
      real*8 a,e,i,p,n1,l,q
c
c------------------------------------------------------------------------------
c
      save a0,i
c
c      mbin = m(1) + m(2)
c      nn = 0.d0
c
c Put Cartesian coordinates into element arrays
c      do j = i0, nbod
c
c Convert to Keplerian orbital elements
c        gm = m(1) + m(j)
c        if (i0.eq.3) gm = mbin + m(j)
c ##A9,8##
c        if (i0.eq.4) gm = mbin + m(3) + m(j)
c ##A9,8##
c        call mco_x2el (gm,xh(1,j),xh(2,j),xh(3,j),vh(1,j),vh(2,j),
c     %    vh(3,j),q,e,i,p,n1,l)
c        a = q / (1.d0 - e)
c        i = i / DR
c        i = 90 - i
c
c If orbit is hyperbolic, use the distance rather than the semi-major axis
c        if (a.le.0) a = sqrt(xh(1,j)*xh(1,j)+xh(2,j)*xh(2,j))
c
c Calculate average mean motion n in radians/days
c        n = sqrt(gm/a**3)
c        n = sign (n, i)
c        nn = nn + n
c
        if (flag.eq.0) then
          flag = 1
          a0 = sqrt(xh(1,i0)*xh(1,i0)+xh(2,i0)*xh(2,i0))
          a0 = acos(xh(1,i0)/a0)
c          a0 = sign (a0, n)
          gm = m(1) + m(i0)
          call mco_x2el (gm,xh(1,i0),xh(2,i0),xh(3,i0),vh(1,i0),
     %      vh(2,i0),vh(3,i0),q,e,i,p,n1,l)
          a = q / (1.d0 - e)
          i = i / DR
          i = 90 - i
        end if
c      end do
c
c      n = nn / (nbod - (i0 - 1))
      n = sign (n, i)
      a0 = sign (a0, n)
      gama = n * t + a0
      call mco_sine (gama,sg,cg)
c
c Calculate the synodic coordinates and velocities
      do j = i0, nbod
        x(1,j) =  xh(1,j) * cg + xh(2,j) * sg
        x(2,j) = -xh(1,j) * sg + xh(2,j) * cg
        x(3,j) =  xh(3,j)
        v(1,j) =  (vh(1,j) + n * xh(2,j)) * cg +
     %    (vh(2,j) - n * xh(1,j)) * sg
        v(2,j) = -(vh(1,j) + n * xh(2,j)) * sg +
     %    (vh(2,j) - n * xh(1,j)) * cg
        v(3,j) =  vh(3,j)
      enddo
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A7,6##
c
c ##A9,1##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_H2UB.FOR    (ErikSoft   2 March 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers (adapted by A. Amarante - 22 January 2015)
c
c Convert coordinates with respect to the central body to user coordinates
c for close-binary systems.
c
c------------------------------------------------------------------------------
c
      subroutine mco_h2ub (algor,jcen,nbod,nbig,h,m,xh,vh,x,v)
c
      implicit none
c
c Input/Output
      integer algor,nbod,nbig
      real*8 jcen(3),h,m(nbod),xh(3,nbod),vh(3,nbod),x(3,nbod)
      real*8 v(3,nbod)
c
c Local
      integer j
      real*8 temp
      integer i0
      real*8 msum,mbin,mbin_1,temp2
      real*8 mxsum(3),mxsum2(3),mvsum(3),mvsum2(3)
c
c------------------------------------------------------------------------------
c
      temp = m(2) / (m(1) + m(2))
c
      x(1,2) = xh(1,2) - temp * xh(1,2)
      x(2,2) = xh(2,2) - temp * xh(2,2)
      x(3,2) = xh(3,2) - temp * xh(3,2)
      v(1,2) = vh(1,2) - temp * vh(1,2)
      v(2,2) = vh(2,2) - temp * vh(2,2)
      v(3,2) = vh(3,2) - temp * vh(3,2)
c
      if (algor.eq.11.or.algor.eq.12) i0 = 3
      if (algor.eq.5) i0 = 4
c
      msum = 0.d0
      mxsum(1) = 0.d0
      mxsum(2) = 0.d0
      mxsum(3) = 0.d0
      mvsum(1) = 0.d0
      mvsum(2) = 0.d0
      mvsum(3) = 0.d0
      mbin = m(1) + m(2)
      mbin_1 = 1.d0 / mbin
c
      do j = i0, nbod
        msum = msum + m(j)
        mxsum(1) = mxsum(1)  +  m(j) * xh(1,j)
        mxsum(2) = mxsum(2)  +  m(j) * xh(2,j)
        mxsum(3) = mxsum(3)  +  m(j) * xh(3,j)
        mvsum(1) = mvsum(1)  +  m(j) * vh(1,j)
        mvsum(2) = mvsum(2)  +  m(j) * vh(2,j)
        mvsum(3) = mvsum(3)  +  m(j) * vh(3,j)
      end do
c
      temp2 = 1.d0 / (msum + mbin)
c
      mxsum2(1) = temp2 * (mxsum(1) + m(2) * xh(1,2))
      mxsum2(2) = temp2 * (mxsum(2) + m(2) * xh(2,2))
      mxsum2(3) = temp2 * (mxsum(3) + m(2) * xh(3,2))
      mvsum2(1) = temp2 * (mvsum(1) + m(2) * vh(1,2))
      mvsum2(2) = temp2 * (mvsum(2) + m(2) * vh(2,2))
      mvsum2(3) = temp2 * (mvsum(3) + m(2) * vh(3,2))
c
      x(1,3) = xh(1,3)  -  mxsum2(1)
      x(2,3) = xh(2,3)  -  mxsum2(2)
      x(3,3) = xh(3,3)  -  mxsum2(3)
      v(1,3) = vh(1,3)  -  mvsum2(1)
      v(2,3) = vh(2,3)  -  mvsum2(2)
      v(3,3) = vh(3,3)  -  mvsum2(3)
c
      if (algor.eq.12) then
        i0 = nbod + 1
        temp = 1.d0 / (msum + m(1))
        x(1,2) = xh(1,2)  -  temp * mxsum(1)
        x(2,2) = xh(2,2)  -  temp * mxsum(2)
        x(3,2) = xh(3,2)  -  temp * mxsum(3)
        v(1,2) = vh(1,2)  -  temp * mvsum(1)
        v(2,2) = vh(2,2)  -  temp * mvsum(2)
        v(3,2) = vh(3,2)  -  temp * mvsum(3)
      end if
c
      do j = i0, nbod
        x(1,j) = xh(1,j)  -  temp * xh(1,2)
        x(2,j) = xh(2,j)  -  temp * xh(2,2)
        x(3,j) = xh(3,j)  -  temp * xh(3,2)
        v(1,j) = vh(1,j)  -  temp * vh(1,2)
        v(2,j) = vh(2,j)  -  temp * vh(2,2)
        v(3,j) = vh(3,j)  -  temp * vh(3,2)
      end do
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A9,1##
c
c ##A9,2##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_H2WB.FOR    (ErikSoft   2 March 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Convert coordinates with respect to the central body to wide-binary
c coordinates.
c
c------------------------------------------------------------------------------
c
      subroutine mco_h2wb (jcen,nbod,nbig,h,m,xh,vh,x,v)
c
      implicit none
c
c Input/Output
      integer nbod,nbig,ngflag,opt(8)
      real*8 time,jcen(3),h,m(nbod),xh(3,nbod),vh(3,nbod),x(3,nbod)
      real*8 v(3,nbod),ngf(4,nbod)
c
c Local
      integer j
      real*8 msum,mxsum(3),mvsum(3),temp,tmp2,tmp3
c
c------------------------------------------------------------------------------
c
      mxsum(1) = 0.d0
      mxsum(2) = 0.d0
      mxsum(3) = 0.d0
      msum = 0.d0
      mvsum(1) = 0.d0
      mvsum(2) = 0.d0
      mvsum(3) = 0.d0
c
      do j = 3, nbod
        x(1,j) = xh(1,j)
        x(2,j) = xh(2,j)
        x(3,j) = xh(3,j)
        mxsum(1) = mxsum(1)  +  m(j) * xh(1,j)
        mxsum(2) = mxsum(2)  +  m(j) * xh(2,j)
        mxsum(3) = mxsum(3)  +  m(j) * xh(3,j)
        msum = msum + m(j)
        mvsum(1) = mvsum(1)  +  m(j) * vh(1,j)
        mvsum(2) = mvsum(2)  +  m(j) * vh(2,j)
        mvsum(3) = mvsum(3)  +  m(j) * vh(3,j)
      end do
c
      temp = 1.d0 / (m(1) + msum)
      tmp3 = 1.d0 / (m(1) + msum + m(2))
      tmp2 = (m(1) + msum) * tmp3
c
      x(1,2) = xh(1,2)  -  temp * mxsum(1)
      x(2,2) = xh(2,2)  -  temp * mxsum(2)
      x(3,2) = xh(3,2)  -  temp * mxsum(3)
      v(1,2) = tmp2 * vh(1,2)  -  tmp3 * mvsum(1)
      v(2,2) = tmp2 * vh(2,2)  -  tmp3 * mvsum(2)
      v(3,2) = tmp2 * vh(3,2)  -  tmp3 * mvsum(3)
c
      mvsum(1) = temp * mvsum(1)
      mvsum(2) = temp * mvsum(2)
      mvsum(3) = temp * mvsum(3)
      do j = 3, nbod
        v(1,j) = vh(1,j) - mvsum(1)
        v(2,j) = vh(2,j) - mvsum(2)
        v(3,j) = vh(3,j) - mvsum(3)
      end do
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A9,2##
c
c ##A9,3##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_H2SABP.FOR    (ErikSoft   2 March 2001)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers (adapted by A. Amarante and A. Izidoro - 18 July 2014)
c
c Convert coordinates with respect to the central body to S(AB)-P coordinates.
c
c OBS: Para se ter uma idéia de como encontrar as equações das novas
c coordenadas veja as equações 9 e 16 da referência [2] e as equações 1 da
c referência [1] da implementação ##AAR1,n##. Sempre levando em conta o centro
c de massa do subsistema que está se considerando. Já para encontrar as
c equações dos novos momentos deve-se primeiro isolar as coordenadas antigas em
c função das novas usando as equações encontradas das novas coordenadas e
c depois usar o procedimento da função geradora descrito no apêndice da
c referência [2]. Os novos momentos podem ser encontrados na referência [1],
c equações 2.
c
c------------------------------------------------------------------------------
c
      subroutine mco_h2sabp (jcen,nbod,nbig,h,m,xh,vh,x,v)
c
      implicit none
c
c Input/Output
      integer nbod,nbig,ngflag,opt(8)
      real*8 time,jcen(3),h,m(nbod),xh(3,nbod),vh(3,nbod),x(3,nbod)
      real*8 v(3,nbod),ngf(4,nbod)
c
c Local
      integer j
      real*8 msum,mvsum(3),temp,mbin,mbin_1,mtot_1
c
      real*8 mxsum(3),mtri,mvsum2(3)
c
c------------------------------------------------------------------------------
c
      msum = 0.d0
c
      mxsum(1) = 0.d0
      mxsum(2) = 0.d0
      mxsum(3) = 0.d0
c
      mvsum(1) = 0.d0
      mvsum(2) = 0.d0
      mvsum(3) = 0.d0
      mbin = m(1) + m(2)
      mbin_1 = 1.d0 / mbin
c
      mtri = mbin + m(3)
c
      x(1,2) = xh(1,2)
      x(2,2) = xh(2,2)
      x(3,2) = xh(3,2)
      temp = m(1) * mbin_1
      v(1,2) = temp * vh(1,2)
      v(2,2) = temp * vh(2,2)
      v(3,2) = temp * vh(3,2)
c
      do j = 4, nbod
        msum = msum + m(j)
c
        mxsum(1) = mxsum(1)  +  m(j) * xh(1,j)
        mxsum(2) = mxsum(2)  +  m(j) * xh(2,j)
        mxsum(3) = mxsum(3)  +  m(j) * xh(3,j)
c
        mvsum(1) = mvsum(1)  +  m(j) * vh(1,j)
        mvsum(2) = mvsum(2)  +  m(j) * vh(2,j)
        mvsum(3) = mvsum(3)  +  m(j) * vh(3,j)
      end do
c
      mtot_1 = 1.d0 / (msum + mbin)
c
      mxsum(1) = mtot_1 * (mxsum(1) + m(2)*xh(1,2))
      mxsum(2) = mtot_1 * (mxsum(2) + m(2)*xh(2,2))
      mxsum(3) = mtot_1 * (mxsum(3) + m(2)*xh(3,2))
      x(1,3) = xh(1,3)  -  mxsum(1)
      x(2,3) = xh(2,3)  -  mxsum(2)
      x(3,3) = xh(3,3)  -  mxsum(3)
      temp = 1.d0 / (msum + mtri)
      mvsum2(1) = temp * (mvsum(1) + m(2)*vh(1,2) + m(3)*vh(1,3))
      mvsum2(2) = temp * (mvsum(2) + m(2)*vh(2,2) + m(3)*vh(1,3))
      mvsum2(3) = temp * (mvsum(3) + m(2)*vh(3,2) + m(3)*vh(1,3))
      v(1,3) = vh(1,3)  -  mvsum2(1)
      v(2,3) = vh(2,3)  -  mvsum2(2)
      v(3,3) = vh(3,3)  -  mvsum2(3)
c
      mvsum(1) = mtot_1 * (mvsum(1) + m(2)*vh(1,2))
      mvsum(2) = mtot_1 * (mvsum(2) + m(2)*vh(2,2))
      mvsum(3) = mtot_1 * (mvsum(3) + m(2)*vh(3,2))
c
      temp = m(2) * mbin_1
      do j = 4, nbod
        x(1,j) = xh(1,j)  -  temp * xh(1,2)
        x(2,j) = xh(2,j)  -  temp * xh(2,2)
        x(3,j) = xh(3,j)  -  temp * xh(3,2)
        v(1,j) = vh(1,j)  -  mvsum(1)
        v(2,j) = vh(2,j)  -  mvsum(2)
        v(3,j) = vh(3,j)  -  mvsum(3)
      end do
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A9,3##
c
c ##A10,4##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      ORB_VERIF2.FOR    (31 December 2014)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante (A. Amarante) - andre.amarante@unesp.br
c
c Verifica se algum corpo não existe.
c
c------------------------------------------------------------------------------
c
      subroutine orb_verif2 (nbod,cont,id,oid,idc,icen,lmem,mem)

c
      implicit none
      include 'mercury.inc'
c
c Input/Output
      integer nbod,cont,icen
      character*8 id(nbod),oid(2,cont),idc
      integer lmem(NMESS)
      character*80 mem(NMESS)
c
c Local
      integer j,l,flagid
c
c------------------------------------------------------------------------------
c
      do l = 1, cont
        flagid = 0
        do j = 1, nbod
          if (oid(1,l)(1:8).eq.id(j)(1:8)) flagid = 1
        end do
        if (flagid.eq.0) call mio_err (6,mem(81),lmem(81),
     %    mem(116),lmem(116),oid(1,l),8,
     %    '       Check close.in',21)
      end do
c
      do l = 1, cont
        flagid = 0
        do j = 1, nbod
          if (oid(2,l)(1:8).eq.id(j)(1:8)) flagid = 1
        end do
        if (oid(2,l)(1:8).eq.idc(1:8)) flagid = 1
        if (flagid.eq.0) call mio_err (6,mem(81),lmem(81),
     %    mem(116),lmem(116),oid(2,l),8,
     %    '       Check close.in',21)
      end do
c
      icen = 1
      do j = 1, nbod
        if (idc(1:8).eq.id(j)(1:8)) then
          icen = j + 1
        end if
      end do
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A10,4##
c
c ##A10,6##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      ORB_OI2.FOR    (31 December 2014)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante (A. Amarante) - andre.amarante@unesp.br
c
c Encontra o índice do corpo que é orbitado.
c
c------------------------------------------------------------------------------
c
      subroutine orb_oi2 (j,nbod,cont,icen,id,oid,idc,oi,flagorb)
c
      implicit none
c
c Input/Output
      integer j,nbod,cont,icen,oi,flagorb
      character*8 id(nbod),oid(2,cont),idc
c
c Local
      integer l,k,flagorb1,flagorb2
c
c------------------------------------------------------------------------------
c
      oi = icen
c
      flagorb1 = 0
      flagorb2 = 0
c
      do l = 1, cont
        if (oid(1,l)(1:8).eq.id(j)(1:8)) then
          k = l
          flagorb1 = 1
        end if
      end do
c
      if (flagorb1.eq.1) then
        do l = 1, nbod
          if (oid(2,k)(1:8).eq.id(l)(1:8)) then
            oi = l + 1
            flagorb2 = 1
          end if
        end do
      end if
c
      if (flagorb2.eq.0.and.flagorb1.eq.1) then
        if (oid(2,k)(1:8).eq.idc(1:8)) then
c          oi = icen
          flagorb2 = 1
        end if
      end if
c
      flagorb = flagorb1 * flagorb2
c
      if (flagorb.eq.0.and.icen.ne.1) then
        do l = 1, nbod
          if (idc(1:8).eq.id(l)(1:8)) then
c            oi = icen
            flagorb = 1
          end if
        end do
      end if
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A10,6##
c
c ##A10,7##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_X2ORB.FOR    (31 December 2014)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante (A. Amarante) - andre.amarante@unesp.br
c
c Converte as coordenadas e velocidades de um corpo para um corpo de referência.
c
c------------------------------------------------------------------------------
c
      subroutine mco_x2orb (j,nbod,flag,i,x0,v0,x,v)
c
      implicit none
c
c Input/Output
      integer j,nbod,flag,i
      real*8 x0(3,nbod+1),v0(3,nbod+1),x(3,nbod+1),v(3,nbod+1)
c
c Local
      integer k
c
c------------------------------------------------------------------------------
c
      if (flag.eq.1) then
        do k = 1, 3
          x(k,j+1) = x0(k,j+1) - x0(k,i)
          v(k,j+1) = v0(k,j+1) - v0(k,i)
        end do
      end if
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A10,7##
c
c ##A12,8##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_X2A.FOR    (ErikSoft   4 October 2000)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Calculates an object's orbital semi-major axis given its Cartesian coords.
c
c------------------------------------------------------------------------------
c
      subroutine mco_x2a (gm,x,y,z,u,v,w,a,r,v2)
c
      implicit none
c
c Input/Output
      real*8 gm,x,y,z,u,v,w,a,r,v2
c
c------------------------------------------------------------------------------
c
      r  = sqrt(x * x  +  y * y  +  z * z)
      v2 =      u * u  +  v * v  +  w * w
      a  = gm * r / (2.d0 * gm  -  r * v2)
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A12,8##
c
c ##A12,9##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCE_HILL.FOR    (ErikSoft   4 October 2000)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers (adapted by A. Amarante - 28 July 2016)
c
c Calculates the Hill radii for all objects given their masses, M,
c coordinates, X, and velocities, V; plus the mass of the central body, M(1)
c Where HILL = a * (m/3*m(1))^(1/3)
c
c If the orbit is hyperbolic or parabolic, the Hill radius is calculated using:
c       HILL = r * (m/3*m(1))^(1/3)
c where R is the current distance from the central body.
c
c The routine also gives the semi-major axis, A, of each object's orbit.
c
c N.B. Designed to use heliocentric coordinates, but should be adequate using
c ===  barycentric coordinates.
c
c------------------------------------------------------------------------------
c
      subroutine mce_hill (m1,m2,x,y,z,u,v,w,hill,a)
c
      implicit none
      include 'mercury.inc'
      real*8 THIRD
      parameter (THIRD = .3333333333333333d0)
c
c Input/Output
      real*8 m1,m2,x,y,z,u,v,w,hill,a
c
c Local
      real*8 r, v2, gm
c
c------------------------------------------------------------------------------
c
      gm = m1 + m2
      call mco_x2a (gm,x,y,z,u,v,w,a,r,v2)
c If orbit is hyperbolic, use the distance rather than the semi-major axis
      if (a.le.0) a = r
      hill = a * (THIRD * m2 / m1)**THIRD
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A12,9##
c
c ##A9,12##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_H2AST.FOR    (FEG   7 March 2016)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: Andre Amarante (A. Amarante) - andre.amarante@unesp.br
c
c Converts coordinates with respect to the central body to synodic
c coordinates.
c
c------------------------------------------------------------------------------
c
      subroutine mco_h2ast (time,jcen,nbod,nbig,h,m,xh,vh,x,v)
c
      implicit none
c
c Input/Output
      integer nbod,nbig
      real*8 time,jcen(3),h,m(nbod),x(3,nbod),v(3,nbod),xh(3,nbod)
      real*8 vh(3,nbod)
c
c Local
      integer k
      real*8 gama,sg,cg
c
c------------------------------------------------------------------------------
c
      gama = h * time
      call mco_sine (gama,sg,cg)
c
c Calculate the synodic coordinates and velocities
      do k = 2, nbod
        x(1,k) =  xh(1,k) * cg + xh(2,k) * sg
        x(2,k) = -xh(1,k) * sg + xh(2,k) * cg
        x(3,k) =  xh(3,k)
        v(1,k) =  (vh(1,k) + h * xh(2,k)) * cg +
     %    (vh(2,k) - h * xh(1,k)) * sg
        v(2,k) = -(vh(1,k) + h * xh(2,k)) * sg +
     %    (vh(2,k) - h * xh(1,k)) * cg
        v(3,k) =  vh(3,k)
      enddo
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A9,12##
c
c ##A23,9##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MIO_SPL2.FOR    (ErikSoft  14 November 1999)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers (adapted by A. Amarante - 2 March 2014)
c
c Given a character string STRING, of length LEN bytes, the routine finds 
c the beginnings and ends of NSUB substrings present in the original, and 
c delimited by spaces. The positions of the extremes of each substring are 
c returned in the array DELIMIT.
c Substrings are those which are separated by spaces or the = symbol.
c
c------------------------------------------------------------------------------
c
      subroutine mio_spl2 (len,string,nsub,delimit)
c
      implicit none
c
c Input/Output
c ##A19,140##
      integer len,nsub,delimit(2,1000)
c ##A19,140##
      character*1 string(len)
c
c Local
      integer j,k
      character*1 c
c
c------------------------------------------------------------------------------
c
      nsub = 0
      j = 0
      c = ' '
      delimit(1,1) = -1
c
c Find the start of string
  10  j = j + 1
      if (j.gt.len) goto 99
      c = string(j)
      if ((c.ne.'1'.and.c.ne.'2'.and.c.ne.'3'.and.c.ne.'4')
     %  .and.(c.ne.'5'.and.c.ne.'6'.and.c.ne.'7'.and.c.ne.'8')
     %  .and.(c.ne.'9'.and.c.ne.'0')) goto 10
c
c Find the end of string
      k = j
  20  k = k + 1
      if (k.gt.len) goto 30
      c = string(k)
      if ((c.eq.'1'.or.c.eq.'2'.or.c.eq.'3'.or.c.eq.'4')
     %  .or.(c.eq.'5'.or.c.eq.'6'.or.c.eq.'7'.or.c.eq.'8')
     %  .or.(c.eq.'9'.or.c.eq.'0')) goto 20
c
c Store details for this string
  30  nsub = nsub + 1
      delimit(1,nsub) = j
      delimit(2,nsub) = k - 1
c
      if (k.lt.len) then
        j = k
        goto 10
      end if
c
  99  continue
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A23,9##
c
c ##A21,8##
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c      MCO_H2B3.FOR    (ErikSoft   2 November 2000)
c
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c Author: John E. Chambers
c
c Converts coordinates with respect to the central body to barycentric
c coordinates.
c
c------------------------------------------------------------------------------
c
      subroutine mco_h2b3 (jcen,nbod,nbig,h,m,xh,vh,x,v,ini,fin)
c
      implicit none
c
c Input/Output
      integer nbod,nbig,ini,fin
      real*8 jcen(3),h,m(nbod),xh(3,nbod),vh(3,nbod),x(3,nbod),v(3,nbod)
c
c Local
      integer j
      real*8 mtot,temp
c
c------------------------------------------------------------------------------
c
      mtot = 0.d0
      x(1,1) = 0.d0
      x(2,1) = 0.d0
      x(3,1) = 0.d0
      v(1,1) = 0.d0
      v(2,1) = 0.d0
      v(3,1) = 0.d0
c
c Calculate coordinates and velocities of the central body
      do j = 2, nbod
        if (j.ge.ini.and.j.le.fin) then
        mtot = mtot  +  m(j)
        x(1,1) = x(1,1)  +  m(j) * xh(1,j)
        x(2,1) = x(2,1)  +  m(j) * xh(2,j)
        x(3,1) = x(3,1)  +  m(j) * xh(3,j)
        v(1,1) = v(1,1)  +  m(j) * vh(1,j)
        v(2,1) = v(2,1)  +  m(j) * vh(2,j)
        v(3,1) = v(3,1)  +  m(j) * vh(3,j)
        endif
      enddo
c
      temp = -1.d0 / (mtot + m(1))
      x(1,1) = temp * x(1,1)
      x(2,1) = temp * x(2,1)
      x(3,1) = temp * x(3,1)
      v(1,1) = temp * v(1,1)
      v(2,1) = temp * v(2,1)
      v(3,1) = temp * v(3,1)
c
c Calculate the barycentric coordinates and velocities
      do j = 2, nbod
        x(1,j) = xh(1,j) + x(1,1)
        x(2,j) = xh(2,j) + x(2,1)
        x(3,j) = xh(3,j) + x(3,1)
        v(1,j) = vh(1,j) + v(1,1)
        v(2,j) = vh(2,j) + v(2,1)
        v(3,j) = vh(3,j) + v(3,1)
      enddo
c
c------------------------------------------------------------------------------
c
      return
      end
c
c ##A21,8##

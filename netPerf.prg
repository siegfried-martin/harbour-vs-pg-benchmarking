//#define DEBUG
#ifndef DEBUG
   #translate trax([<list,...>])  =>
   #translate ?? [<list,...>] =>
#endif
#include 'set.ch'
#INCLUDE "dbinfo.ch"
#include "hbcompat.ch"
ANNOUNCE RDDSYS
//ANNOUNCE HB_GTSYS
//REQUEST HB_GT_CGI_DEFAULT

request strtran
request memotran
request pad

#ifndef __XHARBOUR__
request "hbnetio"


/* net:localhost:2941:topsecret:data/_tst_ */

//assume server is running in the netperf directory
//#define DBSERVER  "localhost"
//#define DBPORT    2941
//#define DBPASSWD  "topsecret"
//#define DBDIR     "data"
//#define DBFILE    "_tst_"
//#define DBNAME    "net:" + DBSERVER + ":" + hb_ntos( DBPORT ) + ":" + DBPASSWD + ":" + DBDIR + "/" + DBFILE

REQUEST hb_DirExists
REQUEST hb_DirCreate
REQUEST hb_DateTime



/* few PP rules which allow to execute RPC function using
 * pseudo object 'net', i.e. ? net:date()
 */
#xtranslate net:<!func!>( [<params,...>] ) => ;
            netio_FuncExec( #<func> [,<params>] )
#xtranslate net:[<server>]:<!func!>( [<params,...>] ) => ;
            netio_FuncExec( [ #<server> + ] ":" + #<func> [,<params>] )
#xtranslate net:[<server>]:<port>:<!func!>( [<params,...>] ) => ;
            netio_FuncExec( [ #<server> + ] ":" + #<port> + ":" + #<func> ;
                            [,<params>] )

#xtranslate net:exists:<!func!> => ;
            netio_ProcExists( #<func> )
#xtranslate net:exists:[<server>]:<!func!> => ;
            netio_ProcExists( [ #<server> + ] ":" + #<func> )
#xtranslate net:exists:[<server>]:<port>:<!func!> => ;
            netio_ProcExists( [ #<server> + ] ":" + #<port> + ":" + #<func> )




#xcommand DEFAULT <v1> TO <x1> [, <vn> TO <xn> ]                        ;
		  =>                                                            ;
		  IF <v1> == NIL ; <v1> := <x1> ; END                           ;
		  [; IF <vn> == NIL ; <vn> := <xn> ; END ]
#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]


#include "hbzlib.ch"
#endif

//static nNetperfSize:=4000000
static nNetperfSize:=100000


procedure main( ... )
	local cstation,adbf,x,dstart,tstart,nstart,cNet:=""
   LOCAL lNet
   local y,n2,ncol,nrow,nfail,ncount,ncomplete,ntot,cKey,h:={=>}
   local aParams:=hb_AParams(),lMaster,lrpc,nLocks
   private nLock,cPass,DBSERVER,DBPORT,DBPASSWD,DBDIR
   setmode(25,80)
   HSetCaseMatch(h,.f.)
   h['NETIO_SERVER']:=  ""
   h['NETIO_PORT']:= "2941"
   h['NETIO_PASSWD']:=  ""  //"topsecret"
   h['NETIO_DIR']:= ""
   h['MASTER']:=.f.
   h['NETIO_TIMEOUT']:=''
   #ifndef __XHARBOUR__
   h['NETIO_COMPRESSION']:=str(HB_ZLIB_COMPRESSION_SPEED)
   h['NETIO_STRATEGY']:=str(HB_ZLIB_STRATEGY_DEFAULT)
   #else
   h['NETIO_COMPRESSION']:=NIL
   h['NETIO_STRATEGY']:=NIL
   #endif
   h['DISABLEWAITLOCKS']:=.t.

   cStation:=getenv('computername')
   
   default_parameters(aParams,h)
   lMaster:=h['MASTER']
   if valtype(lMaster)="C"
      lMaster:=upper(alltrim(strtran(lMaster,'.','')))
      lMaster:=lMaster${'T','1'}
   endif
   #ifndef __XHARBOUR__
      if !empty(h['NETIO_SERVER'])
         //USE net:example.org:2942:path/to/file
         cNet:='net:'+alltrim(h['NETIO_SERVER'])+':'+h['NETIO_PORT']+':'+alltrim(h['NETIO_DIR'])
         ? "netio_Connect():",cNet
         lNet:=netio_Connect(h['NETIO_SERVER'],;
            val( h['NETIO_PORT']),;
            if(empty(h['NETIO_TIMEOUT']),nil,val( h['NETIO_TIMEOUT'])),;
            if(empty(h['NETIO_PASSWD']),nil,h['NETIO_PASSWD']),;
            if(empty(h['NETIO_COMPRESSION']),nil,val( h['NETIO_COMPRESSION'])),;
            if(empty(h['NETIO_STRATEGY']),nil,val( h['NETIO_STRATEGY']) ))
         ?lNet
         if !lNet
            ?"Could not connect to server"
            ?h['NETIO_SERVER'],val( h['NETIO_PORT']),val( h['NETIO_TIMEOUT']),h['NETIO_PASSWD'],val( h['NETIO_COMPRESSION']),val( h['NETIO_STRATEGY']) 
            inkey(10)
            quit
         endif
         cnet:="net:"
         ?'testing rpc'
         lRPC:=net:exists:qout
         ??lRpc
         if lRPC
            ?"RPC enabled"
            net:qout("Station: "+cStation)
         endif
         //hb_curdrive(cNet)
         //DirChange(cNet)
         set default to (cnet)
         //?"curdrive()",hb_curdrive()
         ?"Curdir():",curdir()
         ?"DefPath()",defpath()  //net:
         //cNet:=''
         ?"file('dbflock.ini'): ",file('dbflock.ini')
         ?"file('"+cNet+"dbflock.ini'): ",file(cNet+'dbflock.ini')
         ?"hb_vfexists('dbflock.ini'): ",hb_vfExists('dbflock.ini')
         ?"hb_vfexists('"+cNet+"dbflock.ini'): ",hb_vfexists(cNet+'dbflock.ini')
         
      endif
   #endif
   
	?
   trax()
   //set filecase lower
	//SET(_SET_FILECASE  ,'UPPER')
   IF empty(nLock)
      nLock:=SET(_SET_DBFLOCKSCHEME)
   else
		IF valtype(nLock)="C"
			nLock:=val(nLock)
         if !empty(nLock)
            SET(_SET_DBFLOCKSCHEME, nLock)
         endif
		ENDIF
	ENDIF
   if !empty(cPass)
      cPass:=alltrim(cPass)
   endif
   setcancel(.T.)
   hb_DISABLEWAITLOCKS(h['DISABLEWAITLOCKS'])
   ?'DisableWaitLocks',hb_DISABLEWAITLOCKS()
	//errorblock({|e|alertsys(e)})
//	set alternate to "atnight.log" additive
//	set alternate on
	set exclusive off
	set deleted off



	//cStation:=netconfig("Computer name")
	if !HB_DBExists(cnet+"netperf2.dbf")
      trax()
      ?"No File: ",cNet+"NETPERF2.DBF"
		lMaster:=.t.
      aDbf := {}
      AADD(aDbf, { "Station", "C", 25, 0 })
      aADD(aDbf, { "dStart", "D", 8, 0 })
      AADD(aDbf, { "tStart", "C", 8, 0 })
      AADD(aDbf, { "tEnd", "C", 8, 0 })
		AADD(aDbf, { "Elapsed", "N", 5, 0 })
      AADD(aDbf, { "Fail", "N", 5, 0 })
      AADD(aDbf, { "locks", "N", 6, 0 })
      AADD(aDbf, { "Avg", "N", 5, 0 })
      AADD(aDbf, { "Stations", "N", 5, 0 })
      AADD(aDbf, { "completed", "N", 5, 0 })
      AADD(aDbf, { "ttl_locks", "N", 7, 0 })
      AADD(aDbf, { "avg_locks", "N", 6, 0 })
      dbcreate(cnet+"netperf2.dbf", adbf)
      trax()
   endif
   if !HB_DBExists(cnet+"netperf.dbf")
      trax()
      ?"No File: ",cNet+"NETPERF.DBF"
      aDbf := {}
      AADD(aDbf, { "ID", "N", 7, 0 })
      for x:=0 to 9
         AADD(aDbf, { "Col_"+ltrim(str(x,1,0)), "C", 150, 0 })
      next
      AADD(aDbf, { "Station", "C", 25, 0 })
		AADD(aDbf, { "MemoTest", "M", 10, 0 })
      AADD(aDbf, { "locked", "L", 1, 0 })
      ferase(cnet+'netperf.cdx')
      dbcreate(cnet+"netperf.dbf", adbf)
      trax()
		use (cnet+"netperf") exclusive
      trax()
      if !empty(cPass)
         trax()
         netperf->(dbinfo( DBI_ENCRYPT, cPass))
      endif
      lMaster:=.t.

      trax()
      ?"Becoming Master Workstation..."
      //zap
      y:=nNetperfSize-netperf->(lastrec())
      if y>0
         ?"Seeding the database..."
         FOR x := 0 TO y
            netperf->(dbappend())
            replace netperf->id with x
            //@24,0 say str(y-x)
         NEXT
         dbcommitall()
         dbunlockall()
      endif


      trax()

      ??"done."

   endif
   //if !file(cnet+'netperf.cdx')   //no
   //if !hb_FileExists(cnet+'netperf.cdx')  //no
   if !HB_DBExists(cnet+"netperf.cdx")
      trax()
      ?'Cannot find: ',cnet+'netperf.cdx'
      if !lMaster
         use (cnet+"netperf") exclusive
         trax()
         if !empty(cPass)
            trax()
            netperf->(dbinfo( DBI_ENCRYPT, cPass))
         endif
         lMaster:=.t.
      endif
      trax()
      ?"Indexing..."
      dbselectarea('netperf')
      ??'id...'
      cKey:='id'
      //index on (cKey) tag id to ()
      ordCreate(cnet+"netperf.cdx",'id',cKey,&("{||"+cKey+"}"),.f.)
      //??'station...'
      //index on station tag station to (cnet+"netperf.cdx")
      ??"done."
      #ifdef DEBUG
         trax()
         ?'quiting to flush memory'
         quit
      #endif
   ENDIF

   ??"done."

   IF !lMaster
      trax()
      use (cnet+"netperf") exclusive new
      trax()
      if !neterr()
         trax()
         lMaster:=.t.
         if !empty(cPass).and.netperf->(dbinfo( DBI_ISENCRYPTED ))
            trax()
            netperf->(dbinfo( DBI_PASSWORD, cPass ))
            trax()
         endif
      endif
   ENDIF

   trax()
	dbcloseall()
   hb_gcall(.t.)
	IF lMaster
      trax()
		IF nLock=nil
         trax()
			ferase(cnet+'dbflock.ini')
		else
         trax()
			memowrit(cnet+'dbflock.ini',str(nlock))
		ENDIF
      trax()
      IF empty(cPass)
         trax()
			ferase(cnet+'dbfpass.ini')
		else
         trax()
			memowrit(cnet+'dbfpass.ini',cpass)
		ENDIF
      trax()
	else
		nlock:=val(memoread(cnet+'dbflock.ini'))
      cpass:=memoread(cnet+'dbfpass.ini')
	ENDIF
	IF !empty(nLock)
      ?"Locking Scheme: "
		do case
		case nlock=0
			??"HB_SET_DBFLOCK_DEFAULT - default value"
		//It's HB_SET_DBFLOCK_CLIP for DBFNTX and
		//HB_SET_DBFLOCK_VFP for DBFCDX - just like in CL5.2
		case nLock=1
			?? "HB_SET_DBFLOCK_CLIP - CL5.2 locking"
    	case nLock=2
			??"HB_SET_DBFLOCK_CL53 - CL5.3 locking"
    	case nLock=3
			??"HB_SET_DBFLOCK_VFP  - VFP (FP) locking"
      case nLock=4
         ??"DB_DBFLOCK_CL53EXT locking"
      case nLock=5
         #ifndef __XHARBOUR__
            ??"HB_SET_DBFLOCK_HB64 - Harbour Locking"
         #else
			   ??"HB_SET_DBFLOCK_XHB64 - xHarbour Locking"
         #endif
      otherwise
         nLock:=0
		endcase
		//SET(_SET_DBFLOCKSCHEME, nLock)
	ENDIF
	//c2:=replicate('*',250)
	//c3:=1234567890123
   ?"Opening "+cNet+"netper2"
   use (cnet+"netperf2") shared new
   if neterr()
      ?"Could not open!"
      inkey(10)
      quit
   endif
   ??"Appending Blank."
	append blank
   dStart:=date()
	tStart:=time()
   replace netperf2->station with cStation
   replace netperf2->dStart with dStart,;
			netperf2->tStart with tStart

   dbcommitall()
   n2:=netperf2->(recno())
   ?"Session:",n2

   ?"Opening netperf."
	use (cnet+"netperf") shared new
   if !empty(cPass).and.netperf->(dbinfo( DBI_ISENCRYPTED ))
      netperf->(dbinfo( DBI_PASSWORD, cPass ))
   endif
   ??'done.'
	ordsetfocus(1)
	nStart:=netperf->(lastrec())
   hb_gcall(.t.)
	If lMaster
		?"Start other workstations now"
		?"Press any key to start test"
      while nextkey()=0
         HB_IdleSleep(1)
      end
		inkey()
	else
		?"Waiting for start signal."
		while nStart=netperf->(lastrec())
			HB_IdleSleep(1)
		end
	EndIF
   nCol:=0
   hb_gcall(.t.)
   ?"Started " ,cStation,dStart,tStart
	?
   nRow:=row()
	dStart:=date()
	tStart:=time()
	nStart:=seconds()
   replace netperf2->dStart with dStart,;
			netperf2->tStart with tStart
   dbcommitall()
   ??'l'
   #ifdef __XHARBOUR__
   hb_gcall(.t.)
   #endif
	??'m'
	nFail:=0
   y:=0
   nLocks:=0
   For x:=1 to 200
      #ifdef DEBUG
         ?x
      #endif
      //@nRow,nCol+20 say 'X'
      //hb_gcall()//does not change a thing
      //HB_IdleState()  //no change
      /*
      if y>10
         ??'x'
         hb_gcall(.t.)  //this locks up the program.
         y:=0
      else
         y++
      endif
      */
      ??'a'
		@nRow,nCol say str(x)
      if y==0
         dbgoto(1)
         //ordsetfocus(0)
         dbappend(.f.)
         y:=1
      else
         //while !dbseek(hb_randomint(nStart+x),.t.).or.!dbrlock(recno())
         //end
         nLower:=(nNetperfSize / 200) * (x - 1)
         nUpper:=(nNetperfSize / 200 * x) - 1
         while !dbseek(hb_randomint(nLower, nUpper),.t.)
            if netperf->locked
               exit
            else
               nLocks++
               replace netperf->locked with .t.
            endif
         end
         y:=0

      endif
      ??'b'
      //HB_IdleSleepMSec(500)
      //@nRow,nCol+20 say 'A'
		IF neterr()
         //@nRow,nCol+20 say 'F'
         ??'F'
			nFail++
         HB_IdleSleep(1)
			loop
		endif
      ??'c'
      //@nRow,nCol+20 say 'B'
      dbcommit()
      ??'d'
      //@nRow,nCol+20 say 'C'
		fieldput(1,recno())
      ??'e'
      //@nRow,nCol+20 say '1'
		dbcommit()
      //@nRow,nCol+20 say '2'
      ??'f'
      /*
		fieldput(2,c2)
      @nRow,nCol+20 say '2'
		dbcommit()
		fieldput(3,c3)
      @nRow,nCol+20 say '3'
		dbcommit()
      */
      replace netperf->station with cStation
		//fieldput(4,cstation)
      //@nRow,nCol+20 say '3'
      ??'g'
		//dbcommit()
      ??'h'
      //@nRow,nCol+20 say '4'
      replace netperf->memotest with "Start"+ltrim(str(recno()))+"|"+replicate(time(),x+10)+"END"
		//fieldput(5,"Start"+ltrim(str(recno()))+"|"+replicate(time(),x+10)+"END")
      //@nRow,nCol+20 say '5'
      ??'i'
		dbcommitall()
      ??'j'
      //@nRow,nCol+20 say 'W'
		dbrunlock(recno())
      ??'k'
      //@nRow,nCol+20 say 'U'
      //ordsetfocus(1)
      dbseek(hb_randomint(nStart+x),.t.)
      ??'l'


      //@nRow,nCol+20 say 'S'
      /*
      cFilter:='column1>'+ltrim(str(1000*x))
      set filter to &cFilter
      dbgotop()
      */
	Next

	replace netperf2->tEnd with time(),;
			netperf2->elapsed with seconds()-nStart,;
			netperf2->dStart with dStart,;
			netperf2->tStart with tStart,;
         netperf2->fail with nFail,;
         netperf2->locks with nLocks
	?" Ended ",netperf2->elapsed,' Locking',nLock
	IF nFail>0
		?"FAILED APPENDS:",nFail
	ENDIF
   dbcommitall()
	dbcloseall()
   if lMaster
      ?"Waiting for all stations to complete..."
      while .t.
         use (cnet+"netperf") exclusive
         trax()
         if !neterr()
            use (cnet+"netperf2") shared new
            if neterr()
               dbcloseall()
               HB_IdleSleep(1)
               loop
            endif
            netperf2->(dbgoto(n2))
            if !netperf2->(dbrlock(n2))
               ?"could not lock",n2
            endif
            nCount:=0
            ncomplete:=0
            nTot:=0
            nLocks:=0
            while !netperf2->(eof())
               if netperf2->elapsed>0
                  nComplete++
                  nTot+=netperf2->elapsed
                  nLocks+=netperf2->locks
               endif
               nCount++
               netperf2->(dbskip())
            end
            netperf2->(dbgoto(n2))
            replace netperf2->avg with if(nComplete>0,nTot/nComplete,0),;
               netperf2->stations with nCount,;
               netperf2->completed with nComplete,;
               netperf2->ttl_locks with nLocks,;
               netperf2->avg_locks with if(nComplete>0,nLocks /nComplete,0)

            ?"Average Time",if(nComplete>0,nTot/nComplete,0),"Stations",nCount,"Completed",nComplete
            #ifndef __XHARBOUR__
            if lRPC
               net:qout("Average Time",if(nComplete>0,nTot/nComplete,0),"Stations",nCount,"Completed",nComplete)
            endif
            #endif
            if nCount!=nComplete
               ?nCount-nComplete,"did not finish the test"
               #ifndef __XHARBOUR__
                  if lRPC
                     net:qout(nCount-nComplete,"did not finish the test")
                  endif
               #endif
            endif
            dbcommitall()
            dbcloseall()
            exit
         endif
         inkey(1)
      end
   endif
   If lMaster
		?"Press any key to exit"
		inkey(0)
   else
	   inkey(5)
   endif
	return

#ifdef DEBUG
procedure trax()
   ?procline(1)
   return
#endif

init PROCEDURE RddInit
   #ifdef __XHARBOUR__
      REQUEST RMDBFCDX
      request dbfcdx
      REQUEST dbfFPT
      rddsetdefault("RMDBFCDX")
      cmxAutoOrder( 0 )
      cmSetLinear(.t.)
   #else
      request bmdbfcdx
      
      REQUEST DBFCDX
      REQUEST _BMDBF
      REQUEST DBFFPT
      rddsetdefault("BMDBFCDX")
      set( _SET_AUTORDER ,0) //cmxAutoOrder
      set( _SET_FORCEOPT ,.t.) //cmxsetlinear
   #endif
   
   set( _SET_OPTIMIZE , .t. )  //harbour: if you get errors on this line you may have to -DHB_COMPAT_C53
   //SET(_SET_DBFLOCKSCHEME, DB_DBFLOCK_XHB64 )  //does not appear to work on win9x machines
   SET( _SET_DBFLOCKSCHEME , 5 )
   
   DISABLEWAITLOCKS(.t.)
   set deleted off


   //SET(_SET_FILECASE  ,'UPPER')  //maybe upper to help linux?
   //SET( _SET_DIRCASE,'MIXED')
   #ifndef __XHARBOUR__
      //gd 6/2/20:  Both of these enabled did not make a difference in speed.  maybe only one of them will be faster?

      /*hb_rddInfo( RDDI_INDEXPAGESIZE, <nNewSize>, "DBFCDX" )      
      DBFCDX accepts page sizes which are power of 2 in from 512 to 8192.     
      The upper range is my personal decision and can be easy changed      
      in Harbour source code. 512 is default CDX index page size and      
      only such indexes can be read by other RDDs.      In some cases bigger pages can increase performance and reduce      
      index size. In local networks probably 1024 should give optimal      performance because can be transferred in single ethernet frame.      Just make a tests.
      */
   
     // hb_rddInfo( RDDI_INDEXPAGESIZE, 1024, "DBFCDX" )

      /*2019-04-11 17:23 UTC+0200 Przemyslaw Czerpak (druzus/at/poczta.onet.pl)   * include/dbinfo.ch   * src/rdd/dbf1.c     + added DB_SETHEADER_EOL flag, it's used to force setting EOL marker      
      when header is written. In Harbour's DBF* RDDs is set in CLOSE()       method so just like in Clipper when DBF is closed and header has to       be updated the EOL() marker is set.       
      As side effect reducing header updates to minimal level (in such       case DBF header is not updated after APPEND what is safe for Harbour,       
      Clipper and compatible RDDs because they use file size to calculate       number of records but some other DBF drivers may be confused)       
      increase the APPEND speed and also forces EOL setting in all cases       
      when CLOSE() method is called. Header updates can be reduce to minimal       level by:          hb_rddInfo( RDDI_SETHEADER, DB_SETHEADER_MINIMAL ) 
      */
      //gd 6/2/20: this didn't make a speed diff by itself
      //hb_rddInfo( RDDI_SETHEADER, DB_SETHEADER_MINIMAL ) 
   #endif
   return
   function default_parameters(aParams,hParams,xArgSep,lUpperKey)
      //we assume all switches will be in pairs. Eg: "-switch=value" or "-switch value" unless followed by another switch.
      //TODO: may need to pass an array of muilti value vars that can have many values eg: "-from file.txt file2.txt -to out.txt"
         //A possible workaround is pass those vars inside quotes.
         //may want to HSetCaseMatch hParams if case does not mean anything to you
      local cArg,aUnknown:={},cVar,cUarg,xTemp,nArg
      local lVarNext:=.f.,lValueNext:=.f.
      if xArgSep=nil
         xArgSep :='-/'
      endif
      if lUpperKey=NIL
         lUpperKey:=.t.
      endif
   
      
      if empty(aParams).or.!valtype(aParams)=="A"
         return(aUnknown)
      endif
      FOR EACH cArg IN aParams
         cUarg:=upper(cArg)
         nArg:=len(cArg)
         DO CASE
         CASE nArg<3 .and. cUArg$ {"-H","/H","-?","/?","?"}
            //? "Help requested"
            aadd(aUnknown,{"HELP",.t.})
            lValueNext:=lVarNext:=.f.
         case cArg=="-" .or. cArg=="/"
            if lValueNext.and.!empty(cVar)
               aadd(aUnknown,cVar)
               cVar:=''
            endif
            lVarNext:=.t.
            lValueNext:=.f.
         case cArg=="="
            lValueNext:=.t.
            lVarNext:=.f.
         case pad(cArg,1) $ "-/"
            if lValueNext.and.!empty(cVar)
               aadd(aUnknown,cVar)
               cVar:=''
            endif
            lValueNext:=lVarNext:=.f.
            cArg:=alltrim(substr(cArg,2))
            if right(cArg,1)="="
               lValueNext:=.t.
               cVar:=pad(cArg,nArg-1)
            elseif "="$cArg
               aadd(aUnknown,HB_ATokens( cArg,"=",,.t. ))
            else
               lValueNext:=.t.
               cVar:=cArg
            endif
         case lValueNext
            if pad(cArg,1)="="
               cArg:=substr(cArg,2)
            endif
            aadd(aUnknown,{cVar,cArg})
            cVar:=''
            lValueNext:=lVarNext:=.f.
         case lVarNext
            lValueNext:=lVarNext:=.f.
            if right(cArg,1)="="
               lValueNext:=.t.
               cVar:=substr(cArg,2)
            elseif "="$cVar
               aadd(aUnknown,HB_ATokens( cArg,"=",,.t. ))
            else
               cVar:=cArg
               lValueNext:=.t.
            endif
         OTHERWISE
            //? "Unknown:", cArg
            if "="$cArg
               aadd(aUnknown,HB_ATokens( cArg,"=",,.t. ))
            else //add target
               aadd(aUnknown,cArg)
            endif
   
         ENDCASE
      NEXT
      if valtype(hParams)="H"
         for each xTemp in aUnknown
            if valtype(xTemp)=="A"
               if len(xTemp)==2
                  hParams[xTemp[1]]:=xTemp[2]
               else
                  hParams[xTemp[1]]:=NIL
               endif
            else
               hParams[xTemp]:=NIL
            endif
         next
      endif
      
      return(aUnknown)
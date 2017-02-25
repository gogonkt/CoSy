: ! [ $18891e8b ,  $adad 2,  ;inline
' 'macro : macro  literal  default_class ! ;
' 'forth : forth  literal  default_class ! ;
: 2drop [ $8d04468b , $0876 2, ;inline
: parseln 10 parse ;
macro
: | parseln 2drop ;
: ( ') parse 2drop ;
| ========================= CORE WORDS ==================
: 0; [ $0275c009 , $c3ad 2, ;inline | or eax, eax; jnz .done; lodsd; ret; .done:
: 0;drop [ $75adc009 , $c301 2, ;inline | or eax, eax; lodsd; jnz .done; ret; .done:
: drop ( a -- )   [ $768d068b , $04 1, ;inline
forth
: xchg ( n a -- a^ ) [ $0e8b188b , $d8890889 , $04768d 3, ;
: (inline) parsews >single 0;drop 1, (inline) ;
macro
: inline{
    16 base xchg
    (inline)
    2drop base !  ;
forth
: xchg2 ( a b -- ) inline{ 89 C3 AD 8B 0B 8B 10 89 13 89 08 AD } ; 
: 3drop inline{ 8b 46 08 8d 76 0c } ;inline
: pop>eax inline{ 8B 06 8D 76 04 } ;inline
: 0drop; inline{ 09 c0 75 03 ad ad c3 } ;inline | or eax, eax; jnz .done; lodsd; lodsd; ret; .done:
: aligned ( a -- a' ) inline{ 83 c0 03 83 e0 fc } ;inline | add eax, 3; and eax, -4
: dup ( a -- a a ) inline{ 8d 76 fc 89 06 } ;inline
: 1+ ( a -- a+1 ) inline{ 40 } ;inline | inc eax
: 1- ( a -- a-1 ) inline{ 48 } ;inline | dec eax
: _1- ( a b -- a-1 b ) inline{ ff 0e } ;inline
: _1+ ( a b -- a+1 b ) inline{ ff 06 } ;inline
: _+ ( a b c -- a+c b ) inline{ 01 46 04 ad } ;inline
: - inline{ 29 06 } pop>eax ;inline
: + inline{ 01 06 } pop>eax ;inline
: and inline{ 21 06 } pop>eax ;inline
: or inline{ 09 06 } pop>eax ;inline
: xor inline{ 31 06 } pop>eax ;inline
: not inline{ 83 f8 01 19 c0 } ;inline  | cmp eax,1 ; sbb eax,eax
: invert inline{ f7 d0 } ;inline | not eax
: negate inline{ f7 d8 } ;inline | neg eax
: << inline{ 89 c1 ad d3 e0 } ;inline 
: >> inline{ 89 c1 ad d3 e8 } ;inline 
: +! inline{ 89 c3 ad 01 03 ad } ;inline
: @ inline{ 8b 00 } ;inline 
: w@ inline{ 0f b7 00 } ;inline
: swap inline{ 89 c3 8b 06 89 1e } ;inline
: && not swap not or not ;  | logical "and"
: || or not not ;           | logical "or"
: * inline{ f7 26 83 c6 04 } ;inline 
: ++ inline{ ff 00 ad } ;inline 
: -- inline{ ff 08 ad } ;inline 
macro
| Fix #292, but I don't like this fix :(
: | >in -- parseln 2drop ;
forth
: cells inline{ c1 e0 02 } ;inline
| : cells/ inline{ c1 f8 02 } ;inline 	| BA 20150620  needs to be recompiled

: cell+ inline{ 8d 40 04 } ;inline 
: cell+! cell+ ! ;
: cell+@ cell+ @ ;
: >body inline{ 8d 40 05 } ;inline 
: cell- inline{ 8d 40 fc } ;inline 
: cell-! cell- ! ;
: cell-@ cell- @ ;

: body> inline{ 8d 40 fb } ;inline 
: 2cell- inline{ 8d 40 f8 } ;inline
: 2cell+ inline{ 8d 40 08 } ;inline 
: 3cell+ inline{ 8d 40 0c } ;inline 
: 4cell+ inline{ 8d 40 10 } ;inline 
: rot inline{ 50 8B 46 04 8B 1E 89 5E 04 8F 06 } ;
: -rot inline{ 50 8B 5E 04 8B 06 89 1E 8F 46 04 } ;
: c@ inline{ 0f b6 00 } ;inline | movzx eax, byte [eax]
: nip inline{ 8d 76 4 } ;inline | lea esi, [esi+4]
: pick inline{ 8b 04 86 } ;inline | mov eax, [esi+4*eax]
: put inline{ 89 c3 ad 89 04 9e ad } ;inline | mov ebx, eax; lodsd ; mov [esi+4*ebx], eax ; lodsd
: r> dup inline{ 58 } ;inline | [ $58 1, ;
: r@ r> inline{ 50 } ;inline | [ $50 1, ;
: >r inline{ 50 ad } ;inline | [ $ad50 2, ;
: rdrop inline{ 5b } ;inline | [ $5b 1, ;
: 00; inline{ 09 c0 75 01 c3 } ;inline | or eax, eax; jnz .done; ret; .done:
: abs inline{ 99 31 d0 29 d0 } ;inline | cdq; xor eax, eax; sub eax, edx
: (execute) inline{ ad ff d3 } ;inline | lodsd; call ebx
: @execute inline{ 8b 18 } (execute) ;inline | mov ebx, [eax]
: execute inline{ 89 c3 } (execute) ;inline  | mov ebx, eax
: exec ( dict -- ) inline{ 8D 58 FC 8B 1B 8B 40 04 FF E3 } ;
    
: rp@ dup inline{ 89 e0 } ;inline  | get current ESP
: rpick  inline{ 8b 04 84 } ;inline | mov eax, [4*eax+esp]
: 2* inline{ d1 e0 } ;inline
: 2/ inline{ d1 f8 } ;inline
forth
: compiling? state @ ;
: over dup inline{ 8b 46 04 } ;
: here (here) @ ;
| : 2over 3 pick 3 pick ;
: 2over inline{ 8d 76 fc 89 06 8b 46 0c 8d 76 fc 89 06 8b 46 0c } ; | thanks, malcoln
: off inline{ 31 db 89 18 }  drop ;
: on  inline{ 31 db 4b 89 18 } drop ;
: (.) 0 (.r) ;
: .r (.r) : type_ type : space 32 emit ;
: cr 10 emit ;  : dblquote '" emit ;  : question '? emit ; 
: lparen '( emit ; : rparen ') emit ;
: . (.) type_ ;
: ? @ . ;
| ==== OFFSET WORDS ====
: >xt cell+ ; 
: count dup c@ _1+ ; | swap 1+ swap ;
| mov ecx, eax;drop;mov ebx,eax;drop;imul ebx;idiv ecx
: */  inline{ 89 c1 ad 89 c3 ad f7 eb f7 f9 } ;
: allot (here) +! ;
: max inline{ 89 c3 ad 39 d8 7f 02 89 d8 } ;
: min inline{ 89 c3 ad 39 d8 7c 02 89 d8 } ;
 : w! inline{ 89 c3 ad 66 89 03 ad } ;
: vector 0 : vector! $e9 1, , ;
: '' parsews find-dict ;
: xt 00; >xt @ ; | take dict and return 0 or xt
: find find-dict xt ;
: lastxt last @ >xt @ ;
: alias ( xt -- ) header last @ >xt ! ;
' literal alias literal,
| : later r> r> swap >r >r ;
: later inline{ 5B 59 53 51 } ;

' cell- alias >class
' 2cell+ alias >name
: @litcomp dup cell+@ literal, cell-@ compile ;
macro
: p: '' @litcomp  ;
: ['] ' p: literal ;
: [''] '' p: literal ;

| class words:
: notail ['] 'notail default_class ! ;
: mnotail ['] 'macront default_class ! ;

forth
variable classes
	'' 'forth classes link 
	'' 'macro classes link 
	'' 'defer classes link 
	'' 'notail classes link 
	'' 'inline classes link 
	'' 'value classes link 
	'' 'constant classes link 
	'' 'variable classes link 
	'' 'does classes link 
macro
: newclass last @ classes link ;
forth  
: pdoes 
	| r: code-after-does>
	| set the class of the current word to be "'does"
	['] 'does last @ cell-!
	| set the offset of this word:
	r> lastxt cell-!
	;
: create parsews : (create) align 0 , (header) ['] 'variable last @ cell-! ;
macro
: does> ['] pdoes compile 
	here
	last @ >name
	count + 1+ !
	4 dict +!
    ;
: super> ( <name> -- ) | compile call to "does" for <name>
	'' >name count + 1+ @
	compile
	;
forth
: :: 0L (header) lastxt p: ] : noop ; 
: >rel 1+ here - cell- ;
: rel> dup @ swap cell+ + ;
: defer 
    header ['] 'defer last @ cell-!
    vector ['] noop >rel 1- 1- vector! ;
: defer@  1+ rel> ;
: defer@def  cell+ 1+ 1+ rel> ;
macro
: chain ( <name> -- )	| call prior value of the deferred word
	' defer@ compile ;
forth
s0 variable, (s0)
: reset ( -- )   (s0) @ inline{ 89 c6 31 c0 } ; 
: spaces 0 max 0; 1- space spaces ;
: 2swap inline{ 87 46 04 87 1e 87 5e 08 87 1e } ;
| mov ebx,eax; mov eax, [esi]; cdq; idiv ebx; mov [esi], edx
: /mod  inline{ 89 c3 8b 06 99 f7 fb 89 16 } ;
: /  inline{ 89 c3 8b 06 99 f7 fb } nip ;
: mod /mod drop ;
: tuck inline{ 8D 76 FC 8B 5E 04 89 1E 89 46 04 } ;
: c!  inline{ 8b 1e 88 18 8b 46 04 8d 76 08 } ; | mov ebx, [esi]; mov [eax], bl; drop2
: bye 0 (bye) ;
: true -1 ;
: false 0 ;
: ?dup inline{ 85 c0 74 05 8d 76 fc 89 06 } ; | test eax, eax; jz .1; dup; .1:
: depth (s0) @ inline{ 29 f0 } 2/ 2/ 1- ;
: rr> inline{ 8D 76 FC 89 06 59 5B 58 53 51 } ;

forth
: >rr inline{ 5B 50 53 AD } ;inline
defer key?
defer ekey

| ========================= CONDITIONALS ==================
: ahead vector here ;
: (if $063b 2, p: 2drop ; | cmp eax, [esi]; lodsd; lodsd
: if) 0 , here ;
: back compile here  body> ++ ;
mnotail
: then align here over - swap cell-!  ;
macro
: 0if $0fadc085 , $85 1, if) ; | test eax, eax; lodsd; jnz ...
: =if (if $850f 2, if) ;
: <>if (if $840f 2, if) ; 
: >if (if $8d0f 2, if) ; 
: <if (if $8e0f 2, if) ;
: if $0fadc085 , $84 1, if) ; | thanks, malcoln
: else 0 back here swap p: then ; 
: ;then p: ;; p: then ;
variable oldstate
macro
: {  ( -- xt )
	| force compiling state, save old state:
	state @ oldstate !
	state on
	oldstate @ if ahead then 
	here 
	;
: }	 ( xt -- xt ) 
	| seal off temp definition:
	$c3 1, 
	| if compiling, seal the jump and compile the 'here'
	| if interactive, just return the 'here'
	oldstate state xchg2
	compiling? if p: ;then literal, then
	;
: {{ here p: { ;
: }} >r p: } execute r> here - allot ;
forth
: ((cmp)) [ $b8ad063b , 0 , ;inline | cmp eax, [esi] ; lodsd ; mov eax, 0 ....
: then> compiling? 0;drop r> compile ; | thanks malcoln
: ?literal compiling? 0;drop literal ; | thanks malcoln
: < ((cmp)) inline{ 7e 01 48 } ; | jle .1; dec eax
: u< ((cmp)) inline{ 76 01 48 } ; | cmp eax, [esi]; lodsd; mov eax, 0; jbe .1; dec eax
: > ((cmp)) inline{ 7d 01 48 } ; | cmp eax, [esi]; lodsd; mov eax, 0; jge .1; dec eax
: = ((cmp)) inline{ 75 01 48 } ;
: <> ((cmp)) inline{ 74 01 48 } ;

| ========================= EXTRA ==================
: used dict @ d0 @ - here h0 @ - ;
: 2variable create 0 , 0 , ;
: 2@ dup @ swap cell+@ ;
: 2! 2dup cell+! nip ! ;
: srcstr >in @ src @ over - ;
: hex 16 : base! base ! ; : decimal 10 base! ; : binary 2 base! ; : octal 8 base! ;
: ||| srcstr + >in !  ;
: between inline{ 89 c3 ad 89 c1 ad 93 40 29 c8 29 cb 29 c3 19 c0 } ;
: (p.r) padchar @ >r padchar ! (.r) r> padchar ! ;
variable temp

| ========================= STRINGS ==================
 : lcount dup cell+ swap @ ;
| : lcount inline{ 8D 76 FC 89 06 83 06 04 8B 00 } ;

: 0term 2dup + 0 swap c! ;
| : lplace 2dup ! cell+ swap 0term move ;

: lplace 2dup ! cell+ 2dup + >r swap move 0 r> c! ;
: +lplace  ( a n buf )
    dup >r lcount + ( a n a' r:buf )
    r> swap >r      ( a n buf r:a' )
    2dup +! drop r> swap 0term move
    ;
: c+lplace ( c lstr -- )
    >r r@ lcount + c!
    r> dup ++ lcount 0term 2drop
    ;
: asciiz, dup 1,
: z, here, 0 1, ;
: asciizl, dup , z, ; 
| place for temporary strings
variable (s^)
| place for compiled strings (loaded from revastr)
variable (compstr)
variable (compstrend)   | end of used compiled string space
1000000 variable, (compsize)
    | compile time:
    (compsize) @ allocate dup (compstr) ! (compstrend) !

: strallot ( n -- a )
    cell+ 1+
    | see if our allocate
    (compstrend) @ aligned      | address of string
    tuck +
    (compstrend) !  
    (compstr) @ -
    ;
    | n a'

| compile string (use short version if possible) :
: (")  ( a n -- ) 
    dup strallot | a n a'
    dup literal, (compstr) @ + lplace
    { (compstr) @ + lcount } compile ;

| put string into 'rotating' temp area
create sbufs 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 
: "" 
	255 min 
	(s^) dup ++ @ 8 mod cells sbufs + @
	dup >r place r> count
	;
macro
: " '" parse/ compiling? if (") ;then "" ;
: ." p: " then> type ;
: z" p: " then> drop ; | "
forth
: /char inline{ 89 C3 8B 06 8D 76 04 89 C1 E3 14 8B 3E 38 1F 74 03
        47 E2 F9 38 1F 75 07 E3 05 89 C8 89 3E C3 31 C0
        89 06 } ;
: \char inline{ 89 C3 8B 06 8D 76 04 89 C1 E3 18 8B 3E 01 CF 4F 38
        1F 74 05 4F E2 F9 E3 0A 38 1F 75 06 29 C8 40 89
        3E C3 31 C0 89 06 } ;
: cmove> inline{ 89 C1 8B 06 8D 76 04 89 C7 8B 06 8D 76 04 89 C2 8B
        06 8D 76 04 E3 0E 01 CA 01 CF 90 4A 4F 8A 1A 90
        88 1F E2 F7 } ;

: c+place ( c cstr -- ) dup ++ count +  0 over c! 1- c! ;
| name of auxiliary string file
: revastr
    appname zcount here place 
    '. here c+place
    'x here c+place
    here count
    ;
: _2dup inline{ 89 c3 8b 0e 8b 56 04 8d 76 f8 89 56 04 89 0e 89 d8 } ;
: _2nip ( a b c d -- a d ) inline{ 83 c6 08 } ;inline
: 2nip inline{ 50 ad 8d 76 04 89 06 58 } ;
: -swap inline{ 8B 5E 04 8B 0E 89 1E 89 4E 04 } ;
: chop ( a n c -- a1 n1 ) _2dup /char nip - ;
: -chop ( a n c -- a1 n1 ) _2dup \char nip - ;
|		mov ebx, eax
|		lodsd
|		add [esi], ebx
|		sub eax, ebx
: /string ( a n m -- a1 n1 ) [ $01adc389 , $d8291e 3, ;

| ========================= LOOPING ==================
: unloop inline{ 5b 5b } ;inline | pop ebx|pop ebx
: remains dup inline{ 8b 04 24 } 1- ;inline | mov eax, [esp]
: more ( n -- ) 1+ inline{ 89 04 24 ad } ;inline | mov [esp], eax|lodsd
: skip ( n -- ) inline{ 29 04 24 ad } ;inline | sub dword [esp], eax|lodsd
: eleave inline{ 5b 68 01 00 0 0 } ;inline | pop ebx|push 1
forth
: i dup inline{ 8b 44 24 08 2b 44 24 04 } ; 
: j dup inline{ 8b 44 24 10 2b 44 24 0c } ;
align here $850f , $75 , $8f0f , $7f ,
: (while)
    cells literal + >r
    align here - 1- 1- 
    dup -125 <if
        r> @ 2, cell- , | long jump!
    ;then
    r> cell+@ 1, 1, | short jump!
    ;
: (do) align here 0 >rr ;
macro
: leave $e9 1, here >rr 0 , ;
: repeat align here ;
: again back ;
: while $c085 2,  | test eax, eax; lodsd
    p: drop
    0 (while) ;
| mov ebx, eax; lodsd; push eax; sub eax, ebx; push eax; lodsd ...
: do $50adc389 , $ad50d829 , (do) ; 
: 0do $ad5050 3, (do) ;
: ?do 
    0 >rr
    $50adc389 , $ad50d829 , | mov ebx, eax;lodsd;push eax;sub
    $8e0f 2, | jle dword later
    here >rr 0 ,
    align here
    ; 
: loop  $240cff 3, | dec [esp] 
    2 (while)
    $08c483 3,  | add esp, 8
    | resolve 'leave' forward references:
    repeat
        rr> 0;
        here over - 2cell- 1+ swap !
    again
    ;
: p[ repeat parsews 2dup " ]p" cmp 0if 2drop ;then find-dict @litcomp again ;
forth
: foreach ( xt hi lo -- ) do i over execute loop drop ;
: sbufsallot 8 0do 256 allocate sbufs i cells + ! loop ;
sbufsallot ' sbufsallot onstartup
| ========================= DICT ==================
| variable findprev?
variable found
: findprev ( dict-to-find -- prev-dict ) 
	found off 
	{
        cell- dup  | dict dict
        @ 2 pick
        =if found xchg then
    }
    last iterate drop
	found @ ;

: -1throw -1 throw ;
: not-word dblquote type dblquote ."  is not a word" cr -1 throw ;
: dict? '' ?dup 0if not-word  then ;
: xt? dict? >xt @ ;
: !isa ( class-dict a n -- ) dblquote type dblquote ."  not class: " >name count type cr -1throw ;
: isa ( class-dict <name> -- xt-of-name | THROW )
    '' | class-dict dict-of-name
    ?dup 0if !isa then
    | class-dict dict-of-name
    2dup | class name class name
    >class @ swap >xt @ | class name name-class class
    <>if >name count !isa then
    nip >xt @ 
    ;

: hide ( <name> -- )
    dict?
    dup  findprev
	| us
: (hide)  ( dict dict' -- )
	dup if | there is a previous item
		swap @ swap
	else
		drop @ last
	then
	!
    ;

hide !isa
hide (do)
hide found
| hide findprev?
hide (execute)
| : then,> compiling? if literal, r> compile then ;
: then,> compiling? 0;drop literal, r> compile ;
: (is) ( xt1 xt2 -- )
    1+ 2dup - cell- -rot nip
    2dup swap body> swap >body ! ! ;

macro
: is [''] 'defer isa then,> (is) ;
forth

| ========================= PRIVATE STACK (used by contexts)
: stack: ( n -- )  
        create  here ,  cells allot ; 

: stack-size   ( stack -- nof-cells ) dup @ swap - 2/ 2/ ;
: stack-empty? ( stack -- flag )  dup @  =  ;

: push  ( x stack -- ) 4 over +! @ ! ; 
: pop    ( stack -- n ) 
		dup dup @ - 0;drop 
		dup @ @ 
        -4 rot +!  ;
: peek ( stack -- x ) @ @ ;
: peek-n ( n stack -- m )  @ swap cells - @ ;


: stack-iterate ( xt stack -- )
  dup stack-empty? if 2drop ;then

  dup stack-size 0do
    2dup i swap peek-n swap execute
  loop
  2drop
;




| ========================= CONTEXTS ==================
' find-dict defer@	 variable, oldfind 
' (header) defer@ dup variable, oldheader variable, newheader

| Create a list containing all contexts:
variable all-contexts

| Create the stack that contains the active contexts
| (TOS is the currently active context)
63 stack: contexts
63 stack: saved-contexts

: >base> base xchg later base! ;
: hex# ( n -- a n ) 16 >base> >r (.) r> ;
variable xtdict
: xt>name  ( xt -- a n )
	xtdict off
    {
       @    | xt context 
	   {
			cell-
			2dup
			>xt @ 
			| xt dict xt xt1 
			=if
				| xt dict xt xt1
				xtdict !
				false
			then
	   } swap iterate 
	   xtdict @ not	| keep iterating if we did NOT find something
    } all-contexts iterate drop
	xtdict @ ?dup if >name count ;then 0L ;

: ctx>name 2cell+ @ >name count ;
: exit~
	| pop current context
    contexts pop 0; | context-to-deactivate

    contexts stack-empty? if contexts push ;then

    | save current last into that context
    last @ swap !

    | now restore the last of the newly active context
    contexts peek @ last !
	;
: push~ contexts stack-size saved-contexts push ;
: pop~ contexts stack-size saved-contexts pop -
    dup 1 <if drop ;then
    0do exit~ loop ;

: setclass ( class -- )
    default_class xchg
    later
    default_class !
    ;
: .contexts { @ dup ctx>name type_ } all-contexts iterate ;
: .~ { ctx>name type_ } contexts stack-iterate ;
: ''context
    contexts stack-empty? not
    if
      | save the current "last" into the current context
      last @  contexts peek !
    then

    | make the specified context the current one
    dup contexts push

    | set "last" appropriately
    dup @ last !

    | set 'header' appropriately
    4cell+ @ newheader !
    ;

: 'context then,> ''context ; 
: context: parsews
: (context) ( a n -- )
    find-dict 0if
        (create) 
            0 ,				| 00 this context's chain of words
            oldfind @ ,		| 04 'find-dict' for this context
            last @ ,        | 08 dictionary entry for this context
            $54585443 ,     | 0C context signature
            oldheader @ ,   | 10 '(header)' for this context

            lastxt all-contexts link
        does> 'context
    then
	;

: context?? ( xt -- flag ) 3cell+ @ $54585443 = ;
: context? xt? dup context?? 0if ." not a context" -1throw then ; 
: find-word ( a n context -- 0 | xt -1 ) dup 0if 3drop 0 ;then
  last @ >r
  dup @ last !
  | get the 'find' for this context, and execute it on the string
  dup cell+@ >r _2dup -rot r> execute
  | restore last
  r> last !
  | a n ctx a n 0 | a n ctx xt
  dup 0if 3drop 3drop 0 ;then >r 3drop r> -1 ;

:: newheader @execute ; is (header) 
macro

: in~ ( <ctx> <word> -- )
    context?
    parsews rot find-word
    0if ." in~ failed " ;then
	| dict entry: do the appropriate thing
	dup >xt @ swap cell- @execute
	;

: with~ ( <ctx> -- ) context? contexts pop swap contexts push contexts push ;
: without~ contexts pop contexts pop drop contexts push ;

| transfer the word <word> into the context <ctx>
: to~ ( <ctx> <word> -- ) context?
    dict?	| ctx dict
: (to~) ( ctx dict -- )
    over contexts peek =if 2drop ;then
	dup findprev			| ctx dict dict'
	over >r
	| hide the original entry
	(hide) r>				| ctx dict
	| put this entry into the new context
	| get the 'prev' of the ctx and make it the next
	over @ over !
	| make the last the first:
	swap !
	;
: setfind~ ( xt <ctx> -- ) context? cell+!  ;
: setheader~ ( xt <ctx> -- ) context? 4cell+ ! ;
forth
| : 3dup dup 2over rot ;
| : 4dup 2over 2over ;
: 3dup inline{ 8b 0e 8b 56 04 8d 76 f4 89 0e 89 56 04 89 46 08 } ;
: 4dup inline{ 8b 1e 8b 4e 04 8b 56 08 8d 76 f0 89 1e 89 4e 04 89 56 08 89 46 0c } ;
| print all contexts in which the word (a,n) can be found:
: xfind ( <name> -- )
	parsews
: (xfind)
	{
		@ 3dup
		find-word nip if ctx>name type_ then
		true
	} all-contexts iterate 2drop ;

context: ~
context: ~reva
context: ~sys
context: ~os
context: ~doubles
context: ~strings
context: ~util
context: ~io
context: ~priv

to~ ~doubles >double
last @ ' ~ ! | >body !
~

| reset to only the first context:
: (reset~) contexts stack-size 1- 0;drop exit~ (reset~) ;
' ~ variable, root
: reset~ (reset~) 
    contexts peek
    root @ 2cell+ ( >body ) <>if
        | some random context is on the stack.  make sure "~" is there instead
        root @ 'context
        p: without~
    then
    ; 

to~ ~priv root
to~ ~priv ''context
to~ ~priv (reset~)

: only~ parsews eval
    contexts pop >r
    reset~ 
    contexts pop drop
    r> contexts push ;

: split  ( a n c -- a1 n1 a2 n2 true | a n false )
    _2dup /char 
: (split) ( a n a2 n2 -- a1 n1 a2 n2 )
    0; 1 /string
	2swap
	2 pick - 1- true
	;

:: ( a n -- xt | a n 0 )
    | update "last" in the current context
    last @ contexts peek !
    contexts stack-size 0do
        2dup i contexts peek-n find-word
        if _2nip unloop ;then
    loop
    | did not find it; see if it's a dotted-context word?
    2dup '. split if 
        | a n a2 n2 a1 n1
        find dup if  | a n a2 n2 ctx
            dup context?? 0if
                drop
            else
                find-word if _2nip ;then 2dup
            then
        else | a n a2 n2 a1 n1 
            3drop 
        then
    then
    2drop
  0 ; is find-dict
| set the search order while building Reva:
reset~ ~reva ~priv ~sys ~os ~util ~io ~strings ~
| ========================= ENDOFCONTEXTS ==================
| ========================= ENDOFCONTEXTS ==================
| ========================= ENDOFCONTEXTS ==================
~priv 
variable cases
: inrange? ( x low hi -- x flag ) 2 pick -rot between ;
exit~ 
macro
| : endcase cases @ ?dup if p: then then ;
: endcase cases @ 0; p: then ;
: case ( -- ) cases off ;
: of ( n -- n |  )  p[ over =if drop ]p ;
: strof ( a n -- a n | ) p[ 2over cmp 0if 2drop ]p ;
: rangeof ( low high -- n | ) p[ inrange? if ]p ;
: endof ( -- ) 
	p: endcase
	ahead cases !
	p: then 
	;
forth

| ========================= VARIOUS ==================
create nul  0 , | "empty" NUL terminated string
: .2x 16 /mod >digit emit >digit emit ; 
: rol8 inline{ c1 c0 08 } ;inline | [ $08c0c1 3, ;
: .x 4 0do rol8 dup $ff and .2x loop drop space ;
: .s depth dup lparen (.) type rparen space 0 max 0; 10 min dup 0do dup i - pick . loop drop ;
: rdepth rp0 @ rp@ - 2/ 2/ ;
| : .rs rdepth 1- dup lparen (.) type rparen space 0 max dup 0; 10 min 
|     0do dup i - rpick .x loop drop ;
| : .rs rdepth 1- dup lparen (.) type rparen space 0 max dup 0; 10 min
|   3 do i rpick .x loop drop ;
    
: .rs rdepth 1+ dup lparen (.) type rparen space 0 max dup 0; 10 min
: (.rs) 0; dup rpick .x 1- (.rs) ;

~strings

0 [IF]
: search inline{ 89 C2 8B 06 8D 76 04 89 C7 8B 06 8D 76 04 89 C1 8B
        06 8D 76 04 50 51 E3 17 09 C0 74 13 09 D2 74 0F
        09 FF 74 0B 8A 3F 8A 18 38 FB 74 08 40 E2 F7 31
        C0 59 59 C3 39 D1 72 F7 89 D5 4D 8A 3C 2F 3A 3C
        28 75 19 4D 79 F5 8D 76 FC 89 06 58 2B 06 5B 01
        D8 8D 76 FC 89 06 B8 FF FF FF FF C3 40 EB C5 } ;
[THEN]

: search inline{ 89 C2 8B 06 8D 76 04 89 C7 8B 06 8D 76 04 89 C1 8B
        06 8D 76 04 50 51 E3 17 09 C0 74 13 09 D2 74 0F
        09 FF 74 0B 8A 3F 8A 18 38 FB 74 08 40 E2 F7 31
        C0 59 59 C3 39 D1 72 F7 89 D5 4D 8A 3C 2F 3A 3C
        28 75 19 4D 79 F5 8D 76 FC 89 06 58 2B 06 5B 01
        D8 8D 76 FC 89 06 B8 FF FF FF FF C3 40 49 EB C4
        } ;

: rsplit ( a n c -- a1 n1 a2 n2 true | a n false )
	_2dup \char (split) ;
: bounds inline{ 8B 1E 01 06 89 D8 } ;inline
exit~

to~ ~strings split
to~ ~strings (split)
forth

~priv
| implementation of 'words' :
variable wcnt
defer ((words))
2variable (w)
: (showword) dup 0if 2drop ;then type_ wcnt ++ ;
: words? 2dup (w) 2@ search _2nip 0;drop (showword) ;
exit~

: words parsews tuck (w) 2!
    if ['] words? else ['] (showword) then is ((words)) 
: (words) wcnt off 
    { cell- >name count ((words)) 1 }
    last iterate cr wcnt ? ." words" cr ;
: words~ 
    context?
: (words~)
    ['] (showword) is ((words))
    last @ >r
    @ last !
    (words)
    r> last !
    ;
| to~ ~priv (words)
: xwords
	{ 
		@ dup
		." context: " dup ctx>name type cr
        (words~) cr 
	} all-contexts iterate
	;

~util
: clamp ( m n -- ) min 0 max ;
: xt>size 
    dup 1000 $c3 /char 0if drop 4 ;then
    swap -
    ;
exit~

~strings
forth
: lc ( c -- c' ) $20 or ;
macro
: quote ( <cr> --- a n ) 
    parsews drop c@ parse 
    compiling? if (") ;then | " (just for vim syntax highlighting)
    255 min "" ;
exit~
~util
: alias: ( newname oldname -- )
    header | create new word
    ''      | get dict entry of next word
    ?dup 0if type ."  not found" cr -1throw then
    last @   | dictptr lastptr
    2dup cell- swap cell-@ swap !  | set class of new word to that of old word
    >xt swap >xt @ swap !           | set XT of new word to that of old word
    ;
: prior last @ dup @ last ! dict? | orig-last dict 
  @litcomp | implementation of p:
  last !  ;
exit~

forth
~priv
: ((const))
	header swap ,  ;
~
: constant 
    ['] 'constant setclass ((const)) ;
~util
-1 constant THROW_GENERIC
-2 constant THROW_BADFUNC
-3 constant THROW_BADLIB
-4 constant THROW_NEEDS
| -5 constant THROW_BADXT
exit~
: [DEFINED] '' if true ;then 2drop false ;

| redefine ' and ['] to throw as per Bob Armstrong's suggestion:
: '' dict? ; | : ' xt? ;
macro : ['] ' p: literal ;
forth
: 2constant
    create swap , ,
    does> 2@ 
    ;
: value ['] 'value setclass ((const)) ;
~priv
: (value) [''] 'value isa then,>  ;
exit~
macro
: to (value) then,> ! ;
: +to (value) then,> +! ;
forth
| implementation of 'dump' :
~priv
0 value dump$
: dumpasc
    dump$ count dup 0if 2drop else
        16 over - 3 * spaces type
    then cr dump$ off ;
: ?nl dup 0; 16 mod not 0; 
    drop over dumpasc .x ;
: >printable dup 32 127 between not 0; 2drop '. ;
exit~
~util
: dump 0; dump$ off 
    over .x 0do | iterate for each line:
        i ?nl drop dup c@ dup >printable dump$ c+place .2x space 1+
    loop drop dumpasc ;
exit~
0 value scratch
0 value pad

| these are all called with a stack: a n x
| where 'a' is the buffer to put the char in
|       'n' is the buffer's max size
|       'x' is the number of characters in it
|   and 'c' is the current character (for the default)
~io
| hex ' (p.r) $36 + @ . decimal 
: accept ( a n -- n2 )
    0 repeat 
    ekey ( dup accept? ) 
        case
            8 of 
                dup | a n x x
                if
                    8 emit space 8 emit
                    1-
                then
                true   | a n (0|x-1) true
              endof
            10 13 rangeof drop false endof
            27 of drop 0L endof
                dup emit | show the key
                | a n x c
                >r rot dup >r -rot dup  | a n x x  r: c a
                r> + r> swap            | a n x c (a+x)
                c!                      | a n x
                1+
                2dup -  | =0 (false) if we shall not continue reading characters...
        endcase
    while _2nip ;
| hex ' (p.r) $36 + @ . decimal 
exit~
hide xt
defer help
defer help/
context: ~help ~help
defer nohelp
defer showhelp
~priv
: help! " needs helper" eval ;
:: help! help/ ; is help/
:: help! help ; is help
exit~
exit~

| DOERS
~priv
: (is2) ( xt1 xt2 -- ) 1+ tuck - cell- swap ! ;
: !r tuck cell+ - swap ! ;
: (make) r> tuck cell+ swap !r dup @ + cell+ >r ;
exit~
~sys
: defer? [''] 'defer isa ;
exit~
macro
: make
  defer? 1+ compiling? if literal, p: (make) 0 , ;then
  :: swap 2dup !r >body dup 1- defer@ ['] noop =if !r ;then 2drop ;
: undo defer? 1+ then,> off ;
: >defer xt?  then,> (is2) ;
: defer: defer here lastxt (is2) p: ] ;

forth
to~ ~priv ((cmp))

~util
defer: disassemble dump ;
defer: (see)
    find ?dup 0if type question ;then
    64 disassemble cr ;
: see parsews (see) ;
exit~ 

| ========================= PREPROCESSOR ==================
~priv
variable if-nesting		| [IF] increases nesting, [THEN] decreases it
20 stack: if-flag
: (then) if-nesting -- if-flag pop drop ;
: eat ( M -- )
	parsews
	case
		" [IF]" strof if-nesting ++ endof
		" [THEN]" strof if-nesting @ over (then) =if rdrop drop ;then endof
		" [ELSE]" strof if-nesting @ over =if if-flag peek rdrop 2drop ;then endof
		" |" strof parseln 2drop endof
		" (" strof ') parse 2drop endof
		2drop
	endcase
	eat ;
exit~
macro
: [THEN] (then) ;
: [ELSE]
	if-flag peek
	0if if-nesting @ eat then ;
: [IF] ( n -- )
	if-nesting ++
	dup not if-flag push	| save flag for [ELSE]
	0if if-nesting @ eat drop then ;
: [IFTEST] " TESTING" find if true else 2drop false then p: [IF] ;
forth
: sm/rem ( d n -- rem div ) inline{ 89 c3 ad 89 c2 ad f7 fb 92 8d 76 fc 89 06 89 d0 } ;

| ========================= FFI LAYER ==================
~priv
variable (cur-lib)
variable last-lib
variable last-func

: notloaded ( a n a2 n2 throwcode -- ) >r type_ type ."  not loaded" cr r> throw ;
: dolib
    | make us the current-library:
    dup (cur-lib) !
    dup @ 0if dup cell+ count (lib) over !  then
    dup @ | provide our 'handle'
    nip
    ;
exit~
: lib create 
        0 ,                 | +00 this is the handle of the library
        asciiz,             | +04 store cstr name of library
        lastxt
		dup (cur-lib) !      | make us the current-library to use
		last-lib link	    | link us into the chain of libs
    does> dolib
    ;

~priv
: (func-create)
		parsews 2dup (create) rot
        0 ,                 | +00 function pointer
        ,                   | +04 number of parameters
        (cur-lib) @  ,      | +08 library (xt of library)
        asciiz,             | +0C zt string name of function
		lastxt last-func link
        ;

: (func-data-does)  ( -- ptr )
        dup @ 0if
            dup dup             | self self self
            3cell+ count        | self self fnamea n
            rot 2cell+ @ dolib    | self a n lib
            (func)              | self handle
            over !              | self
        then
        dup @ 0if 3cell+ count " function" THROW_BADFUNC notloaded then
        ;
exit~ 
: func: ( n <name> -- )
    (func-create)  
    does> (func-data-does) 
	dup @ swap cell+@ 
	(call) 
    ;
: vfunc: ( n <name> -- )
    (func-create)  
    does> super> func: drop
    ;


: data: ( <name> -- )
    0 (func-create)
    does> (func-data-does) @ @ ;

~priv
: .libfunc  @ dup @ .x space dup xt>name type_ ;
exit~
: .libs
    ." handle   word  libname" cr
	{	
		.libfunc
		cell+ count type cr
		true
	} last-lib iterate
    ;


: .funcs 
    ." handle   word  funcname libname" cr
	{	
		.libfunc
		dup 3cell+ count type_
		2cell+ @ cell+ count type cr
		true
	} last-func iterate
    ;

| Makes an alias of the last word to the new name, and 'hides' the prior name:
: as ( <name> -- )
    lastxt alias
    last @ dup @ swap 2dup (hide)
    cell- swap cell-@ swap !
    ; 

:: | clean up libraries
	{ @ off true } last-func iterate
	{ @ off true } last-lib iterate
	; onexit

| ========================= OS LAYER ==================
| os-specific words:
: sp   inline{ 83 ee 04 89 06 89 f0 } ;
~os
os [IF]
    : ioctl ( p1 p2 ... pN N -- result ) 54 syscall ;
    : select ( nfds *readfds *wfds *efds *timeout ) 5 142 syscall ;
    " libc.so.6" lib libc
    data: errno
    : osname " Linux" ; 
    : getpid 0 20 syscall ;
    ~priv
    $a variable, line-end
    exit~
    : linefeed line-end 1 ;
    ~priv
    | TODO: make dynamic
    create in_termios 20 cells allot
    : non-canonical 
        | save terminal state
        in_termios $5401 0 3 ioctl drop
        in_termios 12 + @ >r
        | set terminal state:
        &100 in_termios 12 + !  
        in_termios $5403 0 3 ioctl drop
        r> in_termios 12 + !  
        ;
    : restore-canonical in_termios $5403 0 3 ioctl drop ;

    ::
        non-canonical
        3 sp $541b 0  3 ioctl drop
        restore-canonical
    ; is key?
    :: non-canonical key restore-canonical ; is ekey

    1 func: localtime
    :: 0 1 13 syscall here ! here localtime 
        dup @ swap cell+ dup @ swap cell+ dup @ 
        swap cell+ dup @ 
        swap cell+ dup @ 1+ 
        swap cell+@ 1900 + ;
    exit~ 
    ~
    alias time&date
    : ms 1000 /mod here !  1000000 * here cell+!
        0 here 2 162 syscall drop ;
    : ms@ 0 here 2 78 syscall drop here @ 1000000 * here cell+@ + 1000 / ;
    : makeexename ;
    exit~
[ELSE]
    ~priv
    $a0d variable, line-end
    exit~
    : linefeed line-end 2 ;
    : osname " Windows" ; 
    " user32" lib u32
    " gdi32" lib g32 
    " kernel32" lib k32
    ~priv
    1 vfunc: GetLocalTime
    1 vfunc: Sleep
    0 func: GetTickCount
    0 func: GetCurrentProcessId 
    2 func: GetConsoleMode
    2 func: SetConsoleMode
    4 func: PeekConsoleInputA
    4 func: ReadConsoleInputA 
    0 func: GetLastError
    2 func: WaitForSingleObject
    ~os
    : errno GetLastError ;
    exit~
    variable (conmode)
    : raw ( -- ) stdin here GetConsoleMode drop here @ 
        (conmode) !
        stdin 0 SetConsoleMode drop ;
    : cooked ( -- ) stdin (conmode) @ SetConsoleMode drop ;

|    create ir 5 cells allot | 0=type 4=keydown 8=repeatcount 10=vkeycode
                            | 12=vscancode 14=ascii 16=controlkeystate
    :: stdin 1 WaitForSingleObject not ; is key?
    : shiftmod ( n -- mask )
        | 3 -> alt  0c -> ctrl  10 -> shift
        | 000sccaa --> 00000sca --> 0sca00
        dup >r 3 and if $100 else 0 then
        r@ $c and if $200 else 0 then
        r> $10 and if $400 else 0 then 
        or or 
        ;
    : (ekey) 
        raw 
        stdin here 1 temp ReadConsoleInputA drop
        here 3cell+ 1+ 1+ w@ ?dup 0if
            here 2cell+ 1+ 1+ w@ 
            here 4cell+ @ | controlkey
            shiftmod or
        then
        cooked
        ;
    :: 0 repeat drop (ekey) dup $ff and 16 18 between while ; is ekey

    ~os
    : getpid GetCurrentProcessId ;
    exit~
    : exe " .exe" ;
    ~
    : ms@ GetTickCount ;
    : ms  Sleep ;
    : time&date here dup GetLocalTime 
        dup 3cell+ w@ swap
        dup 2cell+ 1+ 1+ w@ swap
        dup 2cell+ w@ swap
        dup cell+ 1+ 1+ w@ swap
        dup 1+ 1+ w@ swap
        w@ ;
    : makeexename ( a n -- a' n' )
        2dup here lplace exe here +lplace
        '. split _2nip if
            exe 1 /string cmpi 0if
                -4 here +!
            then
        then
        here lcount
        ;
    exit~
    exit~ 
[THEN]

| ." hi" cr bye
| ========================= ENVIRONMENT ==================
~priv
    32767 constant #env-var-buffer 
    0 value env-var-buffer
exit~
os [IF]
    ~os
    1 func: getenv as os_getenv
    ~priv
    1 func: putenv
    exit~
    exit~
    ~util
    : getenv zt in~ ~os os_getenv zcount ;
    : setenv ( a1 n1 a2 n2  -- )  |  variable, value
        2swap env-var-buffer lplace 
        '= env-var-buffer c+lplace 
        env-var-buffer +lplace | buffer: variable=value
        env-var-buffer lcount zt putenv drop
        ;
    exit~
[ELSE]
    ~priv
    3 func: GetEnvironmentVariableA
    2 func: SetEnvironmentVariableA
    exit~
    ~util
    : getenv ( a n -- a n ) zt env-var-buffer #env-var-buffer
        GetEnvironmentVariableA env-var-buffer swap ;
    : setenv ( a1 n1 a2 n2 -- ) 
        2swap zt -rot zt        | z1 z2
        SetEnvironmentVariableA drop
        ;
    exit~
[THEN]
exit~

| ========================= FILEIO ==================
| file i/o words:
~os
~priv
0 value dirbuf 
exit~
os [IF]
    ~
    : pathsep '/ ;
    exit~
    ~os
    : chdir ( a n -- ) zt 1 12 syscall ioerr ! ; | 12
    : getcwd ( -- a n ) 255 dirbuf 2 183 syscall 1- dirbuf swap ; | 183 buf size --> buf
    exit~
    ~io
    : (seek) ( whence offset handle ) 3 19 syscall ;
    : rename zt -rot zt 3 38 syscall ioerr ! ;
    : delete  ( a n -- ior ) zt 1 10 syscall ioerr ! ;

| create stat_buf 100 allot
| struct stat {
|         unsigned long  st_dev;
|         unsigned long  st_ino;
|         unsigned short st_mode;
|         unsigned short st_nlink;
|         unsigned short st_uid;
|         unsigned short st_gid;
|         unsigned long  st_rdev;
|         unsigned long  st_size;
|         unsigned long  st_blksize;
|         unsigned long  st_blocks;
|         unsigned long  st_atime;
|         unsigned long  st_atime_nsec;
|         unsigned long  st_mtime;
|         unsigned long  st_mtime_nsec;
|         unsigned long  st_ctime;
|         unsigned long  st_ctime_nsec;
|         unsigned long  __unused4;
|         unsigned long  __unused5;
| };
    
    ~priv
    : (stat) ( a n -- x ) zt here swap 2 106 syscall ioerr ! ;
    exit~
    : stat ( a n -- x ) (stat) here 2cell+ @ ;
    : mtime ( a n -- x ) (stat) here [ 12 cells ] + @ ;
    exit~
[ELSE]
    ~
    : pathsep '\ ;
    exit~
    k32 drop
    ~priv
    4 func: SetFilePointer
    2 func: MoveFileA as MoveFile
    1 func: DeleteFileA as DeleteFile
    1 func: GetFileAttributesA as GetFileAttributes
    4 func: GetFileTime
    2 func: GetCurrentDirectoryA
    1 func: SetCurrentDirectoryA
    1 func: CloseHandle
    exit~
    ~os
    : chdir ( a n -- ) zt SetCurrentDirectoryA ioerr ! ;
    : getcwd ( -- a n ) 255 dirbuf GetCurrentDirectoryA dirbuf swap ;
    exit~
    | stat:
    ~io
    : stat zt GetFileAttributes ;
    | delete:
    : delete zt DeleteFile not ioerr ! ;
    | rename:
    : rename zt -rot zt swap MoveFile not ioerr ! ;
    : mtime open/r ioerr @ if drop -1 ;then
        >r | fh
        r@ 0 0 here GetFileTime if
            here 2@ | FILETIME>unixtime
            27111902 - swap -717324288 - swap
            10000000 sm/rem nip
        else
            -1
        then
        r> close ;

    : (seek) ( whence offset handle ) 
        -rot 0 rot
        SetFilePointer ( handle off offhigh whence )
        ;
    exit~
[THEN]
exit~
to~ ~os hinst
to~ ~os syscall
' | dup alias #!  alias @rem

: appdir appname zcount pathsep -chop 1+ ;
: libdir appdir 1- pathsep -chop 1+ scratch place " lib" scratch +place pathsep
    scratch c+place scratch count ; 
: seek ( offs h -- newoffs ) >r 0 swap r> (seek) drop ;
: tell ( fh -- offs ) 1 0 rot (seek) ;

| ========================= NEEDS ==================
~priv
variable uses-list
: libname ( a n la ln -- a1 n1 )
    dup if scratch place scratch +place scratch count ;then
    2drop ;

variable needs?
: needslibname libname (include) ioerr @ ;
: needs 
    parsews 
: (needs)
	needs? on
	{ @ count 2over cmp dup needs? !  }
	uses-list iterate 
	needs? @ 0if 2drop ;then
    |  a n 
    | try in userlib first:
    2dup " REVAUSERLIB" getenv needslibname if
        2dup libdir needslibname  if 
            type question cr  
            THROW_NEEDS throw
        ;then
    then
	here -rot asciiz, uses-list link
   ; 

: .needs { @ count type_ true } uses-list iterate cr ;
to~ ~ needs
to~ ~ .needs
exit~
: .classes { @ >name count type_ true } classes iterate ;
to~ ~priv classes

| ========================= CONTEXT FIXUPS ===============
to~ ~strings place to~ ~strings +place to~ ~strings c+place
to~ ~strings lplace to~ ~strings +lplace to~ ~strings c+lplace to~ ~strings count
to~ ~strings lcount to~ ~strings (") to~ ~strings "" to~ ~strings /char to~ ~strings \char 
to~ ~strings chop to~ ~strings -chop to~ ~strings cmp to~ ~strings cmpi 
to~ ~strings zcount to~ ~strings zt to~ ~strings z"
to~ ~io creat to~ ~io close to~ ~io open/r to~ ~io open/rw to~ ~io read to~ ~io write
to~ ~io fsize to~ ~io ioerr to~ ~io seek to~ ~io tell
to~ ~util >lz to~ ~util lz> to~ ~util lzmax to~ ~util fnvhash  
to~ ~util findprev
to~ ~util asciiz, to~ ~util asciizl, to~ ~util z, to~ ~util used to~ ~util depth
to~ ~io spaces to~ ~util later
to~ ~sys (to~) to~ ~sys then,>  to~ ~sys (while)
to~ ~sys (s^) to~ ~sys srcstr
to~ ~strings /string to~ ~strings 0term
to~ ~sys ?literal to~ ~sys then> to~ ~sys compiling? to~ ~sys (if to~ ~sys if)
to~ ~io ekey to~ ~io key? to~ ~io cr
to~ ~sys (s0) to~ ~sys pdoes
to~ ~sys rel> to~ ~sys >rel to~ ~sys vector! to~ ~sys vector
to~ ~util >body 
to~ ~util body>
to~ ~util >name to~ ~util >xt to~ ~util >class
to~ ~io type_ to~ ~io space to~ ~io type
to~ ~util rpick to~ ~util rp@ to~ ~util put to~ ~util 4cell+ to~ ~util 3cell+
to~ ~util 2cell+ to~ ~util 2cell- to~ ~util 3drop to~ ~util 0drop;
to~ ~priv pop>eax  to~ ~sys (here) to~ ~sys dict to~ ~sys word?
to~ ~util slurp to~ ~util iterate to~ ~util link to~ ~util (save)
to~ ~util appname to~ ~util (include) to~ ~util include
to~ ~util >digit to~ ~util digit> to~ ~util >single
to~ ~sys find-dict to~ ~sys src to~ ~sys tp to~ ~sys tib to~ ~sys >in to~ ~sys (bye)
to~ ~sys (func) to~ ~sys (call) to~ ~sys (-lib) to~ ~sys (lib)
to~ ~io emit to~ ~io key
to~ ~util here, to~ ~util parse/ to~ ~util os
to~ ~util argc to~ ~util (argv)
to~ ~sys onstartup to~ ~sys onexit
to~ ~sys rp0 
to~ ~sys h0 to~ ~sys d0 to~ ~sys s0
to~ ~sys default_class  to~ ~sys cold
to~ ~sys find-word
to~ ~util stack-iterate to~ ~util peek-n to~ ~util peek to~ ~util pop
to~ ~util push to~ ~util stack-empty?  to~ ~util stack-size to~ ~util stack:
to~ ~sys xt? to~ ~sys isa to~ ~sys context? 
to~ ~priv all-contexts
to~ ~priv xtdict

to~ ~priv contexts hide oldfind
to~ ~priv saved-contexts

: reva reset~ ~reva ~os ~util ~io ~strings ~ ; reva
| ========================= REVA STARTUP ==================
~priv
with~ ~sys
| buffer allocations:
| Note: all these scratch buffers are just one allocated buffer, split up in
| chunks.  Presumably this is a bit more efficient than having multiple
| allocated buffers.  Certainly it is faster (but who would notice?)
::
    [ 16384 18 +  #env-var-buffer + 256 + 1024 + ] literal allocate 
    dup to scratch
    16384 + dup to env-var-buffer
    #env-var-buffer + dup to dirbuf
    256 + dup to pad
    1024 + to dump$
    | load strings
    revastr slurp dup 0if 2drop 10 0do '$ emit loop cr bye ;then
    | a n
    dup 3 2 */ 1000000 max allocate (compstr) !
    2dup (compstr) @ swap move
    (compstr) @ + (compstrend) !
    free
    ; onstartup
without~
exit~
: argv2 swap 0; 1- swap zcount + 1+ argv2 ;
: argv argc 1- clamp (argv) argv2 zcount ;
hide argv2
hide not-word
hide @litcomp
to~ ~priv sbufs
to~ ~priv sbufsallot


forth
~reva
: revaver " 7.0.8" ;
| convert 'revaver' to 'revaver#' automagically:
    " 0" revaver
    '. split drop
    eval 8 << temp !
    '. split drop
    eval temp +!
    eval temp @ 8 << +        constant revaver#
    reset

: .ver " Reva " type  revaver type_ osname type ;
: revalang " REVALANG" getenv ;
~priv
defer: caught cr ." Caught: " . cr ;
: catchme ( xt -- ) catch 0; caught ~sys.src off ;
: ((hi)) ( i c -- m )
    1 -rot
    case
        'n of 1+ argv (needs) endof
        'e of 1+ argv eval endof
        'd of drop " debugger" (needs) 1- endof
        'a of drop " needs ansi ~ans" eval  1- endof
        'c of 1+ argv chdir endof
        't of drop " needs testing " eval 1- endof
        'v of .ver linefeed type bye endof
        3drop argc
    endcase
    ;
: (hi)  ( argc a n -- m ) over c@ '- =if drop 1+ c@ ((hi)) ;then (include) drop 0 ;
~
defer deinit-console
exit~
:: ." Break" cr bye ; is ctrl-c
::  deinit-console ." Exception: " .x ." at: " .x 100 ms ['] bye cr ; is exception
: hello 
    argc 1 do 
        i dup argv (hi) skip 
    loop ;
make appstart  
    argc 1- 0if .ver cr else ['] hello catchme then 
    | main interpreter loop:
    repeat p: [ ['] interp catchme again ;
make prompt  cr ." ok> " ;
: sorry cr ." No more " type ." space! Sorry." cr bye ;
make heapgone " code" sorry ;
make dictgone " dict" sorry ;
to~ ~reva caught
exit~ 
exit~
to~ ~sys appstart to~ ~sys interp to~ ~sys prompt
to~ ~sys state
to~ ~sys dict?
to~ ~util alias
to~ ~priv (is)
| to~ ~priv help!
to~ ~priv oldstate
to~ ~priv newheader
to~ ~priv oldheader
~strings
to~ ~priv (split)
exit~

2variable revaused 
: .used
    revaused 2@ used  
    rot - . ." code, "
    swap - . ." dict" cr
    ;
: save parsews : (save) 
    | save out strings
    256 allocate >r
    2dup r@ place '. r@ c+place 'x r@ c+place
    r@ count creat dup             | h h
    (compstr) @ (compstrend) @ over - rot write
    close
    cr 
    ." Saving: " 2dup type cr
    ." Uses: " .used
    ." Libraries: " cr .libs
    ." Strings: " r> count type cr
    prior (save) bye ;
 to~ ~util save
 to~ ~util (save)
used revaused 2!
1 [IF]
| Generate the Reva executable:
appdir here 1000 + place " reva" makeexename here  1000 + +place here 1000 + count (save) 
[THEN]

| vim: et ts=4 :

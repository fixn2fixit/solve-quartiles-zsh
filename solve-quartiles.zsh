#! /bin/zsh
# AUTHOR  : Michael Carney, Ver. 2.7.15, Dec. 01, 2025
# CONTACT : fixn2fixit@gmail.com
# USAGE   : zsh ./solve-quartiles.zsh
# WHAT    : Solves Apple News+ Quartiles puzzles
# WHY     : There are 123,520 non redundant combinations of (1-4 tiles) among 20 total 
#         : Tiles contain 2-4 characters each, tiles rearrange, not characters within
#         : (zsh) proves the usefulness of traditional command-line scripting, no frills
# REQUIRED: Z shell is the MacOS default, most Linux repos have (zsh) available to add
#         : Wordplay (wordlist.txt) is intended bundled, can overwite it with your own
#         : (wordlist.txt) & (tiles.txt) must exist in the $PATH of this script
#         : (tiles.txt) must must contain all tile characters from (any) single puzzle
# TO PLAY : Initial run asks for input (goes into tiles.txt), type 20 tiles, all chars 
#         : If instead you enter a single period, the current (tiles.txt) file is used
#         : (tiles.txt) must have (20) tiles total, space-delimited, one or more lines
#         : Intended/bundled (tiles.test) can be used to copy to (tiles.txt) for demo
# WRITES  : This version writes (7) small files in /tmp/ which improves search time 
# SPEEDY  : Typical full solution runtime 01-04 sec. using one CPU and a single thread
# OPTIONAL: Hint, an OCR app can reduce typing effort, can utilize copy/paste for input
#         : If using an OCR app to copy/paste tiles text, scans can be imperfect, check
# YOUR JOB: Knowing how to edit a file is req'd to fix tiles.txt or modify wordlist.txt
# UPDATED : Rewritten as functions for clarity and ease of testing 
#         : Each tile length (2-4 chars) is checked as well as total tiles = 20
#         : Typed input can be backspaced for corrections, use a period to finish input
#         : Word length ranges are based on historical analysis of 400+ actual puzzles
#         : Total avoided but possible lookups provided as a measurement of efficiency
#         : Exit if pasted or typed characters are detected as malformed, multi-char
#         : Increased exclusions list in loop4, reduced total searches, reduced runtime
#         : Fixed input_tiles() bug, punctuation not allowed; therefore eliminated 
#         : Fixed exclude_some() bug, $move_on[@] patterns now match consistently
#         : End, kill -s SIGINT $$ avoids closing Terminal when called by double-click
# MIN-MAX : Oct. 03, 2025 min-max character range updated based on historical analysis
#         : Slower now by .5 sec due to 'embroils' & 'prognosticated' needing 08-14 char
# METHODS : /tmp/ is utilized for reduction and cleanup, writes are public & disposable 
#         : dict[@] is resized per loop(1-4) to the expected character-range (min-max)
#         : dict[@] is further reduced using only first-tile matches in current wordlist
#         : sort_tiles() puts tiles in order of frequency that match anywhere in wordlist
#         : Four reduced wordlist files are written to contain wordlist character ranges
#         : Historical analysis: (min-max) char-range determined by real puzzles solved
#         : At completion the total quantity of words discovered is displayed 
#         : At completion the total quantity of searches expended is displayed 
#         : When five quartile words have been found ((quartiles > 4)), searches terminate
#         : Official Quartiles puzzles do not generate (more than five) (4-tile) words
#         : Implemented 'exclude_some()' to exclude some tiles from first-tile searches
#         : Does not display exclusions message if exclusions are empty
#         : If malformed input (hidden chars) discovered, show good/bad two-column list
# EZ PEZY : Using the (wordlist.txt) intended with this distro will save you effort
# CAVEAT  : The quality of (wordlist.txt) determines the accuracy of solutions
# FORMAT  : The expected format of any wordlist is one lower-case word per line
# FIXER   : This script auto-corrects Win/DOS style wordlists for Unix compatible end-of-lines
# SCRUBBER: This script eliminates wordlist records with capitals, numbers, or punctuation
# LIMITER : This script limits word size to 14 characters, /tmp/min-max files are written
# ONGOING : You should (add or delete) words in (wordlist.txt) as puzzles determine valid
# DICT    : If using your own word list, preserve (wordlist.txt), overwrite with yours
# ================================ BEGIN FUNCTIONS ===========================================
say_greeting(){ clear
              echo "\nSolving Quartiles Puzzles ($qt_ver)"
              echo "=========================" 
              }
input_tiles() { theseTiles=( )
              echo "Input Tips\n=========="
              echo "Input puzzle tiles, finish with ( .)"
              echo "1 or more per line, space them apart" 
              echo "If (.) only, input is from tiles.txt"
              echo "\nEnter 20 tiles, end with (. return)\n> \c"
              while read z
              do theTiles+=( $z)
              [[ $theTiles[@] =~ "\." ]] && break
              done
              [[ $theTiles[@] =~ [a-z]+ ]] && (echo $theTiles[@] | tr -d \. | sed 's/,/ /g') > $tiles
              clear
              }
check_wordlist() {
              echo "\nChecking presence and content of: ($masterlist)\n" ; qty=0
              [ ! -s $masterlist ] && echo "Missing wordplay list, copy one to $masterlist\n"   && exit
              file $masterlist | grep -q CRLF                                                   &&
              tr -dc "[:alpha:]\n" < $masterlist | sed '/[0-9]/d;/[A-Z]/d' > /tmp/wordlist.unix &&
              cp /tmp/wordlist.unix $masterlist
              [ -s $masterlist ] && qty=$(awk 'BEGIN{n=0} /./ {n+=NF} END{print n}' $masterlist)
              echo "$qty words in $masterlist\n"
              (($qty < 50000 )) && echo "\ninadequate wordplay list, get one with 50,000+ words..\n" && exit
                 }
reduce_wordlist() { # limit words in wordlist.txt to 14 chars max
                  awk 'length < 15' $masterlist > $smallerList
                  }
check_tiles() {  # checking because OCR scans may introduce hidden ctrl chars or omit text
              echo "\nChecking presence and content of: ($tiles)\n"
              [ ! -s $tiles ] && echo "Missing content! Put all tile chars into: $tiles\n"      && exit
              [ -s $tiles ] && qty=$(awk 'BEGIN{n=0} /./ {n+=NF} END{print n}' $tiles)
              echo "$qty tiles"
              (($qty != 20 )) && echo && cat $tiles && echo "\ntry again..\n" && exit
              invalid=$(cat $tiles | xargs -n1 | awk 'length > 4 || length < 2') 
              [[ $invalid ]] && echo "\nlength errors (try again)\n=============\n$invalid\n" && exit
              tr -dc "[:print:]\n" < $tiles | tr -d '[:punct:]' | grep . | \
              sed 's/0/o/g;s/9/g/g;s/1/l/g;s/I/l/g' | \
              tr '[:upper:]' '[:lower:]' > /tmp/tiles.cleaned
              sed 's/ /\n/g' /tmp/tiles.cleaned | grep . > $tiles
              file $tiles | egrep -q 'U' && echo "\nBad OCR copy/paste or typing in: ($tiles)\n"    &&
              echo "SHOULD BE\t     FOUND\n============\t     ============="                      &&
              (cat $tiles ; cat -v $tiles ) | pr -t -2 -o8 -w25                         && echo && 
              kill -s SIGINT $$
              }
sort_tiles()  { # sort tiles low-to-high by presence anywhere, among all words
              for ea_ in $(cat $tiles)
              do 
              qty=$(grep -c $ea_ $smallerList)
              echo $ea_ $qty
              done | sort +1 -n | awk '{print $1}' > /tmp/tiles.lo.hi
              cp /tmp/tiles.lo.hi $tiles
              }
tiles_array() {
              tile=($(< $tiles))
              }
make_dict()   { # tile one during each top loop determines dict[@] array size
              dict=(: $(grep "^${tile[$one]}" $min_max) :)
              }
exclude_some(){ # first tile searches having no matches in wordlist
              for ea_ in $tile[@] ; do 
              move_on+=($(grep -q ^$ea_ $smallerList || echo $ea_))
              done
              (( ${#move_on} > 0 )) && echo "Excluding first-tile searches: $move_on[@]\n"
              exclude=$(echo $move_on | awk 'END{print (1/(20/NF)*123520)}')
              echo "TILE ARRAY\n----------\n$tile[@]\n"
              }
loop1() {
min_max="/tmp/wordlist-02-04-char.txt"
awk 'length < 5' $smallerList > $min_max
echo "searching one-tile hits.. $(date)\n"
for (( one=1; one<=20; one++ ))
do  [[ $move_on[@] =~ " $tile[$one] " ]] && continue 
     ((lookups++))
     make_dict
     [[ $dict[@] =~ " $tile[$one] " ]] && 
     printf "%-16s : %s\n" "$tile[$one]" "$tile[$one]" && ((hits++))
done
        }
loop2() {
min_max="/tmp/wordlist-04-08-char.txt"
awk 'length > 3 && length < 9' $smallerList > $min_max
echo "\nsearching two-tile hits.. \n"
for (( one=1; one<=20; one++ ))
do  [[ $move_on[@] =~ " $tile[$one] " ]] && continue
    make_dict
    for (( two=1; two<=20; two++ ))
    do 
    (( $one !=  $two )) && ((lookups++)) &&
    [[ $dict[@] =~ " $tile[$one]$tile[$two] " ]]  &&
    printf "%-16s : %s\n" "$tile[$one]$tile[$two]" \
             "$tile[$one] $tile[$two]" && ((hits++))
    done
done
        }
loop3() {
min_max="/tmp/wordlist-06-12-char.txt"
awk 'length > 5 && length < 13' $smallerList > $min_max
echo "\nsearching three-tile hits.. \n"
for (( one=1; one<=20; one++ ))
do  [[ $move_on[@] =~ " $tile[$one] " ]] && continue
make_dict
    for (( two=1; two<=20; two++ ))
    do 
      for (( three=1; three<=20; three++ ))
      do
      (( $one != $two )) && (( $one != $three )) && (( $two != $three )) && ((lookups++)) &&
      [[ $dict[@] =~ " $tile[$one]$tile[$two]$tile[$three] " ]] &&
      printf "%-16s : %s\n" "$tile[$one]$tile[$two]$tile[$three]" \
             "$tile[$one] $tile[$two] $tile[$three]" && ((hits++))
      done
    done
done
        }
loop4() {
min_max="/tmp/wordlist-08-14-char.txt"
awk 'length > 7' $smallerList > $min_max
echo "\nsearching four-tile hits.. \n"
for (( one=1; one<=20; one++ ))
do  [[ $move_on[@] =~ " $tile[$one] " ]] && continue
    ((quartiles > 4)) && break
make_dict
    for (( two=1; two<=20; two++ ))
    do [[ $move_on[@] =~ " $tile[$one] " ]] && continue
      ((quartiles > 4)) && break
      for (( three=1; three<=20; three++ ))
      do [[ $move_on[@] =~ " $tile[$one] " ]] && continue
        ((quartiles > 4)) && break
        for (( four=1; four<=20; four++ ))
        do
        ((quartiles > 4)) && break
        (( $one != $two )) && (( $one != $three )) && (( $two != $three ))  &&
        (( $one != $four )) && (( $two != $four )) && (( $three != $four )) && ((lookups++)) &&
        [[ $dict[@] =~ " $tile[$one]$tile[$two]$tile[$three]$tile[$four] " ]] && 
        move_on+=( $tile[$one] $tile[$two] $tile[$three] $tile[$four] ) &&
        printf "%-16s : %s\n" "$tile[$one]$tile[$two]$tile[$three]$tile[$four]" \
        "$tile[$one] $tile[$two] $tile[$three] $tile[$four]" && ((hits++)) && ((quartiles++))
        done
      done
    done
done
        }
# ================================ MAIN =====================================
umask 111            # /tmp/ files written are public
qt_ver="v2.7.15"
possible="123520"
tiles="tiles.txt"
masterlist="wordlist.txt" ; hits=0 ; quartiles=0 ; lookups=0
smallerList="/tmp/wordlist.max14.chars.txt"
my_runtime=/tmp/quartiles.times.out
say_greeting
input_tiles
say_greeting
check_tiles
check_wordlist
reduce_wordlist
sort_tiles
tiles_array
exclude_some
loop1 ; loop2 ; loop3 ; loop4
echo "\nTotal ($hits) words\t$(date)\n" 
times > $my_runtime
echo "runtime : \c" ; awk 'NR==1 {print $1}' $my_runtime | sed 's/^.*m//'
echo "lookups : $lookups"
echo "excluded: $exclude"
unused=$(awk -v L=$lookups -v P=$possible 'BEGIN{print int(100-(100/(P/L)))"%"}')
echo "\n$unused of possible brute-force lookups were avoided"
kill -s SIGINT $$

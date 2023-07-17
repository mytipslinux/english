#!/bin/bash
#set -x
#set -e
IFS=$'\n\t'
clear
# VARIABLE
# ======================================
#WORKDIR="$( cd -P -- "$(dirname "$(~/git/perso-git/english "$0")" )" && pwd )"
WORKDIR="$(cd /home/${USER}/git/perso-git/english && pwd)" 
cd ${WORKDIR}
#compteur
succes=""
total=""
moyenne=""
i=""
j=""
trad=""
Langue1=""
Langue2="French"
# FONCTION
function blank_var
{
succes=""
total=""
moyenne=""
i=""
}

function rappel_menu_principal
{
echo "Menu principal ?
Choix 1: -English/French
Choix 2: -Italian/French
choix 3: -Spanish/French
Choix 4: -Dutch/French
Choix 5: -Quitter (q|Q)"
}

function rappel_menu_categorie
{
echo "Catégorie ?
Choix 1: -5000 Mots courants
Choix 2: -Animaux
choix 3: -Nombres
Choix 4: -Maison
Choix 5: -Argos
Choix 6: -Insultes
Choix 7: -Mots de liaisons
Choix 8: -Métier
Choix 9: -Quitter (q|Q)"
}

function rappel_menu_random
{
echo "Un autre Quizz Random ?
Choix 1: -${Langue1}/${Langue2}
Choix 2: -${Langue2}/${Langue1}
choix 3: -Relancer la même plage aléatoire
choix 4: -Plage suivante de ${iteration} mots?
choix 5: -Historique
choix 6: -Quitter (q|Q)"
}

function choix
{
echo -e "\033[37m\nChoix du test entre seulement les erreurs ou tous les mots"
select i in "Seulement les erreurs du fichier" "Tous les mots du fichier"; do
        if [ "${i}" = "Seulement les erreurs du fichier" ]; then
                fichier=onlyerr
                break
        elif [ "${i}" = "Tous les mots du fichier" ]; then
                fichier=allwords
                break
        else
                echo "mauvaise reponse"
        fi
done
}

function mainCategorie
{
select choix in "5000 mots courants" "Animaux" "Nombres" "Maison" "Argos" "Insultes" "Liaisons" "Métier" "Quitter (q|Q)";do
case ${REPLY} in
        1) echo "5000 mots courants: "
		cd ./5000
                mainQuizzRandom
                rappel_menu_categorie;;
        2) echo "Animaux"
                cd ./Animaux
                mainQuizzRandom
                rappel_menu_categorie;;
        3) echo "Nombre"
                cd ./Nombres
                mainQuizzRandom
                rappel_menu_categorie;;
        4) echo "Maison"
                cd ./Maison
                mainQuizzRandom
                rappel_menu_categorie;;
        5) echo "Argos"
                cd ./Argos
                mainQuizzRandom
                rappel_menu_categorie;;
        6) echo "Insultes"
                cd ./Insultes
                mainQuizzRandom
                rappel_menu_categorie;;
        7) echo "Liaisons"
                cd ./Liaisons
                mainQuizzRandom
                rappel_menu_categorie;;
        8) echo "Métier"
                cd ./Metier
                mainQuizzRandom
                rappel_menu_categorie;;
        9|q|Q) echo "Quitter"
                break
esac
done
}

function mainQuizzRandom
{
select choix in "${Langue1}/${Langue2}" "${Langue2}/${Langue1}" "Relancer la même plage aléatoire" "Plage suivante?" "Historique" "Quitter (q|Q)"; do
case ${REPLY} in

        1) echo "Aléatoire ${Langue1}/${Langue2}: "
        j=""
        j=$((j+1))
        choix
        interval
        RandomQuizzLangue1
        blank_var
        j=""
        rappel_menu_random;;

        2) echo "Aléatoire ${Langue2}/${Langue1}: "
        j=""
        h=""
        j=$((h+2))
        choix
        interval
        RandomQuizzLangue2
        blank_var
        j=""
        h=""
        rappel_menu_random;;

        3) echo "Relancer la même plage aléatoire: "
        param
        if [[ "${j}" == 1 ]]
                then RandomQuizzLangue1
                else RandomQuizzLangue2;
        fi
        blank_var
        rappel_menu_random;;
        4) echo "Plage suivante"
	paramITE
        if [[ "${j}" == 1 ]]
                then RandomQuizzLangue1
                else RandomQuizzLangue2;
        fi
        blank_var
        rappel_menu_random;;
	5) echo "Historique: "
        cat result1.txt
        rappel_menu_random;;
        6|q|Q) break;;
esac
done
}


function RandomQuizzLangue1
{
RandomQuizz=$(shuf -i 1-${b})
c=1
echo ${quizz} |sed "s+@ +@\n+g" > aftersed
FILE=aftersed
until [ $b == 0 ]; do
       down=$(echo ${RandomQuizz} |cut -d" " -f${c})
       ((c=c+1))
       export lignerandom=$(cat $FILE |awk  NR==${down})
       while [ -z ${trad} ]; do
                echo -e "\033[33mMot à traduire:"
                export mot1=$(echo ${lignerandom} |cut -d "#" -f1)
                echo -e "\033[37m${mot1}"
		while [ -z ${trad} ]; do	
                        read -e -p "> " trad
		done
                export mot2=$(echo ${lignerandom} |cut -d "#" -f2 |cut -d "@" -f1)
                check_response
        score > result1.txt
        done
        ((b=b-1))
        trad=""
affichage_score |tail -n 9
done
affichage_score |tail -n 9
}

function RandomQuizzLangue2
{
RandomQuizz=$(shuf -i 1-${b})
c=1
echo ${quizz} |sed "s+@ +@\n+g" > aftersed
FILE=aftersed
until [ $b == 0 ]; do
       down=$(echo ${RandomQuizz} |cut -d" " -f${c})
       ((c=c+1))
       export lignerandom=$(cat $FILE |awk  NR==${down})
       while [ -z ${trad} ]; do
                echo -e "\033[33mMot à traduire:"
                export mot1=$(echo ${lignerandom} |cut -d "#" -f2 |cut -d "@" -f1)
                echo -e "\033[37m${mot1}"
                while [ -z ${trad} ]; do
                        read -e -p "> " trad
                done
                export mot2=$(echo ${lignerandom} |cut -d "#" -f1 |cut -d "@" -f1)
        	check_response
	score > result1.txt
	done
	((b=b-1))
        trad=""
affichage_score |tail -n 9
done
affichage_score |tail -n 9
}

function interval
{
export nbr=$(wc -l ${fichier} |cut -d " " -f1)
echo -e "\033[37m\nSelectionnez l'interval de ligne à tester entre les: ${nbr} lignes du Quizz"
read -p "Position de la 1ere ligne: " debut
read -p "Position de la dernière ligne: " fin
export quizz=$(cat ${fichier} |awk "NR>=${debut} && NR<=${fin}")
echo -e "\033[37m\n Score Reset à: 0 \n Lets GO"
b=$((${fin} - ${debut} +1))
}

function param
{
export j=$(cat result1.txt |awk  NR==3 |cut -d ")" -f1 |cut -d" " -f2)
export i=$(cat result1.txt |awk  NR==3 |cut -d ":" -f2 |cut -d")" -f2| cut -c 2-)
export fichier=$(cat result1.txt |awk  NR==3 |cut -d ":" -f3 | cut -d" " -f2)
export debut=$(cat result1.txt |awk  NR==4 |cut -d " " -f4 )
export fin=$(cat result1.txt |awk  NR==4 |cut -d " " -f8)
b=$((${fin} - ${debut} +1))
echo "Lancement du Quizz avec les derniers parametres: 
Choix: ${j}) ${i}: ${fichier} entre la ligne: ${debut} et la ligne: ${fin}"

export quizz=$(cat ${fichier} |awk "NR>=${debut} && NR<=${fin}")
echo -e "\033[37m\n Score Reset à: 0 \n Lets GO"
}

function paramITE
{
export j=$(cat result1.txt |awk  NR==3 |cut -d ")" -f1 |cut -d" " -f2)
export i=$(cat result1.txt |awk  NR==3 |cut -d ":" -f2 |cut -d")" -f2| cut -c 2-)
export fichier=$(cat result1.txt |awk  NR==3 |cut -d ":" -f3 | cut -d" " -f2)
export debut=$(cat result1.txt |awk  NR==4 |cut -d " " -f4 )
export fin=$(cat result1.txt |awk  NR==4 |cut -d " " -f8)
iteration=$((${fin}-${debut} +1))
debut=$((${debut}+${iteration}))
fin=$((${fin}+${iteration}))
b=$((${fin} - ${debut} +1))
echo "Lancement du Quizz avec les derniers parametres:
Choix: ${j}) ${i}: ${fichier} entre la ligne: ${debut} et la ligne: ${fin}"

export quizz=$(cat ${fichier} |awk "NR>=${debut} && NR<=${fin}")
echo -e "\033[37m\n Score Reset à: 0 \n Lets GO"
}



function check_response
{
#echo "=====>        ${mot2}"
#	trans -t en+fr ${trad}
        if [[ "${mot2}" =~ "${trad}" ]]
                then echo -e "\t\t\t\t\t\t\t\033[32mGOOD: ${mot2} "
                succes=$((succes+1))
                total=$((total+1))
		echo -e "\t\t\t\t\t\t\t\033[32m====================================================="
        else echo -e "\t\t\t\t\t\t\t\033[31mFAILED: ${mot2}"
#	echo -e "\033[31mAjouté à votre liste d'erreur"
#	echo "$ligne" >> onlyerr2
        echo -e "\t\t\t\t\t\t\t\033[31m====================================================="
                total=$((total+1)) ;
        fi
moyenne=$((succes*20/total))
}

function score
{
date=$(date "+%d-%m-%Y   %Hh%M")
echo -e "\t\t\t\t\t\t\t\033[37m\nDate: ${date}
\t\t\t\t\t\t\tQuizz: ${j}) ${i}: ${fichier} 
\t\t\t\t\t\t\tEntre la ligne: ${debut} et la ligne: ${fin} :
\t\t\t\t\t\t\t\033[32m=====================================================
\t\t\t\t\t\t\t==Bonne Réponse=========Total============Moyenne=====
\t\t\t\t\t\t\t=================|=================|=================
\t\t\t\t\t\t\t\t ${succes} \t  \t ${total} \t  \t ${moyenne}/20 \t
\t\t\t\t\t\t\t=================|=================|=================
\t\t\t\t\t\t\t\033[37m\n "
}

function affichage_score
{
cat result1.txt >> result.txt
echo "Fin du quizz
Resultat:"
cat result.txt
succes=""
total=""
}

#  CODE
# ======================================
PS3="> Votre choix: "

select choix in "English/French" "Italian/French" "Spanish/French" "Dutch/French" "Quitter (q|Q)"; do
case ${REPLY} in

1) echo "English/French: "
echo -e "\033[37m\n =======ENGLISH======="
echo -e "c=====================
      | \:::|  |::://|
      |\ \::|  |::// |
      |:\\ \:|  |:// /|
      |::\\ \|  |// /:|
      |:::\\_|  |/_/::|
      |              |
      |_____.  ._____|
      |::/ /|  | \\:::|
      |:/ //|  |\ \\::|
      |/ //:|  |:\ \\:|
      | //::|  |::\ \|
      |//:::|__|:::\_|\n\n"

WORKDIR="$(cd /home/${USER}/git/perso-git/english && pwd)"
Langue1="$(echo English)"
cd ${WORKDIR}/${Langue1}
mainCategorie
rappel_menu_principal;;

2) echo "Italian/French: "
echo -e "
|___________________________________________________________________________
|              \"Aveva i capelli rossi. Come leggere un testo
|                 letterario: metodi a confronto
|                      su Rosso Malpelo. Atti del
|                         Seminario di studi\".
|        Pal                                                    umbo.
|
|
|                     Mendes.                \"L'occhio
|           \"L'occhio        del          del         male\"
|                   poeta\"                      Lars
|     \"La       Ste   ga  gno               so  nBj  örn ;          \"Le
| pulce               Pi  cc  hi   o          Ipe   rb or            avven
| nell'                 Luciana ; Ga              ea                   ture
|  orec                          ng                                  di Tin
|   chio\"                      emi                                     Tin\"
|    Pest                                                             di
|     elli                                                          Her
|       G.                      \"Il       naso                      gè.
|                               di          Pi
|           M                   noc        chio\"                  ;
|           a                       Charyn                        L
|            r                        Jer                        i
|             s                       ome.                     z
|              i                                              a
|               l                   \"Quello                  r
|                i                col piede in              d
|                  o           bocca        e altri
|                                   racconti\"
|                                   S.Bellow
|                                  Mondadori
|
|                       \"La                        ma
|                          no                     no
|                            sul              mento
|                             Racconti,    memorie,
|                                   pensieri\".
|                                 A. Romagnino
|                                   Edizioni
|                                    della
|                                    Torre
|_____________________________________________________________________________"

WORKDIR="$(cd /home/${USER}/git/perso-git/english && pwd)"
Langue1="$(echo Italian)"
cd ${WORKDIR}/${Langue1}
mainCategorie
rappel_menu_principal;;

3) echo "Spanish/French: " 
#echo -e "
#                  /\       ,,                                        ./
#          .---.   ||      /||                                       //
#       --'-----`--||    .'  \                                      //
#         {{{N `(  ||  .'    @                                     //
#         {{{` _/  ||.'    |  \                        _________ _//
#         {{{.-.   ||  /  /\   \                        \"-------(_)
#          {( )| .'||    /  `.  \                               | \\
#__        {|\ \'  / )  /     \\O|                              |_|\\
#  `-.____.-| \ \ /\/  /       `'                               |_| \\
# -     ////|  \ Y /| |                                         [ ]  \\
#   |   |||||`-|\^/|| |                                         F-J   `\
#       |||||`-| " [] /                                        J.-'L
#     _ \\\\/`-|   []|\                                        ]`-.[
# ) |`---``| _ |__([]| \                                       |.-'|
#  /       |/ `|   FJ|\ \                                      [`-.]
# /        `|  |   FJ) \ \                                     F.-'J
#/          |  |   FJ|  \ )                                   J`-._ L
#|          |  F  J  L  ||                                    ]    >[
#`.         )-(> '----` ||                                    | .-' |
#`.\        | |    |||  ||                                    [<    ]
#| \\       |-|    ||| / |                                    F `-. J
# \ )\    *_)/`-.__|| \\ |                                   J     ` L
#--'--'\"""""\`------''--'\`'""""""""""""""""""""""""""""""""""""""""""""""
#"
WORKDIR="$(cd /home/${USER}/git/perso-git/english && pwd)"
Langue1="$(echo Spanish)"
cd ${WORKDIR}/${Langue1}
mainCategorie
rappel_menu_principal;;

4) echo "Dutch/French: "
echo "

                                                  _             _
                                                 | |           | |
                                                 |###############|
                      |=|                        |###############|
         _           /   \                 0     |###############|
        | |         /     \               / \   ===================
       /   \       / [][]  \            _/___\_ \_/\_/\_/\_/\_/\__/
      /     \     /  [][]   \           )     (  |               |
     /       \   /           \ ###### .'       '.|[][] [][] [][] |
    /   [][]  \ | [][]  [][]  |######| [][] [][] |[][] [][] [][] |
   /    [][]   \| [][]  [][]  |######| [][] [][] |[][] [][] [][] |
  /     [][]    | [][]  [][]  |######| [][] [][] |               |
 |       __     |    __       |      |           |     _____     |
 | [][] |==| [] | []| -| [][] |[] [] | [] [] |XXX|[][] [] [] [][]|
 | [][] | -| [] | []|__| [][] |[] [] | [] [] [][]|[][] [] [] [][]|
 | [][] |__| [] | | | -| [][] |      |       |  ||     |X|X|     |
_|______|__|____|_|_|__=______|_==__-|_______|__||_____|___|_____|

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/^PB_/_/_/_/

"
WORKDIR="$(cd /home/${USER}/git/perso-git/english && pwd)"
Langue1="$(echo Dutch)"
cd ${WORKDIR}/${Langue1}
mainCategorie
rappel_menu_principal;;

5|q|Q) exit;;
esac
done

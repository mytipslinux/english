#!/bin/bash
#set -x
#set -e
IFS=$'\n\t'
clear
# VARIABLE
# ======================================
#WORKDIR="$( cd -P -- "$(dirname "$(~/git/perso-git/english "$0")" )" && pwd )"
WORKDIR="$( cd ~/git/perso-git/english && pwd )"
cd "${WORKDIR}"
#compteur
succes=""
total=""
moyenne=""
i=""
j=""
trad=""
# FONCTION
function blank_var
{
succes=""
total=""
moyenne=""
i=""
}

function rappel_menu
{
echo "Un autre Quizz ?
Choix 1: -Anglais/Francais
Choix 2: -Francais/Anglais
choix 3: -Relancer le dernier Quizz
Choix 4: -Quizz Aléatoire
Choix 5: -Voir votre historique
Choix 6: -Quitter (q|Q)"
}

function rappel_menu_random
{
echo "Un autre Quizz Random ?
Choix 1: -Anglais/francais
Choix 2: -Francais/Anglais
choix 3: -Relancer la même plage aléatoire
choix 4: -Quitter (q|Q)"
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

function QuizzEng
{
for ligne in ${quizz}; do
	echo "Passons au mot suivant:"
        echo -e "\033[33m===================================================================================="
        echo -e "\t\t\t\tMot à traduire:"
        export mot1=$(echo ${ligne} |cut -d "#" -f1)
        echo -e "=====>      ${mot1}"
        echo "===================================================================================="

        echo -e "\033[37m\n "
        while [ -z ${trad} ]; do
		read -p "Quelle est la traduction: " trad
	done
        echo -e "\033[32m===================================================================================="
        echo -e "\t\t\t\tLa bonne traduction:"
        export mot2=$(echo ${ligne} |cut -d "#" -f2 |cut -d "@" -f1)
	check_response
	trad=""
score > result1.txt
done
affichage_score |tail -n 9
}

function QuizzFr
{
for ligne in ${quizz}; do
	echo "Passons au mot suivant:"
        echo -e "\033[33m================================================================================================================="
        echo -e "\t\t\t\tMot à traduire:"
        export mot1=$(echo ${ligne} |cut -d "#" -f2 |cut -d "@" -f1)
        echo -e "=====>      ${mot1}"
        echo "================================================================================================================="

        echo -e "\033[37m\n "
        while [ -z ${trad} ]; do
        	read -p "Quelle est la traduction: " trad
        done
        echo -e "\033[32m================================================================================================================="
        echo -e "\t\t\t\tLa bonne traduction:"
        export mot2=$(echo ${ligne} |cut -d "#" -f1 |cut -d "@" -f1)
        check_response
	trad=""
score > result1.txt
done
affichage_score |tail -n 9
}

function RandomQuizzEng
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

function RandomQuizzFr
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
                        read -p "> " trad
                done
                export mot2=$(echo ${lignerandom} |cut -d "#" -f1 |cut -d "@" -f1)
        	check_response
	score > result1.txt
	done
	((b=b-1))
        trad=""
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
export debut=$(cat result1.txt |awk  NR==4 |cut -d ":" -f2 | cut -d" " -f2)
export fin=$(cat result1.txt |awk  NR==4 |cut -d ":" -f3 | cut -d" " -f2)
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
                then echo -e "\033[32mGOOD: ${mot2} "
                succes=$((succes+1))
                total=$((total+1))
		echo -e "\033[32m===================================================================================="
        else echo -e "\033[31mFAILED: ${mot2}"
#	echo -e "\033[31mAjouté à votre liste d'erreur"
#	echo "$ligne" >> onlyerr2
        echo -e "\033[31m===================================================================================="
                total=$((total+1)) ;
        fi
moyenne=$((succes*20/total))
}

function score
{
date=$(date "+%d-%m-%Y   %Hh%M")
echo -e "\t\t\t\t\t\t\t\033[37m\nDate: ${date}
\t\t\t\t\t\t\tQuizz: ${j}) ${i}: ${fichier} Entre la ligne: ${debut} et la ligne: ${fin}:
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
PS3="> selectionnez une action : "
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

select choix in "Quizz in English" "Quizz in French" "Relancer le dernier Quizz" "Quizz aléatoire" "Voir votre historique" "Quitter (q|Q)"; do
case ${REPLY} in

1) echo "Quizz in English:"
j=$((j+1))
choix
interval
QuizzEng
blank_var
j=""
rappel_menu;;

2) echo "Quizz in French:"
j=$((h+2))
choix
interval
QuizzFr
blank_var
j=""
rappel_menu;;

3) param
if [[ "${j}" == 1 ]]
	then QuizzEng
	else QuizzFr;
fi
blank_var
rappel_menu;;

4) echo "Quizz Aléatoire:"
select choix in "Aléatoire Anglais/Francais" "Aléatoire Francais/Anglais" "Relancer la même plage aléatoire" "Quitter (q|Q)"; do
case ${REPLY} in

	1) echo "Aléatoire Anglais/Francais:"
	j=""
	j=$((j+1))
	choix
	interval
	RandomQuizzEng
	blank_var
	j=""
	rappel_menu_random;;

	2) echo "Aléatoire Francais/Anglais:"
	j=""
	h=""	
	j=$((h+2))
	choix
	interval
	RandomQuizzFr
	blank_var
	j=""
	h=""
	rappel_menu_random;;

	3) echo "Relancer la même plage aléatoire:"
	param
	if [[ "${j}" == 1 ]]
	        then RandomQuizzEng
        	else RandomQuizzFr;
	fi
	blank_var
        rappel_menu_random;;
	4|q|Q) exit;;
esac
done
rappel_menu;;

5) echo "Historique des résultats"
cat result.txt
rappel_menu;;

6|q|Q) exit;;
esac
done

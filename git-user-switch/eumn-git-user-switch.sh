#!/bin/bash

echo "---------- Git user switch ------------"
function gitcheck () {
  gitcurrentuser="$(git config --global user.name)"
  gitcurrentemail="$(git config --global user.email)"
}

gitcheck

if [ ${gitcurrentuser} == "work-account" ]; then
   echo " - switching to personal account.."
   git config --global user.name personal-account
   git config --global user.email personal-account@mail.com
else
   echo " - switching to work account.."
   git config --global user.name work-account
   git config --global user.email work-account@mail.com
fi

gitcheck

echo -e "\n -- Curent User  = ${gitcurrentuser}"
echo -e " -- Current Email = ${gitcurrentemail} \n"

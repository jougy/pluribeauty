#!/bin/bash

clear

function pause(){
    read -p "Pressione ENTER para continuar..."
}

function init_repo(){
    echo "Inicializando repositório..."
    git init
    pause
}

function status_repo(){
    git status
    pause
}

function commit_simples(){
    read -p "Mensagem do commit: " msg
    git commit -m "$msg"
    pause
}

function commit_completo(){
    read -p "Mensagem do commit: " msg
    git add .
    git commit -m "$msg"
    pause
}

function push_repo(){
    read -p "Branch para enviar (ex: main): " branch
    git push origin $branch
    pause
}

function pull_repo(){
    read -p "Branch para receber (ex: main): " branch
    git pull origin $branch
    pause
}

function clone_repo(){
    read -p "URL do repositório: " url
    git clone $url
    pause
}

function switch_branch(){
    read -p "Nome da nova branch: " branch
    git switch -c $branch
    pause
}

function listar_branch(){
    git branch -a
    pause
}

function adicionar_remote(){
    read -p "URL do repositório remoto: " url
    git remote add origin $url
    pause
}

function ver_log(){
    git log --oneline --graph --all
    pause
}

while true
do
clear
echo "===================================="
echo "        GIT HELPER TERMINAL         "
echo "===================================="
echo
echo "1  - Inicializar repositório"
echo "2  - Status"
echo "3  - Commit simples"
echo "4  - Commit completo (add . + commit)"
echo "5  - Push"
echo "6  - Pull"
echo "7  - Clonar repositório"
echo "8  - Criar/Switch branch"
echo "9  - Listar branches"
echo "10 - Adicionar remote origin"
echo "11 - Ver log"
echo
echo "0  - Sair"
echo
read -p "Escolha uma opção: " opcao

case $opcao in

1) init_repo ;;
2) status_repo ;;
3) commit_simples ;;
4) commit_completo ;;
5) push_repo ;;
6) pull_repo ;;
7) clone_repo ;;
8) switch_branch ;;
9) listar_branch ;;
10) adicionar_remote ;;
11) ver_log ;;
0) exit ;;

*) echo "Opção inválida"; pause ;;

esac

done

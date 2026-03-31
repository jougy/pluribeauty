#!/bin/bash

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funcao para checar status
check_status() {
    echo -e "\n${BLUE}=== Status dos Servicos ===${NC}"
    
    # Checar Supabase (verifica se existe container do supabase e se esta rodando)
    if docker ps --format '{{.Names}}' | grep -q 'supabase_'; then
        echo -e "Supabase: ${GREEN}Ativo${NC} (Studio: http://127.0.0.1:54321, API: http://127.0.0.1:54321)"
    else
        echo -e "Supabase: ${RED}Inativo${NC}"
    fi

    # Checar Astro (usando netstat ou lsof para achar porta 4321 do astro)
    if lsof -Pi :4321 -sTCP:LISTEN -t >/dev/null 2>&1 || curl -s -m 1 http://localhost:4321 > /dev/null 2>&1; then
        echo -e "Astro (Frontend): ${GREEN}Ativo${NC} (http://localhost:4321)"
    else
        echo -e "Astro (Frontend): ${RED}Inativo${NC}"
    fi
    echo -e "${BLUE}===========================${NC}\n"
}

# Menu
show_menu() {
    clear
    check_status
    echo "Escolha uma opcao:"
    echo -e "${GREEN}--- Astro (Frontend) ---${NC}"
    echo " 1) Iniciar Astro (dev, roda em background)"
    echo " 2) Parar Astro (mata processos na porta 4321)"
    echo " 3) Instalar/Atualizar Dependencias (npm install)"
    echo " 4) Build Astro"
    echo -e "${YELLOW}--- Supabase ---${NC}"
    echo " 5) Iniciar Supabase"
    echo " 6) Parar Supabase"
    echo " 7) Reiniciar Supabase"
    echo " 8) Resetar Supabase (Zerar Banco/Migrations)"
    echo " 9) Supabase Status (Detalhado)"
    echo -e "${BLUE}--- Docker Controles ---${NC}"
    echo "10) Listar Containers (docker ps)"
    echo "11) Listar Compose (docker compose ps)"
    echo "12) Parar TODOS (docker stop)"
    echo "13) Pausar TODOS (docker pause)"
    echo "14) Despausar TODOS (docker unpause)"
    echo "15) Reiniciar TODOS (docker restart)"
    echo "--- Geral ---"
    echo " 0) Sair"
    echo ""
}

# Loop principal
while true; do
    show_menu
    read -p "Opcao: " opt
    echo ""
    case $opt in
        1)
            echo -e "${YELLOW}Iniciando Astro em background...${NC}"
            npm run dev > astro_out.log 2>&1 &
            echo -e "${GREEN}Astro iniciado! (Logs em astro_out.log)${NC}"
            sleep 2
            ;;
        2)
            echo -e "${YELLOW}Parando Astro (verificando porta 4321)...${NC}"
            ASTRO_PID=$(lsof -t -i:4321)
            if [ -n "$ASTRO_PID" ]; then
                kill -9 $ASTRO_PID
                echo -e "${GREEN}Acesso liberado, processos do Astro encerrados.${NC}"
            else
                echo -e "${RED}Astro nao parece estar rodando na porta 4321.${NC}"
            fi
            sleep 2
            ;;
        3)
            echo -e "${YELLOW}Instalando/Atualizando dependencias...${NC}"
            npm install
            ;;
        4)
            echo -e "${YELLOW}Gerando build do Astro...${NC}"
            npm run build
            ;;
        5)
            echo -e "${YELLOW}Iniciando Supabase...${NC}"
            npx supabase start
            ;;
        6)
            echo -e "${YELLOW}Parando Supabase...${NC}"
            npx supabase stop
            ;;
        7)
            echo -e "${YELLOW}Reiniciando Supabase...${NC}"
            npx supabase stop && npx supabase start
            ;;
        8)
            echo -e "${RED}CERTEZA QUE DESEJA RESETAR O BANCO? TODOS OS DADOS LOCAIS SERAO PERDIDOS! (y/N)${NC}"
            read -p "Confirmar: " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                echo -e "${YELLOW}Resetando Supabase (Zerar Banco Local)...${NC}"
                npx supabase db reset
            else
                echo "Operacao cancelada."
            fi
            ;;
        9)
            npx supabase status
            ;;
        10)
            echo -e "${BLUE}Containers ativos (docker ps):${NC}"
            docker ps
            ;;
        11)
            echo -e "${BLUE}Containers do Compose (docker compose ps):${NC}"
            docker compose ps
            ;;
        12)
            echo -e "${RED}Parando TODOS os conteineres...${NC}"
            if [ "$(docker ps -q)" ]; then
                docker stop $(docker ps -q)
                echo -e "${GREEN}Todos conteineres foram parados.${NC}"
            else
                echo "Nenhum container rodando no momento."
            fi
            ;;
        13)
            echo -e "${YELLOW}Pausando TODOS os conteineres...${NC}"
            if [ "$(docker ps -q)" ]; then
                docker pause $(docker ps -q)
                echo -e "${GREEN}Todos conteineres pausados.${NC}"
            else
                echo "Nenhum container rodando para pausar."
            fi
            ;;
        14)
            echo -e "${YELLOW}Despausando TODOS os conteineres...${NC}"
            if [ "$(docker ps -q -f status=paused)" ]; then
                docker unpause $(docker ps -q -f status=paused)
                echo -e "${GREEN}Todos conteineres despausados.${NC}"
            else
                echo "Nenhum container pausado."
            fi
            ;;
        15)
            echo -e "${YELLOW}Reiniciando TODOS os conteineres...${NC}"
            if [ "$(docker ps -aq)" ]; then
                docker restart $(docker ps -aq)
                echo -e "${GREEN}Todos conteineres reiniciados.${NC}"
            else
                echo "Nenhum container encontrado para reiniciar."
            fi
            ;;
        0)
            echo "Saindo do controle..."
            exit 0
            ;;
        *)
            echo -e "${RED}Opcao invalida!${NC}"
            ;;
    esac
    echo ""
    read -p "Pressione [Enter] para continuar..."
done

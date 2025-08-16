#!/bin/bash

# Script para mostrar resultados de segurança de forma limpa
# Uso: ./scripts/show-security-results.sh [all|snyk|gitleaks|semgrep|bandit]

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Função para mostrar header
show_header() {
    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN}🔒 RELATÓRIO DE SEGURANÇA${NC}"
    echo -e "${CYAN}================================${NC}"
    echo ""
}

# Função para mostrar resultados do Snyk
show_snyk_results() {
    echo -e "${BLUE}🛡️  SNYK SECURITY SCAN${NC}"
    echo -e "${BLUE}─────────────────────────${NC}"

    if [[ -f "logs/snyk.log" ]]; then
        # Extrai apenas as vulnerabilidades encontradas
        if grep -q "found [0-9]* issues" logs/snyk.log; then
            echo -e "${RED}❌ VULNERABILIDADES ENCONTRADAS:${NC}"
            echo ""

            # Mostra o resumo
            grep "found [0-9]* issues" logs/snyk.log | sed 's/^/   /'
            echo ""

            # Mostra as vulnerabilidades críticas/altas
            grep -A 10 "Issues to fix by upgrading:" logs/snyk.log | head -20 | sed 's/^/   /'
            echo ""
            echo -e "${YELLOW}💡 Para detalhes completos: cat logs/snyk.log${NC}"
        else
            echo -e "${GREEN}✅ Nenhuma vulnerabilidade crítica encontrada${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Log não encontrado: logs/snyk.log${NC}"
    fi
    echo ""
}

# Função para mostrar resultados do GitLeaks
show_gitleaks_results() {
    echo -e "${PURPLE}🕵️  GITLEAKS SECRETS SCANNER${NC}"
    echo -e "${PURPLE}──────────────────────────────${NC}"

    if [[ -f "logs/gitleaks.log" ]]; then
        if grep -q "leaks found:" logs/gitleaks.log; then
            echo -e "${RED}❌ SEGREDOS ENCONTRADOS:${NC}"
            echo ""

            # Mostra quantos leaks foram encontrados
            grep "leaks found:" logs/gitleaks.log | sed 's/^/   /'
            echo ""
            echo -e "${YELLOW}💡 Para detalhes completos: cat logs/gitleaks.log${NC}"
        else
            echo -e "${GREEN}✅ Nenhum segredo detectado${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Log não encontrado: logs/gitleaks.log${NC}"
    fi
    echo ""
}

# Função para mostrar resultados do Semgrep
show_semgrep_results() {
    echo -e "${CYAN}🔎 SEMGREP SAST SCANNER${NC}"
    echo -e "${CYAN}─────────────────────────${NC}"

    if [[ -f "logs/semgrep.log" ]]; then
        # Verifica se há vulnerabilidades no JSON (procura por "results":[{)
        if grep -q '"results":\[{' logs/semgrep.log; then
            echo -e "${RED}❌ VULNERABILIDADES ENCONTRADAS:${NC}"
            echo ""

            # Tenta extrair número de findings se disponível
            if command -v jq >/dev/null 2>&1; then
                # Extrai apenas o JSON da saída (procura pela linha que começa com {)
                JSON_PART=$(grep -A 10000 '^{' logs/semgrep.log | head -n 1)
                if [[ -n "$JSON_PART" ]]; then
                    FINDINGS=$(echo "$JSON_PART" | jq '.results | length' 2>/dev/null || echo "N/A")
                    ERROR_COUNT=$(echo "$JSON_PART" | jq '[.results[] | select(.extra.severity == "ERROR")] | length' 2>/dev/null || echo "0")
                    WARNING_COUNT=$(echo "$JSON_PART" | jq '[.results[] | select(.extra.severity == "WARNING")] | length' 2>/dev/null || echo "0")

                    echo -e "   📊 Total de vulnerabilidades: ${FINDINGS}"
                    echo -e "   🔴 Erros:      ${ERROR_COUNT}"
                    echo -e "   🟡 Avisos:     ${WARNING_COUNT}"
                else
                    echo -e "   📊 Vulnerabilidades detectadas no scan"
                fi
            else
                echo -e "   📊 Vulnerabilidades detectadas (instale 'jq' para detalhes)"
            fi

            echo ""
            echo -e "${YELLOW}💡 Para detalhes completos: cat logs/semgrep.log${NC}"
        else
            echo -e "${GREEN}✅ Nenhuma vulnerabilidade crítica encontrada${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Log não encontrado: logs/semgrep.log${NC}"
    fi
    echo ""
}

# Função para mostrar resultados do Bandit
show_bandit_results() {
    echo -e "${YELLOW}🐍 BANDIT PYTHON SCANNER${NC}"
    echo -e "${YELLOW}──────────────────────────${NC}"

    if [[ -f "logs/bandit.log" ]]; then
        # Extrai métricas do JSON se disponível
        if command -v jq >/dev/null 2>&1 && grep -q '"results": \[' logs/bandit.log; then
            # Extrai apenas a parte JSON (a partir da linha que contém {)
            LINE_NUM=$(grep -n '^{' logs/bandit.log | cut -d: -f1)
            if [[ -n "$LINE_NUM" ]]; then
                HIGH=$(tail -n +$LINE_NUM logs/bandit.log | jq '.metrics._totals["SEVERITY.HIGH"]' 2>/dev/null || echo "0")
                MEDIUM=$(tail -n +$LINE_NUM logs/bandit.log | jq '.metrics._totals["SEVERITY.MEDIUM"]' 2>/dev/null || echo "0")
                LOW=$(tail -n +$LINE_NUM logs/bandit.log | jq '.metrics._totals["SEVERITY.LOW"]' 2>/dev/null || echo "0")
                TOTAL_RESULTS=$(tail -n +$LINE_NUM logs/bandit.log | jq '.results | length' 2>/dev/null || echo "0")

                if [[ "$TOTAL_RESULTS" -gt 0 ]]; then
                    echo -e "${RED}❌ VULNERABILIDADES PYTHON ENCONTRADAS:${NC}"
                    echo ""
                    echo -e "   � Total:      ${TOTAL_RESULTS}"
                    echo -e "   � Alta:       ${HIGH}"
                    echo -e "   � Média:      ${MEDIUM}"
                    echo -e "   � Baixa:      ${LOW}"
                    echo ""
                    echo -e "${YELLOW}💡 Para detalhes completos: cat logs/bandit.log${NC}"
                else
                    echo -e "${GREEN}✅ Código Python sem vulnerabilidades críticas${NC}"
                fi
            else
                echo -e "${RED}❌ VULNERABILIDADES PYTHON ENCONTRADAS${NC}"
                echo -e "${YELLOW}💡 Para detalhes: cat logs/bandit.log${NC}"
            fi
        else
            # Fallback se jq não estiver disponível
            if grep -q '"results":' logs/bandit.log; then
                echo -e "${RED}❌ VULNERABILIDADES PYTHON ENCONTRADAS${NC}"
                echo -e "${YELLOW}💡 Para detalhes: cat logs/bandit.log${NC}"
            else
                echo -e "${GREEN}✅ Código Python sem vulnerabilidades críticas${NC}"
            fi
        fi
    else
        echo -e "${YELLOW}⚠️  Log não encontrado: logs/bandit.log${NC}"
    fi
    echo ""
}

# Função para mostrar todos os resultados
show_all_results() {
    show_header
    show_snyk_results
    show_gitleaks_results
    show_semgrep_results
    show_bandit_results

    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN}📁 LOGS COMPLETOS EM: ./logs/${NC}"
    echo -e "${CYAN}================================${NC}"
}

# Função para mostrar ajuda
show_help() {
    echo "Uso: $0 [OPÇÃO]"
    echo ""
    echo "Opções:"
    echo "  all        Mostra todos os resultados (padrão)"
    echo "  snyk       Mostra apenas resultados do Snyk"
    echo "  gitleaks   Mostra apenas resultados do GitLeaks"
    echo "  semgrep    Mostra apenas resultados do Semgrep"
    echo "  bandit     Mostra apenas resultados do Bandit"
    echo "  help       Mostra esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0                    # Mostra todos os resultados"
    echo "  $0 all               # Mostra todos os resultados"
    echo "  $0 snyk              # Mostra apenas Snyk"
    echo "  $0 bandit            # Mostra apenas Bandit"
}

# Main
case "${1:-all}" in
    "all")
        show_all_results
        ;;
    "snyk")
        show_header
        show_snyk_results
        ;;
    "gitleaks")
        show_header
        show_gitleaks_results
        ;;
    "semgrep")
        show_header
        show_semgrep_results
        ;;
    "bandit")
        show_header
        show_bandit_results
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo -e "${RED}Opção inválida: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac

# 🛡️ Pre-commit Security Demo

Este repositório demonstra como implementar **hooks de segurança automatizados** usando o pre-commit framework, com exemplos de código **intencionalmente vulnerável** para fins didáticos e testes de ferramentas de segurança.

## 🎯 Objetivo

Demonstrar a implementação de um pipeline de segurança automatizado que executa múltiplas ferramentas de análise antes de cada commit:

- **Snyk** - Análise de vulnerabilidades em dependências
- **GitLeaks** - Detecção de segredos hardcoded (senhas, tokens, chaves)
- **Semgrep** - SAST (Static Application Security Testing)
- **Bandit** - Scanner de segurança específico para código Python

## 🚨 ⚠️ AVISO IMPORTANTE ⚠️

**Este repositório contém código intencionalmente vulnerável para fins educacionais e de demonstração.**

- **NÃO use este código em produção**
- **NÃO exponha este repositório em ambientes públicos sem proteção**
- Os exemplos incluem vulnerabilidades reais como: SQL Injection, XSS, hardcoded secrets, etc.

## 📁 Estrutura do Projeto

```
precommit-demo/
├── .pre-commit-config.yaml      # Configuração dos hooks de segurança
├── vulnerable-code.js           # Exemplos vulneráveis em JavaScript
├── vulnerable-code.py           # Exemplos vulneráveis em Python
├── test-secrets.js             # Arquivo com segredos hardcoded
├── package.json                # Dependências com vulnerabilidades conhecidas
├── scripts/
│   ├── show-security-results.sh    # Script detalhado de análise
│   └── security-summary.sh         # Resumo executivo das vulnerabilidades
└── logs/                       # Logs detalhados das ferramentas
    ├── snyk.log
    ├── gitleaks.log
    ├── semgrep.log
    └── bandit.log
```

## ⚙️ Configuração e Instalação

### Pré-requisitos

- Python 3.8+
- Node.js 14+
- Docker
- Git
- Snyk CLI

### Instalação

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/gabrielvieira1/precommit-demo.git
   cd precommit-demo
   ```

2. **Instale as dependências:**
   ```bash
   npm install
   pip install pre-commit
   ```

3. **Configure o Snyk (opcional - para análise completa):**
   ```bash
   npm install -g snyk
   snyk auth  # Requer conta no snyk.io
   ```

4. **Instale os hooks do pre-commit:**
   ```bash
   pre-commit install
   ```

## 🚀 Como Usar

### Modo Normal (com hooks ativos)
```bash
# Os hooks rodam automaticamente a cada commit
git add .
git commit -m "Sua mensagem"
```

### Modo Demo (executar manualmente)
```bash
# Executar todos os hooks sem fazer commit
pre-commit run --all-files

# Executar hook específico
pre-commit run snyk-security-scan
pre-commit run gitleaks-local
pre-commit run semgrep-sast
pre-commit run bandit-python-sast
```

### Scripts de Análise

```bash
# Relatório detalhado com todas as vulnerabilidades
./scripts/show-security-results.sh

# Resumo executivo com contadores
./scripts/security-summary.sh
```

## 📊 Saída dos Hooks

### Durante o Commit (Modo Limpo)
```
🛡️  Executando Snyk Security Scan...
📋 Resultados salvos em logs/snyk.log
❌ Vulnerabilidades encontradas!

🕵️  Executando GitLeaks via Docker...
📋 Resultados salvos em logs/gitleaks.log
❌ Segredos detectados!

🔎 Executando Semgrep SAST via Docker...
📋 Resultados salvos em logs/semgrep.log
❌ Problemas de segurança encontrados!

🐍 Executando Bandit Python SAST...
📋 Resultados salvos em logs/bandit.log
❌ Vulnerabilidades Python encontradas!
```

### Análise Detalhada (Script)
```bash
./scripts/show-security-results.sh
```

Exemplo de saída:
```
🛡️  SNYK DEPENDENCY SCANNER
──────────────────────────────
❌ VULNERABILIDADES ENCONTRADAS:
   📊 5 vulnerabilidades detectadas
   🔥 2 vulnerabilidades HIGH
   ⚠️  3 vulnerabilidades MEDIUM

🕵️  GITLEAKS SECRETS SCANNER
──────────────────────────────
❌ SEGREDOS ENCONTRADOS:
   📊 Total de segredos detectados: 8
   🔍 Tipos encontrados:
   • generic-api-key: 3 ocorrência(s)
   • aws-access-token: 2 ocorrência(s)
   • github-pat: 1 ocorrência(s)
```

## 🔧 Configurações Personalizadas

### Desabilitar hooks temporariamente
```bash
# Para um commit específico
git commit -m "Mensagem" --no-verify

# Desinstalar hooks
pre-commit uninstall

# Reinstalar hooks
pre-commit install
```

### Configurar limiar de severidade
Edite `.pre-commit-config.yaml` para ajustar os parâmetros:
```yaml
entry: bash -c "snyk test --severity-threshold=critical"  # Only critical
entry: bash -c "snyk test --severity-threshold=high"     # High and critical
```

## 🎓 Vulnerabilidades Incluídas (Para Estudo)

### JavaScript (`vulnerable-code.js`)
- SQL Injection
- Cross-Site Scripting (XSS)
- Path Traversal
- Command Injection
- Insecure Direct Object Reference

### Python (`vulnerable-code.py`)
- SQL Injection
- OS Command Injection
- Path Traversal
- Deserialization Vulnerabilities
- Hardcoded Secrets

### Dependências (`package.json`)
- Packages com vulnerabilidades conhecidas
- Versões desatualizadas intencionalmente

### Segredos (`test-secrets.js`)
- API Keys hardcoded
- Tokens de acesso
- Senhas em código
- Chaves criptográficas

## 📈 Estatísticas Atuais (Exemplo)

| Ferramenta | Vulnerabilidades | Severidade Alta | Status |
|------------|------------------|-----------------|--------|
| Snyk       | 5               | 2               | ❌ Fail |
| GitLeaks   | 8               | -               | ❌ Fail |
| Semgrep    | 14              | 6               | ❌ Fail |
| Bandit     | 15              | 8               | ❌ Fail |
| **Total**  | **42**          | **16**          | **❌ Fail** |

## 🛠️ Ferramentas Utilizadas

- **[pre-commit](https://pre-commit.com/)** - Framework de hooks Git
- **[Snyk](https://snyk.io/)** - Scanner de vulnerabilidades em dependências
- **[GitLeaks](https://github.com/zricethezav/gitleaks)** - Detector de segredos
- **[Semgrep](https://semgrep.dev/)** - Static Analysis Security Testing
- **[Bandit](https://bandit.readthedocs.io/)** - Security linter para Python
- **[Docker](https://docker.com/)** - Containerização das ferramentas

## 🤝 Contribuindo

Este é um projeto educacional. Contribuições são bem-vindas:

1. Fork o projeto
2. Crie sua branch feature (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## ⚠️ Disclaimer

Este repositório é destinado **exclusivamente para fins educacionais e de demonstração**. O código vulnerável incluído não deve ser usado em ambientes de produção. Os autores não se responsabilizam por qualquer uso inadequado deste material.
---
title: "Google Mantis: Inaugurando uma Era de Diagnóstico e Remediação de Segurança Automática Alimentada por IA"
date: "2026-09-07"
author: "Equipe Editorial do AI Learning Log"
category: "Descoberta de Matt"
edition: "Descoberta de Matt #04"
summary: "Mantis do Google foi projetado para reduzir falsos positivos em ferramentas de varredura de segurança. Usando uma estrutura de verificação em múltiplas camadas com agentes de IA, visa melhorar a baixa taxa de verdadeiros positivos das ferramentas existentes. A tecnologia pode ser aproveitada para melhorar a eficiência de verificação dos times de DevSecOps."
description: "Mantis de código aberto do Google: descoberta, validação e remediação de vulnerabilidades com agentes de IA—estabelecendo um novo padrão para automação de segurança"
sources:
  - name: "Google Cloud Blog - Mantis Harness"
    url: "https://cloud.google.com/blog/products/identity-security/getting-started-with-the-mantis-harness-to-find-and-fix-bugs/"
  - name: "GitHub - Google Mantis"
    url: "https://github.com/google/mantis"
tags: ["Google", "Mantis", "Security", "AI Agents", "DevSecOps", "Open Source", "Vulnerability Detection"]
featured: true
keyFacts:
  - label: "Problema de Precisão do Scanner Existente"
    value: "Taxa de Verdadeiros Positivos Abaixo de 7%"
    detail: "Entre os alertas gerados por scanners de segurança gerais, menos de 7% representam vulnerabilidades reais. 93% são falsos positivos."
  - label: "Abordagem de Design do Mantis"
    value: "Estrutura de Verificação em Múltiplas Camadas com Agentes de IA"
    detail: "Múltiplos agentes executam sequencialmente etapas de verificação, com o objetivo de reduzir falsos positivos."
  - label: "Aplicação Potencial"
    value: "Melhoria da Eficiência de Verificação de Segurança"
    detail: "Ao filtrar falsos positivos, essa tecnologia pode reduzir o tempo de verificação do time de DevSecOps."
---

## Problema Fundamental dos Times de Segurança: A Batalha Entre Sinal e Ruído

Se seu time cuida da segurança, você experimenta um pesadelo diariamente:

**Centenas de alertas de vulnerabilidade chegam. Mas a maioria é falsa.**

De acordo com pesquisa lançada pelo Google, ferramentas de varredura de segurança existentes têm uma taxa de verdadeiros positivos de **menos de 7%**. Em outras palavras, seu time repete o seguinte ciclo diariamente:

1. Uma ferramenta de varredura automatizada relata 500 vulnerabilidades
2. Desenvolvedores verificam manualmente cada uma
3. A maioria é considerada "não é realmente um problema"
4. Aproximadamente 35 acabam sendo problemas de segurança reais

**Este processo é enormemente custoso.** O tempo do time é desperdiçado, e riscos genuínos são enterrados no ruído.

Mantis do Google visa abordar este problema através de design baseado em IA.

---

## Inovação do Mantis: "IA Filtra Afirmações Falsas"

O núcleo do Mantis é simples porém poderoso:

**Quando um agente identifica uma vulnerabilidade, outros agentes a verificam.**

### Estrutura de Verificação em Múltiplas Camadas

Mantis é projetado como uma estrutura onde múltiplos agentes de IA realizam verificação em cada estágio. Ao fazer com que os achados de um agente sejam verificados por outro agente, visa reduzir falsos positivos.

Porque cada agente passa por estágios sequenciais de verificação, **vulnerabilidades significativas têm maior probabilidade de serem relatadas ao time**.

---

## Cenários Hipotéticos: Potencial de Uso do Mantis

### Cenário 1: Automação de Segurança para Startups

**Situação:** Time de desenvolvimento sem pessoal de segurança dedicado

Ferramentas existentes geram muitos falsos positivos, consumindo tempo de verificação do time. Através da filtragem baseada em IA do Mantis, times podem se focar em vulnerabilidades significativas.

### Cenário 2: Projetos de Migração em Larga Escala

**Situação:** Migração de sistemas legados para frameworks modernos

Ao reduzir a carga de revisão manual de código e validar automaticamente problemas de segurança que poderiam passar despercebidos, projetos de migração podem proceder de forma mais segura.

### Cenário 3: Manutenção de Projetos de Código Aberto

**Situação:** Necessidade de verificar manualmente a segurança com cada PR

Quando Mantis automatiza a verificação inicial do código enviado por contribuidores, mantenedores podem se focar na tomada de decisão real.

---

## Limitações Realistas e Expectativas: Por Que Mantis Não é "Perfeito"

Mesmo que Mantis seja inovador, não resolve todos os problemas.

### Limitações Atuais

1. **Não pode encontrar vulnerabilidades zero-day**
   - Mantis é treinado em "padrões conhecidos"
   - Técnicas de ataque completamente novas não podem ser detectadas

2. **Fraco em vulnerabilidades de lógica comercial**
   - Determinar "este controle de acesso é realmente correto?" é difícil
   - Problemas de etapa de design não podem ser descobertos

3. **Eliminação completa de falsos positivos é limitada**
   - IA pode cometer erros; nem todos os falsos positivos podem ser filtrados perfeitamente
   - A possibilidade de falsos positivos remanescentes deve ser considerada

---

## Conclusão: Por Que Esta Tecnologia é Importante

Mantis não é "apenas outra ferramenta de segurança."

**Esta é uma mudança de paradigma.**

Automação de segurança convencional:
```
Descoberta (Automatizada) → Verificação (Manual) → Remediação (Manual)
                         ↑ A maioria do tempo é consumida aqui
```

Automação de segurança baseada em IA (Mantis):
```
Descoberta (Automatizada) → Verificação (Automatizada) → Remediação (Automatizada)
                                            → Time toma decisões de prioridade
```

### Quem Deveria Usar Agora?

✅ **Fortemente Recomendado:**
- Startups sem times de segurança
- Empresas realizando projetos de migração
- Mantenedores de código aberto

⚠️ **Adotar com Cautela:**
- Indústrias altamente reguladas (finanças, saúde)
- Aqueles esperando automação perfeita

### Próximos Passos

1. **Comece com projetos pequenos** → Escala de microsserviços de um time
2. **Revise resultados** → "Isso reflete com precisão nosso perfil de risco?"
3. **Integração de CI/CD** → Automação de PR
4. **Mudança cultural** → "Revisão de segurança = colaboração IA + humana"

Mantis do Google é uma ferramenta que "devolve a segurança aos programadores."

Sem um time de segurança dedicado, significa que IA pode automatizar verificação de vulnerabilidades—algo que a humanidade tem feito manualmente—em um **nível confiável**.

Segurança não é mais "responsabilidade do time de segurança"—está se tornando **automação corporativa**.

Esta é a mudança que precisamos ver.

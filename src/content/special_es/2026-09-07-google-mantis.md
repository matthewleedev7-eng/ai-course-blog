---
title: "Google Mantis: Inaugurando una Era de Diagnóstico y Remediación de Seguridad Automática Impulsada por IA"
date: "2026-09-07"
author: "Equipo Editorial de AI Learning Log"
category: "Descubrimiento de Matt"
edition: "Descubrimiento de Matt #04"
summary: "Mantis de Google fue diseñado para reducir falsos positivos en herramientas de escaneo de seguridad. Utilizando una estructura de verificación multicapa con agentes de IA, tiene como objetivo mejorar la baja tasa de verdaderos positivos de las herramientas existentes. La tecnología puede aprovecharse para mejorar la eficiencia de verificación de los equipos de DevSecOps."
description: "Mantis de código abierto de Google: descubrimiento, validación y remediación de vulnerabilidades con agentes de IA—estableciendo un nuevo estándar para la automatización de seguridad"
sources:
  - name: "Google Cloud Blog - Mantis Harness"
    url: "https://cloud.google.com/blog/products/identity-security/getting-started-with-the-mantis-harness-to-find-and-fix-bugs/"
  - name: "GitHub - Google Mantis"
    url: "https://github.com/google/mantis"
tags: ["Google", "Mantis", "Security", "AI Agents", "DevSecOps", "Open Source", "Vulnerability Detection"]
featured: true
keyFacts:
  - label: "Problema de Precisión del Escáner Existente"
    value: "Tasa de Verdaderos Positivos Inferior al 7%"
    detail: "Entre las alertas generadas por escáneres de seguridad generales, menos del 7% representan vulnerabilidades reales. El 93% son falsos positivos."
  - label: "Enfoque de Diseño de Mantis"
    value: "Estructura de Verificación Multicapa con Agentes de IA"
    detail: "Múltiples agentes realizan secuencialmente pasos de verificación, con el objetivo de reducir falsos positivos."
  - label: "Aplicación Potencial"
    value: "Mejora de la Eficiencia de Verificación de Seguridad"
    detail: "Al filtrar falsos positivos, esta tecnología puede reducir el tiempo de verificación del equipo de DevSecOps."
---

## Problema Fundamental de los Equipos de Seguridad: La Batalla Entre Señal y Ruido

Si tu equipo maneja la seguridad, experimentas una pesadilla diaria:

**Llegan cientos de alertas de vulnerabilidad. Pero la mayoría son falsas.**

Según investigaciones publicadas por Google, las herramientas de escaneo de seguridad existentes tienen una tasa de verdaderos positivos de **menos del 7%**. En otras palabras, tu equipo repite el siguiente ciclo diariamente:

1. Una herramienta de escaneo automatizada reporta 500 vulnerabilidades
2. Los desarrolladores verifican manualmente cada una
3. La mayoría se considera "no es realmente un problema"
4. Aproximadamente 35 resultan ser problemas de seguridad reales

**Este proceso es enormemente costoso.** El tiempo del equipo se desperdicia, y los riesgos genuinos se entierran en el ruido.

Mantis de Google tiene como objetivo abordar este problema mediante diseño basado en IA.

---

## Innovación de Mantis: "La IA Filtra Afirmaciones Falsas"

El núcleo de Mantis es simple pero poderoso:

**Cuando un agente identifica una vulnerabilidad, otros agentes la verifican.**

### Estructura de Verificación Multicapa

Mantis está diseñado como una estructura donde múltiples agentes de IA realizan verificación en cada etapa. Al hacer que los hallazgos de un agente sean verificados por otro agente, tiene como objetivo reducir falsos positivos.

Debido a que cada agente pasa por etapas de verificación secuencial, **es más probable que solo las vulnerabilidades significativas se reporten al equipo**.

---

## Escenarios Hipotéticos: Potencial de Uso de Mantis

### Escenario 1: Automatización de Seguridad para Startups

**Situación:** Equipo de desarrollo sin personal de seguridad dedicado

Las herramientas existentes generan muchos falsos positivos, consumiendo tiempo de verificación del equipo. A través del filtrado basado en IA de Mantis, los equipos pueden enfocarse en vulnerabilidades significativas.

### Escenario 2: Proyectos de Migración a Gran Escala

**Situación:** Migración de sistemas heredados a marcos modernos

Al reducir la carga de revisión manual de código y validar automáticamente problemas de seguridad que de otro modo pasarían desapercibidos, los proyectos de migración pueden proceder de manera más segura.

### Escenario 3: Mantenimiento de Proyectos de Código Abierto

**Situación:** Necesidad de verificar manualmente la seguridad con cada PR

Cuando Mantis automatiza la verificación inicial del código enviado por colaboradores, los mantenedores pueden enfocarse en la toma de decisiones real.

---

## Limitaciones Realistas y Expectativas: Por Qué Mantis No es "Perfecto"

Aunque Mantis es innovador, no resuelve todos los problemas.

### Limitaciones Actuales

1. **No puede encontrar vulnerabilidades de día cero**
   - Mantis está entrenado en "patrones conocidos"
   - No se pueden detectar técnicas de ataque completamente nuevas

2. **Débil en vulnerabilidades de lógica empresarial**
   - Determinar "¿es este control de acceso realmente correcto?" es difícil
   - Los problemas de etapa de diseño no pueden ser descubiertos

3. **La eliminación completa de falsos positivos es limitada**
   - La IA puede cometer errores; no todos los falsos positivos pueden filtrarse perfectamente
   - La posibilidad de falsos positivos restantes debe considerarse

---

## Conclusión: Por Qué Esta Tecnología es Importante

Mantis no es "solo otra herramienta de seguridad."

**Este es un cambio de paradigma.**

Automatización de seguridad convencional:
```
Descubrimiento (Automatizado) → Verificación (Manual) → Remediación (Manual)
                              ↑ La mayoría del tiempo se consume aquí
```

Automatización de seguridad basada en IA (Mantis):
```
Descubrimiento (Automatizado) → Verificación (Automatizado) → Remediación (Automatizado)
                                                    → El equipo toma decisiones de prioridad
```

### ¿Quién Debería Usarlo Ahora?

✅ **Fuertemente Recomendado:**
- Startups sin equipos de seguridad
- Empresas que realizan proyectos de migración
- Mantenedores de código abierto

⚠️ **Adoptar con Cautela:**
- Industrias altamente reguladas (finanzas, cuidado de la salud)
- Aquellos que esperan automatización perfecta

### Próximos Pasos

1. **Comienza con proyectos pequeños** → Escala de microservicios de un equipo
2. **Revisa resultados** → "¿Esto refleja con precisión nuestro perfil de riesgo?"
3. **Integración de CI/CD** → Automatización de PR
4. **Cambio cultural** → "Revisión de seguridad = colaboración IA + humana"

Mantis de Google es una herramienta que "devuelve la seguridad a los programadores."

Sin un equipo de seguridad dedicado, significa que la IA puede automatizar la verificación de vulnerabilidades—algo que la humanidad ha hecho manualmente—a un **nivel confiable**.

La seguridad ya no es "responsabilidad del equipo de seguridad"—se está convirtiendo en **automatización empresarial**.

Este es el cambio que necesitamos ver.

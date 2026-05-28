# Repositorio de Documentación Extendida: Laboratorios SOC con Wazuh

Bienvenido a mi repositorio personal de respaldo y base de conocimiento. Aquí almaceno la documentación técnica extendida, notas de Obsidian, capturas de pantalla, resolución de problemas y scripts personalizados desarrollados durante mi entrenamiento y despliegue de un Centro de Operaciones de Seguridad (SOC).

Este repositorio funciona como un archivo detallado de mi trabajo técnico, complementario a los reportes ejecutivos e informes resumidos entregados a la gerencia.

## Contexto del Proyecto

Este material fue desarrollado como parte de las implementaciones y pruebas de concepto para un proyecto interno organizacional.. El objetivo principal de estos laboratorios fue evolucionar la infraestructura de seguridad desde un modelo de monitoreo y detección pasiva, hacia un ecosistema automatizado con capacidades de Respuesta a Incidentes (IR) y Orquestación (SOAR) para reducir drásticamente el Tiempo Medio de Respuesta (MTTR) ante ciberataques.

## Fuente de las Instrucciones

La base teórica, la arquitectura de los ejercicios y las instrucciones principales provienen del libro oficial:

*   **Título:** *Security Monitoring with Wazuh: A hands-on guide to effective enterprise security using real-life use cases in Wazuh* [2].
*   **Autor:** Rajneesh Gupta [3].
*   **Editorial:** Packt Publishing [3].

*Nota: Aunque las directrices base provienen del libro de Packt, gran parte de los laboratorios documentados aquí contienen adaptaciones propias, resolución de problemas específicos del entorno (como el uso de contenedores anidados en Incus/Fedora) y la creación de scripts personalizados (ej. en Bash y PowerShell) para superar limitaciones de las herramientas por defecto.*

## Índice de Laboratorios

A continuación, se encuentran los enlaces a la documentación detallada de cada una de las fases del proyecto. Haz clic en cada laboratorio para acceder a los markdowns completos, configuraciones y evidencias en imágenes:

*   🔗 **[Laboratorio 1: Intrusion Detection System (IDS) con Wazuh y Suricata](./Lab1)** -- NO PÚBLICO
    *   *Despliegue del entorno, instalación de Suricata, reconocimiento de red, ataques web (DVWA) y pruebas NIDS con tmNIDS.*
*   🔗 **[Laboratorio 2: Detección de Malware usando Wazuh](./Lab2)** -- NO PÚBLICO
    *   *File Integrity Monitoring (FIM), integración con la API de VirusTotal, uso de listas CDB, monitoreo con Windows Defender y Sysmon.*
*   🔗 **[Laboratorio 3: Inteligencia y Análisis de Amenazas](./Lab3) -- NO PÚBLICO**
    *   *Integración del ecosistema de ciberseguridad utilizando las plataformas TheHive, Cortex y MISP para el análisis de observables.*
*   🔗 **[Laboratorio 4: Automatización de Seguridad (SOAR) con Shuffle](./Lab4)** -- NO PÚBLICO
    *   *Implementación de arquitectura basada en eventos (Webhooks), parseo de JSON, autenticación de API remota mediante JWT y automatización de notificaciones tácticas.*
*   🔗 **[Laboratorio 5: Respuesta a Incidentes (Active Response) con Wazuh](./lab5)**
    *   *Contención automatizada de fuerza bruta SSH en Linux mediante scripts custom (`block-ip.sh`), aislamiento de red post-infección en Windows (PowerShell) y bloqueo de fuerza bruta RDP (`netsh.exe`).*

## 🛠️ Tecnologías Utilizadas

A lo largo de estas documentaciones, encontrarás configuraciones e interacciones con las siguientes tecnologías:
*   **SIEM / XDR:** Wazuh Manager & Wazuh Agents.
*   **IDS / IPS:** Suricata.
*   **SOAR & Threat Intel:** Shuffle, TheHive, Cortex, MISP, VirusTotal.
*   **Sistemas Operativos:** Ubuntu Server, Debian, Fedora (Incus Containers), Windows 10/11/Server, Kali Linux.
*   **Scripting:** Bash, PowerShell, Batch.
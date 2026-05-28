# Aislamiento de red de una máquina Windows post-infección

Descripción: Implementar una contención agresiva creando un script personalizado en PowerShell (wfblock.ps1) y un archivo Batch (fw.cmd) que bloquee todo el tráfico de red saliente en el entorno Windows. La acción será detonada por la regla 87105 (detección de malware mediante la integración de la API de VirusTotal)
Estado: Listo

**Prerrequisitos**

Para este laboratorio, asumimos que ya cuentas con **PowerShell versión 7** instalado en tu máquina Windows y que tienes tu **API Key de VirusTotal** configurada en el Wazuh Manager (con la respectiva regla de File Integrity Monitoring activada en las carpetas a vigilar).

**Paso 1: Preparar los scripts de Respuesta Activa en Windows**

Vamos a crear los scripts que ejecutarán el bloqueo en el Firewall de Windows. Ambos archivos deben guardarse estrictamente en la carpeta de Respuesta Activa del agente.

1. Ingresa a tu Endpoint Windows (Víctima 2).
2. Abre el Bloc de notas y crea un archivo Batch que servirá como el activador principal. Pega el siguiente código y guárdalo como **`fw.cmd`** en la ruta **`C:\Program Files (x86)\ossec-agent\active-response\bin`**:
    
    ![Se optó por reemplazar el script original por una versión simplificada utilizando rutas válidas de Windows 11 y una llamada directa al ejecutable `pwsh.exe` mediante el parámetro -File para ejecutar el script `wfblock.ps1` . También se agregó `EXIT /B` para asegurar una finalización adecuada del proceso y devolver correctamente el control del agente a Wazuh.](Aislamiento%20de%20red%20de%20una%20m%C3%A1quina%20Windows%20post-inf/image.png)
    
    Se optó por reemplazar el script original por una versión simplificada utilizando rutas válidas de Windows 11 y una llamada directa al ejecutable `pwsh.exe` mediante el parámetro -File para ejecutar el script `wfblock.ps1` . También se agregó `EXIT /B` para asegurar una finalización adecuada del proceso y devolver correctamente el control del agente a Wazuh.
    
3. Abre un nuevo Bloc de notas para crear el script de PowerShell que hará el trabajo sucio. Pega este código y guárdalo como **`wfblock.ps1`** en la misma ruta **`C:\Program Files (x86)\ossec-agent\active-response\bin`**
    
    ![image.png](Aislamiento%20de%20red%20de%20una%20m%C3%A1quina%20Windows%20post-inf/image%201.png)
    

**Paso 2: Configurar Active Response en el Wazuh Manager**

Ahora le diremos al "cerebro" (Wazuh Manager) que detone estos scripts cuando encuentre malware.

1. Entra a la terminal de tu Wazuh Manager (**`10.11.147.221`**).
2. Edita el archivo principal de configuración: **`sudo nano /var/ossec/etc/ossec.conf`**.
3. Agrega el siguiente bloque **`<command>`** para indicarle al manager el nombre de tu archivo Batch:
    
    ```xml
    <command>
    <name>windowsfirewall</name>
    <executable>fw.cmd</executable>
    <timeout_allowed>yes</timeout_allowed>
    </command>
    ```
    
    ![image.png](Aislamiento%20de%20red%20de%20una%20m%C3%A1quina%20Windows%20post-inf/image%202.png)
    
4. Justo debajo, agrega el bloque **`<active-response>`** vinculándolo con la alerta de VirusTotal (Regla `87105`, de acuerdo a la integración de virustotal):
    
    ```xml
    <active-response>
    <disabled>no</disabled>
    <command>windowsfirewall</command>
    <location>local</location>
    <rules_id>87105</rules_id>
    <timeout>60</timeout>
    </active-response>
    ```
    
    ![image.png](Aislamiento%20de%20red%20de%20una%20m%C3%A1quina%20Windows%20post-inf/image%203.png)
    
    ![image.png](Aislamiento%20de%20red%20de%20una%20m%C3%A1quina%20Windows%20post-inf/14baae50-10ae-4d6d-8ba8-24070ae24663.png)
    
5. Guarda los cambios y reinicia el manager para aplicar la configuración: **`sudo systemctl restart wazuh-manager`**.

**Paso 3: Prueba de fuego (Emular la infección)**

1. Para evitar que tu navegador o sistema eliminen el archivo de prueba antes que Wazuh, asegúrate de desactivar temporalmente la protección en tiempo real de Windows Defender y la navegación segura de Chrome.
2. Descarga el archivo de prueba de malware inofensivo desde la página oficial de EICAR: **`https://www.eicar.org/download-anti-malware-testfile/`**.
3. Guarda o mueve este archivo a una carpeta que esté siendo monitoreada por el File Integrity Monitoring de Wazuh (por ejemplo, tu carpeta de Documentos).

**Paso 4: Visualizar el aislamiento**

1. Ve a tu panel de Wazuh y entra a **Security events**.
2. Observarás cómo se dispara la regla de FIM al añadir el archivo, y enseguida la regla **87105** de VirusTotal alertando la detección de motores antivirus.
![alt text](Aislamiento%20de%20red%20de%20una%20m%C3%A1quina%20Windows%20post-inf/image.png)
3. Automáticamente, el Wazuh Manager enviará la orden a tu endpoint Windows para ejecutar **`fw.cmd`**, aislando la máquina de la red.
4. Para comprobar la eficacia del Active Response, ve a tu máquina Windows, abre el **Firewall de Windows Defender con seguridad avanzada** y revisa las Reglas de Salida (*Outbound Rules*). ¡Ahí verás una nueva regla llamada **`BlockOutgoingTraffic`** deteniendo toda la comunicación!.
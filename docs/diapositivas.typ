#import "@preview/touying:0.7.3": *
#import themes.metropolis: *
#import "@preview/numbly:0.1.0": numbly

#set text(lang: "es")

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-colors(
    primary: rgb("#e74e4e"),
    primary-light: rgb("#e63737"),
    secondary: rgb("#1a1a1a"),
    neutral-lightest: rgb("#FFFFFF"),
    neutral-dark: rgb("#333333"),
    neutral-darkest: rgb("#000000"),
  ),
  config-info(
    title: [Registro de Incidencias de Videovigilancia en el Callao],
    subtitle: [Inteligencia de Negocios],
    author: [
      Carrillo Barba, Alexis Martín \
      Olivos Suxe, Neyser Alexander \
      Pecho Santos, Manuel Angel \
      Ramos Yampufe, Martin Alexander \
      Neyra Nina, Bryan Smelin
    ],
    date: datetime.today(),
    institution: [Universidad Tecnológica del Perú],
  ),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()


= Diagnóstico Estratégico

== Municipalidad Provincial del Callao

La Municipalidad Provincial del Callao es la entidad de gobierno local
responsable de la administración pública, prestación de servicios y regulación
en la provincia constitucional del Callao, principal puerto del Perú y uno de
los distritos más densamente poblados del país @PortalTransparencia.

Opera el *Sistema de Monitoreo y Videovigilancia*: infraestructura de cámaras
CCTV distribuida en 3 zonas geográficas, cada una subdividida en sectores
atendidos por bases descentralizadas @VideovigilanciaCallao2025. Las incidencias
se reportan por múltiples canales: cámaras, WhatsApp, app móvil, teléfono, botón
de pánico y atención presencial.

== Misión y Visión

#cols[
  *Misión*

  Proteger a los ciudadanos del Callao mediante un sistema de monitoreo y
  videovigilancia eficiente, oportuno y transparente, garantizando la atención
  integral de incidencias y la coordinación interinstitucional para la
  prevención y reducción de la criminalidad.
][
  *Visión*

  Consolidar un sistema de seguridad ciudadana referente en el país, reconocido
  por su eficiencia operativa, uso responsable de la tecnología y capacidad de
  respuesta, contribuyendo al bienestar y desarrollo sostenible del Callao.
]

== Industria y tamaño

- Sector de *gobierno local y seguridad pública*
- 6 distritos (Callao, Bellavista, Carmen de la Legua-Reque, La Perla, La Punta
  y Mi Perú), más de 1 millón de habitantes @PortalTransparencia
  @VideovigilanciaCallao2025
- Red de cámaras en 3 zonas, bases descentralizadas y una central de monitoreo

#focus-slide[
  *219 373* incidencias registradas, *218 591* válidas tras la limpieza \
  8 canales de reporte · 10 categorías de caso · 39 bases descentralizadas
  #text(size: 0.5em, fill: gray)[@MunicipalidadCallao2024]
]

== Modelo de negocio: Lienzo Canvas

#align(center)[
  #image("/src/assets/img/canvas.png", width: 70%)
]

== Análisis PESTEL

#align(center)[
  #image("/src/assets/img/pestel.jpg", width: 60%)
]

== Matriz FODA

#align(center)[
  #image("/src/assets/img/foda.jpeg", width: 58%)
]

== Diagrama de Ishikawa

#align(center)[
  #image("/src/assets/img/ishikawa.jpeg", width: 62%)
]

== Problemática central del negocio

Más de *219 000* incidencias registradas en la plataforma de datos abiertos
@MunicipalidadCallao2024, pero la ausencia de herramientas de análisis y
visualización adecuadas limita:

- La identificación de patrones y tendencias espaciotemporales
- La detección de áreas prioritarias que requieren intervención
- La distribución eficiente de recursos y planificación de patrol
- La evaluación del desempeño operativo del sistema de seguridad

== Objetivo general del proyecto

#focus-slide[
  Diseñar e implementar un sistema de inteligencia de negocios que permita el
  análisis descriptivo de las incidencias de videovigilancia en el Callao,
  facilitando la identificación de patrones críticos y la toma de decisiones
  informada para la optimización de la seguridad ciudadana.
]

== Objetivos específicos

+ Ejecutar el proceso ETL completo (Extracción, Transformación y Carga) sobre el
  dataset de incidencias de la plataforma de datos abiertos del Estado Peruano.
+ Construir un dashboard interactivo en Power BI con los indicadores clave de
  rendimiento del sistema de videovigilancia.
+ Analizar la distribución geográfica y temporal de las incidencias para
  detectar zonas de alto riesgo y horarios críticos.
+ Formular recomendaciones basadas en evidencia para mejorar la operatividad del
  sistema de seguridad ciudadana.


= Diseño Técnico de la Solución

== Propuesta de solución en BI

Pipeline de datos que transforma información cruda de incidencias en información
estructurada y accionable: automatización del proceso ETL con Python,
almacenamiento del dataset limpio en CSV y visualización interactiva mediante un
dashboard en Power BI, con métricas en tiempo real para los tomadores de
decisiones.

== Arquitectura de Inteligencia de Negocios

#cols[
  *1. Extracción*

  Descarga del CSV fuente desde datos abiertos del Estado Peruano con
  `curl-cffi`.

  *2. Transformación*

  Limpieza de nulos y duplicados, normalización de fechas/horas, estandarización
  de texto y eliminación de columnas redundantes con `pandas`.
][
  *3. Carga*

  Exportación del dataset depurado a `registro_de_incidencias_clean.csv`.

  *4. Visualización*

  Dashboard interactivo en Power BI con filtros dinámicos, KPIs y gráficos
  orientados a la toma de decisiones.
]

== Herramientas utilizadas (1/2)

#align(center)[
  #table(
    columns: (1fr, 1fr, 2.2fr),
    align: (left, left, left),
    inset: 6pt,
    stroke: 0.5pt,
    table.header([*Herramienta*], [*Función*], [*Justificación*]),
    [Python 3.14], [ETL y análisis], [Lenguaje principal del pipeline de datos],
    [`pandas`],
    [Manipulación de datos],
    [Lectura, limpieza, transformación y exportación de datasets],

    [`curl-cffi`],
    [Descarga de datos],
    [Extracción del CSV y del GeoJSON para validación geográfica],

    [`orjson`],
    [Parsing JSON],
    [Lectura eficiente del GeoJSON con límites distritales],
  )
]

== Herramientas utilizadas (2/2)

#align(center)[
  #table(
    columns: (1fr, 1fr, 2.2fr),
    align: (left, left, left),
    inset: 6pt,
    stroke: 0.5pt,
    table.header([*Herramienta*], [*Función*], [*Justificación*]),
    [`shapely`],
    [Georreferenciación],
    [Cálculo de polígonos y buffers dentro del Callao],

    [`Tortoise ORM`],
    [BD y migraciones],
    [Mapeo objeto-relacional para PostgreSQL con esquema estrella],

    [`PostgreSQL`],
    [Almacenamiento],
    [Almacén de datos con soporte de tipos geográficos],

    [VS Code + Jupyter],
    [Desarrollo],
    [Notebooks para ejecución reproducible y documentada],

    [Power BI],
    [Visualización],
    [Dashboard interactivo con filtros, KPIs y gráficos],
  )
]

== Diseño del modelado de datos

Esquema estrella: una tabla de hechos central y cuatro tablas de dimensión, que
desnormaliza las dimensiones categóricas y mantiene la granularidad en la tabla
de hechos.

#cols[
  *Dimensiones*
  - DimTime (95 526): fecha/hora, turno
  - DimLocation (168): zona, sector, base
  - DimCaseType (10): categoría de incidencia
  - DimOrigin (8): canal de reporte
][
  *Hechos y relaciones*
  - FactIncident (218 591 registros)
  - Coordenadas, N° de caso, tiempo de respuesta
  - Cada fila se vincula a las 4 dimensiones vía FK
]

== Esquema estrella

#align(center)[
  #image("/src/assets/img/start-schema.png", height: 100%)
]

== Indicadores clave de rendimiento (KPI)

#align(center)[
  #table(
    columns: (1.6fr, 2.8fr, 1.6fr),
    align: (left, left, left),
    inset: 6pt,
    stroke: 0.5pt,
    table.header([*KPI*], [*Descripción*], [*Fuente*]),
    [Total de incidencias],
    [Casos acumulados en el período analizado],
    [FactIncident],

    [Incidencias por zona],
    [Distribución geográfica de casos],
    [FactIncident × DimLocation],

    [Incidencias por turno],
    [Madrugada, Mañana, Tarde, Noche],
    [FactIncident × DimTime],

    [Incidencias por categoría],
    [Frecuencia por tipo de caso],
    [FactIncident × DimCaseType],

    [Canal predominante],
    [Fuente de origen con mayor volumen],
    [FactIncident × DimOrigin],

    [Tiempo prom. de atención],
    [Minutos entre caso y atención],
    [response_time_min],

    [Incidencias por base],
    [Workload entre 39 bases operativas],
    [FactIncident × DimLocation],

    [Tendencia mensual],
    [Evolución del número de incidencias],
    [FactIncident × DimTime],
  )
]


= Construcción del Dashboard

== Construcción de la solución ETL

Pipeline ejecutado en tres etapas secuenciales, cada una en un cuaderno Jupyter
independiente, documentando fase, justificación y resultados intermedios.

*Extracción*: 219 373 registros, 18 columnas, 39.39 MB, escritura atómica
(`.tmp` + renombrado).

#align(center)[
  #image("/src/assets/img/vista-web-extraccion.png", height: 100%)
]

== Transformación

+ Eliminación de nulos: 145 filas (0.07%) sin ZONA
+ Eliminación de atípicos: 4 filas con cadenas corruptas
+ Filtrado geográfico: buffer de 100 m sobre GeoJSON; 629 registros (0.29%)
  eliminados
+ Duplicados: 4 casos (mismo N° CASO) eliminados
+ Normalización de texto (title case), columnas redundantes eliminadas
+ Parsing de ZONA, conversión de fechas/horas, renombrado a snake_case

*Resultado*: 218 591 registros limpios en `registro_de_incidencias_clean.csv`.

== Carga

+ Migración del esquema (`migrate_db()`)
+ Carga de dimensiones: DimTime (95 526), DimLocation (168), DimCaseType (10),
  DimOrigin (8)
+ Carga de hechos: 218 591 registros en lotes de 10 000 con `bulk_create()`

#align(center)[
  #image("/src/assets/img/vista-tabla-fact_incident.png", height: 100%)
]

== Construcción del dashboard en Power BI

Conexión directa a PostgreSQL con los datos cargados en el esquema estrella:

- Tarjetas de KPIs: total de incidencias y tiempo promedio de respuesta
- Mapa de calor geográfico de distribución espacial
- Gráfico de líneas: tendencia mensual (sept.–nov. 2025)
- Gráfico de anillo: distribución por turnos
- Treemap: carga por base descentralizada (39 bases)
- Filtros: slicer de meses y segmentadores por zona

#align(center)[
  #image("/src/assets/img/vista-powerbi-dashboard.png", height: 100%)
]


= Storytelling con Datos

== El dashboard como eje narrativo

El storytelling con datos combina visualización, contexto periodístico y
estructura dramática para transformar cifras abstractas en una historia
comprensible y accionable @Duarte2019. Se presenta en cuatro actos, anclado en
noticias y reportes oficiales sobre seguridad ciudadana en el Callao.

#align(center)[
  #image("/src/assets/img/dashboard.png", height: 100%)
]

== Acto I: El panorama

El Callao alcanzó una tasa de homicidios de 23.6 por cada 100 mil habitantes en
2025, la segunda región más violenta del país @INEICriminalidad2025. Entre enero
y octubre de 2025 se registraron 165 homicidios, un récord histórico
@LaRepublicaHomicidiosOct2025; las extorsiones subieron 57%.

#focus-slide[
  *218 591* incidencias (sept.–nov. 2025) · *12.47 min* tiempo promedio de
  respuesta · 3 zonas operativas · 8 canales (97.6% cámaras)
]

El mapa de calor muestra la mayor concentración en Callao Cercado, La Perla, San
Miguel y Bellavista — zonas que lideran homicidios y extorsión
@LaRepublicaHomicidiosOct2025.

== Acto II: ¿Cuándo y cómo?

#cols[
  *Distribución por turno*
  - Noche: 27.4%
  - Madrugada: 26.8%
  - Tarde: 24.7%
  - Mañana: 21.1%

  Noche + madrugada = *54.2%* de las incidencias
][
  *Tendencia mensual*
  - Septiembre: 54 mil
  - Octubre: 84 mil (+55.6%)
  - Noviembre: 80 mil

  Cámaras: 97.6% de los reportes; canales ciudadanos subutilizados
]

== Acto III: ¿De qué tipo y dónde?

#cols[
  *Por categoría*
  - Tránsito y Seg. Vial: 64.6%
  - Ambientales: 16.8%
  - Fiscalización: 10.0%
  - Apoyo al Ciudadano: 7.6%
  - Seguridad Ciudadana: 0.8%
][
  *Top 5 bases*
  + Oquendo: 49 829
  + Ramon Castilla: 32 881
  + Quilca: 26 333
  + Tomas Valle: 22 918
  + Obelisco: 18 266
]

Las 5 bases principales concentran el *68.8%* del total de incidencias.

== Acto IV: Insights y acción

- Reforzar cobertura de serenazgo en turnos noche/madrugada
- Fortalecer canales ciudadanos (App Callao Seguro, WhatsApp) frente al 97.6%
  concentrado en cámaras
- Redistribuir recursos hacia bases sobrecargadas (Oquendo, Ramon Castilla:
  37.8%)
- Integrar el dashboard con la Central de Emergencias (`*3333`)
- Priorizar intervenciones de tránsito y seguridad vial (64.6% de los casos)


= Conclusiones

== Conclusiones

- Se transformaron 219 373 registros iniciales en 218 591 registros válidos tras
  limpieza, normalización y validación
- El modelo estrella permitió consultas y análisis rápidos y ordenados mediante
  hechos y dimensiones (tiempo, ubicación, tipo, canal)
- El 64.6% de las incidencias corresponde a tránsito y seguridad vial: una
  problemática tan relevante como la seguridad ciudadana
- La inteligencia de negocios permitió convertir datos históricos en información
  que apoya la distribución de recursos y la planificación de seguridad

== Recomendaciones

- Reforzar personal de serenazgo y patrullaje en turnos noche/madrugada,
  priorizando zonas y bases con mayor carga
- Promover canales alternativos a las cámaras (WhatsApp, App Callao Seguro,
  teléfono, botón de pánico) para mayor participación ciudadana
- Automatizar el proceso ETL con validaciones de calidad programadas, en lugar
  de cargas manuales, para mantener el dashboard siempre actualizado y confiable

== Lecciones aprendidas

- Modelar bien el esquema estrella es la base de todo: errores en granularidad o
  relaciones producen KPIs mal calculados
- "Tener muchos datos" no es lo mismo que "tener datos útiles": de 219 373
  registros se descartaron 782 tras la depuración
- Trabajar con datos reales de seguridad ciudadana implica responsabilidad, pues
  la información puede influir en decisiones de despliegue y priorización de
  zonas

== ¡Gracias!

#focus-slide[
  #text(size: 1.4em)[
    *Gracias*
  ]
]

#bibliography("refs.bib", title: [Bibliografía])

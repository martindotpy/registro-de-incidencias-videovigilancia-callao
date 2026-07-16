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

#cols[
  *Misión*

  Proteger a los ciudadanos del Callao mediante un sistema de monitoreo y
  videovigilancia eficiente, oportuno y transparente.

  *Visión*

  Consolidar un sistema de seguridad ciudadana referente en el país, reconocido
  por su eficiencia operativa, uso responsable de la tecnología y capacidad de
  respuesta.
][
  *Contexto*

  Entidad de gobierno local que opera el Sistema de Monitoreo y Videovigilancia:
  3 zonas geográficas, bases descentralizadas y central de monitoreo. 6
  distritos, más de 1 millón de habitantes @PortalTransparencia.
]

#focus-slide[
  *219 373* incidencias registradas, *218 591* válidas tras la limpieza \
  8 canales de reporte · 10 categorías · 39 bases descentralizadas
  #text(size: 0.5em, fill: gray)[@MunicipalidadCallao2024]
]

== Canvas

#align(center)[
  #image("/src/assets/img/canvas.png", height: 1fr)
]

== Pestel

#align(center)[
  #image("/src/assets/img/pestel.jpg", height: 1fr)
]

== FODA

#align(center)[
  #image("/src/assets/img/foda.jpeg", height: 1fr)
]

== Diagrama de Ishikawa

#align(center)[
  #image("/src/assets/img/ishikawa.jpeg", height: 1fr)
]

== Problemática y objetivos

#focus-slide[
  Procesar manualmente más de *219 000* incidencias históricas es inviable para
  la gestión pública. Sin herramientas de BI, se limita la identificación de
  patrones, la distribución eficiente de recursos y la capacidad de respuesta
  @MunicipalidadCallao2024.
]

*Objetivo general:* Diseñar e implementar un sistema de inteligencia de negocios
para el análisis descriptivo de incidencias de videovigilancia en el Callao,
facilitando la identificación de patrones críticos y la toma de decisiones
informada.

*Objetivos específicos:*
+ Ejecutar el proceso ETL completo sobre el dataset de incidencias
+ Construir un dashboard interactivo en Power BI con indicadores clave
+ Analizar la distribución geográfica y temporal de incidencias
+ Formular recomendaciones basadas en evidencia


= Diseño Técnico de la Solución

== Arquitectura de Inteligencia de Negocios

Pipeline ETL en cuatro etapas que transforma datos crudos en información
estructurada y accionable.

#cols[
  *1. Extracción*
  Descarga del CSV fuente desde datos abiertos del Estado Peruano con
  `curl-cffi`.

  *2. Transformación*
  Limpieza de nulos y duplicados, normalización de fechas/horas, estandarización
  de texto y eliminación de columnas redundantes con `pandas`.
][
  *3. Carga*
  Exportación del dataset depurado a CSV y carga en PostgreSQL con esquema
  estrella mediante Tortoise ORM.

  *4. Visualización*
  Dashboard interactivo en Power BI con filtros dinámicos, KPIs y gráficos
  orientados a la toma de decisiones.
]

== Herramientas utilizadas

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
    [Limpieza, transformación y exportación],

    [`curl-cffi`], [Descarga de datos], [Extracción del CSV y GeoJSON],
    [`orjson`], [Parsing JSON], [Lectura eficiente del GeoJSON],
    [`shapely`], [Georreferenciación], [Cálculo de polígonos y buffers],
    [`Tortoise ORM`],
    [BD y migraciones],
    [ORM para PostgreSQL con esquema estrella],

    [`PostgreSQL`], [Almacenamiento], [Almacén de datos con tipos geográficos],
    [VS Code + Jupyter], [Desarrollo], [Notebooks para ejecución reproducible],
    [Power BI], [Visualización], [Dashboard interactivo con KPIs y gráficos],
  )
]

== Diseño del modelado de datos

Esquema estrella: una tabla de hechos central y cuatro tablas de dimensión, que
desnormaliza dimensiones categóricas y mantiene granularidad analítica.

#cols[
  *Dimensiones*
  - DimTime (95 526): fecha/hora, turno
  - DimLocation (168): zona, sector, base
  - DimCaseType (10): categoría de incidencia
  - DimOrigin (8): canal de reporte
][
  *Hechos*
  - FactIncident (218 591 registros)
  - Coordenadas, N° de caso, tiempo de respuesta
  - Cada fila vinculada a las 4 dimensiones vía FK
]

#colbreak()

#align(center)[
  #image("/src/assets/img/start-schema.png", height: 1fr)
]

== Indicadores clave de rendimiento (KPI)

#align(center)[
  #table(
    columns: (1.6fr, 2.8fr, 1.6fr),
    align: (left, left, left),
    inset: 6pt,
    stroke: 0.5pt,
    table.header([*KPI*], [*Descripción*], [*Fuente*]),
    [Total de incidencias], [Casos acumulados en el período], [FactIncident],
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
    [Fuente con mayor volumen],
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

== Proceso ETL

*Extracción:* 219 373 registros, 18 columnas, 39.39 MB, escritura atómica.

*Transformación:*
- Eliminación de nulos (145), atípicos (4), filtrado geográfico (629),
  duplicados (4)
- Normalización de texto, parsing de ZONA, conversión de fechas/horas,
  renombrado a snake_case
- *Resultado:* 218 591 registros limpios

*Carga:*
- Migración del esquema, carga de dimensiones (DimTime 95 526, DimLocation 168,
  DimCaseType 10, DimOrigin 8) y hechos (218 591) en lotes de 10 000

== Vista general del dashboard

Conexión directa a PostgreSQL con esquema estrella. El dashboard integra seis
componentes visuales que permiten un análisis completo del sistema de
videovigilancia.

#colbreak()

#align(center)[
  #image("/src/assets/img/vista-powerbi-dashboard.png", height: 1fr)
]


= Dashboard en Detalle

== KPIs y sistema de filtros

#cols[
  *Tarjetas de KPIs*
  - Total de incidencias: 218 591
  - Tiempo promedio de respuesta: 12.47 min
  - Métricas calculadas directamente desde FactIncident sobre el modelo estrella

  *Slicer de meses*
  - Septiembre, octubre y noviembre 2025
  - Filtrado dinámico de todo el dashboard
][
  *Segmentadores por zona*
  - Zona 1, Zona 2, Zona 3
  - Selección múltiple para comparar áreas operativas
  - Actualización en tiempo real de KPIs, mapa y gráficos
]

#colbreak()

#align(center)[#image("/src/assets/img/dashboard.png", height: 1fr)]

== Mapa de calor geográfico

#focus-slide[
  *Distribución espacial de incidencias* \
  Gradiente de calor proporcional al volumen por coordenada \
  Mayor concentración: C - Oquendo, C - Ramon Castilla, C - Quilca, \
  C - Tomas Valle y C - Obelisco
]

- Validación geográfica con buffer de 100 m sobre GeoJSON distrital
- Correlación visual con zonas de alta criminalidad reportadas por INEI
- Permite identificar clusters y áreas prioritarias para patrullaje

#align(center)[#image(
  "/src/assets/img/vista-powerbi-dashboard.png",
  height: 50%,
)]

== Gráficos analíticos

#cols[
  *Gráfico de líneas — Tendencia mensual*
  - Septiembre: 54 mil
  - Octubre: 84 mil (+55.6%)
  - Noviembre: 80 mil
  - Identifica el repunte estacional

  *Gráfico de anillo — Turnos*
  - Noche: 27.4% | Madrugada: 26.8%
  - Tarde: 24.7% | Mañana: 21.1%
  - 54.2% en noche + madrugada
][
  *Treemap — Carga por base*
  - 39 bases descentralizadas
  - Top 5 concentra 68.8% del total
  - Oquendo (49 829) y Ramon Castilla (32 881) lideran
]

#align(center)[#image(
  "/src/assets/img/vista-powerbi-dashboard.png",
  height: 40%,
)]


= Storytelling con Datos

== El dashboard como eje narrativo

El storytelling con datos combina visualización, contexto periodístico y
estructura dramática para transformar cifras abstractas en una historia
comprensible y accionable @Duarte2019. Cuatro actos anclados en noticias y
reportes oficiales sobre seguridad ciudadana en el Callao.

#align(center)[
  #image("/src/assets/img/dashboard.png", height: 80%)
]

== Acto I: El panorama — ¿Qué está pasando en el Callao?

El Callao alcanzó una tasa de homicidios de 23.6 por cada 100 mil habitantes en
2025, la segunda región más violenta del país @INEICriminalidad2025. Entre enero
y octubre de 2025 se registraron 165 homicidios, récord histórico; las
extorsiones subieron 57% @LaRepublicaHomicidiosOct2025.

#focus-slide[
  *218 591* incidencias (sept.–nov. 2025) · *12.47 min* tiempo promedio de
  respuesta · 3 zonas operativas · 8 canales (97.6% cámaras)
]

El mapa de calor muestra la mayor concentración en las bases C - Oquendo,
C - Ramon Castilla, C - Quilca, C - Tomas Valle y C - Obelisco — las cinco
bases con mayor carga operativa del sistema.

== Acto II: ¿Cuándo y cómo ocurren?

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

== Conclusiones y recomendaciones

*Conclusiones:*
- 219 373 registros iniciales transformados en 218 591 válidos tras limpieza
- El modelo estrella permitió consultas y análisis rápidos y ordenados
- El 64.6% de las incidencias corresponde a tránsito y seguridad vial
- La inteligencia de negocios convierte datos históricos en información para la
  distribución de recursos y planificación de seguridad

*Recomendaciones:*
- Reforzar personal de serenazgo y patrullaje en turnos noche/madrugada
- Promover canales alternativos a las cámaras (WhatsApp, App Callao Seguro)
- Automatizar el proceso ETL con validaciones de calidad programadas

== Lecciones aprendidas

- Modelar bien el esquema estrella es la base de todo: errores en granularidad o
  relaciones producen KPIs mal calculados
- "Tener muchos datos" no es lo mismo que "tener datos útiles": de 219 373
  registros se descartaron 782 tras la depuración
- La calidad de la solución final depende directamente del rigor en la limpieza
  del origen: un dashboard montado sobre datos sucios solo perpetúa el problema
  que busca resolver
- Trabajar con datos reales de seguridad ciudadana implica responsabilidad, pues
  la información puede influir en decisiones de despliegue y priorización

== ¡Gracias!

#focus-slide[
  #text(size: 1.4em)[
    *Gracias*
  ]
]

#bibliography("refs.bib", title: [Bibliografía])

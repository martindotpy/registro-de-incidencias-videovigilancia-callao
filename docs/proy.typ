#import "@preview/versatile-apa:7.2.0": versatile-apa
#import "@preview/callisto:0.2.5": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/cmarker:0.1.8"
#import "@preview/mitex:0.2.7": mitex

// Style
#show: versatile-apa.with(font-size: 11pt)
#show: codly-init.with()
#let render = render.with(
  template: (
    raw: (cell, ..args) => source(cell),
    markdown: (cell, handlers: auto, ..args) => read-mime(
      source(cell).text,
      format: "text/markdown",
      handlers: handlers,
    ),
    input: (cell, input-args: none, ..args) => source(cell, ..input-args),
    output: (cell, output-args: none, ..args) => outputs(
      cell,
      ..output-args,
      result: "value",
    ).join(),
  ),
  handlers: (
    "text/markdown": cmarker.render.with(
      math: mitex,
      scope: (
        image: (path, alt: none) => block(figure(image(path), caption: alt)),
      ),
    ),
  ),
)

#codly(languages: codly-languages)

// Fixes conflict with codly's and apa-style's figure configuration
#set raw(block: false)
#show figure.where(kind: raw): set block(width: auto)
#show raw: set block(fill: none, stroke: none, inset: 0pt)


// Configuration
#set page(numbering: none, paper: "a4")
#set text(lang: "es", font: "Arial")
#set figure(placement: none)
#set table(align: left)
#set image(fit: "contain")


// Cover
#page()[
  #set align(center)
  #set text(size: 13pt)

  #image("/src/assets/img/utp-logo.png", width: 80%)

  #v(0.5cm)
  *UNIVERSIDAD TECNOLÓGICA DEL PERÚ*
  #v(0.125cm)

  *Proyecto Final — Registro de Incidencias de Videovigilancia en el Callao*
  #v(1cm)

  *Curso*\
  Inteligencia de Negocios
  #v(0.5cm)

  *Sección*\
  31677
  #v(0.5cm)

  *Integrantes*\
  #table(
    [Carrillo Barba, Alexis Martín], [U21218567],
    [Olivos Suxe, Neyser Alexander], [U22315776],
    [Pecho Santos, Manuel Angel], [U76075762],
    [Ramos Yampufe, Martin Alexander], [U22214724],
    [Neyra Nina, Bryan Smelin], [U19204046],
    columns: (55%, 25%),
    gutter: 0.25cm,
    stroke: none,
  )
  #v(0.5cm)

  *Docente*\
  Tapia Ore, Willy Alexander

  #v(1fr)
  Perú

  #v(0.5cm)
  #datetime.today().year()
]


// Configuration post cover
#set page(numbering: "1")
#show heading: set block(above: 2em, below: 1.5em)

#show table.cell.where(y: 0): strong


// Sections
#outline()

#show heading.where(level: 1): h => {
  colbreak()
  h
}

#outline(target: figure.where(kind: table), title: [Tablas])


#outline(target: figure.where(kind: image), title: [Figuras])


#show table.cell.where(y: 0): it => block(it)


= Diagnóstico estratégico y análisis del negocio

== Municipalidad Provincial del Callao

La Municipalidad Provincial del Callao es la entidad de gobierno local
responsable de la administración pública, prestación de servicios y
regulación en la provincia constitucional del Callao, principal puerto del
Perú y uno de los distritos más densamente poblados del territorio nacional.

En el marco de su función de seguridad ciudadana, la Municipalidad opera el
Sistema de Monitoreo y Videovigilancia, una infraestructura de cámaras
CCTV distribuidas en tres zonas geográficas (Zona 1, Zona 2 y Zona 3),
cada una subdividida en sectores operativos atendidos por bases
descentralizadas. Este sistema genera un volumen significativo de datos
sobre incidencias reportadas por múltiples canales: cámaras, WhatsApp,
aplicación móvil, teléfono, botón de pánico y atención presencial.

== Misión y Visión

Visión: Consolidar un sistema de seguridad ciudadana referente en el país,
reconocido por su eficiencia operativa, uso responsable de la tecnología y
capacidad de respuesta, contribuyendo al bienestar y desarrollo sostenible
del Callao.

Misión: Proteger a los ciudadanos del Callao mediante un sistema de
monitoreo y videovigilancia eficiente, oportuno y transparente, garantizando
la atención integral de incidencias y la coordinación interinstitucional para
la prevención y reducción de la criminalidad.

== Industria y tamaño

La Municipalidad del Callao opera en el sector de gobierno local y seguridad
pública, gestionando un sistema de videovigilancia que cubre la totalidad
de la provincia. La provincia del Callao comprende 6 distritos (Callao,
Bellavista, Carmen de la Legua-Reque, La Perla, La Punta y Mi Perú) con una
población estimada de más de 1 millón de habitantes.

El sistema de monitoreo cuenta con una red de cámaras distribuidas en 3
zonas principales, operadas por bases descentralizadas y una central de
monitoreo. Según los datos analizados, se registraron más de 219,000
incidencias, lo que evidencia la escala operativa y la importancia de
herramientas de análisis para la gestión eficiente de recursos.

== Modelo de negocio: Lienzo Canvas

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.header([Componente], [Descripción]),
    [Socios clave], [Policía Nacional del Callao, Serenazgo Municipal, Defensa Civil, Ministerio Público],

    [Actividades clave],
    [Monitoreo continuo de cámaras CCTV, Registro y clasificación de incidencias, Atención y despacho de unidades, Coordinación interinstitucional, Generación de reportes estadísticos],

    [Recursos clave],
    [Red de cámaras CCTV, Central de monitoreo, Personal operativo capacitado, Infraestructura tecnológica, Base de datos de incidencias],

    [Propuesta de valor],
    [Seguridad ciudadana las 24 horas, Tiempo de respuesta optimizado, Datos confiables para toma de decisiones, Transparencia en la gestión pública],

    [Relaciones con clientes],
    [Atención directa vía cámaras y botones de pánico, Canales digitales (WhatsApp, App Callao Seguro), Línea telefónica, Atención presencial en bases],

    [Canales], [Cámaras CCTV, WhatsApp, App Callao Seguro, Teléfono fijo/móvil, Radio, Atención presencial],

    [Segmentos de clientes],
    [Ciudadanos residentes del Callao, Visitantes y transeúntes, Empresas y comercios locales, Instituciones educativas],

    [Estructura de costos],
    [Mantenimiento de cámaras e infraestructura, Nómina del personal de monitoreo, Licencias de software, Consumo energético],

    [Fuentes de ingresos],
    [Presupuesto municipal asignado, Regalías y permisos de funcionamiento, Transferencias del gobierno central],
    table.hline(),
  ),
  caption: [Modelo Canvas — Municipalidad Provincial del Callao],
)

\<pendiente-canvas>

== Análisis PESTEL

\<pendiente-pestel>

== Matriz FODA

\<pendiente-foda>

== Diagrama de la problemática (Ishikawa)

\<pendiente-ishikawa>

== Problemática central del negocio

La Municipalidad Provincial del Callao genera un volumen elevado de datos
derivados del sistema de videovigilancia, con más de 219,000 incidencias
registradas en la plataforma de datos abiertos. Sin embargo, la ausencia de
herramientas de análisis y visualización adecuadas limita la capacidad de
identificar patrones, tendencias espaciotemporales y áreas prioritarias que
requieren intervención inmediata.

Esta situación dificulta la distribución eficiente de recursos, la
planificación estratégica de patrol y la evaluación del desempeño operativo
del sistema de seguridad. La falta de información procesada y accesible
impacta negativamente en la calidad de las decisiones y en la capacidad de
respuesta ante incidentes de seguridad ciudadana.

== Objetivo general del proyecto

Diseñar e implementar un sistema de inteligencia de negocios que permita el
análisis descriptivo de las incidencias de videovigilancia en el Callao,
facilitando la identificación de patrones críticos y la toma de decisiones
informada para la optimización de la seguridad ciudadana.

== Objetivos específicos

+ Ejecutar el proceso ETL completo (Extracción, Transformación y Carga) sobre
  el dataset de incidencias disponible en la plataforma de datos abiertos del
  Estado Peruano.
+ Construir un dashboard interactivo en Power BI que visualice los indicadores
  clave de rendimiento del sistema de videovigilancia.
+ Analizar la distribución geográfica y temporal de las incidencias para
  detectar zonas de alto riesgo y horarios críticos.
+ Formular recomendaciones basadas en evidencia para la mejora de la
  operatividad del sistema de seguridad ciudadana.


= Diseño técnico de solución en Inteligencia de Negocios

== Propuesta de solución en BI

La solución propuesta comprende la implementación de un pipeline de datos
que transforme la información cruda de incidencias en información estructurada
y accionable. El enfoque incluye la automatización del proceso ETL mediante
scripts en Python, el almacenamiento del dataset limpio en formato CSV y la
visualización interactiva a través de un dashboard en Power BI, permitiendo
a los tomadores de decisiones acceder a métricas relevantes en tiempo real.

== Arquitectura de Inteligencia de Negocios

La arquitectura adopta un modelo ETL clásico compuesto por cuatro etapas:

+ *Extracción:* Descarga del archivo CSV fuente desde la plataforma de datos
  abiertos del Estado Peruano mediante la librería `curl-cffi`.
+ *Transformación:* Limpieza de valores nulos y duplicados, normalización de
  formatos de fecha y hora, estandarización de texto y eliminación de columnas
  redundantes, utilizando la librería `pandas`.
+ *Carga:* Exportación del dataset depurado a un nuevo archivo CSV
  (`registro_de_incidencias_clean.csv`) para su consumo por herramientas de
  visualización.
+ *Visualización:* Dashboard interactivo en Power BI con filtros dinámicos,
  KPIs y gráficos orientados a la toma de decisiones.

== Herramientas utilizadas

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([Herramienta], [Función], [Justificación]),
    [Python 3.14], [ETL y análisis], [Librería `pandas` para manipulación y transformación de datos tabulares],

    [VS Code + Jupyter], [Desarrollo], [Entorno de desarrollo con notebooks para ejecución reproducible],
    table.hline(),
  ),
  caption: [Herramientas del proyecto y su justificación],
)

== Diseño del modelado de datos

El dataset transformado se organiza en una estructura de tabla de hechos
relacionada con dimensiones categóricas:

- *Tabla de hechos — Incidencias:* `N° CASO` (identificador), `FECHA DEL
  CASO`, `HORA DEL CASO`, `LATITUD`, `LONGITUD`, `ATENCION AL CASO`,
  `HORA ATENCION AL CASO`.
- *Dimensión geográfica:* `ZONA` (sector y cuadrante), `BASE DESCENTRALIZADA`.
- *Dimensión temporal:* `TURNO` (mañana, tarde, noche, madrugada).
- *Dimensión categorial:* `TIPO DE CASO`, `ORIGEN` (canal de reporte).

\<pendiente-modelado>

== Indicadores clave de rendimiento (KPI)

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.header([KPI], [Descripción]),
    [Total de incidencias], [Cantidad acumulada de casos registrados en el período analizado],

    [Incidencias por zona], [Distribución geográfica de los casos para identificar zonas críticas],

    [Incidencias por turno], [Distribución temporal: mañana, tarde, noche y madrugada],

    [Tipo de caso más frecuente], [Categoría con mayor volumen de reportes (ej. tránsito, ambientales)],

    [Canal de reporte predominante], [Fuente de origen con mayor cantidad de incidencias],

    [Tiempo promedio de atención], [Intervalo entre la hora del caso y la hora de atención registrada],
    table.hline(),
  ),
  caption: [Indicadores clave de rendimiento del sistema de videovigilancia],
)


= ETL

#render(nb: json("/src/content/docs/etl/extraccion.ipynb"))

#render(nb: json("/src/content/docs/etl/transformacion.ipynb"))

#render(nb: json("/src/content/docs/etl/carga.ipynb"))


= Construcción del dashboard en Power BI

== Construcción de solución ETL


== Construcción del dashboard en Power BI


= Storytelling con datos


= Conclusiones, Recomendaciones y Lecciones Aprendidas

== Conclusiones


== Recomendaciones


== Lecciones aprendidas



#bibliography(
  "refs.bib",
  full: true,
  title: [Bibliografía],
)

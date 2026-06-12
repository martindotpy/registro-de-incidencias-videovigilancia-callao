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


= Introducción


= ETL

#render(nb: json("/src/content/docs/etl/extraccion.ipynb"))

#render(nb: json("/src/content/docs/etl/transformacion.ipynb"))

#render(nb: json("/src/content/docs/etl/carga.ipynb"))


#bibliography(
  "refs.bib",
  full: true,
  title: [Bibliografía],
)

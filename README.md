<h1 align="center">
  Registro de Incidencias de Videovigilancia en el Callao
</h1>

Proyecto ETL (Extracción, Transformación, Carga) que procesa datos de
incidencias de videovigilancia del Callao, Perú. Los datos se obtienen del
portal de datos abiertos del Estado Peruano, se transforman y cargan en un
almacén de datos PostgreSQL usando un modelo estrella (star schema).

El proyecto incluye un sitio web de documentación construido con Astro +
Starlight que presenta el pipeline ETL a través de notebooks Jupyter convertidos
a markdown.

## Requisitos previos

- [uv](https://docs.astral.sh/uv/) (gestor de paquetes Python)
- [Bun](https://bun.sh/) >= 1.x
- [Docker](https://www.docker.com/) (para la base de datos en desarrollo y
  despliegue)

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/martindotpy/registro-de-indicencias-videovigilancia-callao.git
cd registro-incidencias-videovigilancia-callao
```

### 2. Instalar dependencias de Python

`uv` se encargará de instalar automáticamente Python 3.14 y todas las
dependencias:

```bash
uv sync
```

### 3. Instalar dependencias de Node.js

```bash
bun install
```

### 4. Configurar variables de entorno

Copia el archivo `.env.example` (si existe) o crea un archivo `.env`:

```bash
DATABASE_URL=postgres://user:password@localhost:5432/registro-indicencias
```

## Ejecución

### Desarrollo

#### 1. Iniciar base de datos

```bash
docker compose -f docker-compose-devservices.yaml up -d
```

Esto iniciará PostgreSQL y Drizzle Studio en los puertos:

- PostgreSQL: `5432`
- Drizzle Studio: `4983`

#### 2. Migraciones de base de datos

Las migraciones se generan con:

```bash
uv run tortoise makemigrations
```

La ejecución de las migraciones se realiza automáticamente en el notebook de
carga (`carga.ipynb`).

#### 3. Ejecutar el pipeline ETL

Los notebooks están en `src/content/docs/etl/`:

```bash
# Extraer datos
uv run jupyter notebook src/content/docs/etl/extraccion.ipynb

# Transformar datos
uv run jupyter notebook src/content/docs/etl/transformacion.ipynb

# Cargar datos
uv run jupyter notebook src/content/docs/etl/carga.ipynb
```

O ejecutar todos los notebooks como scripts:

```bash
uv run jupyter nbconvert --to script --execute src/content/docs/etl/extraccion.ipynb
uv run jupyter nbconvert --to script --execute src/content/docs/etl/transformacion.ipynb
uv run jupyter nbconvert --to script --execute src/content/docs/etl/carga.ipynb
```

#### 4. Convertir notebooks a markdown

```bash
bun run ipynb:build
```

#### 5. Iniciar servidor de desarrollo

```bash
bun run dev
```

El sitio estará disponible en `http://localhost:4321`.

### Producción (Docker)

#### Build de la imagen

```bash
docker build -t registro-incidencias .
```

#### Ejecutar

```bash
docker run -p 80:80 registro-incidencias
```

## Estructura del proyecto

```
registro-incidencias-videovigilancia-callao/
├── src/
│   ├── content/docs/etl/          # Notebooks Jupyter (ETL)
│   │   ├── extraccion.ipynb       # Extracción de datos
│   │   ├── transformacion.ipynb   # Transformación y limpieza
│   │   └── carga.ipynb            # Carga a PostgreSQL
│   ├── registro_de_indicencias/   # Módulos Python
│   │   ├── model.py               # Modelos ORM (Tortoise)
│   │   ├── database.py            # Configuración de BD
│   │   ├── configuration.py       # Variables de entorno
│   │   ├── folder.py              # Rutas de archivos
│   │   ├── geojson.py             # Modelos GeoJSON
│   │   └── migrations/            # Migraciones Aerich
│   └── assets/                    # Assets del sitio
├── scripts/
│   └── convert_notebooks.py       # Conversor notebooks → markdown
├── docs/                          # Documentación Typst
├── public/                        # Archivos públicos
├── data/                          # Datos generados (gitignored)
├── dist/                          # Build de producción
├── Dockerfile                     # Build multi-etapa
├── docker-compose-devservices.yaml
├── pyproject.toml                 # Configuración Python
├── package.json                   # Configuración Node.js
└── astro.config.ts                # Configuración Astro
```

## Pipeline ETL

### Extracción (`extraccion.ipynb`)

- Descarga CSV del portal de datos abiertos del Perú
- Usa `curl_cffi` para peticiones HTTP
- Escritura atómica (temp + rename)

### Transformación (`transformacion.ipynb`)

- Limpieza de datos nulos y duplicados
- Normalización de texto a Title Case
- Filtrado por coordenadas geográficas del Callao
- División de columnas compuestas
- Renombrado de columnas a snake_case en inglés

### Carga (`carga.ipynb`)

- Migración automática de esquema
- Modelo estrella: 4 dimensiones + 1 tabla de hechos
- Dimensiones: Tiempo, Ubicación, Tipo de Caso, Origen
- Carga por lotes de 10,000 registros

## Comandos útiles

```bash
# Formateo de código
bun run format

# Linting
bun run lint

# Linting Python
uv run ruff check .
uv run ruff format .

# Build completo (notebooks + PDF + sitio)
bun run build
```

from pathlib import Path


# Auxiliar
def _find_root_folder():
    current = Path.cwd()

    for parent in [current, *current.parents]:
        if (parent / "pyproject.toml").exists():
            return parent

    msg = "No se encontró el archivo pyproject.toml en ningún directorio padre."
    raise FileNotFoundError(msg)


# Constant
WORKSPACE_FOLDER_PATH = _find_root_folder()
DATA_FOLDER_PATH = WORKSPACE_FOLDER_PATH / "data"
CSV_PATH = DATA_FOLDER_PATH / "registro_de_incidencias.csv"
CLEAN_CSV_PATH = DATA_FOLDER_PATH / "registro_de_incidencias_clean.csv"
LIMA_GEOJSON_PATH = DATA_FOLDER_PATH / "lima.geojson"

"""Convert Jupyter notebooks to Markdown with nbconvert + frontmatter for Starlight."""

import json
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from typing import TYPE_CHECKING

from nbconvert import MarkdownExporter
from nbformat import read

if TYPE_CHECKING:
    from typing import TypedDict

    class NotebookMetadata(TypedDict):
        """Metadata per notebook for frontmatter."""

        title: str
        description: str

    type NotebooksMetadata = dict[str, NotebookMetadata]


NOTEBOOK_METADATA: NotebooksMetadata = {
    "extraccion": {
        "title": "Extracción",
        "description": "Extracción de datos desde la fuente original (CSV de datos abiertos del Estado Peruano).",
    },
    "transformacion": {
        "title": "Transformación",
        "description": "Limpieza, normalización y transformación de los datos extraídos.",
    },
    "carga": {
        "title": "Carga",
        "description": "Carga de los datos transformados a su destino final.",
    },
}

NOTEBOOKS_DIR = Path("src/content/docs")


def _convert_single(path: Path) -> None:
    stem = path.stem
    meta = NOTEBOOK_METADATA.get(
        stem, {"title": stem.replace("_", " ").title(), "description": ""}
    )

    with path.open(encoding="utf-8") as f:
        nb = read(f, as_version=4)

    exporter = MarkdownExporter()
    body, _ = exporter.from_notebook_node(nb)

    frontmatter = {k: v for k, v in meta.items() if v}
    md_content = f"---\n{json.dumps(frontmatter, ensure_ascii=False)}\n---\n\n{body.strip()}\n"
    path.with_suffix(".md").write_text(md_content, encoding="utf-8")


def main() -> None:
    """Find all notebooks and convert them in parallel."""
    notebooks = sorted(NOTEBOOKS_DIR.rglob("*.ipynb"))

    if not notebooks:
        return

    with ThreadPoolExecutor(max_workers=len(notebooks)) as pool:
        list(pool.map(_convert_single, notebooks))


if __name__ == "__main__":
    main()

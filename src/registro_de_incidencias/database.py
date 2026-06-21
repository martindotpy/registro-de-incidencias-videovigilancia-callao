from tortoise import Tortoise
from tortoise.config import AppConfig, DBUrlConfig, TortoiseConfig
from tortoise.migrations.api import migrate

from registro_de_incidencias.configuration import app_configuration

# Config
TORTOISE_ORM = TortoiseConfig(
    connections={
        "default": DBUrlConfig(url=app_configuration.database_url),
    },
    apps={
        "models": AppConfig(
            models=["registro_de_incidencias.model"],
            default_connection="default",
            migrations="registro_de_incidencias.migrations",
        ),
    },
)


# Database
async def init_db() -> None:
    await Tortoise.init(config=TORTOISE_ORM)


async def close_db() -> None:
    await Tortoise.close_connections()


async def migrate_db() -> None:
    await migrate(config=TORTOISE_ORM)

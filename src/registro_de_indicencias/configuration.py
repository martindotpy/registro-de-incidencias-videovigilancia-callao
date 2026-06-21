from pydantic_settings import BaseSettings, SettingsConfigDict


# Configuration
class AppConfiguration(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8"
    )

    database_url: str


app_configuration = AppConfiguration()  # type: ignore  # noqa: PGH003

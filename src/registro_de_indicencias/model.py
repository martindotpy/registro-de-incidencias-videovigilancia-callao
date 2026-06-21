import enum

from tortoise import fields
from tortoise.contrib.pydantic import pydantic_model_creator
from tortoise.models import Model


# Enum
class DayOfWeekEnum(enum.StrEnum):
    MONDAY = "Lunes"
    TUESDAY = "Martes"
    WEDNESDAY = "Miércoles"
    THURSDAY = "Jueves"
    FRIDAY = "Viernes"
    SATURDAY = "Sábado"
    SUNDAY = "Domingo"


class TurnEnum(enum.StrEnum):
    MORNING = "Mañana"
    AFTERNOON = "Tarde"
    NIGHT = "Noche"
    DAWN = "Madrugada"


class CaseCategoryEnum(enum.StrEnum):
    TRANSIT = "Transito y Seguridad Vial"
    ENVIRONMENTAL = "Ambientales"
    ENFORCEMENT = "Fiscalización y Defensa Civil"
    CITIZEN_SUPPORT = "Apoyo al Ciudadano"
    SECURITY = "Seguridad Ciudadana"
    APP_CALLAO_SEGURO = "App Callao Seguro"
    HEALTH = "Salud"
    FAMILY = "Protección Familiar"
    SPECIAL = "Casos Especiales"
    CITIZEN = "Ciudadano"


class OriginCategoryEnum(enum.StrEnum):
    CAMERA = "Cámara"
    WHATSAPP = "WhatsApp"
    APP_CALLAO_SEGURO = "App Callao Seguro"
    TELEPHONE = "Teléfono"
    PANIC_BUTTON = "Boton de Panico"
    PRESENTIAL_ATTENTION = "Atencion Presencial"
    RADIO = "Radio"
    QR_CONTACTO_CIUDADANO = "QR - Contacto Ciudadano"


# Model
class DimTime(Model):
    id = fields.IntField(pk=True)
    date = fields.DateField()
    time = fields.TimeField(null=True)
    year = fields.IntField()
    month = fields.IntField()
    day = fields.IntField()
    day_of_week = fields.CharEnumField(DayOfWeekEnum, max_length=20)
    turn = fields.CharEnumField(TurnEnum, max_length=20)

    class Meta:  # pyright: ignore[reportIncompatibleVariableOverride]
        table = "dim_time"


class DimLocation(Model):
    id = fields.IntField(pk=True)
    zone_number = fields.IntField()
    sector_name = fields.CharField(max_length=100)
    decentralized_base = fields.CharField(max_length=100)

    class Meta:  # pyright: ignore[reportIncompatibleVariableOverride]
        table = "dim_location"


class DimCaseType(Model):
    id = fields.IntField(pk=True)
    category = fields.CharEnumField(CaseCategoryEnum, max_length=50)

    class Meta:  # pyright: ignore[reportIncompatibleVariableOverride]
        table = "dim_case_type"


class DimOrigin(Model):
    id = fields.IntField(pk=True)
    category = fields.CharEnumField(OriginCategoryEnum, max_length=30)

    class Meta:  # pyright: ignore[reportIncompatibleVariableOverride]
        table = "dim_origin"


class FactIncident(Model):
    id = fields.IntField(pk=True)
    case_number = fields.IntField()
    time = fields.ForeignKeyField(DimTime, related_name="incidents")
    location = fields.ForeignKeyField(DimLocation, related_name="incidents")
    case_type = fields.ForeignKeyField(DimCaseType, related_name="incidents")
    origin = fields.ForeignKeyField(DimOrigin, related_name="incidents")
    latitude = fields.DecimalField(max_digits=12, decimal_places=8)
    longitude = fields.DecimalField(max_digits=12, decimal_places=8)
    response_time_min = fields.IntField(null=True)
    attention_date = fields.DateField(null=True)

    class Meta:  # pyright: ignore[reportIncompatibleVariableOverride]
        table = "fact_incident"


# Schema
DimTimeSchema = pydantic_model_creator(DimTime)
DimLocationSchema = pydantic_model_creator(DimLocation)
DimCaseTypeSchema = pydantic_model_creator(DimCaseType)
DimOriginSchema = pydantic_model_creator(DimOrigin)
FactIncidentSchema = pydantic_model_creator(FactIncident)

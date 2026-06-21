from tortoise import migrations
from tortoise.migrations import operations as ops
from registro_de_indicencias.model import CaseCategoryEnum, DayOfWeekEnum, OriginCategoryEnum, TurnEnum
from tortoise.fields.base import OnDelete
from tortoise import fields

class Migration(migrations.Migration):
    initial = True

    operations = [
        ops.CreateModel(
            name='DimCaseType',
            fields=[
                ('id', fields.IntField(generated=True, primary_key=True, unique=True, db_index=True)),
                ('category', fields.CharEnumField(description='TRANSIT: Transito y Seguridad Vial\nENVIRONMENTAL: Ambientales\nENFORCEMENT: Fiscalización y Defensa Civil\nCITIZEN_SUPPORT: Apoyo al Ciudadano\nSECURITY: Seguridad Ciudadana\nAPP_CALLAO_SEGURO: App Callao Seguro\nHEALTH: Salud\nFAMILY: Protección Familiar\nSPECIAL: Casos Especiales\nCITIZEN: Ciudadano', enum_type=CaseCategoryEnum, max_length=50)),
            ],
            options={'table': 'dim_case_type', 'app': 'models', 'pk_attr': 'id'},
            bases=['Model'],
        ),
        ops.CreateModel(
            name='DimLocation',
            fields=[
                ('id', fields.IntField(generated=True, primary_key=True, unique=True, db_index=True)),
                ('zone_number', fields.IntField()),
                ('sector_name', fields.CharField(max_length=100)),
                ('decentralized_base', fields.CharField(max_length=100)),
            ],
            options={'table': 'dim_location', 'app': 'models', 'pk_attr': 'id'},
            bases=['Model'],
        ),
        ops.CreateModel(
            name='DimOrigin',
            fields=[
                ('id', fields.IntField(generated=True, primary_key=True, unique=True, db_index=True)),
                ('category', fields.CharEnumField(description='CAMERA: Cámara\nWHATSAPP: WhatsApp\nAPP_CALLAO_SEGURO: App Callao Seguro\nTELEPHONE: Teléfono\nPANIC_BUTTON: Boton de Panico\nPRESENTIAL_ATTENTION: Atencion Presencial\nRADIO: Radio\nQR_CONTACTO_CIUDADANO: QR - Contacto Ciudadano', enum_type=OriginCategoryEnum, max_length=30)),
            ],
            options={'table': 'dim_origin', 'app': 'models', 'pk_attr': 'id'},
            bases=['Model'],
        ),
        ops.CreateModel(
            name='DimTime',
            fields=[
                ('id', fields.IntField(generated=True, primary_key=True, unique=True, db_index=True)),
                ('date', fields.DateField()),
                ('time', fields.TimeField(null=True, auto_now=False, auto_now_add=False)),
                ('year', fields.IntField()),
                ('month', fields.IntField()),
                ('day', fields.IntField()),
                ('day_of_week', fields.CharEnumField(description='MONDAY: Lunes\nTUESDAY: Martes\nWEDNESDAY: Miércoles\nTHURSDAY: Jueves\nFRIDAY: Viernes\nSATURDAY: Sábado\nSUNDAY: Domingo', enum_type=DayOfWeekEnum, max_length=20)),
                ('turn', fields.CharEnumField(description='MORNING: Mañana\nAFTERNOON: Tarde\nNIGHT: Noche\nDAWN: Madrugada', enum_type=TurnEnum, max_length=20)),
            ],
            options={'table': 'dim_time', 'app': 'models', 'pk_attr': 'id'},
            bases=['Model'],
        ),
        ops.CreateModel(
            name='FactIncident',
            fields=[
                ('id', fields.IntField(generated=True, primary_key=True, unique=True, db_index=True)),
                ('case_number', fields.IntField()),
                ('time', fields.ForeignKeyField('models.DimTime', source_field='time_id', db_constraint=True, to_field='id', related_name='incidents', on_delete=OnDelete.CASCADE)),
                ('location', fields.ForeignKeyField('models.DimLocation', source_field='location_id', db_constraint=True, to_field='id', related_name='incidents', on_delete=OnDelete.CASCADE)),
                ('case_type', fields.ForeignKeyField('models.DimCaseType', source_field='case_type_id', db_constraint=True, to_field='id', related_name='incidents', on_delete=OnDelete.CASCADE)),
                ('origin', fields.ForeignKeyField('models.DimOrigin', source_field='origin_id', db_constraint=True, to_field='id', related_name='incidents', on_delete=OnDelete.CASCADE)),
                ('latitude', fields.DecimalField(max_digits=12, decimal_places=8)),
                ('longitude', fields.DecimalField(max_digits=12, decimal_places=8)),
                ('response_time_min', fields.IntField(null=True)),
                ('attention_date', fields.DateField(null=True)),
            ],
            options={'table': 'fact_incident', 'app': 'models', 'pk_attr': 'id'},
            bases=['Model'],
        ),
    ]

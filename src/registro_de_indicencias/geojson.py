from typing import Literal

from pydantic import BaseModel

# Model
Point = tuple[float, float]
LinearRing = list[Point]


class PolygonGeometry(BaseModel):
    type: Literal["Polygon"]
    coordinates: list[LinearRing]  # [ring][point] -> (lon, lat)


class MultiPolygonGeometry(BaseModel):
    type: Literal["MultiPolygon"]
    coordinates: list[list[LinearRing]]  # [polygon][ring][point] -> (lon, lat)


Geometry = PolygonGeometry | MultiPolygonGeometry


class _Properties(BaseModel):
    distrito: str


class _Feature(BaseModel):
    type: Literal["Feature"]
    geometry: Geometry
    properties: _Properties


class GeoJSON(BaseModel):
    type: Literal["FeatureCollection"]
    features: list[_Feature]

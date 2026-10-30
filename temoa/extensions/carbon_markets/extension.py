from __future__ import annotations

from pathlib import Path

from temoa.extensions.carbon_markets.core.model import register_model_components
from temoa.extensions.carbon_markets.data_manifest import build_manifest_items
from temoa.extensions.framework import ExtensionSpec

CARBON_MARKETS_EXTENSION = ExtensionSpec(
    extension_id='carbon_markets',
    owned_tables=('clean_electricity_regulation',),
    register_model_components=register_model_components,
    build_manifest_items=build_manifest_items,
    schema_sql_path=str(Path(__file__).parent / 'tables.sql'),
)

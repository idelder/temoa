from __future__ import annotations

from typing import TYPE_CHECKING, cast

from temoa.data_io.loader_manifest import LoadItem

if TYPE_CHECKING:
    from temoa.core.model import TemoaModel
    from temoa.extensions.carbon_markets.core.model import CarbonMarketsModel


def build_manifest_items(model: TemoaModel) -> list[LoadItem]:
    """Return LoadItems for clean_electricity_regulation (one per value column)."""
    m = cast('CarbonMarketsModel', model)
    return [
        LoadItem(
            component=component,
            table='clean_electricity_regulation',
            columns=['region', 'period', 'tech', 'vintage', 'emis_comm', column],
            index_length=5,
            validator_name='viable_rpt',
            validation_map=(0, 1, 2),
            is_table_required=False,
        )
        for component, column in (
            (m.cap_and_trade_cap, 'cap'),
            (m.cap_and_trade_credit_limit, 'credit_limit'),
            (m.cap_and_trade_credit_cost, 'credit_cost'),
        )
    ]

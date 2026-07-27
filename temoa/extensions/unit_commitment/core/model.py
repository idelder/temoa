from __future__ import annotations

from typing import TYPE_CHECKING, cast

from pyomo.environ import (
    Binary,
    BuildAction,
    Constraint,
    Integers,
    NonNegativeReals,
    Param,
    PositiveReals,
    Set,
    Var,
)

from temoa.components import operations
from temoa.extensions.unit_commitment.components import commitment, startup
from temoa.model_checking.validators import validate_0to1

if TYPE_CHECKING:
    from temoa.core.model import TemoaModel
    from temoa.types.core_types import Season, TimeOfDay

    class UnitCommitmentModel(TemoaModel):
        """TemoaModel extended with unit-commitment components for type hinting/checking."""

        # --- Instantiation helpers ---
        uc_backslices: dict[tuple[Season, TimeOfDay, int], set[tuple[Season, TimeOfDay]]]
        uc_backseasons: dict[tuple[Season, TimeOfDay, int], set[Season]]

        # --- UC process parameters (indexed by region, tech) ---
        uc_unit_capacity: Param
        uc_min_output_fraction: Param
        uc_max_output_fraction: Param
        uc_min_up_time_hours: Param
        uc_min_down_time_hours: Param
        uc_planned_outage_rate: Param
        uc_linearized: Param

        # --- Startup parameters (indexed by region, tech, emission_commodity) ---
        uc_startup_cost: Param
        uc_startup_emissions: Param
        uc_startup_input: Param

        # --- Index sets ---
        uc_indices_rpsdtv: Set  # all (r,p,s,d,t,v) subject to UC
        uc_indices_rptv: Set  # all (r,p,s,d,t,v) subject to UC
        uc_planned_outage_indices_rpstv: Set  # all (r,p,s,t,v) subject to UC planned outage
        uc_planned_outage_indices_rptv: Set  # all (r,p,t,v) subject to UC planned outage
        default_capacity_constraint_rpsdtv: Set
        default_ramp_up_constraint_rpsdtv: Set
        default_ramp_down_constraint_rpsdtv: Set
        uc_ramp_up_constraint_rpsdtv: Set
        uc_ramp_down_constraint_rpsdtv: Set

        # --- Build actions ---
        uc_initialise: BuildAction
        uc_apply_integer_domains: BuildAction
        uc_append_startup_costs: BuildAction

        # --- Decision variables ---
        v_uc_total_units: Var  # total whole units available in each period
        v_uc_online: Var  # units online in each time slice
        v_uc_started: Var  # units starting up at end of the time slice
        v_uc_stopped: Var  # units shutting down at end of the time slice
        v_uc_planned_outage: Var  # units shutting down for planned outage at end of the time slice

        # --- Constraints ---
        uc_online_upper_constraint: Constraint
        uc_min_output_constraint: Constraint
        uc_max_output_constraint: Constraint
        uc_started_upper_tightening_constraint: Constraint
        uc_stopped_upper_tightening_constraint: Constraint
        uc_transition_constraint: Constraint
        uc_min_up_time_constraint: Constraint
        uc_min_down_time_constraint: Constraint
        uc_ramp_up_constraint: Constraint
        uc_ramp_down_constraint: Constraint
        uc_planned_outage_stoppage_constraint: Constraint
        uc_planned_outage_constraint: Constraint
        uc_total_units_upper_constraint: Constraint
        uc_total_units_lower_constraint: Constraint


def register_early_components(model: TemoaModel) -> None:
    """Attach unit-commitment components to the core Temoa model."""
    m = cast('UnitCommitmentModel', model)

    # Instantiation helpers
    m.uc_backslices = {}
    m.uc_backseasons = {}

    # Params
    m.uc_unit_capacity = Param(m.regions, m.tech_with_capacity, domain=PositiveReals)
    m.uc_min_output_fraction = Param(
        m.regions, m.tech_with_capacity, domain=NonNegativeReals, default=0.0
    )
    m.uc_max_output_fraction = Param(
        m.regions, m.tech_with_capacity, domain=NonNegativeReals, default=1.0
    )
    m.uc_min_up_time_hours = Param(m.regions, m.tech_with_capacity, domain=Integers, default=0)
    m.uc_min_down_time_hours = Param(m.regions, m.tech_with_capacity, domain=Integers, default=0)
    m.uc_planned_outage_rate = Param(
        m.regions, m.tech_with_capacity, domain=NonNegativeReals, default=0, validate=validate_0to1
    )
    m.uc_linearized = Param(m.regions, m.tech_with_capacity, domain=Binary, default=0)

    # Startup params
    m.uc_startup_cost = Param(m.regions, m.tech_with_capacity, domain=PositiveReals)
    m.uc_startup_emissions = Param(
        m.regions, m.commodity_emissions, m.tech_with_capacity, domain=PositiveReals
    )
    m.uc_startup_input = Param(
        m.regions, m.commodity_physical, m.tech_with_capacity, domain=PositiveReals
    )

    # Index sets
    m.uc_indices_rptv = Set(dimen=4, initialize=commitment.uc_capacity_indices)
    m.uc_indices_rpsdtv = Set(dimen=6, initialize=commitment.uc_constraint_indices)
    m.uc_planned_outage_indices_rptv = Set(
        dimen=4, initialize=commitment.uc_planned_outage_annual_indices
    )
    m.uc_planned_outage_indices_rpstv = Set(
        dimen=5, initialize=commitment.uc_planned_outage_indices
    )

    # BuildAction to initialise
    m.uc_initialise = BuildAction(rule=commitment.initialize_unit_commitment)

    # Decision variables
    m.v_uc_total_units = Var(m.uc_indices_rptv, domain=NonNegativeReals, initialize=0)
    m.v_uc_online = Var(m.uc_indices_rpsdtv, domain=NonNegativeReals, initialize=0)
    m.v_uc_started = Var(m.uc_indices_rpsdtv, domain=NonNegativeReals, initialize=0)
    m.v_uc_stopped = Var(m.uc_indices_rpsdtv, domain=NonNegativeReals, initialize=0)
    m.v_uc_planned_outage = Var(
        m.uc_planned_outage_indices_rpstv, domain=NonNegativeReals, initialize=0
    )

    # BuildAction to upgrade domains to integers where flag is set
    m.uc_apply_integer_domains = BuildAction(rule=commitment.apply_integer_domains)


def register_model_components(model: TemoaModel) -> None:
    """Attach unit-commitment components to the core Temoa model."""
    m = cast('UnitCommitmentModel', model)

    # We intercepted these earlier. Split them by unit commitment vs default
    m.default_ramp_up_constraint_rpsdtv = Set(
        dimen=6, initialize=commitment.ramp_up_constraint_indices
    )
    m.default_ramp_down_constraint_rpsdtv = Set(
        dimen=6, initialize=commitment.ramp_down_constraint_indices
    )
    m.uc_ramp_up_constraint_rpsdtv = Set(
        dimen=6, initialize=commitment.uc_ramp_up_constraint_indices
    )
    m.uc_ramp_down_constraint_rpsdtv = Set(
        dimen=6, initialize=commitment.uc_ramp_down_constraint_indices
    )

    # Rebuild default constraints we intercepted
    m.ramp_up_constraint = Constraint(
        m.default_ramp_up_constraint_rpsdtv, rule=operations.ramp_up_constraint
    )
    m.ramp_down_constraint = Constraint(
        m.default_ramp_down_constraint_rpsdtv, rule=operations.ramp_down_constraint
    )

    # Constraints
    m.uc_online_upper_constraint = Constraint(
        m.uc_indices_rpsdtv, rule=commitment.uc_online_upper_constraint
    )
    m.uc_started_upper_tightening_constraint = Constraint(
        m.uc_indices_rpsdtv, rule=commitment.uc_started_upper_tightening_constraint
    )
    m.uc_stopped_upper_tightening_constraint = Constraint(
        m.uc_indices_rpsdtv, rule=commitment.uc_stopped_upper_tightening_constraint
    )
    m.uc_transition_constraint = Constraint(
        m.uc_indices_rpsdtv, rule=commitment.uc_transition_constraint
    )
    m.uc_min_output_constraint = Constraint(
        m.uc_indices_rpsdtv, rule=commitment.uc_min_output_constraint
    )
    m.uc_min_up_time_constraint = Constraint(
        m.uc_indices_rpsdtv, rule=commitment.uc_min_up_time_constraint
    )
    m.uc_min_down_time_constraint = Constraint(
        m.uc_indices_rpsdtv, rule=commitment.uc_min_down_time_constraint
    )
    m.uc_ramp_up_constraint = Constraint(
        m.uc_ramp_up_constraint_rpsdtv, rule=commitment.uc_ramp_up_constraint
    )
    m.uc_ramp_down_constraint = Constraint(
        m.uc_ramp_down_constraint_rpsdtv, rule=commitment.uc_ramp_down_constraint
    )
    m.uc_planned_outage_stoppage_constraint = Constraint(
        m.uc_planned_outage_indices_rpstv, rule=commitment.uc_planned_outage_stoppage_constraint
    )
    m.uc_planned_outage_constraint = Constraint(
        m.uc_planned_outage_indices_rptv, rule=commitment.uc_planned_outage_constraint
    )
    m.uc_total_units_upper_constraint = Constraint(
        m.uc_indices_rptv, rule=commitment.uc_total_units_upper_constraint
    )
    m.uc_total_units_lower_constraint = Constraint(
        m.uc_indices_rptv, rule=commitment.uc_total_units_lower_constraint
    )

    # Startup costs to objective function
    m.uc_append_startup_costs = BuildAction(rule=startup.append_startup_costs)

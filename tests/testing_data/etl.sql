PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE MetaData
(
    element TEXT,
    value   INT,
    notes   TEXT,
    PRIMARY KEY (element)
);
INSERT INTO MetaData VALUES('DB_MAJOR',3,'DB major version number');
INSERT INTO MetaData VALUES('DB_MINOR',1,'DB minor version number');
CREATE TABLE MetaDataReal
(
    element TEXT,
    value   REAL,
    notes   TEXT,

    PRIMARY KEY (element)
);
INSERT INTO MetaDataReal VALUES('global_discount_rate',0.05,'Discount Rate for future costs');
INSERT INTO MetaDataReal VALUES('default_loan_rate',0.05,'Default Loan Rate if not specified in LoanRate table');
CREATE TABLE Commodity
(
    name        TEXT
        PRIMARY KEY,
    flag        TEXT
        REFERENCES CommodityType (label),
    description TEXT
);
INSERT INTO Commodity VALUES('ethos','s','dummy source');
INSERT INTO Commodity VALUES('dem_etl','d','dummy demand');
INSERT INTO Commodity VALUES('dem_ordinary','d','dummy demand');
CREATE TABLE CommodityType
(
    label       TEXT
        PRIMARY KEY,
    description TEXT
);
INSERT INTO CommodityType VALUES('s','source commodity');
INSERT INTO CommodityType VALUES('p','physical commodity');
INSERT INTO CommodityType VALUES('d','demand commodity');
CREATE TABLE CostFixed
(
    region  TEXT    NOT NULL,
    period  INTEGER NOT NULL
        REFERENCES TimePeriod (period),
    tech    TEXT    NOT NULL
        REFERENCES Technology (tech),
    vintage INTEGER NOT NULL
        REFERENCES TimePeriod (period),
    cost    REAL,
    units   TEXT,
    notes   TEXT,
    PRIMARY KEY (region, period, tech, vintage)
);
CREATE TABLE CostInvest
(
    region  TEXT,
    tech    TEXT
        REFERENCES Technology (tech),
    vintage INTEGER
        REFERENCES TimePeriod (period),
    cost    REAL,
    units   TEXT,
    notes   TEXT,
    PRIMARY KEY (region, tech, vintage)
);
INSERT INTO CostInvest VALUES('region','ordinary',2025,0.1,NULL,NULL);
INSERT INTO CostInvest VALUES('region','ordinary',2030,0.1,NULL,NULL);
INSERT INTO CostInvest VALUES('region','ordinary',2035,0.1,NULL,NULL);
INSERT INTO CostInvest VALUES('region','ordinary',2040,0.1,NULL,NULL);
INSERT INTO CostInvest VALUES('region','ordinary',2045,0.1,NULL,NULL);
INSERT INTO CostInvest VALUES('region','ordinary',2050,0.1,NULL,NULL);
CREATE TABLE CostVariable
(
    region  TEXT    NOT NULL,
    period  INTEGER NOT NULL
        REFERENCES TimePeriod (period),
    tech    TEXT    NOT NULL
        REFERENCES Technology (tech),
    vintage INTEGER NOT NULL
        REFERENCES TimePeriod (period),
    cost    REAL,
    units   TEXT,
    notes   TEXT,
    PRIMARY KEY (region, period, tech, vintage)
);
CREATE TABLE Demand
(
    region    TEXT,
    period    INTEGER
        REFERENCES TimePeriod (period),
    commodity TEXT
        REFERENCES Commodity (name),
    demand    REAL,
    units     TEXT,
    notes     TEXT,
    PRIMARY KEY (region, period, commodity)
);
INSERT INTO Demand VALUES('region',2025,'dem_etl',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2030,'dem_etl',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2035,'dem_etl',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2040,'dem_etl',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2045,'dem_etl',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2050,'dem_etl',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2025,'dem_ordinary',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2030,'dem_ordinary',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2035,'dem_ordinary',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2040,'dem_ordinary',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2045,'dem_ordinary',150.0,NULL,NULL);
INSERT INTO Demand VALUES('region',2050,'dem_ordinary',150.0,NULL,NULL);
CREATE TABLE Efficiency
(
    region      TEXT,
    input_comm  TEXT
        REFERENCES Commodity (name),
    tech        TEXT
        REFERENCES Technology (tech),
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    output_comm TEXT
        REFERENCES Commodity (name),
    efficiency  REAL,
    notes       TEXT,
    PRIMARY KEY (region, input_comm, tech, vintage, output_comm),
    CHECK (efficiency > 0)
);
INSERT INTO Efficiency VALUES('region','ethos','etl',2025,'dem_etl',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','etl',2030,'dem_etl',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','etl',2035,'dem_etl',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','etl',2040,'dem_etl',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','etl',2045,'dem_etl',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','etl',2050,'dem_etl',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','ordinary',2025,'dem_ordinary',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','ordinary',2030,'dem_ordinary',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','ordinary',2035,'dem_ordinary',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','ordinary',2040,'dem_ordinary',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','ordinary',2045,'dem_ordinary',1.0,NULL);
INSERT INTO Efficiency VALUES('region','ethos','ordinary',2050,'dem_ordinary',1.0,NULL);
CREATE TABLE LifetimeProcess
(
    region   TEXT,
    tech     TEXT
        REFERENCES Technology (tech),
    vintage  INTEGER
        REFERENCES TimePeriod (period),
    lifetime REAL,
    notes    TEXT,
    PRIMARY KEY (region, tech, vintage)
);
CREATE TABLE LifetimeTech
(
    region   TEXT,
    tech     TEXT
        REFERENCES Technology (tech),
    lifetime REAL,
    notes    TEXT,
    PRIMARY KEY (region, tech)
);
INSERT INTO LifetimeTech VALUES('region','ordinary',10.0,NULL);
INSERT INTO LifetimeTech VALUES('region','etl',10.0,NULL);
CREATE TABLE OutputBuiltCapacity
(
    scenario TEXT,
    region   TEXT,
    sector   TEXT
        REFERENCES SectorLabel (sector),
    tech     TEXT
        REFERENCES Technology (tech),
    vintage  INTEGER
        REFERENCES TimePeriod (period),
    capacity REAL,
    PRIMARY KEY (region, scenario, tech, vintage)
);
INSERT INTO OutputBuiltCapacity VALUES('zulu','region','energy','etl',2045,150.0);
INSERT INTO OutputBuiltCapacity VALUES('zulu','region','energy','etl',2035,150.0);
INSERT INTO OutputBuiltCapacity VALUES('zulu','region','energy','etl',2025,150.0);
INSERT INTO OutputBuiltCapacity VALUES('zulu','region','energy','ordinary',2025,150.0);
INSERT INTO OutputBuiltCapacity VALUES('zulu','region','energy','ordinary',2045,150.0);
INSERT INTO OutputBuiltCapacity VALUES('zulu','region','energy','ordinary',2035,150.0);
CREATE TABLE OutputCost
(
    scenario TEXT,
    region   TEXT,
    sector   TEXT REFERENCES SectorLabel (sector),
    period   INTEGER REFERENCES TimePeriod (period),
    tech     TEXT REFERENCES Technology (tech),
    vintage  INTEGER REFERENCES TimePeriod (period),
    d_invest REAL,
    d_fixed  REAL,
    d_var    REAL,
    d_emiss  REAL,
    invest   REAL,
    fixed    REAL,
    var      REAL,
    emiss    REAL,
    PRIMARY KEY (scenario, region, period, tech, vintage),
    FOREIGN KEY (vintage) REFERENCES TimePeriod (period),
    FOREIGN KEY (tech) REFERENCES Technology (tech)
);
INSERT INTO OutputCost VALUES('zulu','region','energy',2025,'etl',2025,22.860138000000000957,0.0,0.0,0.0,29.604924553416832821,0.0,0.0,0.0);
INSERT INTO OutputCost VALUES('zulu','region','energy',2025,'ordinary',2025,14.999999999999995559,0.0,0.0,0.0,19.425686244818493264,0.0,0.0,0.0);
INSERT INTO OutputCost VALUES('zulu','region','energy',2035,'etl',2035,5.8923755055835123073,0.0,0.0,0.0,12.429925253874605228,0.0,0.0,0.0);
INSERT INTO OutputCost VALUES('zulu','region','energy',2035,'ordinary',2035,9.2086988031113836683,0.0,0.0,0.0,19.425686244818493264,0.0,0.0,0.0);
INSERT INTO OutputCost VALUES('zulu','region','energy',2045,'etl',2045,2.718478475300753594,0.0,0.0,0.0,9.3410778356794335053,0.0,0.0,0.0);
INSERT INTO OutputCost VALUES('zulu','region','energy',2045,'ordinary',2045,5.653342243095004882,0.0,0.0,0.0,19.425686244818493264,0.0,0.0,0.0);
CREATE TABLE OutputCurtailment
(
    scenario    TEXT,
    region      TEXT,
    sector      TEXT,
    period      INTEGER
        REFERENCES TimePeriod (period),
    season      TEXT
        REFERENCES TimePeriod (period),
    tod         TEXT
        REFERENCES TimeOfDay (tod),
    input_comm  TEXT
        REFERENCES Commodity (name),
    tech        TEXT
        REFERENCES Technology (tech),
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    output_comm TEXT
        REFERENCES Commodity (name),
    curtailment REAL,
    PRIMARY KEY (region, scenario, period, season, tod, input_comm, tech, vintage, output_comm)
);
CREATE TABLE OutputDualVariable
(
    scenario        TEXT,
    constraint_name TEXT,
    dual            REAL,
    PRIMARY KEY (constraint_name, scenario)
);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2040,S,D,etl,2040]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2045,S,D,ordinary,2045]',-0.037688947999999999893);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2040,S,D,ordinary,2040]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2030,S,D,etl,2025]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2050,S,D,etl,2045]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2025,S,D,etl,2025]',-0.057294874000000008962);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2035,S,D,etl,2030]',-0.029520765999999998285);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2045,S,D,etl,2040]',-0.01812319000000000102);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2035,S,D,ordinary,2030]',-0.061391324999999996592);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2030,S,D,ordinary,2025]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2025,S,D,ordinary,2025]',-0.1);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2050,S,D,etl,2050]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2030,S,D,etl,2030]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2050,S,D,ordinary,2045]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2040,S,D,etl,2035]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2035,S,D,etl,2035]',-0.029520765999999998285);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2045,S,D,etl,2045]',-0.01812319000000000102);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2045,S,D,ordinary,2040]',-0.037688947999999999893);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2040,S,D,ordinary,2035]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2035,S,D,ordinary,2035]',-0.061391324999999996592);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2030,S,D,ordinary,2030]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityConstraint[region,2050,S,D,ordinary,2050]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2040,ordinary]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2035,ordinary]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2030,ordinary]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2025,ordinary]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2050,ordinary]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2045,ordinary]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2030,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2025,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2050,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2045,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2040,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','CapacityAvailableByPeriodAndTechConstraint[region,2035,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLPeriodCostConstraint[region,2030,etl]',0.61391324999999996592);
INSERT INTO OutputDualVariable VALUES('zulu','ETLPeriodCostConstraint[region,2025,etl]',1.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLPeriodCostConstraint[region,2050,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLPeriodCostConstraint[region,2045,etl]',0.37688947999999999893);
INSERT INTO OutputDualVariable VALUES('zulu','ETLPeriodCostConstraint[region,2040,etl]',0.37688947999999999893);
INSERT INTO OutputDualVariable VALUES('zulu','ETLPeriodCostConstraint[region,2035,etl]',0.61391324999999996592);
INSERT INTO OutputDualVariable VALUES('zulu','ETLSegmentSwitchConstraint[region,2030,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLSegmentSwitchConstraint[region,2025,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLSegmentSwitchConstraint[region,2050,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLSegmentSwitchConstraint[region,2045,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLSegmentSwitchConstraint[region,2040,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLSegmentSwitchConstraint[region,2035,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2035,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2045,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2035,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2045,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2050,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2040,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2050,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2040,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2025,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2025,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2030,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2045,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2030,etl,6]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2035,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2030,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2045,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2035,etl,6]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2035,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2045,etl,6]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2040,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2050,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2040,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2050,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2025,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2025,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2030,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2045,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2035,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2030,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2045,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2035,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2050,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2040,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2050,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2040,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2050,etl,6]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2040,etl,6]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2025,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2025,etl,6]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2025,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2030,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityLowerBoundConstraint[region,2030,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2035,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2045,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2035,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2045,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2050,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2040,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2050,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2040,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2025,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2025,etl,5]',-0.0092086561000000006771);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2030,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2045,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2030,etl,6]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2035,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2030,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2045,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2035,etl,6]',-0.0034192730000000000067);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2035,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2045,etl,6]',-0.0054369568999999993152);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2040,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2050,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2040,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2050,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2025,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2025,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2030,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2045,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2035,etl,2]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2030,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2045,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2035,etl,5]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2050,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2040,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2050,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2040,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2050,etl,6]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2040,etl,6]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2025,etl,0]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2025,etl,6]',-0.014778291000000001176);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2025,etl,3]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2030,etl,1]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityUpperBoundConstraint[region,2030,etl,4]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityConstraint[region,2030,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityConstraint[region,2025,etl]',-0.02777410699999999899);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityConstraint[region,2050,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityConstraint[region,2045,etl]',-0.01812319000000000102);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityConstraint[region,2040,etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','ETLCapacityConstraint[region,2035,etl]',-0.011397577000000000957);
INSERT INTO OutputDualVariable VALUES('zulu','AnnualRetirementConstraint[region,2045,etl,2035]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AnnualRetirementConstraint[region,2035,ordinary,2025]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AnnualRetirementConstraint[region,2035,etl,2025]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AnnualRetirementConstraint[region,2050,etl,2040]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AnnualRetirementConstraint[region,2040,ordinary,2030]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AnnualRetirementConstraint[region,2040,etl,2030]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AnnualRetirementConstraint[region,2045,ordinary,2035]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AnnualRetirementConstraint[region,2050,ordinary,2040]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2045,etl,2045]',-0.01812319000000000102);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2045,ordinary,2045]',-0.037688947999999999893);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2040,etl,2040]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2025,etl,2025]',-0.057294874000000008962);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2035,ordinary,2030]',-0.061391324999999996592);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2030,ordinary,2030]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2035,etl,2035]',-0.029520765999999998285);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2040,ordinary,2040]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2025,ordinary,2025]',-0.1);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2050,etl,2045]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2050,ordinary,2045]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2030,etl,2025]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2035,ordinary,2035]',-0.061391324999999996592);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2045,etl,2040]',-0.01812319000000000102);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2040,etl,2035]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2045,ordinary,2040]',-0.037688947999999999893);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2050,etl,2050]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2050,ordinary,2050]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2030,etl,2030]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2030,ordinary,2025]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2035,etl,2030]',-0.029520765999999998285);
INSERT INTO OutputDualVariable VALUES('zulu','AdjustedCapacityConstraint[region,2040,ordinary,2035]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2025,dem_etl]',0.057294874000000008962);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2030,dem_etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2035,dem_etl]',0.029520765999999998285);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2040,dem_etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2045,dem_etl]',0.01812319000000000102);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2050,dem_etl]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2025,dem_ordinary]',0.1);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2030,dem_ordinary]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2035,dem_ordinary]',0.061391324999999996592);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2040,dem_ordinary]',0.0);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2045,dem_ordinary]',0.037688947999999999893);
INSERT INTO OutputDualVariable VALUES('zulu','DemandConstraint[region,2050,dem_ordinary]',0.0);
CREATE TABLE OutputEmission
(
    scenario  TEXT,
    region    TEXT,
    sector    TEXT
        REFERENCES SectorLabel (sector),
    period    INTEGER
        REFERENCES TimePeriod (period),
    emis_comm TEXT
        REFERENCES Commodity (name),
    tech      TEXT
        REFERENCES Technology (tech),
    vintage   INTEGER
        REFERENCES TimePeriod (period),
    emission  REAL,
    PRIMARY KEY (region, scenario, period, emis_comm, tech, vintage)
);
CREATE TABLE OutputFlowIn
(
    scenario    TEXT,
    region      TEXT,
    sector      TEXT
        REFERENCES SectorLabel (sector),
    period      INTEGER
        REFERENCES TimePeriod (period),
    season TEXT
        REFERENCES SeasonLabel (season),
    tod         TEXT
        REFERENCES TimeOfDay (tod),
    input_comm  TEXT
        REFERENCES Commodity (name),
    tech        TEXT
        REFERENCES Technology (tech),
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    output_comm TEXT
        REFERENCES Commodity (name),
    flow        REAL,
    PRIMARY KEY (region, scenario, period, season, tod, input_comm, tech, vintage, output_comm)
);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2030,'S','D','ethos','etl',2025,'dem_etl',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2035,'S','D','ethos','ordinary',2035,'dem_ordinary',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2045,'S','D','ethos','etl',2045,'dem_etl',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2025,'S','D','ethos','ordinary',2025,'dem_ordinary',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2045,'S','D','ethos','ordinary',2045,'dem_ordinary',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2035,'S','D','ethos','etl',2035,'dem_etl',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2040,'S','D','ethos','ordinary',2035,'dem_ordinary',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2025,'S','D','ethos','etl',2025,'dem_etl',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2050,'S','D','ethos','etl',2045,'dem_etl',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2040,'S','D','ethos','etl',2035,'dem_etl',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2050,'S','D','ethos','ordinary',2045,'dem_ordinary',150.0);
INSERT INTO OutputFlowIn VALUES('zulu','region','energy',2030,'S','D','ethos','ordinary',2025,'dem_ordinary',150.0);
CREATE TABLE OutputFlowOut
(
    scenario    TEXT,
    region      TEXT,
    sector      TEXT
        REFERENCES SectorLabel (sector),
    period      INTEGER
        REFERENCES TimePeriod (period),
    season TEXT
        REFERENCES SeasonLabel (season),
    tod         TEXT
        REFERENCES TimeOfDay (tod),
    input_comm  TEXT
        REFERENCES Commodity (name),
    tech        TEXT
        REFERENCES Technology (tech),
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    output_comm TEXT
        REFERENCES Commodity (name),
    flow        REAL,
    PRIMARY KEY (region, scenario, period, season, tod, input_comm, tech, vintage, output_comm)
);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2030,'S','D','ethos','etl',2025,'dem_etl',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2035,'S','D','ethos','ordinary',2035,'dem_ordinary',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2045,'S','D','ethos','etl',2045,'dem_etl',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2025,'S','D','ethos','ordinary',2025,'dem_ordinary',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2045,'S','D','ethos','ordinary',2045,'dem_ordinary',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2035,'S','D','ethos','etl',2035,'dem_etl',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2040,'S','D','ethos','ordinary',2035,'dem_ordinary',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2025,'S','D','ethos','etl',2025,'dem_etl',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2050,'S','D','ethos','etl',2045,'dem_etl',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2040,'S','D','ethos','etl',2035,'dem_etl',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2050,'S','D','ethos','ordinary',2045,'dem_ordinary',150.0);
INSERT INTO OutputFlowOut VALUES('zulu','region','energy',2030,'S','D','ethos','ordinary',2025,'dem_ordinary',150.0);
CREATE TABLE OutputNetCapacity
(
    scenario TEXT,
    region   TEXT,
    sector   TEXT
        REFERENCES SectorLabel (sector),
    period   INTEGER
        REFERENCES TimePeriod (period),
    tech     TEXT
        REFERENCES Technology (tech),
    vintage  INTEGER
        REFERENCES TimePeriod (period),
    capacity REAL,
    PRIMARY KEY (region, scenario, period, tech, vintage)
);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2045,'etl',2045,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2045,'ordinary',2045,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2025,'etl',2025,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2035,'etl',2035,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2025,'ordinary',2025,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2050,'etl',2045,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2050,'ordinary',2045,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2030,'etl',2025,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2035,'ordinary',2035,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2040,'etl',2035,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2030,'ordinary',2025,150.0);
INSERT INTO OutputNetCapacity VALUES('zulu','region','energy',2040,'ordinary',2035,150.0);
CREATE TABLE OutputObjective
(
    scenario          TEXT,
    objective_name    TEXT,
    total_system_cost REAL
);
INSERT INTO OutputObjective VALUES('zulu','TotalCost',61.333033027090646527);
CREATE TABLE OutputRetiredCapacity
(
    scenario TEXT,
    region   TEXT,
    sector   TEXT
        REFERENCES SectorLabel (sector),
    period   INTEGER
        REFERENCES TimePeriod (period),
    tech     TEXT
        REFERENCES Technology (tech),
    vintage  INTEGER
        REFERENCES TimePeriod (period),
    cap_eol REAL,
    cap_early REAL,
    PRIMARY KEY (region, scenario, period, tech, vintage)
);
INSERT INTO OutputRetiredCapacity VALUES('zulu','region','energy',2035,'etl',2025,150.0,0.0);
INSERT INTO OutputRetiredCapacity VALUES('zulu','region','energy',2045,'etl',2035,150.0,0.0);
INSERT INTO OutputRetiredCapacity VALUES('zulu','region','energy',2035,'ordinary',2025,150.0,0.0);
INSERT INTO OutputRetiredCapacity VALUES('zulu','region','energy',2045,'ordinary',2035,150.0,0.0);
CREATE TABLE OutputStorageLevel
(
    scenario TEXT,
    region TEXT,
    sector TEXT
        REFERENCES SectorLabel (sector),
    period INTEGER
        REFERENCES TimePeriod (period),
    season TEXT
        REFERENCES SeasonLabel (season),
    tod TEXT
        REFERENCES TimeOfDay (tod),
    tech TEXT
        REFERENCES Technology (tech),
    vintage INTEGER
        REFERENCES TimePeriod (period),
    level REAL,
    PRIMARY KEY (scenario, region, period, season, tod, tech, vintage)
);
CREATE TABLE Region
(
    region TEXT
        PRIMARY KEY,
    notes  TEXT
);
INSERT INTO Region VALUES('region',NULL);
CREATE TABLE SectorLabel
(
    sector TEXT PRIMARY KEY,
    notes  TEXT
);
INSERT INTO SectorLabel VALUES('energy',NULL);
CREATE TABLE Technology
(
    tech         TEXT    NOT NULL PRIMARY KEY,
    flag         TEXT    NOT NULL,
    sector       TEXT,
    category     TEXT,
    sub_category TEXT,
    unlim_cap    INTEGER NOT NULL DEFAULT 0,
    annual       INTEGER NOT NULL DEFAULT 0,
    reserve      INTEGER NOT NULL DEFAULT 0,
    curtail      INTEGER NOT NULL DEFAULT 0,
    retire       INTEGER NOT NULL DEFAULT 0,
    flex         INTEGER NOT NULL DEFAULT 0,
    exchange     INTEGER NOT NULL DEFAULT 0,
    seas_stor    INTEGER NOT NULL DEFAULT 0,
    description  TEXT,
    FOREIGN KEY (flag) REFERENCES TechnologyType (label)
);
INSERT INTO Technology VALUES('ordinary','p','energy',NULL,NULL,0,0,0,0,0,0,0,0,NULL);
INSERT INTO Technology VALUES('etl','p','energy',NULL,NULL,0,0,0,0,0,0,0,0,NULL);
CREATE TABLE TechnologyType
(
    label       TEXT
        PRIMARY KEY,
    description TEXT
);
INSERT INTO TechnologyType VALUES('p','production technology');
CREATE TABLE TimePeriod
(
    sequence INTEGER UNIQUE,
    period   INTEGER
        PRIMARY KEY,
    flag     TEXT
        REFERENCES TimePeriodType (label)
);
INSERT INTO TimePeriod VALUES(-1,2020,'e');
INSERT INTO TimePeriod VALUES(0,2025,'f');
INSERT INTO TimePeriod VALUES(1,2030,'f');
INSERT INTO TimePeriod VALUES(2,2035,'f');
INSERT INTO TimePeriod VALUES(3,2040,'f');
INSERT INTO TimePeriod VALUES(4,2045,'f');
INSERT INTO TimePeriod VALUES(5,2050,'f');
INSERT INTO TimePeriod VALUES(6,2055,'f');
CREATE TABLE TimePeriodType
(
    label       TEXT
        PRIMARY KEY,
    description TEXT
);
INSERT INTO TimePeriodType VALUES('e','existing vintages');
INSERT INTO TimePeriodType VALUES('f','future');
CREATE TABLE ETLSegment (
	region TEXT,
	tech_or_group TEXT,
	segment INTEGER,
	cap_lower REAL,
	cap_upper REAL,
	cost_lower REAL,
	cost_upper REAL,
	PRIMARY KEY (region, tech_or_group, segment)
);
INSERT INTO ETLSegment VALUES('region','etl',0,0.0,10.0,0.0,6.299456091999999785);
INSERT INTO ETLSegment VALUES('region','etl',1,10.0,20.0,6.299456091999999785,8.8192385279999996328);
INSERT INTO ETLSegment VALUES('region','etl',2,20.0,50.0,8.8192385279999996328,13.759474400000000215);
INSERT INTO ETLSegment VALUES('region','etl',3,50.0,100.0,13.759474400000000215,19.263264169999999353);
INSERT INTO ETLSegment VALUES('region','etl',4,100.0,250.0,19.263264169999999353,30.053886099999997938);
INSERT INTO ETLSegment VALUES('region','etl',5,250.0,500.0,30.053886099999997938,42.075440540000004219);
INSERT INTO ETLSegment VALUES('region','etl',6,500.0,1000.0,42.075440540000004219,58.905616759999999132);
COMMIT;

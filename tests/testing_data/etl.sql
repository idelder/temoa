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
CREATE TABLE ETLSegment
(
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
CREATE TABLE OutputObjective
(
    scenario          TEXT,
    objective_name    TEXT,
    total_system_cost REAL
);
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
COMMIT;

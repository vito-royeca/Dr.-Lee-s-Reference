create table AppDoc
(
    AppDocID integer Primary Key,
    ApplNo  text NOT NULL,
    SeqNo text NOT NULL,
    DocType text NOT NULL,
    DocTitle text,
    DocURL text NOT NULL,
    DocDate text NOT NULL,
    ActionType text NOT NULL,
    DuplicateCounter integer
);
.separator \t
.import AppDoc.csv AppDoc

create table AppDocType_Lookup
(
    AppDocType text Primary Key,
    SortOrder integer NOT NULL
);
.separator \t
.import AppDocType_Lookup.csv AppDocType_Lookup

create table Application
(
    ApplNo text references AppDoc(ApplNo) ON DELETE CASCADE ON UPDATE CASCADE,
    ApplType text NOT NULL, --(A=ANDA, N=NDA, B=BLA)
    SponsorApplicant text NOT NULL,
    MostRecentLabelAvailableFlag integer NOT NULL,
    CurrentPatentFlag integer NOT NULL,
    ActionType text NOT NULL,
    Chemical_Type text references ChemicalType_Lookup(ChemicalTypeID) ON DELETE CASCADE ON UPDATE CASCADE,
    Therapeutic_Potential text,
    Orphan_Code text
);
.separator \t
.import application.csv Application

create table DocType_Lookup
(
    DocType  text Primary Key,
    DocTypeDesc text
);
.separator \t
.import DocType_lookup.csv DocType_Lookup

create table Product
(
    ApplNo text references AppDoc(ApplNo) ON DELETE CASCADE ON UPDATE CASCADE,
    ProductNo text, --(Primary Key)
    Form text,
    Dosage text,
    ProductMktStatus integer, --(1=prescription, 2=OTC, 3=discontinued, 4=tentative approval) (Primary Key)
    TECode text,
    ReferenceDrug integer, --(0=not RLD, 1=RLD, 2=TBD)
    Drugname text,
    Activeingred text
);
.separator \t
.import Product.csv Product

create table Product_TECode
(
    ApplNo text references AppDoc(ApplNo) ON DELETE CASCADE ON UPDATE CASCADE,
    ProductNo text, --(Primary Key)
    TECode text NOT NULL,
    TESequence integer, --(Primary Key)
    ProdMktStatus integer --(Primary Key)
);
.separator \t
.import Product_tecode.csv Product_TECode

create table RegActionDate
(
    ApplNo  text references AppDoc(ApplNo) ON DELETE CASCADE ON UPDATE CASCADE,
    ActionType text NOT NULL,
    InDocTypeSeqNo text, --(Primary Key)
    DuplicateCounter integer, --(Primary Key)
    ActionDate text,
    DocType text
);
.separator \t
.import RegActionDate.csv RegActionDate

create table ChemicalType_Lookup
(
    ChemicalTypeID integer Primary Key,
    ChemicalTypeCode text NOT NULL,
    ChemicalTypeDescription text
);
.separator \t
.import ChemTypeLookup.csv ChemicalType_Lookup

create table ReviewClass_Lookup
(
    ReviewClassID integer Primary Key,
    ReviewCode text NOT NULL,
    LongDescritption text,
    ShortDescription text NOT NULL
);
.separator \t
.import ReviewClass_Lookup.csv ReviewClass_Lookup

-- ------------------------------------------------------------------------------------------------
-- Descripcion: Script de creacion de los tipos y de la tabla RO
-- Autor: Kevin Alonso Escobar Miranda - Moises Ernesto Viales Espinoza - Marcos Calderon Badilla
-- Fecha: 09/06/2015
-- ------------------------------------------------------------------------------------------------
CREATE OR REPLACE TYPE LINEAFACTURA_RO_TYPE
AS
  OBJECT
  (
    CODARTICULO       VARCHAR2 (30) ,
    DESCRIPCION       VARCHAR2 (256) ,
    PRECIOMERCDOLARES NUMBER (17,2) ,
    UNDMEDIDA         VARCHAR2 (10) ,
    MARCA             VARCHAR2 (30) ,
    FAMILIA           VARCHAR2 (30) ,
    CANTIDAD          NUMBER (10) ,
    CANTMAXIMA        NUMBER (10) ,
    CANTMINIMA        NUMBER (10) ,
    ESTADOARTICULO    VARCHAR2 (30) ) NOT FINAL ;
  /

CREATE OR REPLACE TYPE LISTALINEASFACTURA_RO
IS
  TABLE OF LINEAFACTURA_RO_TYPE ;
  /

CREATE OR REPLACE TYPE FACTURACOMPRAS_RO_TYPE
AS
  OBJECT
  (
    NUMEROFACTURA NUMBER (10) ,
    FECREGISTRO   DATE ,
    FECCOMPRA     DATE ,
    PROVEEDOR     VARCHAR2 (30) ,
    USUARIO       VARCHAR2 (30) ,
    LISTA_LINEASFACTURA LISTALINEASFACTURA_RO ) NOT FINAL ;
  /

CREATE TABLE FACTURAS_RO_TABLE OF FACTURACOMPRAS_RO_TYPE
  (
    NUMEROFACTURA NOT NULL
  )  NESTED TABLE LISTA_LINEASFACTURA STORE AS LISTA_LINEASFACTURA ;


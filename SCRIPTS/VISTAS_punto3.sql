-- ------------------------------------------------------------------------------------------------
-- Descripcion: cada fila de la vista es un documento XML que corresponde a una factura y sus líneas a partir de 
--              las tablas (factura y lineaFactura). La consulta debe retornar las facturas en orden ascendente por fecha.
-- Autor: Kevin Alonso Escobar Miranda - Moises Ernesto Viales Espinoza - Marcos Calderon Badilla
-- Fecha: 12/06/2015
-- ------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW FACTURAS_XML_VIEW OF xmltype
WITH OBJECT ID (
  extractValue(OBJECT_VALUE, '/FacturaCompra/NumeroFactura'))
AS
  SELECT
  XMLElement("FacturaCompra",
    XMLElement("NumeroFactura",FRT.NumeroFactura),
    XMLElement("FechaCompra",FRT.FecCompra),
    XMLElement("Proveedor",FRT.Proveedor),
    XMLElement("Usuario",FRT.Usuario),
    XMLElement("LineasArticulo",
      XMLAgg(
        XMLElement("LineaArticulo",
          XMLElement("Articulo",
            XMLAttributes(
              L.CodArticulo       AS "Codigo",
              L.Descripcion       AS "Descripcion",
              L.PrecioMercDolares AS "PrecioMercDolares",
              L.UndMedida         AS "UnidadMedida",
              L.Marca             AS "Marca",
              L.Familia           AS "Familia",
              L.Cantidad          AS "Cantidad",
              L.CantMaxima        AS "CantMaxima",
              L.CantMinima        AS "CantMinima",
              L.EstadoArticulo    AS "EstadoArticulo"
            )
          )
        )
      )
    )
  )
FROM facturas_ro_table FRT, TABLE(FRT.lista_lineasfactura) L group by FRT.NumeroFactura,FRT.FecCompra,FRT.Proveedor,FRT.Usuario order by FRT.FecCompra ASC
;
/

select * from FACTURAS_XML_VIEW;




-- ================================================================================================================
-- --------------------------------------------------------------------------------------------PUNTO #3
-- Realice un procedimiento almacenado que defina una vista XML, donde cada fila de
-- la vista es un documento XML que corresponde a una factura y sus líneas a partir de
-- las tablas (factura y lineaFactura). La consulta debe retornar las facturas en orden
-- ascendente por fecha.
-- -----------------------------------------------------------------------------------------------------
create or replace PROCEDURE SP_XML_VIEW_PUNTO_3 (
    CURFACTURAS_XML OUT SYS_REFCURSOR
) IS
BEGIN
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE VIEW FACTURAS_XML_VIEW OF xmltype
WITH OBJECT ID (
  extractValue(OBJECT_VALUE, ''/FacturaCompra/NumeroFactura''))
AS
  SELECT
  XMLElement("FacturaCompra",
    XMLElement("NumeroFactura",FRT.NumeroFactura),
    XMLElement("FechaCompra",FRT.FecCompra),
    XMLElement("Proveedor",FRT.Proveedor),
    XMLElement("Usuario",FRT.Usuario),
    XMLElement("LineasArticulo",
      XMLAgg(
        XMLElement("LineaArticulo",
          XMLElement("Articulo",
            XMLAttributes(
              L.CodArticulo       AS "Codigo",
              L.Descripcion       AS "Descripcion",
              L.PrecioMercDolares AS "PrecioMercDolares",
              L.UndMedida         AS "UnidadMedida",
              L.Marca             AS "Marca",
              L.Familia           AS "Familia",
              L.Cantidad          AS "Cantidad",
              L.CantMaxima        AS "CantMaxima",
              L.CantMinima        AS "CantMinima",
              L.EstadoArticulo    AS "EstadoArticulo"
            )
          )
        )
      )
    )
  )
FROM facturas_ro_table FRT, TABLE(FRT.lista_lineasfactura) L group by FRT.NumeroFactura,FRT.FecCompra,FRT.Proveedor,FRT.Usuario order by FRT.FecCompra ASC
    ';
    
    OPEN CURFACTURAS_XML FOR
      SELECT * FROM FACTURAS_XML_VIEW;

END;
/

VARIABLE CURFACTURAS_XML REFCURSOR;
EXEC SP_XML_VIEW_PUNTO_3(:CURFACTURAS_XML);
PRINT CURFACTURAS_XML;

-- ------------------------------------------------------------------------------------------------
-- Descripcion: Muestra todo lo que tiene FACTURAS_TABLE (Tabla xml que se genera al subir un archivo)
-- Autor: Kevin Alonso Escobar Miranda - Moises Ernesto Viales Espinoza - Marcos Calderon Badilla
-- Fecha: 12/06/2015
-- ------------------------------------------------------------------------------------------------
create or replace view  FACTURAS_VIEW
                        (NumeroFactura,  FecCompra,  Proveedor, Usuario)
as
  select
          extractValue(object_value, '/FacturaCompra/NumeroFactura'),
          extractValue(object_value, '/FacturaCompra/FechaCompra'),
          extractValue(object_value, '/FacturaCompra/Proveedor'),
          extractValue(object_value, '/FacturaCompra/Usuario')
    from  FACTURAS_TABLE;
/


create or replace view  LINEASFACTURAS_VIEW
                        (NumeroFactura, Codigo, Cantidad, CantMaxima, CantMinima,
                        Descripcion, EstadoArticulo, Familia, Marca, PrecioMercDolares, UnidadMedida)
as
  select
          extractValue(object_value, '/FacturaCompra/NumeroFactura'),
          extractValue(value(l), '/Articulo/@Codigo'),
          extractValue(value(l), '/Articulo/@Cantidad'),
          extractValue(value(l), '/Articulo/@CantMaxima'),
          extractValue(value(l), '/Articulo/@CantMinima'),
          extractValue(value(l), '/Articulo/@Descripcion'),
          extractValue(value(l), '/Articulo/@EstadoArticulo'),
          extractValue(value(l), '/Articulo/@Familia'),
          extractValue(value(l), '/Articulo/@Marca'),
          extractValue(value(l), '/Articulo/@PrecioMercDolares'),
          extractValue(value(l), '/Articulo/@UnidadMedida')
    from  FACTURAS_TABLE,
          table(xmlsequence(extract(object_value,'FacturaCompra/LineasFactura/LineaFactura/Articulo'))) l;
/

SELECT * FROM FACTURAS_VIEW
select Lista_LineasFactura FROM FACTURAS_RO_TABLE


-- ================================================================================================================
-- --------------------------------------------------------------------------------------------PUNTO #4
-- Defina las vistas que sean necesarias sobre esos documentos  almacenados en  la base 
-- datos, tal que permita su utilización como si fueran las tablas. Realice un
-- procedimiento  almacenado que utilice las vistas definidas y  retorne los datos 
-- solicitados en la consulta del punto 3
-- -----------------------------------------------------------------------------------------------------
create or replace PROCEDURE SP_DEFINE_XML_VIEW (
    CURFACTURAS OUT SYS_REFCURSOR,
    CURLINFACTURAS OUT SYS_REFCURSOR
) IS
BEGIN
    EXECUTE IMMEDIATE '
        create or replace view  FACTURAS_VIEW
                        (NumeroFactura,  FecCompra,  Proveedor, Usuario)
        as
          select
                  extractValue(object_value, ''/FacturaCompra/NumeroFactura''),
                  extractValue(object_value, ''/FacturaCompra/FechaCompra''),
                  extractValue(object_value, ''/FacturaCompra/Proveedor''),
                  extractValue(object_value, ''/FacturaCompra/Usuario'')
            from  FACTURAS_TABLE
    ';
    
    EXECUTE IMMEDIATE '
        create or replace view  LINEASFACTURAS_VIEW
                        (NumeroFactura, Codigo, Cantidad, CantMaxima, CantMinima,
                        Descripcion, EstadoArticulo, Familia, Marca, PrecioMercDolares, UnidadMedida)
        as
          select
                  extractValue(object_value, ''/FacturaCompra/NumeroFactura''),
                  extractValue(value(l), ''/Articulo/@Codigo''),
                  extractValue(value(l), ''/Articulo/@Cantidad''),
                  extractValue(value(l), ''/Articulo/@CantMaxima''),
                  extractValue(value(l), ''/Articulo/@CantMinima''),
                  extractValue(value(l), ''/Articulo/@Descripcion''),
                  extractValue(value(l), ''/Articulo/@EstadoArticulo''),
                  extractValue(value(l), ''/Articulo/@Familia''),
                  extractValue(value(l), ''/Articulo/@Marca''),
                  extractValue(value(l), ''/Articulo/@PrecioMercDolares''),
                  extractValue(value(l), ''/Articulo/@UnidadMedida'')
            from  FACTURAS_TABLE,
                  table(xmlsequence(extract(object_value,''FacturaCompra/LineasFactura/LineaFactura/Articulo''))) l
    ';
    OPEN CURFACTURAS FOR
      SELECT * FROM FACTURAS_VIEW;
      
    OPEN CURLINFACTURAS FOR
      SELECT * FROM LINEASFACTURAS_VIEW;
END;
/
VARIABLE FACTHEADER REFCURSOR;
VARIABLE FACTLINEAS REFCURSOR;
EXEC SP_DEFINE_XML_VIEW(:FACTHEADER, :FACTLINEAS);
PRINT FACTHEADER;
PRINT FACTLINEAS;
-- ================================================================================================================
-- ================================================================================================================
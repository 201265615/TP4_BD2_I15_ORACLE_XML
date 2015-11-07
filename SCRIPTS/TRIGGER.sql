-- ------------------------------------------------------------------------------------------------
-- Nombre: AFT_INS_GUARDAR_FACTURA_LINEAS
-- Trabaja sobre la tabla FACTURAS_TABLE que posee los registro XML
-- Descripcion: TRIGGER que después de la inserción registre los datos insertados en las tablas (factura y líneaFactura)
-- Autor: Kevin Alonso Escobar Miranda - Moises Ernesto Viales Espinoza - Marcos Calderon Badilla
-- Fecha: 2015
-- ------------------------------------------------------------------------------------------------
create or replace TRIGGER AFT_INS_GUARDAR_FACTURA_LINEAS 
AFTER INSERT ON FACTURAS_TABLE
FOR EACH ROW
DECLARE
	var_NumeroFactura NUMBER(10);
BEGIN
    SELECT EXTRACTVALUE(:NEW.OBJECT_VALUE, '/FacturaCompra/NumeroFactura') INTO var_NumeroFactura FROM DUAL;
    INSERT INTO FACTURAS_RO_TABLE VALUES(
          EXTRACTVALUE(:NEW.OBJECT_VALUE, '/FacturaCompra/NumeroFactura'),
          SYSDATE,
          to_date(EXTRACTVALUE(:NEW.OBJECT_VALUE, '/FacturaCompra/FechaCompra'),'yyyy/mm/dd'),
          EXTRACTVALUE(:NEW.OBJECT_VALUE, '/FacturaCompra/Proveedor'),
          EXTRACTVALUE(:NEW.OBJECT_VALUE, '/FacturaCompra/Usuario'),
          LISTALINEASFACTURA_RO()
        );
    -- LINEAS DE FACTURA
	FOR R IN (
    SELECT
      ExtractValue(Value(P),'/LineaFactura/Articulo/@Codigo') as Codigo,
      ExtractValue(Value(P),'/LineaFactura/Articulo/@Cantidad') as Cantidad,
      ExtractValue(Value(P),'/LineaFactura/Articulo/@CantMaxima') as CantMaxima,
      ExtractValue(Value(P),'/LineaFactura/Articulo/@CantMinima') as CantMinima,
      ExtractValue(Value(P),'/LineaFactura/Articulo/@Descripcion') as Descripcion,
      ExtractValue(Value(P),'/LineaFactura/Articulo/@EstadoArticulo') as EstadoArticulo,
      ExtractValue(Value(P),'/LineaFactura/Articulo/@Familia') as Familia,
      ExtractValue(Value(P),'/LineaFactura/Articulo/@Marca') as Marca,
      ExtractValue(Value(P),'/LineaFactura/Articulo/@PrecioMercDolares') as PrecioMercDolares,
      ExtractValue(Value(P),'/LineaFactura/Articulo/@UnidadMedida') as UnidadMedida
    FROM TABLE(XMLSEQUENCE(EXTRACT(:NEW.object_value,'/FacturaCompra/LineasFactura/LineaFactura'))) P
  ) LOOP
      INSERT INTO TABLE(
				SELECT FRT.LISTA_LINEASFACTURA 
				FROM FACTURAS_RO_TABLE FRT 
				WHERE FRT.NUMEROFACTURA = var_NumeroFactura
			) VALUES (
        R.Codigo,
        R.Descripcion,
        R.PrecioMercDolares,
        R.UnidadMedida,
        R.Marca,
        R.Familia,
        R.Cantidad,
        R.CantMaxima,
        R.CantMinima,
        R.EstadoArticulo);
  END LOOP;
END;
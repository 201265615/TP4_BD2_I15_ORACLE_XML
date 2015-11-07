-- ------------------------------------------------------------------------------------------------
-- Descripcion: Registra un esquema en la base de datos
-- Autor: Jose Stradi
-- Fecha: 2015
-- ------------------------------------------------------------------------------------------------
begin
  dbms_xmlschema.deleteschema(
    schemaurl => 'http://172.19.127.101:9090/grupo01/Facturas/xsd/FacturasCompra.xsd',
    DELETE_OPTION => dbms_xmlschema.delete_cascade_force
  );
end;
/

-- ------------------------------------------------------------------------------------------------
-- Descripcion: Elimina un esquema en la base de datos
-- Autor: Jose Stradi
-- Fecha: 2015
-- ------------------------------------------------------------------------------------------------
begin
  dbms_xmlschema.registerschema(
    schemaurl => 'http://172.19.127.101:9090/grupo01/Facturas/xsd/FacturasCompra.xsd',
    schemadoc =>  xdbURIType('/grupo01/Facturas/xsd/FacturasCompra.xsd').getClob(),
    local => TRUE,
    genTypes => TRUE,
    genBean => FALSE,
    genTables => TRUE
  );
end;
/
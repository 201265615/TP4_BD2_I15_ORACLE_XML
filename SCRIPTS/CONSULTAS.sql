
-- Obtiene el numero de ordenes de compra registradas.
SELECT COUNT(*) FROM FACTURAS_TABLE;

select extract(object_value,'//FacturaCompra/LineasFactura/LineaFactura') LineasFactura from FACTURAS_TABLE;

select extractValue(object_value,'/FacturaCompra/Proveedor') Proveedor from FACTURAS_TABLE where rowid=(select max(rowid) from FACTURAS_TABLE);
-- where existsNode(object_value, '/FacturaCompra/LineasFactura/LineaFactura/Articulo[Codigo = "FP100"]') = 1;


select  extract(object_value,'/FacturaCompra/LineasFactura/LineaFactura/Articulo/@Codigo') codigo from FACTURAS_TABLE;
-- where existsNode(object_value, '/FacturaCompra/LineasFactura/LineaFactura/Articulo[Codigo = "FP100"]') = 1;



-- ------------------------------------------------------------------------------------------------
-- Descripcion: Extrae los atributos de todos articulos de cada linea de la factura
-- Autor: Kevin Alonso Escobar Miranda - Moises Ernesto Viales Espinoza - Marcos Calderon Badilla
-- Fecha: 09/06/2015
-- ------------------------------------------------------------------------------------------------
select extractValue(value(d), 'Articulo/@Codigo') codigo,
  extractValue(value(d), 'Articulo/@Descripcion') descripcion
from FACTURAS_TABLE,
     table(
            xmlsequence(extract(object_value,'/FacturaCompra/LineasFactura/LineaFactura/Articulo'))) d;



-- ------------------------------------------------------------------------------------------------
-- Descripcion: Extrae los atributos de todos articulos de cada linea de la factura de una factura DETERMINADA
-- Autor: Kevin Alonso Escobar Miranda - Moises Ernesto Viales Espinoza - Marcos Calderon Badilla
-- Fecha: 09/06/2015
-- ------------------------------------------------------------------------------------------------
select extractValue(value(d), 'Articulo/@Codigo') codigo,
  extractValue(value(d), 'Articulo/@Descripcion') descripcion
from FACTURAS_TABLE,
     table(
            xmlsequence(extract(object_value,'/FacturaCompra/LineasFactura/LineaFactura/Articulo'))) d
 where  existsNode
       (
           object_value,
           '/FacturaCompra[ NumeroFactura = 2]'
       ) = 1;
       





select extract(object_value,'/FacturaCompra/NumeroFactura') NumeroFactura,
       extract(object_value,'//FacturaCompra/LineasFactura/LineaFactura') LineasFactura
       from FACTURAS_TABLE
       


delete from facturas_ro_table;

delete from facturas_table;

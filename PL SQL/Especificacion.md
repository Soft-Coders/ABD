***Ejercicio 1.*** Cada grupo deberá desarrollar las siguientes funcionalidades. Se espera que en **TODOS** los procedimientos y funciones, donde sea necesario, haya un tratamiento de excepciones.
 
a) Crear un paquete de gestión de clientes`(PK_GESTION_CLIENTES)` que incorpore distintos procesos de gestión de los clientes para proporcionar la funcionalidad necesaria de los distintos requisitos de la aplicación. 
Cada uno de estos procedimientos utilizará como parámetros aquellos que sean necesarios para proporcionar de manera correcta la funcionalidad pretendida. 

1. (RF2) **Alta de un cliente en el sistema**. Este procedimiento permitirá dar de alta a clientes en el sistema. 
Los clientes pueden ser personas físicas o jurídicas. 
2. (RF3) **Modificación de datos de un cliente**. Este procedimiento permitirá modificar los datos de un 
cliente dado mediante el atributo de Identificación. 
3. (RF4) **Baja de un cliente**. Este procedimiento permitirá dar de baja a clientes del banco mediante el 
atributo de Identificación. Los clientes del banco no pueden eliminarse físicamente de la base de datos, ya 
que pueden ser necesarios por motivos de auditorías. La baja de un cliente implicará cambiar los atributos 
de estado y fecha de baja. Solo se puede dar de baja un cliente que no tenga cuentas abiertas. 
4. (RF6) **Añadir autorizados a la cuenta de una persona jurídica**. El procedimiento permitirá añadir personas 
autorizadas a las cuentas que pertenezcan a un cliente que es persona jurídica. El tipo de autorización 
podrá ser `'CONSULTA'` o `'OPERACIÓN'`. Si la persona ya estaba dada de alta en la tabla 
`PERSONA_AUTORIZADA`, solo se inserta su autorización. 
5. (RF7) **Modificación de datos de un autorizado**. El procedimiento permitirá modificar los datos de las 
personas autorizadas a operar con cuentas de clientes que son personas jurídicas. También se puede 
modificar el tipo de autorización. 
6. (RF8) **Eliminar autorizados de una cuenta**. El procedimiento permitirá eliminar la autorización personas 
autorizadas a operar con cuentas cuyos clientes sean personas jurídicas. Estas personas no se eliminan 
del sistema, ya que podría ser necesario que la información conste para alguna auditoría o informe; lo 
que se borra es la autorización. Si ya no hay más autorizaciones para esa persona, entonces se modifican 
los atributos estado, poniéndolo a `'BORRADO'` y `FechaFin` con la fecha del sistema.

b) Crear un paquete de gestión de cuentas `(PK_GESTION_CUENTAS)` que incorpore distintos procesos de gestión 
de las cuentas para proporcionar la funcionalidad necesaria de los distintos requisitos de la aplicación. Cada 
uno de estos procedimientos utilizará como parámetros aquellos que sean necesarios para proporcionar de 
manera correcta la funcionalidad pretendida. 

1. (RF5) **Apertura de una cuenta de cualquiera de los dos tipos considerados**. El procedimiento permitirá la 
apertura de una cuenta. La cuenta podrá ser agrupada (pooled) o segregada (segregated). Ten en cuenta 
que este procedimiento supone la inserción de datos en varias tablas. Además, no se pueden crear 
cuentas de clientes dados de baja (ver RF 4) 
2. (RF9) **Cierre de una cuenta**. El procedimiento permitirá cerrar una cuenta bancaria. Solo se puede cerrar 
una cuenta que tenga saldo 0 (en todas sus divisas). Una cuenta cerrada no se elimina, por si es 
necesario reportarla en algún informe, sino que supone un cambio en los atributos estado y fecha_cierre 
de la tabla correspondiente.
# taller_autofix

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Requisitos Funcionales

ID	Requisito	Rol
RF01	Registrarse e iniciar sesión con correo y contraseña	Ambos
RF02	Registrar, editar y consultar clientes	Empleado
RF03	Registrar, editar y consultar vehículos asociados a un cliente	Empleado
RF04	Agendar, consultar, editar y cancelar citas	Ambos
RF05	Registrar la evaluación de un vehículo (diagnóstico y observaciones)	Empleado
RF06	Crear órdenes de trabajo con diagnóstico, costos y estado	Empleado
RF07	Actualizar el estado de una orden de trabajo	Empleado
RF08	Registrar resultados y recomendaciones al finalizar	Empleado
RF09	Aprobar o rechazar las acciones propuestas antes de proceder	Cliente
RF10	Consultar el estado de reparación de sus vehículos	Cliente
RF11	Consultar el historial de reparaciones de un vehículo	Ambos
RF12	Ver en la pantalla principal las citas y trabajos pendientes	Empleado

Requisitos no funcionales

ID	Requisito
RNF01	App móvil para Android desarrollada en Flutter
RNF02	Datos almacenados en Cloud Firestore
RNF03	Acceso protegido por autenticación y reglas de seguridad según el rol
RNF04	Interfaz simple, con formularios claros y validaciones
RNF05	Las pantallas principales cargan en pocos segundos con conexión normal
RNF06	Código versionado en GitHub

Diseño de colecciones

usuarios (ID del documento = uid de Authentication)
nombre, correo, rol ("empleado" o "cliente"), creadoEn

clientes
nombre, telefono, correo, direccion
usuarioId (uid del cliente si tiene cuenta; puede estar vacío), creadoEn

vehiculos
clienteId, marca, modelo, anio, placa, color, kilometraje
creadoEn

citas
clienteId, vehiculoId
nombreCliente, placa (copias para mostrar en listas)
fecha (timestamp), motivo
estado: programada, confirmada, completada, cancelada

ordenes_trabajo
clienteId, vehiculoId, citaId (opcional)
nombreCliente, placa (copias)
descripcion, diagnostico, costoEstimado, costoFinal
estado: pendiente, en_diagnostico, esperando_aprobacion, en_reparacion, listo, entregado
aprobadaPorCliente (true/false), fechaAprobacion
creadaEn, actualizadaEn

resultados
ordenId, observaciones, diagnosticoFinal, recomendaciones, fecha

Conexiones:

usuarios ──(usuarioId)── clientes ──(clienteId)── vehiculos
                              │                       │
                              └──── citas ────────────┤
                              └──── ordenes_trabajo ──┘
                                          │
                                  resultados (ordenId)

NOTAS SEMANA 1: Se instalaron todas las dependencias y herramientas necesarias para lograr levantar el proyecto y vincularlo con Firebase como base de datos. Cabe mencionar que flutter y firebase nunca han sido usado por mi persona y tampoco se han instalado ni configurado en mi dispositivo , por lo que la instalacion ha tomado una considerable cantidad de tiempo. Se definieron los requisitos funcionales 

# Metodología organizacional SoftSCRUM:
EL workflow base es **feature-branching**
## Pull Requests:
- Todo merge a *main* debe de hacerse mediante *pull request*.
- Opcionalmente se pueden crear *pull requests* para *feature branches* que contengan *sub-features* en las que trabajen varias personas.
### Nomenclatura:
- Se requiere que **todos** los integrantes del grupo revisen y acepten el *pull request* para realizar el *merge*: <br>
  - `MAJOR <Pull Request Name>` <br>
    `@member1 @member2 @member3 ...` <br>
- Se requiere que **alguno** los integrantes citados **en el comentario** revise y acepte el *pull request* para realizar el *merge*.
  - `MINOR <Pull Request Name>` <br>
    `@member1 @member2 @member3 ...` <br>
- Se requiere que **solo** los integrantes citados **en el comentario y título** revisen y acepten el *pull request* para realizar el *merge*.
  - `<member name> <Pull Request Name>` <br>
    `@member1 @member2 @member3 ...` <br>
## Aprobación de Pull Requests
- Síncrono:
  - Reunión de las personas implicadas para aprobar el pull request.
- Asíncrono:
  - Se revisa de manera individual y se comenta si se aprueba o no el request.
  - Cuando la decisión no sea unánime se discute con el resto de implicados si se aprueba o no.
## Sprints
### Sprint Reviews
1. Elección de Sprint master mediante sortea2.
2. Revisión de tareas realizadas en pasado Sprint.
    - Revisión de MAJOR Pull Requests y merged. 
3. Especificación de tareas a realizar para próximo Sprint.
4. Especificar orden de tareas (cuando necesario).
5. Asignación de las tareas.
6. Registro de tareas en GitHub projects.
7. Registro de tareas en Discord channels.
8. Creación de acta Sprint por Sprint master y unificación de actas SCRUM y Sprint del anterior Sprint.

### Resolución de conflictos Mid-Sprint
- Solo altera mi trabajo:
  - Se puede informar mediante Discord o Whatsapp
  - Lo resuelve la persona implicada de manera independiente.
- Altera el trabajo de alguien más:
  - Muy grave:
    1. Crea un Issue en GitHub.
    2. Notifaca a las personas implicadas directamente.
    3. Se establece reunión de emergencia entre las personas implicadas para resolver el conflicto.
  - Moderadamente grave:
    1. Crea un issue en GitHub tageando a las personas implicadas, tanto en título como en cuerpo.
    2. Se resuelve de manera asícrona cuando sea posible.
  - Nada grave:
    1. Se notifica por el canal general de Discord o Whatsapp (opcional).
    2. Se discute en el próximo SCRUM preferiblemente.
### SCRUMs
1. Realización individual de actas de SCRUM.
2. Realización de SCRUM:
    1. Elección de SCRUM master mediante sortea2.
    2. Se exponen las respuestas individuales.
    3. Discusión rápida para resolver conflictos.
3. Unificación de actas individuales por SCRUM master

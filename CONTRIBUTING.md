# Protocolo de contribuciones
## Github
El workflow base es **gitflow**, modificando la rama "develop" por la rama "entrega-x".

<br>

![diagrama gitflow](./images/gitflow.png)
---
## Push (tags)
> En este repositorio se utiliza un script con GitHub actions para crear *tags* de forma automática. Esto requiere del uso de unas etiquetas en el nombre de cada commit y merge para controlar cómo se actualiza el número de versión. Aquí se explica cómo usar estas etiquetas de la forma adecuada.
Existen 2 formas de interactuar con el *tagger*:
- Automáticamente:
	- Cuando se realiza un commit o merge en el que no se especifica con etiquetas como debe de actuar el tagger.
	- En este caso se aumenta el número de versión en el **Patch**.
- Manualmente:
	- El tagger detecta la etiqueta utilizada en el nombre del commit o merge y actualiza la versión de la manera indicada.
	- Para hacer uso de este modo solo hay que añadir en el nombre del commit o merge el nombre del índice que se quiere incrementar precidido de una almohadilla [#]:
		- Se quiere incrementar el Major: `<Commit name> #major`.
		- Se quiere incrementar el Minor: `<Commit name> #minor`.
		- Se quiere incrementar el Patch: `<Commit name> #patch`.
		- No se quiere incrementar la versión: `<Commit name> #none`.

## Pull Requests
- Todo merge a *main* y *entrega-x* debe de hacerse mediante *pull request*.
- En el caso de un PR para *main* deberá ser revisado y aprobado por *todo* el equipo.
- Opcionalmente se pueden crear *pull requests* para *feature branches* que contengan *sub-features* en las que trabajen varias personas.

### Nomenclatura
- Se requiere que **todos** los integrantes del grupo revisen y acepten el *pull request* para realizar el *merge*: <br>
  - `MAJOR -> <Pull Request Name>` <br>
    `@member1 @member2 @member3 ...` <br>
- Se requiere que **alguno** los integrantes citados **en el comentario** revise y acepte el *pull request* para realizar el *merge*.
  - `MINOR -> <Pull Request Name>` <br>
    `@member1 @member2 @member3 ...` <br>
- Se requiere que **solo** los integrantes citados **en el comentario y título** revisen y acepten el *pull request* para realizar el *merge*.
  - `<member name> -> <Pull Request Name>` <br>
    `@member1 @member2 @member3 ...` <br>

### Aprobación de Pull Requests
- Síncrono:
  - Reunión de las personas implicadas para aprobar el pull request.
- Asíncrono:
  - Se revisa de manera individual y se comenta si se aprueba o no el request.
  - Cuando la decisión no sea unánime se d

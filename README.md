# pretty-github

Visor web (`pretty-github`) en vivo del repo
[dev-docs](https://github.com/victormarcias/dev-docs). Se sirve bajo
`victormarcias.online/dev-docs`, con repo y deploy propios.

No hay build ni export intermedio: el sidebar se arma en el cliente pidiendo el árbol del repo dev-docs a la API de GitHub, y cada página se pide en vivo a `raw.githubusercontent.com` y se renderiza con `marked` + `highlight.js` (ambos por CDN, sin bundler).

## Estructura

- `public/index.html` — shell de la página
- `public/pretty-github.js` — fetch del árbol (con cache de 1h en `localStorage`), armado del sidebar, routing por hash (`#carpeta/archivo.md`), carga y renderizado de cada página
- `public/pretty-github.css` — estilos (variables de color propias, sin depender del `styles.css` del portfolio)
- `main.py` — Cloud Function (`serve_pretty_github`, 2nd gen, Python) que sirve los archivos de `public/`, resolviendo el prefijo `/dev-docs` — no hace falta Docker: `gcloud`/Firebase arman el container solos a partir de esto.

## Correr local

```bash
./run-local.sh
```

Sirve `public/` en `http://localhost:8002` (ahí queda en la raíz, no bajo `/dev-docs` — el prefijo lo agrega la Cloud Function recién en producción).

## Deploy (Cloud Function, sin Docker)

```bash
./deploy-prod.sh
```

Vía `gcloud functions deploy`, región `us-east4` — sin Dockerfile, Cloud Build arma el runtime solo a partir de `main.py`/`requirements.txt`.

En el proyecto de Firebase Hosting del portfolio, `/dev-docs` y `/dev-docs/**` se rutean con un rewrite tipo `function` a `serve_pretty_github` (ver `firebase.json` en el repo `portfolio`) — mismo mecanismo que ya usa `/cv` ahí (`serve_cv`), solo que este código vive en este repo aparte.

Sin base de datos, sin estado — la función solo lee un archivo de `public/` y lo devuelve con el `Content-Type` correcto.

import os
from flask import Flask, jsonify, render_template, request
from werkzeug.exceptions import HTTPException
from .db import init_db
from .routes import api


def create_app(test_config=None):
    app = Flask(__name__, template_folder="templates", static_folder="static")
    app.config.from_mapping(
        SECRET_KEY=os.getenv("SECRET_KEY", "dev-only-change-me"),
        DB_PATH=os.getenv("PETCUIDA_DB_PATH", os.path.join(app.root_path, "storage", "petcuida.db")),
        BACKEND=os.getenv("PETCUIDA_BACKEND", "sqlite").strip().lower(),
        FIREBASE_PROJECT_ID=os.getenv("FIREBASE_PROJECT_ID"),
        GOOGLE_APPLICATION_CREDENTIALS=os.getenv("GOOGLE_APPLICATION_CREDENTIALS"),
        SUPABASE_URL=os.getenv("SUPABASE_URL"),
        SUPABASE_ANON_KEY=os.getenv("SUPABASE_ANON_KEY"),
        MAX_CONTENT_LENGTH=2 * 1024 * 1024,
    )
    if test_config is not None:
        app.config.update(test_config)
    if app.config["BACKEND"].lower() == "sqlite":
        os.makedirs(os.path.dirname(app.config["DB_PATH"]) or ".", exist_ok=True)
        init_db(app.config["DB_PATH"])

    app.register_blueprint(api, url_prefix="/api")

    @app.get("/")
    def index():
        return render_template("index.html")

    @app.get("/manus-routes.json")
    def routes_manifest():
        return {"routes": [{"path": "/", "title": "Painel PetCuida"}]}

    @app.errorhandler(HTTPException)
    def handle_http_error(error):
        if request.path.startswith("/api/"):
            return jsonify({"ok": False, "error": error.description}), error.code
        return error

    @app.errorhandler(Exception)
    def handle_unexpected(error):
        app.logger.exception("Erro inesperado no PetCuida")
        if request.path.startswith("/api/"):
            return jsonify({"ok": False, "error": "Serviço temporariamente indisponível."}), 500
        return "Erro interno", 500

    return app

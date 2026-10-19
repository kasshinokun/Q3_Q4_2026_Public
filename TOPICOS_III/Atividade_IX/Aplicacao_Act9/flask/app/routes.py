"""Rotas HTTP da API demonstrativa do PetCuida."""
import re
from flask import Blueprint, current_app, jsonify, request
from .repository import build_repository, normalize_professional_row, parse_professionals_file

api = Blueprint("api", __name__)


def repo():
    return build_repository(current_app.config)


def ok(data):
    return jsonify({"ok": True, **data})


def body_json():
    value = request.get_json(silent=True)
    return value if isinstance(value, dict) else {}


def parse_identifier(value, field, default=None):
    if value in (None, ""):
        return default
    if isinstance(value, bool):
        raise ValueError(f"{field} inválido.")
    text = str(value).strip()
    if text.isdigit():
        parsed = int(text)
        if parsed > 0:
            return parsed
        raise ValueError(f"{field} inválido.")
    # Permite IDs de documento remotos sem converter UUIDs para inteiro.
    if re.fullmatch(r"[A-Za-z0-9_-]{1,128}", text):
        return text
    raise ValueError(f"{field} inválido.")


def user_id_from(body=None):
    value = (body or {}).get("user_id") or request.args.get("user_id")
    return parse_identifier(value, "Usuário", default=1)


def organization_id_from(body=None):
    value = (body or {}).get("organization_id") or request.args.get("organization_id")
    return parse_identifier(value, "Organização")


def bad_request(error):
    return jsonify({"ok": False, "error": str(error)}), 400


@api.post("/auth/login")
def login():
    body = body_json()
    user = repo().authenticate(body.get("username", ""), body.get("password", ""))
    return ok({"user": user}) if user else (jsonify({"ok": False, "error": "Usuário ou senha incorretos."}), 401)


@api.post("/auth/register")
def register():
    try:
        return ok({"user": repo().register(body_json())})
    except (KeyError, ValueError, TypeError) as error:
        return bad_request(error)


@api.get("/pets")
def pets():
    try:
        return ok({"pets": repo().list_pets(user_id_from())})
    except (KeyError, ValueError, TypeError) as error:
        return bad_request(error)


@api.post("/pets")
def add_pet():
    body = body_json()
    try:
        return ok({"id": repo().add_pet(user_id_from(body), body)})
    except (KeyError, ValueError, TypeError) as error:
        return bad_request(error)


@api.get("/services")
def services():
    return ok({"services": repo().services()})


@api.get("/appointments")
def appointments():
    try:
        return ok({"appointments": repo().appointments(user_id_from())})
    except (KeyError, ValueError, TypeError) as error:
        return bad_request(error)


@api.post("/appointments")
def book():
    body = body_json()
    try:
        return ok({"id": repo().book(user_id_from(body), body)})
    except (KeyError, ValueError, TypeError) as error:
        return bad_request(error)


@api.get("/organization/overview")
def organization_overview():
    try:
        org_id = organization_id_from()
        if not org_id:
            raise ValueError("Organização não informada.")
        repository = repo()
        return ok({
            "organization": repository.organization(org_id),
            "professionals": repository.professionals(org_id),
            "offers": repository.service_offers(org_id),
            "demands": repository.demands(org_id),
        })
    except (KeyError, ValueError, TypeError) as error:
        return bad_request(error)


@api.post("/organization/professionals")
def add_professional():
    body = body_json()
    try:
        return ok({"id": repo().add_professional(organization_id_from(body), body)})
    except (KeyError, ValueError, TypeError) as error:
        return bad_request(error)


@api.post("/organization/professionals/import")
def import_professionals():
    try:
        org_id = organization_id_from(request.form.to_dict())
        if not org_id or "file" not in request.files:
            raise ValueError("Envie a organização e um arquivo JSON, XLS ou XLSX.")
        rows = parse_professionals_file(request.files["file"])
        normalized = [normalize_professional_row(row) for row in rows]
        normalized = [row for row in normalized if row is not None]
        if not normalized:
            raise ValueError("O arquivo não contém profissionais válidos.")
        created = repo().add_professionals_bulk(org_id, normalized)
        return ok({"created": len(created)})
    except (KeyError, ValueError, TypeError) as error:
        return bad_request(error)


@api.post("/organization/offers")
def add_offer():
    body = body_json()
    try:
        return ok({"id": repo().add_offer(organization_id_from(body), body)})
    except (KeyError, ValueError, TypeError) as error:
        return bad_request(error)


@api.post("/organization/demands/<int:demand_id>/accept")
def accept_demand(demand_id):
    body = body_json()
    try:
        return ok({"id": repo().accept_demand(organization_id_from(body), demand_id, body.get("professional_id"))})
    except (KeyError, ValueError, TypeError) as error:
        return bad_request(error)


@api.get("/triage")
def triage():
    return ok({
        "disclaimer": "Triagem orientativa; não substitui avaliação veterinária.",
        "questions": [
            "O pet está com dificuldade para respirar?",
            "Há sangramento intenso ou perda de consciência?",
            "O sintoma começou de forma súbita?",
        ],
    })


@api.get("/status")
def status():
    return ok({"app": "PetCuida", "version": "1.5.2-alpha", "revision": "d4", "backend": current_app.config["BACKEND"], "demo": current_app.config["BACKEND"] == "sqlite"})

from io import BytesIO
import json
import pytest
from app import create_app


@pytest.fixture()
def client(tmp_path):
    app = create_app({"TESTING": True, "DB_PATH": str(tmp_path / "test.db")})
    return app.test_client()


def test_routes_manifest(client):
    response = client.get("/manus-routes.json")
    assert response.status_code == 200
    assert response.json["routes"][0]["path"] == "/"


def test_frontend_is_served_locally_and_status_is_versioned(client):
    page = client.get("/")
    status = client.get("/api/status")
    assert page.status_code == 200
    assert b"/static/js/main.js" in page.data
    assert b"fonts.googleapis.com" not in page.data
    assert status.json["version"] == "1.5.2-alpha"
    assert status.json["revision"] == "d4"


def test_login_and_seed_data(client):
    response = client.post("/api/auth/login", json={"username": "petcuida", "password": "meu pet"})
    assert response.status_code == 200
    assert response.json["user"]["account_type"] == "tutor"
    assert client.get("/api/pets").json["pets"][0]["name"] == "Rex"
    services = client.get("/api/services").json["services"]
    assert len(services) == 5
    assert any(item["offer_type"] == "offer" and item["professional_name"] for item in services)


def test_invalid_login_and_malformed_body(client):
    assert client.post("/api/auth/login", json={"username": "x", "password": "y"}).status_code == 401
    assert client.post("/api/auth/login", data="[]", content_type="application/json").status_code == 401


def test_organization_demo_and_registration(client):
    organization = client.post("/api/auth/login", json={"username": "clinica.petcuida", "password": "pet pj"}).json["user"]
    assert organization["account_type"] == "organization"
    overview = client.get(f"/api/organization/overview?organization_id={organization['organization_id']}").json
    assert overview["professionals"] and overview["offers"]
    registered = client.post("/api/auth/register", json={
        "username": "novo.pj", "password": "1234", "account_type": "organization",
        "legal_name": "Novo Projeto LTDA", "trade_name": "Novo Projeto", "org_type": "Projeto social",
    })
    assert registered.status_code == 200
    assert registered.json["user"]["account_type"] == "organization"


def test_organization_can_publish_accept_and_tutor_sees_attribution(client):
    organization = client.post("/api/auth/login", json={"username": "clinica.petcuida", "password": "pet pj"}).json["user"]
    overview = client.get(f"/api/organization/overview?organization_id={organization['organization_id']}").json
    professional = overview["professionals"][0]
    created = client.post("/api/organization/offers", json={
        "organization_id": organization["organization_id"], "professional_id": professional["id"],
        "name": "Plantão demonstrativo", "description": "Atendimento alfa", "location": "Centro", "price_cents": 1000,
    })
    assert created.status_code == 200
    offer = next(item for item in client.get("/api/services").json["services"] if item["offer_type"] == "offer" and item["name"] == "Plantão demonstrativo")
    assert client.post("/api/appointments", json={"user_id": 1, "pet_id": 1, "offer_id": offer["id"], "scheduled_for": "2026-10-10"}).status_code == 200
    demands = client.get(f"/api/organization/overview?organization_id={organization['organization_id']}").json["demands"]
    demand = next(item for item in demands if item["service_name"] == "Plantão demonstrativo")
    accepted = client.post(f"/api/organization/demands/{demand['id']}/accept", json={
        "organization_id": organization["organization_id"], "professional_id": professional["id"],
    })
    assert accepted.status_code == 200
    appointment = next(item for item in client.get("/api/appointments?user_id=1").json["appointments"] if item["service_name"] == "Plantão demonstrativo")
    assert appointment["status"] == "aceita"
    assert appointment["organization_name"] == "Clínica PetCuida Serviços Veterinários LTDA"
    assert appointment["professional_name"] == professional["name"]


def test_import_professionals_is_validated_and_atomic(client):
    organization = client.post("/api/auth/login", json={"username": "clinica.petcuida", "password": "pet pj"}).json["user"]
    bad_payload = json.dumps([{"nome": "Dra. Nova", "cargo": "Veterinária"}, {"cargo": "Sem nome"}]).encode()
    response = client.post("/api/organization/professionals/import", data={
        "organization_id": str(organization["organization_id"]),
        "file": (BytesIO(bad_payload), "equipe.json"),
    }, content_type="multipart/form-data")
    assert response.status_code == 400
    overview = client.get(f"/api/organization/overview?organization_id={organization['organization_id']}").json
    assert len(overview["professionals"]) == 2  # nenhum registro parcial

    good_payload = json.dumps({"professionals": [{"Nome": "Dra. Nova", "Especialidade": "Veterinária", "CRMV": "MG 123"}]}).encode()
    response = client.post("/api/organization/professionals/import", data={
        "organization_id": str(organization["organization_id"]),
        "file": (BytesIO(good_payload), "equipe.json"),
    }, content_type="multipart/form-data")
    assert response.status_code == 200
    assert response.json["created"] == 1


def test_invalid_ids_payloads_and_invalid_offer_data_return_client_errors(client):
    assert client.get("/api/pets?user_id=not valid!").status_code == 400
    assert client.get("/api/organization/overview?organization_id=not valid!").status_code == 400
    assert client.get("/api/organization/overview?organization_id=99999").status_code == 400
    assert client.post("/api/organization/professionals", json={"organization_id": 99999, "name": "Teste"}).status_code == 400
    assert client.post("/api/organization/offers", json={"organization_id": 99999, "professional_id": 1, "name": "Teste", "location": "Centro"}).status_code == 400
    organization = client.post("/api/auth/login", json={"username": "clinica.petcuida", "password": "pet pj"}).json["user"]
    professional_id = client.get(f"/api/organization/overview?organization_id={organization['organization_id']}").json["professionals"][0]["id"]
    negative = client.post("/api/organization/offers", json={
        "organization_id": organization["organization_id"], "professional_id": professional_id,
        "name": "Valor inválido", "location": "Centro", "price_cents": -1,
    })
    assert negative.status_code == 400


def test_invalid_booking_and_unknown_api_route_keep_http_status(client):
    assert client.post("/api/appointments", json={"user_id": 1, "pet_id": 1, "service_id": 1, "scheduled_for": "amanhã"}).status_code == 400
    assert client.get("/api/rota-inexistente").status_code == 404


def test_typed_password_and_oversized_upload_return_controlled_errors(client):
    assert client.post("/api/auth/register", json={"username": "novo", "password": 1234}).status_code == 400
    oversized = BytesIO(b"x" * (2 * 1024 * 1024 + 1))
    response = client.post("/api/organization/professionals/import", data={
        "organization_id": "1", "file": (oversized, "large.json"),
    }, content_type="multipart/form-data")
    assert response.status_code == 413
    assert response.json["ok"] is False


def test_xlsx_import_supports_portuguese_headers(client):
    from openpyxl import Workbook
    organization = client.post("/api/auth/login", json={"username": "clinica.petcuida", "password": "pet pj"}).json["user"]
    workbook = Workbook()
    sheet = workbook.active
    sheet.append(["Nome", "Especialidade", "CRMV"])
    sheet.append(["Dra. Planilha", "Veterinária", "MG 987"])
    stream = BytesIO()
    workbook.save(stream)
    response = client.post("/api/organization/professionals/import", data={
        "organization_id": str(organization["organization_id"]),
        "file": (BytesIO(stream.getvalue()), "equipe.xlsx"),
    }, content_type="multipart/form-data")
    assert response.status_code == 200
    assert response.json["created"] == 1

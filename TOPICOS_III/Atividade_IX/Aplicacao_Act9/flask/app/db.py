import sqlite3
from contextlib import contextmanager
from datetime import datetime, timezone

SCHEMA = """
CREATE TABLE IF NOT EXISTS organizations (id INTEGER PRIMARY KEY AUTOINCREMENT, legal_name TEXT NOT NULL, trade_name TEXT NOT NULL, org_type TEXT NOT NULL, document TEXT DEFAULT '', location TEXT DEFAULT '', created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE NOT NULL, password TEXT NOT NULL, account_type TEXT NOT NULL DEFAULT 'tutor', display_name TEXT DEFAULT '', organization_id INTEGER, created_at TEXT NOT NULL, FOREIGN KEY (organization_id) REFERENCES organizations(id));
CREATE TABLE IF NOT EXISTS pets (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, name TEXT NOT NULL, species TEXT NOT NULL, breed TEXT DEFAULT '', birth_date TEXT DEFAULT '', notes TEXT DEFAULT '', FOREIGN KEY(user_id) REFERENCES users(id));
CREATE TABLE IF NOT EXISTS professionals (id INTEGER PRIMARY KEY AUTOINCREMENT, organization_id INTEGER NOT NULL, name TEXT NOT NULL, role TEXT DEFAULT 'Profissional', registration TEXT DEFAULT '', active INTEGER NOT NULL DEFAULT 1, created_at TEXT NOT NULL, FOREIGN KEY(organization_id) REFERENCES organizations(id));
CREATE TABLE IF NOT EXISTS services (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, provider TEXT NOT NULL, location TEXT NOT NULL, price_cents INTEGER NOT NULL, description TEXT NOT NULL, booked INTEGER NOT NULL DEFAULT 0);
CREATE TABLE IF NOT EXISTS service_offers (id INTEGER PRIMARY KEY AUTOINCREMENT, organization_id INTEGER NOT NULL, professional_id INTEGER NOT NULL, name TEXT NOT NULL, description TEXT NOT NULL, location TEXT NOT NULL, price_cents INTEGER NOT NULL, status TEXT NOT NULL DEFAULT 'publicado', created_at TEXT NOT NULL, FOREIGN KEY(organization_id) REFERENCES organizations(id), FOREIGN KEY(professional_id) REFERENCES professionals(id));
CREATE TABLE IF NOT EXISTS appointments (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, pet_id INTEGER NOT NULL, service_id INTEGER NOT NULL, scheduled_for TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'agendado', FOREIGN KEY(user_id) REFERENCES users(id), FOREIGN KEY(pet_id) REFERENCES pets(id), FOREIGN KEY(service_id) REFERENCES services(id));
CREATE TABLE IF NOT EXISTS demand_requests (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, pet_id INTEGER NOT NULL, offer_id INTEGER NOT NULL, scheduled_for TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'pendente', accepted_professional_id INTEGER, created_at TEXT NOT NULL, FOREIGN KEY(user_id) REFERENCES users(id), FOREIGN KEY(pet_id) REFERENCES pets(id), FOREIGN KEY(offer_id) REFERENCES service_offers(id), FOREIGN KEY(accepted_professional_id) REFERENCES professionals(id));
"""
SEED = [
 ('Consulta veterinária de rotina','Clínica PetCuida','Padre Eustáquio',6000,'Avaliação clínica geral com veterinário credenciado.'),
 ('Vacinação V10','Clínica PetCuida','Padre Eustáquio',4500,'Aplicação de vacina múltipla e atualização do prontuário.'),
 ('Castração','Clínica PetCuida','Padre Eustáquio',12000,'Pagamento misto com créditos + dinheiro.'),
 ('Banho e tosa','Ana Pet Estética','Floresta',3500,'Higienização completa e corte de unhas.'),
]


def connect(path):
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    conn.execute('PRAGMA foreign_keys = ON')
    return conn


def init_db(path):
    with connect(path) as conn:
        conn.executescript(SCHEMA)
        # Compatibilidade com o banco demo criado antes da evolução de perfis.
        columns = {row['name'] for row in conn.execute('PRAGMA table_info(users)')}
        if 'account_type' not in columns: conn.execute("ALTER TABLE users ADD COLUMN account_type TEXT NOT NULL DEFAULT 'tutor'")
        if 'display_name' not in columns: conn.execute("ALTER TABLE users ADD COLUMN display_name TEXT DEFAULT ''")
        if 'organization_id' not in columns: conn.execute("ALTER TABLE users ADD COLUMN organization_id INTEGER")
        if conn.execute('SELECT COUNT(*) FROM users').fetchone()[0] == 0:
            conn.execute('INSERT INTO users(username,password,account_type,display_name,created_at) VALUES (?,?,?,?,?)', ('petcuida','meu pet','tutor','Tutor PetCuida',datetime.now(timezone.utc).isoformat()))
            user_id = conn.execute('SELECT id FROM users WHERE username=?',('petcuida',)).fetchone()[0]
            conn.execute('INSERT INTO pets(user_id,name,species,breed,birth_date,notes) VALUES (?,?,?,?,?,?)', (user_id,'Rex','Cão','SRD','2023-04-12','Vacinação em dia.'))
        if conn.execute('SELECT COUNT(*) FROM services').fetchone()[0] == 0: conn.executemany('INSERT INTO services(name,provider,location,price_cents,description) VALUES (?,?,?,?,?)', SEED)
        if conn.execute('SELECT COUNT(*) FROM organizations').fetchone()[0] == 0:
            now = datetime.now(timezone.utc).isoformat()
            conn.execute('INSERT INTO organizations(legal_name,trade_name,org_type,document,location,created_at) VALUES (?,?,?,?,?,?)', ('Clínica PetCuida Serviços Veterinários LTDA','Clínica PetCuida','Clínica','00.000.000/0001-00','Padre Eustáquio',now))
            org_id = conn.execute('SELECT id FROM organizations ORDER BY id DESC LIMIT 1').fetchone()[0]
            conn.execute('INSERT INTO users(username,password,account_type,display_name,organization_id,created_at) VALUES (?,?,?,?,?,?)', ('clinica.petcuida','pet pj','organization','Clínica PetCuida',org_id,now))
            conn.executemany('INSERT INTO professionals(organization_id,name,role,registration,created_at) VALUES (?,?,?,?,?)', [(org_id,'Dra. Camila Andrade','Médica veterinária','CRMV-MG 00000',now),(org_id,'Marcos Lima','Tosador','',now)])
            pro_id = conn.execute('SELECT id FROM professionals WHERE organization_id=? ORDER BY id LIMIT 1',(org_id,)).fetchone()[0]
            conn.execute('INSERT INTO service_offers(organization_id,professional_id,name,description,location,price_cents,created_at) VALUES (?,?,?,?,?,?,?)', (org_id,pro_id,'Consulta veterinária de rotina','Avaliação clínica geral com profissional credenciado.','Padre Eustáquio',6000,now))
        conn.commit()

@contextmanager
def db(path):
    conn = connect(path)
    try:
        yield conn
        conn.commit()
    finally:
        conn.close()

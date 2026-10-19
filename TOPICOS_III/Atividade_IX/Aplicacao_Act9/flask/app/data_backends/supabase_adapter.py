"""Persistência opcional em Supabase.

Ativação: PETCUIDA_BACKEND=supabase, SUPABASE_URL e SUPABASE_ANON_KEY.
As tabelas esperadas são users, pets, services e appointments.
"""
class SupabaseRepository:
    def __init__(self, client): self.client = client
    @classmethod
    def from_config(cls, config):
        try: from supabase import create_client
        except ImportError as error: raise RuntimeError('Instale supabase para ativar o Supabase.') from error
        url, key = config.get('SUPABASE_URL'), config.get('SUPABASE_ANON_KEY')
        if not url or not key: raise RuntimeError('Defina SUPABASE_URL e SUPABASE_ANON_KEY para ativar o Supabase.')
        return cls(create_client(url, key))
    def authenticate(self, username, password):
        response = self.client.table('users').select('id,username').eq('username', username.strip()).eq('password', password).limit(1).execute()
        return response.data[0] if response.data else None
    def list_pets(self, user_id): return self.client.table('pets').select('*').eq('user_id', user_id).order('id').execute().data
    def add_pet(self, user_id, data):
        row = {'user_id': user_id, 'name': data['name'].strip(), 'species': data.get('species','Cão'), 'breed': data.get('breed',''), 'birth_date': data.get('birth_date',''), 'notes': data.get('notes','')}
        return self.client.table('pets').insert(row).execute().data[0]['id']
    def services(self): return self.client.table('services').select('*').order('id').execute().data
    def appointments(self, user_id): return self.client.table('appointments').select('*, pets(name), services(name,provider,location,price_cents)').eq('user_id', user_id).order('scheduled_for').execute().data
    def book(self, user_id, data):
        row = {'user_id': user_id, 'pet_id': data['pet_id'], 'service_id': data['service_id'], 'scheduled_for': data['scheduled_for'], 'status': 'agendado'}
        return self.client.table('appointments').insert(row).execute().data[0]['id']

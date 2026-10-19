"""Persistência opcional em Firebase Cloud Firestore.

Ativação: PETCUIDA_BACKEND=firestore e GOOGLE_APPLICATION_CREDENTIALS apontando
para uma conta de serviço fora do repositório. O SDK só é importado quando ativado.
"""
from datetime import datetime, timezone

class FirestoreRepository:
    def __init__(self, client): self.client = client
    @classmethod
    def from_config(cls, config):
        try:
            import firebase_admin
            from firebase_admin import credentials, firestore
        except ImportError as error: raise RuntimeError('Instale firebase-admin para ativar o Firestore.') from error
        if not firebase_admin._apps:
            credential_path = config.get('GOOGLE_APPLICATION_CREDENTIALS')
            if not credential_path: raise RuntimeError('Defina GOOGLE_APPLICATION_CREDENTIALS para ativar o Firestore.')
            firebase_admin.initialize_app(credentials.Certificate(credential_path), {'projectId': config.get('FIREBASE_PROJECT_ID')})
        return cls(firestore.client())
    def _docs(self, collection): return self.client.collection(collection)
    def authenticate(self, username, password):
        query = self._docs('users').where('username', '==', username.strip()).where('password', '==', password).limit(1).stream()
        for doc in query: return {'id': doc.id, **doc.to_dict()}
        return None
    def list_pets(self, user_id): return [{'id': d.id, **d.to_dict()} for d in self._docs('pets').where('user_id', '==', user_id).stream()]
    def add_pet(self, user_id, data):
        ref = self._docs('pets').document(); ref.set({'user_id': user_id, 'name': data['name'].strip(), 'species': data.get('species','Cão'), 'breed': data.get('breed',''), 'birth_date': data.get('birth_date',''), 'notes': data.get('notes',''), 'created_at': datetime.now(timezone.utc).isoformat()}); return ref.id
    def services(self): return [{'id': d.id, **d.to_dict()} for d in self._docs('services').stream()]
    def appointments(self, user_id): return [{'id': d.id, **d.to_dict()} for d in self._docs('appointments').where('user_id', '==', user_id).stream()]
    def book(self, user_id, data):
        ref = self._docs('appointments').document(); ref.set({'user_id': user_id, 'pet_id': data['pet_id'], 'service_id': data['service_id'], 'scheduled_for': data['scheduled_for'], 'status': 'agendado'}); return ref.id

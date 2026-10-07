import { createApp } from './vendor/vue.esm-browser.prod.js';
import { api } from './api.js';
import Login from './components/Login.js';
import Dashboard from './components/Dashboard.js';
import OrganizationDashboard from './components/OrganizationDashboard.js';

const app = createApp({
  components: { Login, Dashboard, OrganizationDashboard },
  data: () => ({ user:null, organization:null, professionals:[], offers:[], demands:[], pets:[], services:[], appointments:[], showPet:false, saving:false, loading:false, message:'', newPet:{name:'',species:'Cão',breed:'',birth_date:'',notes:''} }),
  methods: {
    async login(credentials) { const result=await api.login(credentials); this.user=result.user; try { await this.load(); } catch (error) { this.logout(); throw new Error(`Não foi possível carregar o painel: ${error.message}`); } },
    async register(payload) { const result=await api.register(payload); this.user=result.user; try { await this.load(); } catch (error) { this.logout(); throw new Error(`Não foi possível carregar o painel: ${error.message}`); } this.flash(payload.account_type==='organization'?'Organização criada. Cadastre sua equipe para começar.':'Conta criada com sucesso.'); },
    async load() { this.loading=true; try { if(this.user.account_type==='organization') { const result=await api.organizationOverview(this.user.organization_id); this.organization=result.organization; this.professionals=result.professionals; this.offers=result.offers; this.demands=result.demands; } else { const id=this.user.id; const [pets,services,appointments]=await Promise.all([api.pets(id),api.services(),api.appointments(id)]); this.pets=pets.pets; this.services=services.services; this.appointments=appointments.appointments; } } finally { this.loading=false; } },
    async addPet() { this.saving=true; try { await api.addPet({...this.newPet,user_id:this.user.id}); this.newPet={name:'',species:'Cão',breed:'',birth_date:'',notes:''}; this.showPet=false; await this.load(); this.flash('Pet cadastrado com sucesso.'); } catch(e){this.flash(e.message);} finally{this.saving=false;} },
    async book(service) { if(!this.pets.length){this.flash('Cadastre um pet antes de agendar.');return;} const date=new Date(Date.now()+86400000).toISOString().slice(0,10); const payload={user_id:this.user.id,pet_id:this.pets[0].id,scheduled_for:date}; if(service.offer_type==='offer')payload.offer_id=service.id; else payload.service_id=service.id; try{await api.book(payload);await this.load();this.flash(`${service.name} solicitado para amanhã.`);}catch(e){this.flash(e.message);} },
    async runTriage(){try{const result=await api.triage();this.flash(result.disclaimer);}catch(e){this.flash(e.message);}},
    async addProfessional(payload){try{await api.addProfessional(payload);await this.load();this.flash('Profissional adicionado.');}catch(e){this.flash(e.message);throw e;}},
    async importProfessionals(id,file){try{const result=await api.importProfessionals(id,file);await this.load();this.flash('Lista de profissionais importada.');return result;}catch(e){this.flash(e.message);throw e;}},
    async addOffer(payload){try{await api.addOffer(payload);await this.load();this.flash('Serviço publicado na rede.');}catch(e){this.flash(e.message);throw e;}},
    async acceptDemand(id,payload){try{await api.acceptDemand(id,payload);await this.load();this.flash('Demanda aceita e profissional designado.');}catch(e){this.flash(e.message);throw e;}},
    flash(text){this.message=text;clearTimeout(this._toast);this._toast=setTimeout(()=>this.message='',4200);},
    logout(){this.user=null;this.organization=null;this.professionals=[];this.offers=[];this.demands=[];this.pets=[];this.services=[];this.appointments=[];},
  },
});
app.mount('#app');

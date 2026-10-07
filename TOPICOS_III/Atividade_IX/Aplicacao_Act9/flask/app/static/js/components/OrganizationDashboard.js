export default {
  props: ['user', 'organization', 'professionals', 'offers', 'demands', 'onAddProfessional', 'onImport', 'onAddOffer', 'onAccept', 'onLogout'],
  template: `
    <div class="dashboard-layout organization-layout">
      <aside class="sidebar">
        <div class="sidebar-brand">
          <img src="/static/assets/petcuida-logo.png" alt="" class="brand-logo">
          <div><strong>PetCuida</strong><small>painel parceiro</small></div>
        </div>
        <nav class="side-nav" aria-label="Navegação da organização">
          <button v-for="item in navItems" :key="item.id" :class="['nav-item', {active:view===item.id}]" :aria-current="view===item.id ? 'page' : null" @click="setView(item.id)">
            <span aria-hidden="true">{{item.icon}}</span>{{item.label}}
          </button>
        </nav>
        <div class="sidebar-bottom">
          <div class="support-card"><span aria-hidden="true">✦</span><strong>Rede PetCuida</strong><p>Conecte sua equipe a tutores que precisam de cuidado.</p></div>
          <button class="logout-button" type="button" @click="onLogout"><span aria-hidden="true">↪</span>Sair da conta</button>
        </div>
      </aside>

      <main class="main-content">
        <header class="topbar">
          <div class="mobile-title">
            <button class="mobile-menu" type="button" aria-label="Abrir menu" :aria-expanded="sidebarOpen" @click="sidebarOpen=!sidebarOpen">☰</button>
            <span>PetCuida · Parceiros</span>
          </div>
          <div class="topbar-actions">
            <div class="user-chip"><span class="user-avatar">{{initial}}</span><span class="user-name">{{organization.trade_name}}</span></div>
          </div>
        </header>

        <div v-if="sidebarOpen" class="mobile-nav" @click.self="sidebarOpen=false">
          <nav class="mobile-nav-inner" aria-label="Navegação mobile da organização">
            <button v-for="item in navItems" :key="item.id" :class="['nav-item', {active:view===item.id}]" :aria-current="view===item.id ? 'page' : null" @click="setView(item.id)">{{item.icon}} {{item.label}}</button>
            <button class="logout-button" type="button" @click="onLogout">↪ Sair da conta</button>
          </nav>
        </div>

        <section class="page-content" v-if="view==='overview'">
          <div class="welcome-row"><div><p class="eyebrow">PAINEL DA ORGANIZAÇÃO</p><h1>Olá, {{organization.trade_name}}.<br><em>Vamos cuidar juntos.</em></h1><p class="muted">Publique serviços, organize profissionais e responda demandas da rede.</p></div><span class="partner-badge">{{organization.org_type}} · PJ</span></div>
          <div class="metric-grid">
            <article class="metric-card"><span class="metric-icon blue">♧</span><div><strong>{{professionals.length}}</strong><span>profissionais na equipe</span></div></article>
            <article class="metric-card"><span class="metric-icon pink">✦</span><div><strong>{{offers.length}}</strong><span>serviços publicados</span></div></article>
            <article class="metric-card"><span class="metric-icon yellow">♡</span><div><strong>{{pendingDemands}}</strong><span>demandas pendentes</span></div></article>
          </div>
          <div v-if="!professionals.length" class="onboarding-banner"><div class="onboarding-icon">!</div><div><strong>Cadastre sua equipe para começar</strong><p>Importe uma lista JSON/XLS/XLSX ou insira profissionais manualmente.</p></div><button class="primary" type="button" @click="setView('team')">Cadastrar equipe</button></div>
          <div class="content-grid">
            <section class="panel"><div class="section-heading"><div><p class="eyebrow">DEMANDAS RECENTES</p><h3>Pedidos de atendimento</h3></div><button class="text-action" type="button" @click="setView('demands')">Ver tudo</button></div>
              <div v-if="demands.length" class="demand-list"><article v-for="d in demands.slice(0,3)" :key="d.id" class="demand-row"><span class="demand-icon">♡</span><div><strong>{{d.service_name}}</strong><p>{{d.pet_name}} · {{d.scheduled_for}}</p><small>{{d.organization_name}} · {{d.professional_name || 'Aguardando designação'}}</small></div><span :class="['tag',d.status==='pendente'?'pending':'']">{{d.status}}</span></article></div>
              <div v-else class="empty-state"><span>♡</span><p>As novas demandas aparecerão aqui.</p></div>
            </section>
            <section class="panel"><div class="section-heading"><div><p class="eyebrow">CATÁLOGO</p><h3>Serviços ativos</h3></div><button class="text-action" type="button" @click="setView('offers')">Gerenciar</button></div>
              <div v-if="offers.length" class="mini-offer-list"><article v-for="o in offers.slice(0,3)" :key="o.id"><span>✚</span><div><strong>{{o.name}}</strong><p>{{o.organization_name}}<br>{{o.professional_name}}</p></div></article></div>
              <div v-else class="empty-state compact"><p>Publique seu primeiro serviço.</p><button class="secondary" type="button" @click="setView('offers')">Publicar serviço</button></div>
            </section>
          </div>
        </section>

        <section class="page-content" v-else-if="view==='team'">
          <div class="page-title"><div><p class="eyebrow">MINHA EQUIPE</p><h1>Profissionais que<br><em>fazem acontecer.</em></h1><p class="muted">Os nomes cadastrados aparecerão aos tutores em cada oferta e demanda aceita.</p></div><button class="primary" type="button" @click="manualOpen=true">+ Inserir profissional</button></div>
          <p v-if="actionError" class="error" role="alert">{{actionError}}</p>
          <div class="upload-card"><div class="upload-icon">↑</div><h2>Importe uma lista de profissionais</h2><p>Envie JSON, XLS ou XLSX com colunas como <b>nome</b>, <b>cargo</b> e <b>registro</b>.</p><input ref="file" type="file" accept=".json,.xls,.xlsx,application/json" @change="importFile"><button class="secondary" type="button" @click="$refs.file.click()">Escolher arquivo</button><small v-if="uploadMessage" role="status">{{uploadMessage}}</small></div>
          <div class="professional-grid"><article v-for="p in professionals" :key="p.id" class="professional-card"><div class="professional-avatar">{{p.name.slice(0,1)}}</div><div><span class="tag">ATIVO</span><h3>{{p.name}}</h3><p>{{p.role}}</p><small>{{p.registration || 'Registro não informado'}}</small></div></article></div>
          <div v-if="manualOpen" class="modal-backdrop" @click.self="manualOpen=false"><form class="modal" @submit.prevent="addManual"><button type="button" class="close" aria-label="Fechar" @click="manualOpen=false">×</button><p class="eyebrow">NOVA PESSOA</p><h2>Adicionar profissional</h2><label>Nome<input v-model.trim="manual.name" required maxlength="160"></label><label>Cargo/especialidade<input v-model.trim="manual.role" required maxlength="120" placeholder="Ex.: Médica veterinária"></label><label>Registro profissional<input v-model.trim="manual.registration" maxlength="120" placeholder="Ex.: CRMV 00000"></label><p v-if="actionError" class="error" role="alert">{{actionError}}</p><button class="primary full" :disabled="saving">{{saving ? 'Salvando…' : 'Salvar profissional'}}</button></form></div>
        </section>

        <section class="page-content" v-else-if="view==='offers'">
          <div class="page-title"><div><p class="eyebrow">SERVIÇOS PUBLICADOS</p><h1>Ofertas que chegam<br><em>a quem precisa.</em></h1></div><button class="primary" type="button" @click="openOffer">+ Publicar serviço</button></div>
          <div class="service-grid"><article v-for="o in offers" :key="o.offer_type ? o.offer_type + '-' + o.id : o.id" class="service-card"><div class="service-icon">✚</div><div class="service-content"><span class="service-type">{{o.location}}</span><h3>{{o.name}}</h3><p>{{o.description}}</p><strong>R$ {{price(o.price_cents)}}</strong><small>{{o.organization_name}}<br>{{o.professional_name}} · {{o.professional_role}}</small></div><span class="tag">Publicado</span></article></div>
          <div v-if="offerOpen" class="modal-backdrop" @click.self="offerOpen=false"><form class="modal" @submit.prevent="addOffer"><button type="button" class="close" aria-label="Fechar" @click="offerOpen=false">×</button><p class="eyebrow">NOVA OFERTA</p><h2>Publicar serviço</h2><label>Nome do serviço<input v-model.trim="offer.name" required maxlength="160" placeholder="Ex.: Consulta clínica"></label><label>Profissional designado<select v-model="offer.professional_id" required><option disabled value="">Selecione</option><option v-for="p in activeProfessionals" :key="p.id" :value="p.id">{{p.name}} · {{p.role}}</option></select></label><label>Descrição<textarea v-model.trim="offer.description" rows="3" maxlength="2000"></textarea></label><div class="form-grid"><label>Local<input v-model.trim="offer.location" required maxlength="160"></label><label>Valor (R$)<input v-model.number="offer.price_reais" type="number" min="0" max="999999.99" step="0.01" required></label></div><p v-if="actionError" class="error" role="alert">{{actionError}}</p><button class="primary full" :disabled="saving">{{saving ? 'Publicando…' : 'Publicar na rede'}}</button></form></div>
        </section>

        <section class="page-content" v-else>
          <div class="page-title"><div><p class="eyebrow">DEMANDAS DA REDE</p><h1>Pedidos esperando<br><em>uma resposta.</em></h1></div></div>
          <section class="panel"><div v-if="demands.length" class="agenda-list"><article v-for="d in demands" :key="d.id" class="agenda-row"><span class="agenda-calendar">♡</span><div class="demand-summary"><strong>{{d.service_name}}</strong><p>{{d.pet_name}} · {{d.scheduled_for}} · solicitante {{d.requester_username}}</p><small>{{d.organization_name}}<br>{{d.professional_name || 'Nenhum profissional designado'}}</small></div><span v-if="d.status==='pendente'" class="demand-actions"><select v-model="selectedProfessional[d.id]" aria-label="Profissional designado"><option disabled value="">Designar profissional</option><option v-for="p in activeProfessionals" :key="p.id" :value="p.id">{{p.name}}</option></select><button class="primary" type="button" :disabled="saving || !selectedProfessional[d.id]" @click="accept(d)">Aceitar demanda</button></span><span v-else class="tag">{{d.status}}</span></article></div><div v-else class="empty-state"><span>♡</span><h3>Nenhuma demanda ainda</h3><p>Quando um tutor solicitar um serviço, ele aparecerá nesta área.</p></div><p v-if="actionError" class="error" role="alert">{{actionError}}</p></section>
        </section>
      </main>
    </div>
  `,
  data: () => ({
    view: 'overview', sidebarOpen: false, manualOpen: false, offerOpen: false,
    uploadMessage: '', actionError: '', saving: false, selectedProfessional: {},
    manual: {name: '', role: '', registration: ''},
    offer: {name: '', professional_id: '', description: '', location: '', price_reais: 0},
    navItems: [
      {id: 'overview', icon: '⌂', label: 'Visão geral'},
      {id: 'team', icon: '♧', label: 'Minha equipe'},
      {id: 'offers', icon: '✚', label: 'Serviços publicados'},
      {id: 'demands', icon: '♡', label: 'Demandas da rede'},
    ],
  }),
  computed: {
    pendingDemands() { return this.demands.filter(d => d.status === 'pendente').length; },
    activeProfessionals() { return this.professionals.filter(p => p.active !== 0 && p.active !== false); },
    initial() { return (this.organization.trade_name || 'P').slice(0, 1).toUpperCase(); },
  },
  methods: {
    setView(view) { this.view = view; this.sidebarOpen = false; this.actionError = ''; },
    openOffer() {
      this.actionError = '';
      if (!this.activeProfessionals.length) {
        this.view = 'team';
        this.actionError = 'Cadastre pelo menos um profissional ativo antes de publicar um serviço.';
        return;
      }
      this.offerOpen = true;
    },
    price(cents) { return (Number(cents || 0) / 100).toFixed(2).replace('.', ','); },
    async addManual() {
      this.saving = true; this.actionError = '';
      try {
        await this.onAddProfessional({...this.manual, organization_id: this.organization.id});
        this.manual = {name: '', role: '', registration: ''}; this.manualOpen = false;
      } catch (error) { this.actionError = error.message || 'Não foi possível salvar o profissional.'; }
      finally { this.saving = false; }
    },
    async importFile(event) {
      const input = event.target; const file = input.files && input.files[0];
      if (!file) return;
      this.actionError = ''; this.uploadMessage = ''; this.saving = true;
      try {
        const result = await this.onImport(this.organization.id, file);
        this.uploadMessage = `${result.created} profissional(is) importado(s) com sucesso.`;
      } catch (error) { this.actionError = error.message || 'Não foi possível importar o arquivo.'; }
      finally { this.saving = false; input.value = ''; }
    },
    async addOffer() {
      this.saving = true; this.actionError = '';
      try {
        const price = Number(this.offer.price_reais);
        if (!Number.isFinite(price) || price < 0 || price > 999999.99) throw new Error('Informe um valor válido em reais.');
        await this.onAddOffer({...this.offer, price_cents: Math.round(price * 100), organization_id: this.organization.id});
        this.offer = {name: '', professional_id: '', description: '', location: '', price_reais: 0}; this.offerOpen = false;
      } catch (error) { this.actionError = error.message || 'Não foi possível publicar o serviço.'; }
      finally { this.saving = false; }
    },
    async accept(demand) {
      const professional_id = this.selectedProfessional[demand.id];
      if (!professional_id) { this.actionError = 'Selecione um profissional antes de aceitar.'; return; }
      this.saving = true; this.actionError = '';
      try { await this.onAccept(demand.id, {organization_id: this.organization.id, professional_id}); }
      catch (error) { this.actionError = error.message || 'Não foi possível aceitar a demanda.'; }
      finally { this.saving = false; }
    },
  },
};

const pptxgen = require("pptxgenjs");
const { applyTheme } = require("/mnt/skills/public/pptx/scripts/apply_theme.js");
const { THEME, K, icon, setupMasters, src } = require("./lib.js");
(async () => {
const pres = new pptxgen(); setupMasters(pres);
pres.title="PetCuida — Crescimento e escalabilidade (Atividade XIII)";
pres.author="Gabriel da Silva Cassino; Giovanna Naves Ribeiro; Júlia Rodrigues Vasconcellos Melo; Kathleen Rodrigues Leite Barbosa";
const I={};
for (const [k,n,c] of [["paw","FaPaw",K.white],["handshake","FaHandshake",K.white],["rocket","FaRocket",K.white],["cogs","FaCogs",K.white],["cloud","FaCloud",K.white],["copy","FaClone",K.white],["sync","FaSyncAlt",K.white],["lock","FaLock",K.white],["coins","FaCoins",K.white],["users","FaUsers",K.white],["hand","FaHandHoldingUsd",K.white],["bullseye","FaBullseye",K.white],["map","FaMapMarkedAlt",K.white]]) I[k]=await icon(n,c);
const circ=(s,x,y,d,color,ic)=>{ s.addShape(pres.shapes.OVAL,{x,y,w:d,h:d,fill:{color},line:{color,width:0},objectName:"Círculo de ícone"}); s.addImage({data:ic,x:x+0.22*d,y:y+0.22*d,w:0.56*d,h:0.56*d,altText:"ícone"}); };
const card=(s,x,y,w,h,fill=K.tint)=>s.addShape(pres.shapes.ROUNDED_RECTANGLE,{x,y,w,h,fill:{color:fill},line:{color:fill,width:0},rectRadius:0.12,objectName:"Cartão"});
const bl=(a)=>a.map((t,j)=>({text:t,options:{bullet:true,breakLine:j<a.length-1}}));

let s=pres.addSlide({masterName:"COVER"});
s.addText("Crescer com viabilidade e coerência",{placeholder:"title"});
s.addText("PetCuida · Plano de crescimento e escalabilidade",{x:0.8,y:3.9,w:7.6,h:0.6,fontFace:"Cambria",fontSize:22,italic:true,color:K.amber,margin:0,isTextBox:true});
s.addText([{text:"Gabriel da Silva Cassino",options:{breakLine:true}},{text:"Giovanna Naves Ribeiro",options:{breakLine:true}},{text:"Júlia Rodrigues Vasconcellos Melo",options:{breakLine:true}},{text:"Kathleen Rodrigues Leite Barbosa"}],{x:0.8,y:4.7,w:7.4,h:1.4,fontSize:18,color:K.white,margin:0,isTextBox:true});
s.addText("PUC Minas · Tópicos III — Atividade XIII",{x:0.8,y:6.6,w:9,h:0.4,fontSize:14,color:K.pale,margin:0,isTextBox:true});
s.addShape(pres.shapes.OVAL,{x:8.9,y:1.3,w:4.0,h:4.0,fill:{color:K.tealMid},line:{color:K.tealMid,width:0}});
s.addShape(pres.shapes.OVAL,{x:9.5,y:1.9,w:2.8,h:2.8,fill:{color:K.coral},line:{color:K.coral,width:0}});
s.addImage({data:I.rocket,x:10.15,y:2.55,w:1.5,h:1.5,altText:"foguete"});

s=pres.addSlide({masterName:"LIGHT"});
s.addText("Diagnóstico: fase de validação",{placeholder:"title"});
card(s,0.6,1.75,4.6,4.9,K.teal);
s.addText("33,45%",{x:0.9,y:1.95,w:4,h:1.0,fontFace:"Cambria",fontSize:54,bold:true,color:K.amber,margin:0,isTextBox:true});
s.addText("das startups brasileiras estão em validação; apenas 3,72% estão em escala",{x:0.9,y:3.0,w:4.0,h:1.2,fontSize:16,color:K.white,margin:0,valign:"top",isTextBox:true});
s.addText("PetCuida: protótipo testado em 5 sessões exploratórias, sem receita e sem usuários pagantes.",{x:0.9,y:4.5,w:4.0,h:1.5,fontSize:18,bold:true,color:K.white,margin:0,valign:"top",isTextBox:true});
const ch=[["Disposição a pagar ainda não medida",I.hand,K.coral],["Resultado positivo depende de convênio",I.handshake,K.tealMid],["Fundo de créditos (R$ 6,60) > margem por atendimento (R$ 5,24)",I.coins,K.deep],["CAC, ativação e retenção não medidos",I.bullseye,K.amber],["Arranque dos dois lados: tutores e clínicas",I.users,K.teal]];
ch.forEach((c,i)=>{ const y=1.75+i*1.0; card(s,5.5,y,7.2,0.88); circ(s,5.65,y+0.1,0.68,c[2],c[1]); s.addText(c[0],{x:6.5,y:y,w:6.1,h:0.88,fontSize:16,color:K.ink,margin:0,valign:"middle",isTextBox:true}); });
src(s,"Fontes: Observatório Sebrae Startups (Startups Report Brasil 2024); Atividades VI e IX. Mapa da rede demonstrativo e login simulado no protótipo.");
s.addNotes("Diagnóstico: validação inicial. Cinco desafios principais, com evidências no documento da Atividade XIII.");

s=pres.addSlide({masterName:"LIGHT"});
s.addText("E1 · Densidade local por parcerias (principal)",{placeholder:"title"});
const st=[["Parcerias",I.handshake,K.teal,"3 clínicas no piloto (3 meses grátis) e ONGs como porta de entrada"],["Aquisição",I.users,K.tealMid,"QR no balcão, redes sociais e indicação com créditos; teto de CAC de R$ 3,29"],["Expansão por praça",I.map,K.coral,"Nova área só com gatilhos atingidos"]];
st.forEach((t,i)=>{ const x=0.6+i*4.1; card(s,x,1.75,3.8,3.05); circ(s,x+0.3,1.98,0.95,t[2],t[1]); s.addText(t[0],{x:x+1.45,y:2.0,w:2.2,h:0.9,fontFace:"Cambria",fontSize:22,bold:true,color:K.teal,margin:0,valign:"middle",isTextBox:true}); s.addText(t[3],{x:x+0.3,y:3.15,w:3.2,h:1.5,fontSize:16,color:K.ink,margin:0,valign:"top",isTextBox:true}); });
card(s,0.6,5.05,12.1,1.6,K.teal);
s.addText("Gatilhos para abrir nova praça",{x:0.9,y:5.12,w:6,h:0.45,fontSize:16,bold:true,color:K.amber,margin:0,isTextBox:true});
s.addText("10 clínicas · 1.500 usuários · CAC ≤ teto · 5% de assinantes · fundo ≤ R$ 6,60 por atendimento · convênio contratado",{x:0.9,y:5.55,w:11.4,h:0.95,fontSize:18,color:K.white,margin:0,valign:"top",isTextBox:true});
src(s,"Fonte: Atividades VIII e IX; plataformas de dois lados (Rochet e Tirole, 2003; Eisenmann et al., 2006).");

s=pres.addSlide({masterName:"LIGHT"});
s.addText("Piloto assistido de 8 semanas",{placeholder:"title"});
const wk=[["Semanas 1–2","Descoberta","15–20 tutores · 5 clínicas · 2 organizações",K.teal],["Semanas 3–4","Revisão e teste","10 testes sem ajuda · ≥ 8 concluem as tarefas",K.tealMid],["Semanas 5–8","Piloto concierge","40–50 tutores · 2–3 clínicas, com consentimento",K.coral],["Semana 8","Decisão","Continuar, iterar ou ampliar",K.deep]];
wk.forEach((w,i)=>{ const x=0.6+i*3.1; card(s,x,1.75,2.9,2.9);
  s.addShape(pres.shapes.RECTANGLE,{x,y:1.75,w:2.9,h:0.12,fill:{color:w[3]},line:{color:w[3],width:0},objectName:"Faixa"});
  s.addText(w[0],{x:x+0.2,y:2.0,w:2.5,h:0.45,fontSize:16,bold:true,color:w[3],margin:0,isTextBox:true});
  s.addText(w[1],{x:x+0.2,y:2.5,w:2.5,h:0.6,fontFace:"Cambria",fontSize:22,bold:true,color:K.teal,margin:0,isTextBox:true});
  s.addText(w[2],{x:x+0.2,y:3.2,w:2.5,h:1.3,fontSize:16,color:K.ink,margin:0,valign:"top",isTextBox:true}); });
const mt=[["60%","ativação: perfil do pet e 1º lembrete em até 7 dias"],["30%","retenção: ação relevante entre os dias 22 e 30"],["80%","explicam o QR e os créditos sem ajuda"]];
mt.forEach((m,i)=>{ const x=0.6+i*4.1; card(s,x,4.95,3.8,1.7,K.teal);
  s.addText(m[0],{x:x+0.25,y:5.0,w:1.6,h:1.6,fontFace:"Cambria",fontSize:40,bold:true,color:K.amber,margin:0,valign:"middle",isTextBox:true});
  s.addText(m[1],{x:x+1.8,y:5.0,w:1.85,h:1.6,fontSize:14,color:K.white,margin:0,valign:"middle",isTextBox:true}); });
src(s,"Fonte: documento da Atividade XIII (Subseção 3.3). Quantidades são objetivos de aprendizagem, não resultados; segurança e LGPD antes da semana 5.");
s.addNotes("O piloto reduz incertezas em sequência. As metas são critérios de aprendizagem a discutir com o grupo; se a amostra for menor, reportamos contagens e limitações, sem extrapolar.");

s=pres.addSlide({masterName:"LIGHT"});
s.addText("E2 · Mais receita por usuário (complementar)",{placeholder:"title"});
const lv=[["Assinantes","5%","8%","teste de preço e plano anual"],["Fundo de créditos","R$ 6,60","R$ 3,30","campanhas patrocinadas"],["Parceiros pagantes","1 por 150","1 por 100","Plano Parceiro com agenda"]];
lv.forEach((l,i)=>{ const y=1.75+i*1.5; card(s,0.6,y,12.1,1.3);
  s.addText(l[0],{x:0.9,y:y,w:3.4,h:1.3,fontFace:"Cambria",fontSize:24,bold:true,color:K.teal,margin:0,valign:"middle",isTextBox:true});
  s.addText([{text:l[1],options:{color:K.muted,fontSize:28,fontFace:"Cambria"}},{text:"   →   ",options:{color:K.coral,fontSize:28,bold:true}},{text:l[2],options:{color:K.tealMid,bold:true,fontSize:32,fontFace:"Cambria"}}],{x:4.3,y:y,w:4.6,h:1.3,margin:0,valign:"middle",isTextBox:true});
  s.addText(l[3],{x:9.0,y:y,w:3.5,h:1.3,fontSize:16,color:K.ink,margin:0,valign:"middle",isTextBox:true}); });
card(s,0.6,6.2,12.1,0.6,K.coral);
s.addText("Resultado combinado: contribuição por usuário de R$ 0,55 para R$ 1,42 por mês.",{x:0.9,y:6.2,w:11.5,h:0.6,fontSize:18,bold:true,color:K.white,margin:0,valign:"middle",isTextBox:true});
src(s,"Fonte: simulação dos autores a partir do modelo da Atividade IX (Apêndice A do documento).");

s=pres.addSlide({masterName:"LIGHT"});
s.addText("Escalar é elevar a margem, não só o volume",{placeholder:"title"});
s.addChart(pres.charts.BAR,[{name:"Usuários para equilíbrio",labels:["Base","Fundo −50%","Assinantes 8%","Parceiros 1/100","Preço R$ 14,90","Combinadas"],values:[10155,6339,6519,7089,8876,3918]}],
 {x:0.5,y:1.6,w:6.9,h:5.2,barDir:"bar",chartColors:[K.teal],showValue:true,dataLabelFormatCode:"#,##0",dataLabelFontSize:13,dataLabelFontFace:"+mn-lt",dataLabelColor:K.ink,
  catAxisLabelFontSize:13,catAxisLabelFontFace:"+mn-lt",catAxisOrientation:"maxMin",valAxisLabelFontSize:12,valAxisLabelFontFace:"+mn-lt",valAxisLabelFormatCode:"#,##0",valGridLine:{color:"D5E3E4",size:0.5},catGridLine:{style:"none"},showLegend:false,
  showTitle:true,title:"Usuários ativos para o equilíbrio do cenário B (com convênio)",titleFontSize:14,titleColor:K.teal,titleFontFace:"+mn-lt"});
const sc=[["Automação",I.cogs,K.coral,"Onboarding de clínicas, lembretes, conciliação"],["Tecnologia",I.cloud,K.tealMid,"Backend seguro e testes antes de dados reais"],["Pacote de praça",I.copy,K.teal,"Kit replicável de abertura por cidade"],["Receita recorrente",I.sync,K.deep,"Assinatura, Plano Parceiro e convênios"]];
sc.forEach((c,i)=>{ const y=1.7+i*1.2; card(s,7.7,y,5.0,1.05); circ(s,7.82,y+0.12,0.8,c[2],c[1]); s.addText([{text:c[0],options:{bold:true,fontSize:18,fontFace:"Cambria",color:K.teal,breakLine:true}},{text:c[3],options:{fontSize:14,color:K.ink}}],{x:8.8,y:y,w:3.8,h:1.05,margin:0,valign:"middle",isTextBox:true}); });
src(s,"Fonte: simulação dos autores (Atividade IX; Apêndice A). Premissas são estimativas a validar no piloto.");

s=pres.addSlide({masterName:"LIGHT"});
s.addText("Plano de ação resumido",{placeholder:"title"});
const th=(t)=>({text:t,options:{bold:true,color:K.white,fill:{color:K.teal},fontSize:14,valign:"middle"}});
const td=(t,f)=>({text:t,options:{fontSize:14,color:K.ink,valign:"top",fill:{color:f||K.white}}});
s.addTable([[th("Estratégia"),th("Ações-chave"),th("Recursos"),th("Indicadores")],
 [td("E1 Densidade local (principal)",K.tint),td("Piloto assistido de 8 semanas (40–50 tutores, 2–3 clínicas); 3 clínicas e 2 ONGs; QR por parceiro; medir CAC, ativação e retenção"),td("4 integrantes; R$ 150 + teto de R$ 438/mês de aquisição; consultoria veterinária e jurídica já nos custos"),td("300 (se decisão favorável), 800 e 1.500 usuários nos meses 3, 6, 12; ativação 60%; retenção D30 30%; CAC ≤ R$ 3,29")],
 [td("E2 Mais receita por usuário",K.tint),td("Teste de preço; PetCuida+ com plano anual; patrocínio para o fundo; novos serviços só com demanda"),td("Dev: Gabriel e Kathleen; material comercial; parecer jurídico"),td("Conversão 5% → 8%; fundo R$ 6,60 → 3,30; ≥ 1 convênio; recorrente ≥ 40%")]],
 {x:0.6,y:1.7,w:12.1,colW:[2.1,3.8,3.2,3.0],border:{type:"solid",pt:1,color:"D5E3E4"},rowH:[0.5,1.9,1.9]});
src(s,"Fonte: documento da Atividade XIII (Tabelas 10 e 11). Metas são hipóteses derivadas da Atividade IX.");

s=pres.addSlide({masterName:"LIGHT"});
s.addText("Trajetória-alvo e condições de viabilidade",{placeholder:"title"});
s.addChart(pres.charts.LINE,[{name:"Usuários ativos mensais",labels:["Mês 3","Mês 6","Mês 12","Mês 18","Mês 24"],values:[300,800,1500,2700,5000]}],
 {x:0.5,y:1.6,w:6.9,h:5.2,chartColors:[K.coral],lineSize:3,lineDataSymbolSize:9,showValue:true,dataLabelPosition:"t",dataLabelFormatCode:"#,##0",dataLabelFontSize:14,dataLabelFontFace:"+mn-lt",dataLabelColor:K.ink,
  catAxisLabelFontSize:13,catAxisLabelFontFace:"+mn-lt",valAxisLabelFontSize:12,valAxisLabelFontFace:"+mn-lt",valAxisLabelFormatCode:"#,##0",valGridLine:{color:"D5E3E4",size:0.5},showLegend:false,
  showTitle:true,title:"Meta de usuários ativos (hipótese)",titleFontSize:14,titleColor:K.teal,titleFontFace:"+mn-lt"});
s.addText("O plano só é viável se, no piloto:",{x:7.7,y:1.75,w:5,h:0.5,fontFace:"Cambria",fontSize:20,bold:true,color:K.teal,margin:0,isTextBox:true});
const cd=["Ao menos um convênio ou patrocínio for contratado","O CAC observado não passar do teto","O fundo de créditos for reduzido ou limitado"];
cd.forEach((t,i)=>{ const y=2.4+i*1.15; card(s,7.7,y,5.0,1.0); s.addText(String(i+1),{x:7.85,y:y,w:0.6,h:1.0,fontFace:"Cambria",fontSize:32,bold:true,color:K.coral,margin:0,valign:"middle",isTextBox:true}); s.addText(t,{x:8.6,y:y,w:4.0,h:1.0,fontSize:16,color:K.ink,margin:0,valign:"middle",isTextBox:true}); });
card(s,7.7,5.95,5.0,0.85,K.teal);
s.addText("Se o CAC passar de 2× o teto ou o fundo não cair em 6 meses: revisar o modelo.",{x:7.85,y:5.95,w:4.75,h:0.85,fontSize:14,bold:true,color:K.white,margin:0,valign:"middle",isTextBox:true});
src(s,"Fonte: documento da Atividade XIII. Custos fixos mantidos constantes na simulação (premissa otimista).");

await pres.writeFile({fileName:"Atividade_XIII_Crescimento_PetCuida_Final.pptx"});
await applyTheme("Atividade_XIII_Crescimento_PetCuida_Final.pptx", THEME);
console.log("ok13");
})().catch(e=>{console.error(e);process.exit(1)});

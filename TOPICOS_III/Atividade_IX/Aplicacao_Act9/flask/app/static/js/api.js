const request = async (url, options = {}) => {
  const isForm = options.body instanceof FormData;
  const response = await fetch(`/api${url}`, { ...(isForm ? {} : { headers: { 'Content-Type': 'application/json' } }), ...options });
  const data = await response.json().catch(() => ({}));
  if (!response.ok) throw new Error(data.error || 'Não foi possível concluir a operação.');
  return data;
};
export const api = {
  login: (value) => request('/auth/login', {method:'POST',body:JSON.stringify(value)}), register: (value) => request('/auth/register', {method:'POST',body:JSON.stringify(value)}),
  pets: (userId=1) => request(`/pets?user_id=${userId}`), addPet: (value) => request('/pets', {method:'POST',body:JSON.stringify(value)}), services: () => request('/services'), appointments: (userId=1) => request(`/appointments?user_id=${userId}`), book: (value) => request('/appointments', {method:'POST',body:JSON.stringify(value)}), triage: () => request('/triage'), status: () => request('/status'),
  organizationOverview: (id) => request(`/organization/overview?organization_id=${id}`), addProfessional: (value) => request('/organization/professionals',{method:'POST',body:JSON.stringify(value)}), importProfessionals: (id,file) => { const body=new FormData(); body.append('organization_id',id); body.append('file',file); return request('/organization/professionals/import',{method:'POST',body}); }, addOffer: (value) => request('/organization/offers',{method:'POST',body:JSON.stringify(value)}), acceptDemand: (id,value) => request(`/organization/demands/${id}/accept`,{method:'POST',body:JSON.stringify(value)}),
};

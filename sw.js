// Échecs à trois dimensions : fonctionnement hors ligne.
// La page est d'abord demandée au réseau (pour recevoir les mises à jour),
// et la copie en cache sert quand il n'y a pas de connexion.
const CACHE='echecs3d-v1';
const FILES=['./','./index.html','./three.module.js','./peerjs.min.js','./favicon.svg','./apple-touch-icon.png','./icon-192.png','./icon-512.png','./icon-512-maskable.png','./manifest.webmanifest'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(CACHE).then(c=>c.addAll(FILES)).then(()=>self.skipWaiting()))});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(ks=>Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim()))});
function timeout(ms,p){return new Promise((ok,ko)=>{const t=setTimeout(()=>ko(new Error('délai')),ms);p.then(v=>{clearTimeout(t);ok(v)},e=>{clearTimeout(t);ko(e)})})}
self.addEventListener('fetch',e=>{
  const r=e.request;if(r.method!=='GET')return;
  const u=new URL(r.url);if(u.origin!==location.origin)return; // PeerJS, etc. : réseau seulement
  const page=r.mode==='navigate'||u.pathname.endsWith('/')||u.pathname.endsWith('.html');
  if(page){
    e.respondWith(timeout(4000,fetch(r)).then(res=>{const c=res.clone();caches.open(CACHE).then(ca=>ca.put('./index.html',c));return res})
      .catch(()=>caches.match('./index.html').then(m=>m||caches.match('./'))));
    return}
  // fichiers (three.js, icônes…) : cache d'abord, mis à jour en arrière-plan
  e.respondWith(caches.match(r).then(m=>{const net=fetch(r).then(res=>{if(res.ok){const c=res.clone();caches.open(CACHE).then(ca=>ca.put(r,c))}return res}).catch(()=>m);return m||net}));
});

// =====================================================================
// 03. COMMUNITY DETECTION DENGAN LOUVAIN
// ---------------------------------------------------------------------
// Hasil kami: 73 komunitas, modularity 0.6256
// =====================================================================

// --- 3.1 Salin graf user-user (relasi SIMILAR) ke memori GDS -----------
CALL gds.graph.project('userSimilar', 'User',
  {SIMILAR: {orientation: 'UNDIRECTED', properties: 'score'}});

// --- 3.2 Jalankan Louvain, simpan nomor komunitas di properti community -
CALL gds.louvain.write('userSimilar', {
  relationshipWeightProperty: 'score',
  writeProperty: 'community'
})
YIELD communityCount, modularity;

// --- 3.3 Validasi: hitung modularity secara manual ---------------------
// Rumus: Q = SUM_c [ Lc/m - (dc/2m)^2 ]
// Hasil harus sama dengan output Louvain (0.6256)
MATCH ()-[s:SIMILAR]->()
WITH sum(s.score) AS m
MATCH (u:User)
OPTIONAL MATCH (u)-[s:SIMILAR]-()
WITH m, u.community AS komunitas, sum(s.score) AS d
OPTIONAL MATCH (a:User {community: komunitas})-[s2:SIMILAR]->(b:User {community: komunitas})
WITH m, komunitas, d, sum(s2.score) AS L
RETURN round(sum(L / m - (d / (2 * m)) ^ 2), 4) AS totalModularity;

// --- 3.4 Kontribusi modularity per komunitas ---------------------------
MATCH ()-[s:SIMILAR]->()
WITH sum(s.score) AS m
MATCH (u:User)
OPTIONAL MATCH (u)-[s:SIMILAR]-()
WITH m, u.community AS komunitas, sum(s.score) AS d
OPTIONAL MATCH (a:User {community: komunitas})-[s2:SIMILAR]->(b:User {community: komunitas})
WITH m, komunitas, d, sum(s2.score) AS L
RETURN komunitas,
       round(L, 2) AS bobotDalam,
       round(d, 2) AS totalDerajat,
       round(L / m - (d / (2 * m)) ^ 2, 4) AS kontribusiQ
ORDER BY kontribusiQ DESC;

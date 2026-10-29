// =====================================================================
// 02. MEMBANGUN GRAF KEMIRIPAN ANTAR USER (NODE SIMILARITY / JACCARD)
// ---------------------------------------------------------------------
// Butuh plugin Graph Data Science (GDS).
// Kemiripan Jaccard = film yang sama-sama disukai / semua film yang disukai
// =====================================================================

// --- 2.1 Rating >= 4 dianggap "suka" -----------------------------------
MATCH (u:User)-[r:RATED]->(m:Movie)
WHERE r.rating >= 4
CREATE (u)-[:LIKED]->(m);

// --- 2.2 Salin graf User-Film ke memori GDS ----------------------------
CALL gds.graph.project('userFilm', ['User', 'Movie'], 'LIKED');

// --- 2.3 Hitung kemiripan, tulis relasi SIMILAR antar user -------------
// topK: 10              -> tiap user disambung ke maks. 10 user paling mirip
// similarityCutoff: 0.1 -> kemiripan di bawah 0,1 diabaikan
CALL gds.nodeSimilarity.write('userFilm', {
  topK: 10,
  similarityCutoff: 0.1,
  writeRelationshipType: 'SIMILAR',
  writeProperty: 'score'
})
YIELD nodesCompared, relationshipsWritten;

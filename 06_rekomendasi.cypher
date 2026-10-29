// =====================================================================
// 06. REKOMENDASI FILM BERBASIS KOMUNITAS
// ---------------------------------------------------------------------
// Ide: user satu komunitas seleranya mirip. Film yang disukai teman
// sekomunitas (dan belum ditonton si A) direkomendasikan ke si A.
// Contoh: user 177 (Louvain_C) yang memberi Titanic (1997) rating 5.0
// =====================================================================

// --- 6.1 Cari user di komunitas A-G yang suka Titanic -------------------
MATCH (u:User)-[:LIKED]->(:Movie {title: 'Titanic (1997)'})
WHERE u.namaKomunitas IS NOT NULL
RETURN u.userId AS userId, u.namaKomunitas AS komunitas
ORDER BY komunitas
LIMIT 20;

// --- 6.2 Rekomendasi untuk user 177 (tabel) -----------------------------
MATCH (a:User {userId: 177})
MATCH (x:Movie {title: 'Titanic (1997)'})
MATCH (teman:User {community: a.community})-[:LIKED]->(x)
MATCH (teman)-[:LIKED]->(m:Movie)
WHERE teman <> a AND m <> x
  AND NOT EXISTS { (a)-[:RATED]->(m) }
RETURN a.namaKomunitas AS komunitas,
       m.title AS rekomendasi,
       count(DISTINCT teman) AS jumlahTemanYangSuka
ORDER BY jumlahTemanYangSuka DESC
LIMIT 10;

// --- 6.3 Rekomendasi untuk user 177 (graf: 5 film, 3 teman per film) ----
MATCH (a:User {userId: 177})
MATCH (x:Movie {title: 'Titanic (1997)'})
MATCH (teman:User {community: a.community})-[:LIKED]->(x)
MATCH (teman)-[:LIKED]->(m:Movie)
WHERE teman <> a AND m <> x
  AND NOT EXISTS { (a)-[:RATED]->(m) }
WITH a, x, m, count(DISTINCT teman) AS skor
ORDER BY skor DESC
LIMIT 5
MATCH jalur = (x)<-[:LIKED]-(t:User {community: a.community})-[:LIKED]->(m)
WHERE t <> a
WITH a, x, m, collect(jalur)[0..3] AS buktiJalur
OPTIONAL MATCH sukaX = (a)-[:RATED]->(x)
RETURN a, x, m, buktiJalur, sukaX;

// --- 6.4 Rekomendasi umum untuk satu user (tanpa film acuan) ------------
MATCH (a:User {userId: 177})
MATCH (teman:User {community: a.community})-[:LIKED]->(m:Movie)
WHERE teman <> a
  AND NOT EXISTS { (a)-[:RATED]->(m) }
RETURN m.title AS rekomendasi,
       count(DISTINCT teman) AS jumlahTemanYangSuka
ORDER BY jumlahTemanYangSuka DESC
LIMIT 10;

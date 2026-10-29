// =====================================================================
// 01. IMPORT DATA MOVIELENS KE NEO4J
// ---------------------------------------------------------------------
// Taruh movies.csv dan ratings.csv di folder "import" database Neo4j.
// Jalankan query satu per satu, sesuai urutan.
// Hasil akhir: (User)-[:RATED {rating}]->(Movie)-[:HAS]->(Genre)
// =====================================================================

// --- 1.1 Constraint (agar node unik dan import lebih cepat) ----------
CREATE CONSTRAINT IF NOT EXISTS FOR (m:Movie) REQUIRE m.movieId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (u:User)  REQUIRE u.userId  IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (g:Genre) REQUIRE g.name    IS UNIQUE;

// --- 1.2 Import film dan genre (movies.csv) ---------------------------
LOAD CSV WITH HEADERS FROM 'file:///movies.csv' AS row
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET m.title = row.title
WITH m, row
UNWIND split(row.genres, '|') AS genre
MERGE (g:Genre {name: genre})
MERGE (m)-[:HAS]->(g);

// --- 1.3 Import user dan rating (ratings.csv) --------------------------
// Awalan ":auto" wajib di Neo4j Browser/Query agar IN TRANSACTIONS jalan.
// Pakai MERGE supaya tidak dobel walau query dijalankan ulang.
:auto LOAD CSV WITH HEADERS FROM 'file:///ratings.csv' AS row
CALL (row) {
  MATCH (m:Movie {movieId: toInteger(row.movieId)})
  MERGE (u:User {userId: toInteger(row.userId)})
  MERGE (u)-[r:RATED]->(m)
  SET r.rating = toFloat(row.rating)
} IN TRANSACTIONS OF 5000 ROWS;

// --- 1.4 Cek hasil import ----------------------------------------------
// Harapan: User 610, Movie 9.742, Genre 20
MATCH (n) RETURN labels(n) AS label, count(*) AS jumlah;

// Harapan: 100.836
MATCH (:User)-[r:RATED]->(:Movie) RETURN count(r) AS jumlahRating;

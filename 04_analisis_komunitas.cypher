// =====================================================================
// 04. ANALISIS DAN PENAMAAN KOMUNITAS
// ---------------------------------------------------------------------
// CATATAN: ID komunitas (299, 564, dst.) adalah hasil run kami.
// Kalau Louvain dijalankan ulang, ID-nya bisa berbeda: cek dulu dengan 4.1.
// =====================================================================

// --- 4.1 Ukuran tiap komunitas -----------------------------------------
MATCH (u:User)
RETURN u.community AS komunitas, count(*) AS jumlahUser
ORDER BY jumlahUser DESC;

// --- 4.2 Beri nama Louvain A-G untuk 7 komunitas terbesar ---------------
// Label dipakai untuk mewarnai graf, properti namaKomunitas untuk tabel.
MATCH (u:User {community: 299}) SET u:Louvain_A, u.namaKomunitas = 'A';
MATCH (u:User {community: 564}) SET u:Louvain_B, u.namaKomunitas = 'B';
MATCH (u:User {community: 248}) SET u:Louvain_C, u.namaKomunitas = 'C';
MATCH (u:User {community: 468}) SET u:Louvain_D, u.namaKomunitas = 'D';
MATCH (u:User {community: 493}) SET u:Louvain_E, u.namaKomunitas = 'E';
MATCH (u:User {community: 269}) SET u:Louvain_F, u.namaKomunitas = 'F';
MATCH (u:User {community: 76})  SET u:Louvain_G, u.namaKomunitas = 'G';

// --- 4.3 Cek penamaan -----------------------------------------------------
MATCH (u:User) WHERE u.namaKomunitas IS NOT NULL
RETURN u.namaKomunitas AS komunitas, u.community AS idLouvain, count(*) AS jumlahUser
ORDER BY komunitas;

// --- 4.4 Lima film paling disukai per komunitas -------------------------
MATCH (u:User)-[:LIKED]->(m:Movie)
WHERE u.namaKomunitas IS NOT NULL
WITH u.namaKomunitas AS komunitas, m.title AS film, count(*) AS n
ORDER BY komunitas, n DESC
RETURN komunitas, collect(film)[0..5] AS filmFavorit;

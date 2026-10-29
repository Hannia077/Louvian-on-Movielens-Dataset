// =====================================================================
// 05. VISUALISASI GRAF
// ---------------------------------------------------------------------
// Agar node berwarna per komunitas: di panel Results overview klik ikon
// urutan label, lalu geser label "User" ke paling bawah (di bawah Louvain_A-G).
// =====================================================================

// --- 5.1 Graf 7 komunitas besar (dibatasi 600 relasi agar ringan) -------
MATCH p = (a:User)-[s:SIMILAR]->(b:User)
WHERE a.namaKomunitas IS NOT NULL AND b.namaKomunitas IS NOT NULL
RETURN p
LIMIT 600;

// --- 5.2 Graf 7 komunitas besar tanpa batas -----------------------------
MATCH p = (a:User)-[:SIMILAR]->(b:User)
WHERE a.namaKomunitas IS NOT NULL AND b.namaKomunitas IS NOT NULL
RETURN p;

// --- 5.3 Graf keseluruhan (610 user, termasuk user yang sendirian) ------
MATCH (u:User)
OPTIONAL MATCH p = (u)-[:SIMILAR]->(:User)
RETURN u, p;

// --- 5.4 Satu komunitas saja (ganti Louvain_G sesuai kebutuhan) ---------
MATCH p = (a:Louvain_G)-[:SIMILAR]->(b:Louvain_G)
RETURN p;

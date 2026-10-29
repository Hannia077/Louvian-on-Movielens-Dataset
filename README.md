# Community Detection (Louvain) pada Dataset MovieLens
Mengelompokkan user MovieLens berdasarkan selera film dengan algoritma **Louvain** di **Neo4j Graph Data Science**, lalu memakai komunitasnya untuk **rekomendasi film**.

Anggota Kelompok 1:
- Hafiz Ramadhan (23031554049)
- Hannia Hary Putri (23031554077)
- Tsalma Masyhta Zahwa (23031554103)
- Bintang Prananda Putra (23031554131)

## Tools

- Neo4j Desktop (database 5.x)
- Plugin Graph Data Science (GDS)
- Dataset MovieLens versi kecil (`movies.csv`, `ratings.csv`)

## Alur

1. **Import data**: `(User)-[:RATED {rating}]->(Movie)-[:HAS]->(Genre)`
2. **Rating ≥ 4 dianggap suka**: relasi `LIKED`
3. **Kemiripan antar user** (Node Similarity, Jaccard): relasi `SIMILAR` ke maksimal 10 user paling mirip, kemiripan minimal 0,1
4. **Louvain** pada graf user–user, dengan skor kemiripan sebagai bobot
5. **Rekomendasi**: film yang disukai teman sekomunitas dan belum ditonton user

## Cara menjalankan

1. Buat database di Neo4j Desktop dan install plugin **Graph Data Science**.
2. Salin `movies.csv` dan `ratings.csv` ke folder **import** database.
3. Jalankan file di folder `cypher/` sesuai urutan, satu query per eksekusi:

| File | Isi |
| --- | --- |
| `01_import_data.cypher` | Constraint, import film, genre, user, dan rating |
| `02_graf_kemiripan_user.cypher` | Relasi LIKED dan Node Similarity (relasi SIMILAR) |
| `03_louvain.cypher` | Louvain dan validasi modularity secara manual |
| `04_analisis_komunitas.cypher` | Ukuran komunitas, penamaan Louvain A–G, film favorit |
| `05_visualisasi.cypher` | Query untuk menampilkan graf |
| `06_rekomendasi.cypher` | Rekomendasi film untuk user 177 (film acuan: Titanic) |

> ID komunitas di `04_analisis_komunitas.cypher` (299, 564, dst.) adalah hasil run kami. Jika Louvain dijalankan ulang, cek ID-nya dulu dengan query 4.1.

## Hasil

- **73 komunitas**, modularity **0,626** (kuat). Hitung manual dengan rumus juga menghasilkan **0,6256**.
- 7 komunitas besar (Louvain A–G) berisi **536 user (88%)**, 4 komunitas kecil berisi 12 user, dan 62 user berada sendirian.

| Komunitas | A | B | C | D | E | F | G |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Jumlah user | 163 | 108 | 96 | 72 | 48 | 27 | 22 |

**Contoh rekomendasi** untuk user 177 (Louvain_C, memberi Titanic rating 5,0):

| # | Film | Teman yang suka |
| --- | --- | --- |
| 1 | The Sixth Sense (1999) | 15 |
| 2 | Saving Private Ryan (1998) | 15 |
| 3 | The Green Mile (1999) | 13 |
| 4 | American History X (1998) | 12 |
| 5 | Gladiator (2000) | 12 |

Kelima film bergenre Drama, sama seperti Titanic, dan rilis 1998–2000.

## Keterbatasan

- User yang sendirian di komunitasnya tidak mendapat rekomendasi (*cold start*).
- Film yang sangat populer cenderung selalu muncul di urutan atas (*popularity bias*).

## PPT
https://drive.google.com/file/d/1_UV-2SB6Bk9HW0nek8FsPAQNZ6i2LqfQ/view?usp=sharing

```mermaid
graph TD
    %% --- STYLE DEFINITIONS ---
    classDef actor fill:#e1f5fe,stroke:#01579b,stroke-width:2px,color:black;
    classDef process fill:#fff9c4,stroke:#fbc02d,stroke-width:2px,color:black;
    classDef store fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px,stroke-dasharray: 5 5,color:black;
    classDef external fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px,color:black;

    %% --- ENTITIES (ACTORS) ---
    Admin((Super Admin /<br/>Gugus Mutu)):::actor
    PIC((PIC Unit /<br/>Dosen)):::actor
    Supervisor((Supervisor /<br/>Verifikator)):::actor
    Auditor[Auditor Eksternal<br/>(Asesor)]:::external
    UserLain[User Lain<br/>(Peminjam)]:::actor

    %% --- DATA STORES (DATABASE TABLES) ---
    subgraph Database [Penyimpanan Data]
        StoreInstrumen[(DS1: Instrumen &<br/>Asesmen)]:::store
        StorePeriode[(DS2: Periode &<br/>Penugasan)]:::store
        StoreEviden[(DS3: Eviden &<br/>File Fisik)]:::store
        StorePermohonan[(DS4: Permohonan<br/>Data)]:::store
    end

    %% --- PROCESS 1: PERENCANAAN (SETUP INSTRUMEN) ---
    subgraph P1 [Proses 1: Setup & Penugasan]
        P1_1(1.0 Manajemen Master Data):::process
        P1_2(2.0 Buka Periode &<br/>Distribusi Tugas):::process
    end

    Admin -->|Input Data Kriteria/Butir| P1_1
    P1_1 -->|Simpan Master| StoreInstrumen
    
    Admin -->|Set Tahun & Target Unit| P1_2
    StoreInstrumen -.->|Ambil Data Butir| P1_2
    P1_2 -->|Simpan Mapping Tugas| StorePeriode

    %% --- PROCESS 2: PELAKSANAAN (UPLOAD & VERVAL) ---
    subgraph P2 [Proses 2: Pengumpulan & Validasi]
        P2_1(3.0 Upload Eviden):::process
        P2_2(4.0 Verifikasi Dokumen):::process
    end

    StorePeriode -.->|Notifikasi Tagihan| PIC
    PIC -->|Upload File & Metadata| P2_1
    P2_1 -->|Simpan Draft| StoreEviden
    
    StoreEviden -.->|Notifikasi Menunggu Verval| Supervisor
    Supervisor -->|Review Kualitas| P2_2
    P2_2 -->|Update Status: Disetujui/Revisi| StoreEviden
    P2_2 -.->|Jika Revisi| PIC

    %% --- PROCESS 3: PEMANFAATAN (AUDIT & SHARE) ---
    subgraph P3 [Proses 3: Audit & Akses]
        P3_1(5.0 Peminjaman Data):::process
        P3_2(6.0 Dashboard Akreditasi):::process
    end

    %% Alur Peminjaman (Internal)
    UserLain -->|Request Dokumen Tertentu| P3_1
    P3_1 -->|Cek Izin & Ketersediaan| StoreEviden
    P3_1 -->|Catat Permohonan| StorePermohonan
    StorePermohonan -.->|Notifikasi Approval| PIC
    PIC -->|Approve Peminjaman| P3_1
    P3_1 -.->|Akses Download| UserLain

    %% Alur Audit (Eksternal)
    Admin -->|Buat Akun Tamu (Expired)| Auditor
    Auditor -->|Login & View Data| P3_2
    P3_2 -->|Query Data Valid (Disetujui)| StoreEviden
    P3_2 -->|Mapping ke Instrumen| StoreInstrumen
    P3_2 -.->|Tampilan Tree View| Auditor
```

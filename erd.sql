// Users
Table users {
  id bigint [primary key]
  name varchar
  nip varchar [unique]
  jabatan varchar
  password varchar
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Unit Kerja (dengan hierarki)
Table unit_kerja {
  id bigint [primary key]
  nama_unit varchar
  parent_id bigint [ref: > unit_kerja.id]
  singkatan varchar
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Asesmen
Table asesmen {
  id bigint [primary key]
  nama_asesmen varchar
  singkatan varchar
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Instrumen
Table instrumen {
  id bigint [primary key]
  nama_instrumen varchar
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Periode
Table periode {
  id bigint [primary key]
  jenis_periode varchar
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Instrumen Periode (pivot + atribut)
Table instrumen_periode {
  id bigint [primary key]
  instrumen_id bigint [ref: > instrumen.id]
  periode_id bigint [ref: > periode.id]
  tahun year
  tgl_mulai date
  tgl_selesai date
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Eviden
Table eviden {
  id bigint [primary key]
  pic_id bigint [ref: > users.id]
  supervisor_id bigint [ref: > users.id]
  instrumen_periode_id bigint [ref: > instrumen_periode.id]
  judul_eviden varchar
  deskripsi text
  tingkat_kerahasiaan enum
  status_verval enum
  catatan text
  tanggal_verval timestamp
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Attachments
Table attachments {
  id bigint [primary key]
  eviden_id bigint [ref: > eviden.id]
  nama_file varchar
  file_path varchar
  jenis_file varchar
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Permohonan Data
Table permohonan_data {
  id bigint [primary key]
  user_id bigint [ref: > users.id]
  eviden_id bigint [ref: > eviden.id]
  pic_id bigint [ref: > users.id]
  email varchar
  no_hp varchar
  status enum
  tujuan_permohonan text
  catatan text
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Pivot: Instrumen ↔ Asesmen
Table instrumen_asesmen {
  id bigint [primary key]
  instrumen_id bigint [ref: > instrumen.id]
  asesmen_id bigint [ref: > asesmen.id]
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Pivot: Instrumen ↔ Eviden
Table instrumen_eviden {
  id bigint [primary key]
  instrumen_id bigint [ref: > instrumen.id]
  eviden_id bigint [ref: > eviden.id]
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Pivot: Instrumen ↔ Unit Kerja
Table instrumen_unit_kerja {
  id bigint [primary key]
  instrumen_id bigint [ref: > instrumen.id]
  unit_kerja_id bigint [ref: > unit_kerja.id]
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

// Pivot: User ↔ Unit Kerja
Table unit_user {
  id bigint [primary key]
  user_id bigint [ref: > users.id]
  unit_kerja_id bigint [ref: > unit_kerja.id]
  created_at timestamp
  updated_at timestamp
  deleted_at timestamp
}

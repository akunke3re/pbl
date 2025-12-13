-- ==========================================
-- VIEWS & STORED PROCEDURES
-- ==========================================
-- Centralized data access layer for consistency and reusability

-- ==========================================
-- VIEWS
-- ==========================================

-- View: list_struktur_with_dosen
-- Joins struktur_organisasi, dosen, and files (foto) for complete organizational structure display
CREATE OR REPLACE VIEW list_struktur_with_dosen AS
SELECT 
    so.id,
    so.id_dosen,
    so.jabatan,
    so.urutan,
    d.nama,
    d.deskripsi,
    (f.path || '/' || f.filename) AS foto_path,
    so.created_at,
    so.updated_at
FROM struktur_organisasi so
LEFT JOIN dosen d ON so.id_dosen = d.id
LEFT JOIN files f ON so.foto_id = f.id
ORDER BY 
    CASE 
        WHEN so.jabatan = 'Ketua Laboratorium' THEN 1
        WHEN so.jabatan = 'Wakil Ketua' THEN 2
        WHEN so.jabatan = 'Sekretaris' THEN 3
        WHEN so.jabatan = 'Bendahara' THEN 4
        WHEN so.jabatan = 'Koordinator' THEN 5
        WHEN so.jabatan = 'Anggota' THEN 6
        ELSE 99
    END,
    d.nama ASC;

-- View: list_publikasi_by_dosen
-- Shows publications grouped with dosen details
CREATE OR REPLACE VIEW list_publikasi_by_dosen AS
SELECT 
    p.id,
    p.id_dosen,
    d.nama AS dosen_nama,
    d.deskripsi AS dosen_deskripsi,
    p.judul,
    p.tahun,
    p.jenis,
    p.penerbit,
    p.created_at
FROM publikasi p
LEFT JOIN dosen d ON p.id_dosen = d.id
ORDER BY p.tahun DESC, p.created_at DESC;

-- View: list_partners_with_logo
-- Partners from kolaborasi table with logo files
CREATE OR REPLACE VIEW list_partners_with_logo AS
SELECT 
    k.id,
    k.nama_sponsor,
    k.jenis,
    (f.path || '/' || f.filename) AS logo_path,
    f.filename,
    f.path,
    k.created_at
FROM kolaborasi k
LEFT JOIN files f ON k.image_id = f.id
WHERE LOWER(k.jenis) = 'partner'
ORDER BY k.created_at DESC;

-- View: list_sponsors
-- Sponsors with logo from files table
CREATE OR REPLACE VIEW list_sponsors AS
SELECT 
    s.id,
    s.title,
    s.urutan,
    s.is_visible,
    (f.path || '/' || f.filename) AS logo_path,
    f.filename,
    f.path,
    s.created_at,
    s.updated_at
FROM sponsors s
LEFT JOIN files f ON s.logo_id = f.id
WHERE s.is_visible = TRUE
ORDER BY s.urutan ASC, s.created_at DESC;

-- View: list_berita
-- News articles with image metadata
CREATE OR REPLACE VIEW list_berita AS
SELECT 
    b.id,
    b.judul,
    b.isi,
    b.deskripsi,
    b.kategori,
    b.tanggal,
    (f.path || '/' || f.filename) AS image_path,
    f.filename,
    f.path,
    b.created_at,
    b.updated_at
FROM berita b
LEFT JOIN files f ON b.image_id = f.id
ORDER BY b.tanggal DESC, b.created_at DESC;

-- View: list_produk
-- Products (simple, no file join needed as gambar stored as filename only)
CREATE OR REPLACE VIEW list_produk AS
SELECT 
    id,
    nama,
    deskripsi,
    kategori,
    teknologi,
    status,
    gambar,
    link,
    created_at,
    updated_at
FROM produk
ORDER BY created_at DESC;

-- View: list_contact_messages
-- Incoming messages, newest first
CREATE OR REPLACE VIEW list_contact_messages AS
SELECT 
    id,
    name,
    email,
    subject,
    message,
    is_read,
    created_at
FROM contact_messages
ORDER BY created_at DESC;

-- View: site_settings
-- Current site contact and social media settings
CREATE OR REPLACE VIEW site_settings AS
SELECT 
    id,
    alamat,
    no_hp,
    contact_email,
    facebook,
    twitter,
    instagram,
    linkedin
FROM setting_sosial_media
LIMIT 1;

-- View: list_mission
-- All active missions ordered by urutan
CREATE OR REPLACE VIEW list_mission AS
SELECT 
    id,
    title,
    description,
    urutan,
    created_at,
    updated_at
FROM mission
WHERE is_active = TRUE
ORDER BY urutan ASC, created_at DESC;

-- View: list_priority
-- All active priorities ordered by urutan
CREATE OR REPLACE VIEW list_priority AS
SELECT 
    id,
    title,
    description,
    urutan,
    created_at,
    updated_at
FROM priority
WHERE is_active = TRUE
ORDER BY urutan ASC, created_at DESC;

-- ==========================================
-- STORED PROCEDURES
-- ==========================================

-- Procedure: get_struktur_organisasi_list
-- Returns full organizational structure with dosen and foto details
CREATE OR REPLACE FUNCTION get_struktur_organisasi_list()
RETURNS TABLE (
    id INT,
    id_dosen INT,
    jabatan VARCHAR,
    urutan INT,
    nama VARCHAR,
    deskripsi TEXT,
    foto_path TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY SELECT 
        so.id,
        so.id_dosen,
        so.jabatan,
        so.urutan,
        d.nama,
        d.deskripsi,
        (f.path || '/' || f.filename) AS foto_path,
        so.created_at,
        so.updated_at
    FROM struktur_organisasi so
    LEFT JOIN dosen d ON so.id_dosen = d.id
    LEFT JOIN files f ON so.foto_id = f.id
    ORDER BY 
        CASE 
            WHEN so.jabatan = 'Ketua Laboratorium' THEN 1
            WHEN so.jabatan = 'Wakil Ketua' THEN 2
            WHEN so.jabatan = 'Sekretaris' THEN 3
            WHEN so.jabatan = 'Bendahara' THEN 4
            WHEN so.jabatan = 'Koordinator' THEN 5
            WHEN so.jabatan = 'Anggota' THEN 6
            ELSE 99
        END,
        d.nama ASC;
END;
$$ LANGUAGE plpgsql;

-- Procedure: get_publikasi_by_dosen
-- Returns publications filtered by dosen_id, or all if dosen_id is 0
CREATE OR REPLACE FUNCTION get_publikasi_by_dosen(p_dosen_id INT DEFAULT 0)
RETURNS TABLE (
    id INT,
    id_dosen INT,
    dosen_nama VARCHAR,
    dosen_deskripsi TEXT,
    judul VARCHAR,
    tahun INT,
    jenis VARCHAR,
    penerbit VARCHAR,
    created_at TIMESTAMP
) AS $$
BEGIN
    IF p_dosen_id > 0 THEN
        RETURN QUERY 
        SELECT 
            p.id::INT,
            p.id_dosen,
            d.nama,
            d.deskripsi,
            p.judul,
            p.tahun,
            p.jenis,
            p.penerbit,
            p.created_at
        FROM publikasi p
        LEFT JOIN dosen d ON p.id_dosen = d.id
        WHERE p.id_dosen = p_dosen_id
        ORDER BY p.tahun DESC, p.created_at DESC;
    ELSE
        RETURN QUERY 
        SELECT 
            p.id::INT,
            p.id_dosen,
            d.nama,
            d.deskripsi,
            p.judul,
            p.tahun,
            p.jenis,
            p.penerbit,
            p.created_at
        FROM publikasi p
        LEFT JOIN dosen d ON p.id_dosen = d.id
        ORDER BY p.tahun DESC, p.created_at DESC;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Procedure: get_partners_list
-- Returns all partners with logo paths
CREATE OR REPLACE FUNCTION get_partners_list()
RETURNS TABLE (
    id INT,
    nama_sponsor VARCHAR,
    jenis VARCHAR,
    logo_path TEXT,
    filename VARCHAR,
    path VARCHAR,
    created_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        k.id,
        k.nama_sponsor,
        k.jenis,
        (f.path || '/' || f.filename) AS logo_path,
        f.filename,
        f.path,
        k.created_at
    FROM kolaborasi k
    LEFT JOIN files f ON k.image_id = f.id
    WHERE LOWER(k.jenis) = 'partner'
    ORDER BY k.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- Procedure: get_sponsors_list
-- Returns all visible sponsors ordered by urutan
CREATE OR REPLACE FUNCTION get_sponsors_list()
RETURNS TABLE (
    id INT,
    title VARCHAR,
    urutan INT,
    is_visible BOOLEAN,
    logo_path TEXT,
    filename VARCHAR,
    path VARCHAR,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        s.id,
        s.title,
        s.urutan,
        s.is_visible,
        (f.path || '/' || f.filename) AS logo_path,
        f.filename,
        f.path,
        s.created_at,
        s.updated_at
    FROM sponsors s
    LEFT JOIN files f ON s.logo_id = f.id
    WHERE s.is_visible = TRUE
    ORDER BY s.urutan ASC, s.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- Procedure: get_berita_list
-- Returns all news articles
CREATE OR REPLACE FUNCTION get_berita_list()
RETURNS TABLE (
    id INT,
    judul VARCHAR,
    isi TEXT,
    deskripsi TEXT,
    kategori VARCHAR,
    tanggal DATE,
    image_path TEXT,
    filename VARCHAR,
    path VARCHAR,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        b.id,
        b.judul,
        b.isi,
        b.deskripsi,
        b.kategori,
        b.tanggal,
        (f.path || '/' || f.filename) AS image_path,
        f.filename,
        f.path,
        b.created_at,
        b.updated_at
    FROM berita b
    LEFT JOIN files f ON b.image_id = f.id
    ORDER BY b.tanggal DESC, b.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- Procedure: get_produk_list
-- Returns all products
CREATE OR REPLACE FUNCTION get_produk_list()
RETURNS TABLE (
    id INT,
    nama VARCHAR,
    deskripsi TEXT,
    kategori VARCHAR,
    teknologi VARCHAR,
    status VARCHAR,
    gambar VARCHAR,
    link VARCHAR,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY SELECT * FROM list_produk;
END;
$$ LANGUAGE plpgsql;

-- Procedure: get_contact_messages_list
-- Returns all contact messages
CREATE OR REPLACE FUNCTION get_contact_messages_list()
RETURNS TABLE (
    id INT,
    name VARCHAR,
    email VARCHAR,
    subject VARCHAR,
    message TEXT,
    is_read BOOLEAN,
    created_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY SELECT * FROM list_contact_messages;
END;
$$ LANGUAGE plpgsql;

-- Procedure: get_site_settings
-- Returns current site settings (contact, social links, etc.)
CREATE OR REPLACE FUNCTION get_site_settings()
RETURNS TABLE (
    id INT,
    alamat VARCHAR,
    no_hp VARCHAR,
    contact_email VARCHAR,
    facebook VARCHAR,
    twitter VARCHAR,
    instagram VARCHAR,
    linkedin VARCHAR
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        s.id,
        s.alamat,
        s.no_hp,
        s.contact_email,
        s.facebook,
        s.twitter,
        s.instagram,
        s.linkedin
    FROM setting_sosial_media s
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- Procedure: upsert_site_settings
-- Insert or update site settings (single row)
CREATE OR REPLACE FUNCTION upsert_site_settings(
    p_alamat VARCHAR DEFAULT NULL,
    p_no_hp VARCHAR DEFAULT NULL,
    p_contact_email VARCHAR DEFAULT NULL,
    p_facebook VARCHAR DEFAULT NULL,
    p_twitter VARCHAR DEFAULT NULL,
    p_instagram VARCHAR DEFAULT NULL,
    p_linkedin VARCHAR DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
    WITH upsert AS (
        UPDATE setting_sosial_media
        SET alamat = COALESCE(p_alamat, alamat),
            no_hp = COALESCE(p_no_hp, no_hp),
            contact_email = COALESCE(p_contact_email, contact_email),
            facebook = COALESCE(p_facebook, facebook),
            twitter = COALESCE(p_twitter, twitter),
            instagram = COALESCE(p_instagram, instagram),
            linkedin = COALESCE(p_linkedin, linkedin)
        WHERE id = (SELECT id FROM setting_sosial_media LIMIT 1)
        RETURNING 1
    )
    INSERT INTO setting_sosial_media (alamat, no_hp, contact_email, facebook, twitter, instagram, linkedin)
    SELECT p_alamat, p_no_hp, p_contact_email, p_facebook, p_twitter, p_instagram, p_linkedin
    WHERE NOT EXISTS (SELECT 1 FROM upsert);
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- CRUD PROCEDURES (INSERT, UPDATE, DELETE)
-- ==========================================

-- Procedure: insert_struktur_organisasi
-- Insert new organizational structure entry
CREATE OR REPLACE FUNCTION insert_struktur_organisasi(
    p_id_dosen INT,
    p_jabatan VARCHAR,
    p_urutan INT DEFAULT 999
) RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO struktur_organisasi (id_dosen, jabatan, urutan, created_at, updated_at)
    VALUES (p_id_dosen, p_jabatan, p_urutan, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure: update_struktur_organisasi
-- Update organizational structure entry
CREATE OR REPLACE FUNCTION update_struktur_organisasi(
    p_id INT,
    p_id_dosen INT,
    p_jabatan VARCHAR,
    p_urutan INT
) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE struktur_organisasi
    SET id_dosen = p_id_dosen,
        jabatan = p_jabatan,
        urutan = p_urutan,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: delete_struktur_organisasi
-- Delete organizational structure entry
CREATE OR REPLACE FUNCTION delete_struktur_organisasi(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM struktur_organisasi WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: insert_publikasi
-- Insert new publication
CREATE OR REPLACE FUNCTION insert_publikasi(
    p_id_dosen INT,
    p_judul VARCHAR,
    p_tahun INT,
    p_jenis VARCHAR,
    p_penerbit VARCHAR DEFAULT NULL
) RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO publikasi (id_dosen, judul, tahun, jenis, penerbit, created_at, updated_at)
    VALUES (p_id_dosen, p_judul, p_tahun, p_jenis, p_penerbit, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure: update_publikasi
-- Update publication
CREATE OR REPLACE FUNCTION update_publikasi(
    p_id INT,
    p_id_dosen INT,
    p_judul VARCHAR,
    p_tahun INT,
    p_jenis VARCHAR,
    p_penerbit VARCHAR DEFAULT NULL
) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE publikasi
    SET id_dosen = p_id_dosen,
        judul = p_judul,
        tahun = p_tahun,
        jenis = p_jenis,
        penerbit = p_penerbit,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: delete_publikasi
-- Delete publication
CREATE OR REPLACE FUNCTION delete_publikasi(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM publikasi WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: insert_produk
-- Insert new product
CREATE OR REPLACE FUNCTION insert_produk(
    p_nama VARCHAR,
    p_deskripsi TEXT,
    p_kategori VARCHAR DEFAULT NULL,
    p_teknologi VARCHAR DEFAULT NULL,
    p_status VARCHAR DEFAULT 'active',
    p_gambar VARCHAR DEFAULT NULL,
    p_link VARCHAR DEFAULT NULL
) RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO produk (nama, deskripsi, kategori, teknologi, status, gambar, link, created_at, updated_at)
    VALUES (p_nama, p_deskripsi, p_kategori, p_teknologi, p_status, p_gambar, p_link, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure: update_produk
-- Update product
CREATE OR REPLACE FUNCTION update_produk(
    p_id INT,
    p_nama VARCHAR,
    p_deskripsi TEXT,
    p_kategori VARCHAR DEFAULT NULL,
    p_teknologi VARCHAR DEFAULT NULL,
    p_status VARCHAR DEFAULT 'active',
    p_gambar VARCHAR DEFAULT NULL,
    p_link VARCHAR DEFAULT NULL
) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE produk
    SET nama = p_nama,
        deskripsi = p_deskripsi,
        kategori = p_kategori,
        teknologi = p_teknologi,
        status = p_status,
        gambar = p_gambar,
        link = p_link,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: delete_produk
-- Delete product
CREATE OR REPLACE FUNCTION delete_produk(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM produk WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: insert_contact_message
-- Insert new contact message
CREATE OR REPLACE FUNCTION insert_contact_message(
    p_name VARCHAR,
    p_email VARCHAR,
    p_subject VARCHAR,
    p_message TEXT
) RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO contact_messages (name, email, subject, message, is_read, created_at)
    VALUES (p_name, p_email, p_subject, p_message, FALSE, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure: mark_message_as_read
-- Mark contact message as read
CREATE OR REPLACE FUNCTION mark_message_as_read(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE contact_messages
    SET is_read = TRUE
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: delete_contact_message
-- Delete contact message
CREATE OR REPLACE FUNCTION delete_contact_message(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM contact_messages WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: get_mission_list
-- Returns all active missions
CREATE OR REPLACE FUNCTION get_mission_list()
RETURNS TABLE (
    id INT,
    title VARCHAR,
    description TEXT,
    urutan INT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY SELECT * FROM list_mission;
END;
$$ LANGUAGE plpgsql;

-- Procedure: insert_mission
-- Insert new mission
CREATE OR REPLACE FUNCTION insert_mission(
    p_title VARCHAR,
    p_description TEXT DEFAULT NULL,
    p_urutan INT DEFAULT 0
) RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO mission (title, description, urutan, is_active, created_at, updated_at)
    VALUES (p_title, p_description, p_urutan, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure: update_mission
-- Update mission
CREATE OR REPLACE FUNCTION update_mission(
    p_id INT,
    p_title VARCHAR,
    p_description TEXT DEFAULT NULL,
    p_urutan INT DEFAULT 0,
    p_is_active BOOLEAN DEFAULT TRUE
) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE mission
    SET title = p_title,
        description = p_description,
        urutan = p_urutan,
        is_active = p_is_active,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: delete_mission
-- Delete mission
CREATE OR REPLACE FUNCTION delete_mission(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM mission WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: get_priority_list
-- Returns all active priorities
CREATE OR REPLACE FUNCTION get_priority_list()
RETURNS TABLE (
    id INT,
    title VARCHAR,
    description TEXT,
    urutan INT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY SELECT * FROM list_priority;
END;
$$ LANGUAGE plpgsql;

-- Procedure: insert_priority
-- Insert new priority
CREATE OR REPLACE FUNCTION insert_priority(
    p_title VARCHAR,
    p_description TEXT DEFAULT NULL,
    p_urutan INT DEFAULT 0
) RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO priority (title, description, urutan, is_active, created_at, updated_at)
    VALUES (p_title, p_description, p_urutan, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure: update_priority
-- Update priority
CREATE OR REPLACE FUNCTION update_priority(
    p_id INT,
    p_title VARCHAR,
    p_description TEXT DEFAULT NULL,
    p_urutan INT DEFAULT 0,
    p_is_active BOOLEAN DEFAULT TRUE
) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE priority
    SET title = p_title,
        description = p_description,
        urutan = p_urutan,
        is_active = p_is_active,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Procedure: delete_priority
-- Delete priority
CREATE OR REPLACE FUNCTION delete_priority(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM priority WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- END OF VIEWS & PROCEDURES
-- ==========================================

--
-- PostgreSQL database dump
--

\restrict J9uLkWepk5V4ELo2NuYdNHr49mlQ21OWcaDyuGM6UzDQ9qw99LXlekwOz9KBDT3

-- Dumped from database version 15.14
-- Dumped by pg_dump version 15.14

-- Started on 2025-12-13 10:40:26

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 260 (class 1255 OID 18967)
-- Name: delete_contact_message(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_contact_message(p_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM contact_messages WHERE id = p_id;
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.delete_contact_message(p_id integer) OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 19052)
-- Name: delete_mission(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_mission(p_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM mission WHERE id = p_id;
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.delete_mission(p_id integer) OWNER TO postgres;

--
-- TOC entry 300 (class 1255 OID 19056)
-- Name: delete_priority(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_priority(p_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM priority WHERE id = p_id;
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.delete_priority(p_id integer) OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 18964)
-- Name: delete_produk(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_produk(p_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM produk WHERE id = p_id;
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.delete_produk(p_id integer) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 18961)
-- Name: delete_publikasi(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_publikasi(p_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM publikasi WHERE id = p_id;
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.delete_publikasi(p_id integer) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 18958)
-- Name: delete_struktur_organisasi(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_struktur_organisasi(p_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM struktur_organisasi WHERE id = p_id;
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.delete_struktur_organisasi(p_id integer) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 18943)
-- Name: get_berita_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_berita_list() RETURNS TABLE(id integer, judul character varying, isi text, deskripsi text, kategori character varying, tanggal date, image_path text, filename character varying, path character varying, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_berita_list() OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 18945)
-- Name: get_contact_messages_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_contact_messages_list() RETURNS TABLE(id integer, name character varying, email character varying, subject character varying, message text, is_read boolean, created_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM list_contact_messages;
END;
$$;


ALTER FUNCTION public.get_contact_messages_list() OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 19049)
-- Name: get_mission_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_mission_list() RETURNS TABLE(id integer, title character varying, description text, urutan integer, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM list_mission;
END;
$$;


ALTER FUNCTION public.get_mission_list() OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 18941)
-- Name: get_partners_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_partners_list() RETURNS TABLE(id integer, nama_sponsor character varying, jenis character varying, logo_path text, filename character varying, path character varying, created_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_partners_list() OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 19053)
-- Name: get_priority_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_priority_list() RETURNS TABLE(id integer, title character varying, description text, urutan integer, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM list_priority;
END;
$$;


ALTER FUNCTION public.get_priority_list() OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 18944)
-- Name: get_produk_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_produk_list() RETURNS TABLE(id integer, nama character varying, deskripsi text, kategori character varying, teknologi character varying, status character varying, gambar character varying, link character varying, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM list_produk;
END;
$$;


ALTER FUNCTION public.get_produk_list() OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 18940)
-- Name: get_publikasi_by_dosen(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_publikasi_by_dosen(p_dosen_id integer DEFAULT 0) RETURNS TABLE(id integer, id_dosen integer, dosen_nama character varying, dosen_deskripsi text, judul character varying, tahun integer, jenis character varying, penerbit character varying, created_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_publikasi_by_dosen(p_dosen_id integer) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 19078)
-- Name: get_site_settings(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_site_settings() RETURNS TABLE(id integer, alamat character varying, no_hp character varying, contact_email character varying, facebook character varying, twitter character varying, instagram character varying, linkedin character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_site_settings() OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 18942)
-- Name: get_sponsors_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_sponsors_list() RETURNS TABLE(id integer, title character varying, urutan integer, is_visible boolean, logo_path text, filename character varying, path character varying, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_sponsors_list() OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 19065)
-- Name: get_struktur_organisasi_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_struktur_organisasi_list() RETURNS TABLE(id integer, id_dosen integer, jabatan character varying, urutan integer, nama character varying, deskripsi text, foto_path text, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_struktur_organisasi_list() OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 18965)
-- Name: insert_contact_message(character varying, character varying, character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_contact_message(p_name character varying, p_email character varying, p_subject character varying, p_message text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO contact_messages (name, email, subject, message, is_read, created_at)
    VALUES (p_name, p_email, p_subject, p_message, FALSE, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.insert_contact_message(p_name character varying, p_email character varying, p_subject character varying, p_message text) OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 19050)
-- Name: insert_mission(character varying, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_mission(p_title character varying, p_description text DEFAULT NULL::text, p_urutan integer DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO mission (title, description, urutan, is_active, created_at, updated_at)
    VALUES (p_title, p_description, p_urutan, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.insert_mission(p_title character varying, p_description text, p_urutan integer) OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 19054)
-- Name: insert_priority(character varying, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_priority(p_title character varying, p_description text DEFAULT NULL::text, p_urutan integer DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO priority (title, description, urutan, is_active, created_at, updated_at)
    VALUES (p_title, p_description, p_urutan, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.insert_priority(p_title character varying, p_description text, p_urutan integer) OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 18962)
-- Name: insert_produk(character varying, text, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_produk(p_nama character varying, p_deskripsi text, p_kategori character varying DEFAULT NULL::character varying, p_teknologi character varying DEFAULT NULL::character varying, p_status character varying DEFAULT 'active'::character varying, p_gambar character varying DEFAULT NULL::character varying, p_link character varying DEFAULT NULL::character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO produk (nama, deskripsi, kategori, teknologi, status, gambar, link, created_at, updated_at)
    VALUES (p_nama, p_deskripsi, p_kategori, p_teknologi, p_status, p_gambar, p_link, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.insert_produk(p_nama character varying, p_deskripsi text, p_kategori character varying, p_teknologi character varying, p_status character varying, p_gambar character varying, p_link character varying) OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 18959)
-- Name: insert_publikasi(integer, character varying, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_publikasi(p_id_dosen integer, p_judul character varying, p_tahun integer, p_jenis character varying, p_penerbit character varying DEFAULT NULL::character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO publikasi (id_dosen, judul, tahun, jenis, penerbit, created_at, updated_at)
    VALUES (p_id_dosen, p_judul, p_tahun, p_jenis, p_penerbit, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.insert_publikasi(p_id_dosen integer, p_judul character varying, p_tahun integer, p_jenis character varying, p_penerbit character varying) OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 18956)
-- Name: insert_struktur_organisasi(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_struktur_organisasi(p_id_dosen integer, p_jabatan character varying, p_urutan integer DEFAULT 999) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO struktur_organisasi (id_dosen, jabatan, urutan, created_at, updated_at)
    VALUES (p_id_dosen, p_jabatan, p_urutan, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.insert_struktur_organisasi(p_id_dosen integer, p_jabatan character varying, p_urutan integer) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 18966)
-- Name: mark_message_as_read(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mark_message_as_read(p_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE contact_messages
    SET is_read = TRUE
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.mark_message_as_read(p_id integer) OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 19051)
-- Name: update_mission(integer, character varying, text, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_mission(p_id integer, p_title character varying, p_description text DEFAULT NULL::text, p_urutan integer DEFAULT 0, p_is_active boolean DEFAULT true) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.update_mission(p_id integer, p_title character varying, p_description text, p_urutan integer, p_is_active boolean) OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 19055)
-- Name: update_priority(integer, character varying, text, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_priority(p_id integer, p_title character varying, p_description text DEFAULT NULL::text, p_urutan integer DEFAULT 0, p_is_active boolean DEFAULT true) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.update_priority(p_id integer, p_title character varying, p_description text, p_urutan integer, p_is_active boolean) OWNER TO postgres;

--
-- TOC entry 292 (class 1255 OID 18963)
-- Name: update_produk(integer, character varying, text, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_produk(p_id integer, p_nama character varying, p_deskripsi text, p_kategori character varying DEFAULT NULL::character varying, p_teknologi character varying DEFAULT NULL::character varying, p_status character varying DEFAULT 'active'::character varying, p_gambar character varying DEFAULT NULL::character varying, p_link character varying DEFAULT NULL::character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.update_produk(p_id integer, p_nama character varying, p_deskripsi text, p_kategori character varying, p_teknologi character varying, p_status character varying, p_gambar character varying, p_link character varying) OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 18960)
-- Name: update_publikasi(integer, integer, character varying, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_publikasi(p_id integer, p_id_dosen integer, p_judul character varying, p_tahun integer, p_jenis character varying, p_penerbit character varying DEFAULT NULL::character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.update_publikasi(p_id integer, p_id_dosen integer, p_judul character varying, p_tahun integer, p_jenis character varying, p_penerbit character varying) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 18957)
-- Name: update_struktur_organisasi(integer, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_struktur_organisasi(p_id integer, p_id_dosen integer, p_jabatan character varying, p_urutan integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE struktur_organisasi
    SET id_dosen = p_id_dosen,
        jabatan = p_jabatan,
        urutan = p_urutan,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.update_struktur_organisasi(p_id integer, p_id_dosen integer, p_jabatan character varying, p_urutan integer) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 18947)
-- Name: upsert_site_settings(character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.upsert_site_settings(p_alamat character varying DEFAULT NULL::character varying, p_no_hp character varying DEFAULT NULL::character varying, p_contact_email character varying DEFAULT NULL::character varying, p_facebook character varying DEFAULT NULL::character varying, p_twitter character varying DEFAULT NULL::character varying, p_instagram character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    WITH upsert AS (
        UPDATE setting_sosial_media
        SET alamat = COALESCE(p_alamat, alamat),
            no_hp = COALESCE(p_no_hp, no_hp),
            contact_email = COALESCE(p_contact_email, contact_email),
            facebook = COALESCE(p_facebook, facebook),
            twitter = COALESCE(p_twitter, twitter),
            instagram = COALESCE(p_instagram, instagram)
        WHERE id = (SELECT id FROM setting_sosial_media LIMIT 1)
        RETURNING 1
    )
    INSERT INTO setting_sosial_media (alamat, no_hp, contact_email, facebook, twitter, instagram)
    SELECT p_alamat, p_no_hp, p_contact_email, p_facebook, p_twitter, p_instagram
    WHERE NOT EXISTS (SELECT 1 FROM upsert);
END;
$$;


ALTER FUNCTION public.upsert_site_settings(p_alamat character varying, p_no_hp character varying, p_contact_email character varying, p_facebook character varying, p_twitter character varying, p_instagram character varying) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 19079)
-- Name: upsert_site_settings(character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.upsert_site_settings(p_alamat character varying DEFAULT NULL::character varying, p_no_hp character varying DEFAULT NULL::character varying, p_contact_email character varying DEFAULT NULL::character varying, p_facebook character varying DEFAULT NULL::character varying, p_twitter character varying DEFAULT NULL::character varying, p_instagram character varying DEFAULT NULL::character varying, p_linkedin character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.upsert_site_settings(p_alamat character varying, p_no_hp character varying, p_contact_email character varying, p_facebook character varying, p_twitter character varying, p_instagram character varying, p_linkedin character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 18628)
-- Name: admin_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(100) NOT NULL,
    full_name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admin_users OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 18627)
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_users_id_seq OWNER TO postgres;

--
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 218
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- TOC entry 233 (class 1259 OID 18736)
-- Name: berita; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.berita (
    id integer NOT NULL,
    judul character varying(255) NOT NULL,
    isi text NOT NULL,
    deskripsi text,
    image_id integer,
    kategori character varying(100),
    tanggal date NOT NULL,
    uploaded_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.berita OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 18735)
-- Name: berita_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.berita_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.berita_id_seq OWNER TO postgres;

--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 232
-- Name: berita_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.berita_id_seq OWNED BY public.berita.id;


--
-- TOC entry 237 (class 1259 OID 18768)
-- Name: blueprint; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blueprint (
    id integer NOT NULL,
    title character varying(150) NOT NULL,
    description text NOT NULL,
    icon character varying,
    color character varying(50),
    urutan integer DEFAULT 0,
    uploaded_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.blueprint OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 18767)
-- Name: blueprint_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blueprint_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blueprint_id_seq OWNER TO postgres;

--
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 236
-- Name: blueprint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blueprint_id_seq OWNED BY public.blueprint.id;


--
-- TOC entry 215 (class 1259 OID 18608)
-- Name: contact_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_messages (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    subject character varying(200),
    message text NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.contact_messages OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 18607)
-- Name: contact_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contact_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_messages_id_seq OWNER TO postgres;

--
-- TOC entry 3642 (class 0 OID 0)
-- Dependencies: 214
-- Name: contact_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contact_messages_id_seq OWNED BY public.contact_messages.id;


--
-- TOC entry 243 (class 1259 OID 18843)
-- Name: contact_replies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_replies (
    id integer NOT NULL,
    contact_id integer,
    to_email character varying(255) NOT NULL,
    subject character varying(255) NOT NULL,
    body text NOT NULL,
    sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.contact_replies OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 18842)
-- Name: contact_replies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contact_replies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_replies_id_seq OWNER TO postgres;

--
-- TOC entry 3643 (class 0 OID 0)
-- Dependencies: 242
-- Name: contact_replies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contact_replies_id_seq OWNED BY public.contact_replies.id;


--
-- TOC entry 221 (class 1259 OID 18643)
-- Name: content_dashboard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.content_dashboard (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    data json NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_content_type CHECK (((type)::text = ANY ((ARRAY['sejarah'::character varying, 'visi_misi'::character varying])::text[])))
);


ALTER TABLE public.content_dashboard OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 18642)
-- Name: content_dashboard_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.content_dashboard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.content_dashboard_id_seq OWNER TO postgres;

--
-- TOC entry 3644 (class 0 OID 0)
-- Dependencies: 220
-- Name: content_dashboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.content_dashboard_id_seq OWNED BY public.content_dashboard.id;


--
-- TOC entry 227 (class 1259 OID 18690)
-- Name: dosen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dosen (
    id integer NOT NULL,
    deskripsi text NOT NULL,
    nama character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dosen OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 18689)
-- Name: dosen_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dosen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dosen_id_seq OWNER TO postgres;

--
-- TOC entry 3645 (class 0 OID 0)
-- Dependencies: 226
-- Name: dosen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dosen_id_seq OWNED BY public.dosen.id;


--
-- TOC entry 223 (class 1259 OID 18664)
-- Name: files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.files (
    id integer NOT NULL,
    filename character varying(255) NOT NULL,
    path character varying(255) NOT NULL,
    mime_type character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.files OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 18663)
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.files_id_seq OWNER TO postgres;

--
-- TOC entry 3646 (class 0 OID 0)
-- Dependencies: 222
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.files_id_seq OWNED BY public.files.id;


--
-- TOC entry 235 (class 1259 OID 18752)
-- Name: gallery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gallery (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    image_id integer,
    tanggal date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.gallery OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 18751)
-- Name: gallery_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gallery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gallery_id_seq OWNER TO postgres;

--
-- TOC entry 3647 (class 0 OID 0)
-- Dependencies: 234
-- Name: gallery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gallery_id_seq OWNED BY public.gallery.id;


--
-- TOC entry 245 (class 1259 OID 18853)
-- Name: kolaborasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kolaborasi (
    id integer NOT NULL,
    nama_sponsor character varying(255) NOT NULL,
    jenis character varying(20) NOT NULL,
    image_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.kolaborasi OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 18852)
-- Name: kolaborasi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kolaborasi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kolaborasi_id_seq OWNER TO postgres;

--
-- TOC entry 3648 (class 0 OID 0)
-- Dependencies: 244
-- Name: kolaborasi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kolaborasi_id_seq OWNED BY public.kolaborasi.id;


--
-- TOC entry 250 (class 1259 OID 18922)
-- Name: list_berita; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.list_berita AS
 SELECT b.id,
    b.judul,
    b.isi,
    b.deskripsi,
    b.kategori,
    b.tanggal,
    (((f.path)::text || '/'::text) || (f.filename)::text) AS image_path,
    f.filename,
    f.path,
    b.created_at,
    b.updated_at
   FROM (public.berita b
     LEFT JOIN public.files f ON ((b.image_id = f.id)))
  ORDER BY b.tanggal DESC, b.created_at DESC;


ALTER TABLE public.list_berita OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 18931)
-- Name: list_contact_messages; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.list_contact_messages AS
 SELECT contact_messages.id,
    contact_messages.name,
    contact_messages.email,
    contact_messages.subject,
    contact_messages.message,
    contact_messages.is_read,
    contact_messages.created_at
   FROM public.contact_messages
  ORDER BY contact_messages.created_at DESC;


ALTER TABLE public.list_contact_messages OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 19010)
-- Name: mission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mission (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    urutan integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mission OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 19041)
-- Name: list_mission; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.list_mission AS
 SELECT mission.id,
    mission.title,
    mission.description,
    mission.urutan,
    mission.created_at,
    mission.updated_at
   FROM public.mission
  WHERE (mission.is_active = true)
  ORDER BY mission.urutan, mission.created_at DESC;


ALTER TABLE public.list_mission OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 18912)
-- Name: list_partners_with_logo; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.list_partners_with_logo AS
 SELECT k.id,
    k.nama_sponsor,
    k.jenis,
    (((f.path)::text || '/'::text) || (f.filename)::text) AS logo_path,
    f.filename,
    f.path,
    k.created_at
   FROM (public.kolaborasi k
     LEFT JOIN public.files f ON ((k.image_id = f.id)))
  WHERE (lower((k.jenis)::text) = 'partner'::text)
  ORDER BY k.created_at DESC;


ALTER TABLE public.list_partners_with_logo OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 19023)
-- Name: priority; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.priority (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    urutan integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.priority OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 19045)
-- Name: list_priority; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.list_priority AS
 SELECT priority.id,
    priority.title,
    priority.description,
    priority.urutan,
    priority.created_at,
    priority.updated_at
   FROM public.priority
  WHERE (priority.is_active = true)
  ORDER BY priority.urutan, priority.created_at DESC;


ALTER TABLE public.list_priority OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 18825)
-- Name: produk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produk (
    id integer NOT NULL,
    nama character varying(255) NOT NULL,
    deskripsi text,
    kategori character varying(100),
    teknologi character varying(255),
    status character varying(50),
    gambar character varying(255),
    link character varying(500),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.produk OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 18927)
-- Name: list_produk; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.list_produk AS
 SELECT produk.id,
    produk.nama,
    produk.deskripsi,
    produk.kategori,
    produk.teknologi,
    produk.status,
    produk.gambar,
    produk.link,
    produk.created_at,
    produk.updated_at
   FROM public.produk
  ORDER BY produk.created_at DESC;


ALTER TABLE public.list_produk OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 18700)
-- Name: publikasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publikasi (
    id integer NOT NULL,
    id_dosen integer NOT NULL,
    judul character varying(500) NOT NULL,
    tahun integer NOT NULL,
    jenis character varying(30) NOT NULL,
    penerbit character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_publikasi_jenis CHECK (((jenis)::text = ANY ((ARRAY['jurnal'::character varying, 'conference'::character varying, 'thesis'::character varying])::text[])))
);


ALTER TABLE public.publikasi OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 18908)
-- Name: list_publikasi_by_dosen; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.list_publikasi_by_dosen AS
 SELECT p.id,
    p.id_dosen,
    d.nama AS dosen_nama,
    d.deskripsi AS dosen_deskripsi,
    p.judul,
    p.tahun,
    p.jenis,
    p.penerbit,
    p.created_at
   FROM (public.publikasi p
     LEFT JOIN public.dosen d ON ((p.id_dosen = d.id)))
  ORDER BY p.tahun DESC, p.created_at DESC;


ALTER TABLE public.list_publikasi_by_dosen OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 18674)
-- Name: sponsors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sponsors (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    logo_id integer NOT NULL,
    urutan integer DEFAULT 0,
    is_visible boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sponsors OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 18917)
-- Name: list_sponsors; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.list_sponsors AS
 SELECT s.id,
    s.title,
    s.urutan,
    s.is_visible,
    (((f.path)::text || '/'::text) || (f.filename)::text) AS logo_path,
    f.filename,
    f.path,
    s.created_at,
    s.updated_at
   FROM (public.sponsors s
     LEFT JOIN public.files f ON ((s.logo_id = f.id)))
  WHERE (s.is_visible = true)
  ORDER BY s.urutan, s.created_at DESC;


ALTER TABLE public.list_sponsors OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 18716)
-- Name: struktur_organisasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.struktur_organisasi (
    id integer NOT NULL,
    id_dosen integer NOT NULL,
    jabatan character varying(100) NOT NULL,
    foto_id integer,
    urutan integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.struktur_organisasi OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 18903)
-- Name: list_struktur_with_dosen; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.list_struktur_with_dosen AS
 SELECT so.id,
    so.id_dosen,
    so.jabatan,
    so.urutan,
    d.nama,
    d.deskripsi,
    (((f.path)::text || '/'::text) || (f.filename)::text) AS foto_path,
    so.created_at,
    so.updated_at
   FROM ((public.struktur_organisasi so
     LEFT JOIN public.dosen d ON ((so.id_dosen = d.id)))
     LEFT JOIN public.files f ON ((so.foto_id = f.id)))
  ORDER BY
        CASE
            WHEN ((so.jabatan)::text = 'Ketua Laboratorium'::text) THEN 1
            WHEN ((so.jabatan)::text = 'Wakil Ketua'::text) THEN 2
            WHEN ((so.jabatan)::text = 'Sekretaris'::text) THEN 3
            WHEN ((so.jabatan)::text = 'Bendahara'::text) THEN 4
            WHEN ((so.jabatan)::text = 'Koordinator'::text) THEN 5
            WHEN ((so.jabatan)::text = 'Anggota'::text) THEN 6
            ELSE 99
        END, d.nama;


ALTER TABLE public.list_struktur_with_dosen OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 19009)
-- Name: mission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mission_id_seq OWNER TO postgres;

--
-- TOC entry 3649 (class 0 OID 0)
-- Dependencies: 254
-- Name: mission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mission_id_seq OWNED BY public.mission.id;


--
-- TOC entry 256 (class 1259 OID 19022)
-- Name: priority_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.priority_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.priority_id_seq OWNER TO postgres;

--
-- TOC entry 3650 (class 0 OID 0)
-- Dependencies: 256
-- Name: priority_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.priority_id_seq OWNED BY public.priority.id;


--
-- TOC entry 240 (class 1259 OID 18824)
-- Name: produk_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produk_id_seq OWNER TO postgres;

--
-- TOC entry 3651 (class 0 OID 0)
-- Dependencies: 240
-- Name: produk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produk_id_seq OWNED BY public.produk.id;


--
-- TOC entry 228 (class 1259 OID 18699)
-- Name: publikasi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publikasi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.publikasi_id_seq OWNER TO postgres;

--
-- TOC entry 3652 (class 0 OID 0)
-- Dependencies: 228
-- Name: publikasi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publikasi_id_seq OWNED BY public.publikasi.id;


--
-- TOC entry 239 (class 1259 OID 18785)
-- Name: scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scope (
    id integer NOT NULL,
    title character varying(150) NOT NULL,
    description text NOT NULL,
    icon character varying,
    color character varying(50),
    urutan integer DEFAULT 0,
    uploaded_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.scope OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 18784)
-- Name: scope_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scope_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scope_id_seq OWNER TO postgres;

--
-- TOC entry 3653 (class 0 OID 0)
-- Dependencies: 238
-- Name: scope_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scope_id_seq OWNED BY public.scope.id;


--
-- TOC entry 217 (class 1259 OID 18619)
-- Name: setting_sosial_media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.setting_sosial_media (
    id integer NOT NULL,
    facebook character varying(255),
    twitter character varying(255),
    instagram character varying(255),
    no_hp character varying(20),
    alamat character varying,
    contact_email character varying(255),
    linkedin character varying(255)
);


ALTER TABLE public.setting_sosial_media OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 18618)
-- Name: setting_sosial_media_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.setting_sosial_media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.setting_sosial_media_id_seq OWNER TO postgres;

--
-- TOC entry 3654 (class 0 OID 0)
-- Dependencies: 216
-- Name: setting_sosial_media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.setting_sosial_media_id_seq OWNED BY public.setting_sosial_media.id;


--
-- TOC entry 253 (class 1259 OID 18935)
-- Name: site_settings; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.site_settings AS
 SELECT setting_sosial_media.id,
    setting_sosial_media.alamat,
    setting_sosial_media.no_hp,
    setting_sosial_media.contact_email,
    setting_sosial_media.facebook,
    setting_sosial_media.twitter,
    setting_sosial_media.instagram,
    setting_sosial_media.linkedin
   FROM public.setting_sosial_media
 LIMIT 1;


ALTER TABLE public.site_settings OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 18673)
-- Name: sponsors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sponsors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sponsors_id_seq OWNER TO postgres;

--
-- TOC entry 3655 (class 0 OID 0)
-- Dependencies: 224
-- Name: sponsors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sponsors_id_seq OWNED BY public.sponsors.id;


--
-- TOC entry 230 (class 1259 OID 18715)
-- Name: struktur_organisasi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.struktur_organisasi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.struktur_organisasi_id_seq OWNER TO postgres;

--
-- TOC entry 3656 (class 0 OID 0)
-- Dependencies: 230
-- Name: struktur_organisasi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.struktur_organisasi_id_seq OWNED BY public.struktur_organisasi.id;


--
-- TOC entry 3332 (class 2604 OID 19168)
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- TOC entry 3353 (class 2604 OID 19169)
-- Name: berita id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.berita ALTER COLUMN id SET DEFAULT nextval('public.berita_id_seq'::regclass);


--
-- TOC entry 3359 (class 2604 OID 19170)
-- Name: blueprint id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blueprint ALTER COLUMN id SET DEFAULT nextval('public.blueprint_id_seq'::regclass);


--
-- TOC entry 3328 (class 2604 OID 19171)
-- Name: contact_messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_messages ALTER COLUMN id SET DEFAULT nextval('public.contact_messages_id_seq'::regclass);


--
-- TOC entry 3370 (class 2604 OID 19172)
-- Name: contact_replies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_replies ALTER COLUMN id SET DEFAULT nextval('public.contact_replies_id_seq'::regclass);


--
-- TOC entry 3335 (class 2604 OID 19173)
-- Name: content_dashboard id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content_dashboard ALTER COLUMN id SET DEFAULT nextval('public.content_dashboard_id_seq'::regclass);


--
-- TOC entry 3345 (class 2604 OID 19174)
-- Name: dosen id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen ALTER COLUMN id SET DEFAULT nextval('public.dosen_id_seq'::regclass);


--
-- TOC entry 3338 (class 2604 OID 19175)
-- Name: files id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files ALTER COLUMN id SET DEFAULT nextval('public.files_id_seq'::regclass);


--
-- TOC entry 3356 (class 2604 OID 19176)
-- Name: gallery id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gallery ALTER COLUMN id SET DEFAULT nextval('public.gallery_id_seq'::regclass);


--
-- TOC entry 3372 (class 2604 OID 19177)
-- Name: kolaborasi id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kolaborasi ALTER COLUMN id SET DEFAULT nextval('public.kolaborasi_id_seq'::regclass);


--
-- TOC entry 3375 (class 2604 OID 19178)
-- Name: mission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mission ALTER COLUMN id SET DEFAULT nextval('public.mission_id_seq'::regclass);


--
-- TOC entry 3380 (class 2604 OID 19179)
-- Name: priority id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.priority ALTER COLUMN id SET DEFAULT nextval('public.priority_id_seq'::regclass);


--
-- TOC entry 3367 (class 2604 OID 19180)
-- Name: produk id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produk ALTER COLUMN id SET DEFAULT nextval('public.produk_id_seq'::regclass);


--
-- TOC entry 3347 (class 2604 OID 19181)
-- Name: publikasi id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publikasi ALTER COLUMN id SET DEFAULT nextval('public.publikasi_id_seq'::regclass);


--
-- TOC entry 3363 (class 2604 OID 19182)
-- Name: scope id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope ALTER COLUMN id SET DEFAULT nextval('public.scope_id_seq'::regclass);


--
-- TOC entry 3331 (class 2604 OID 19183)
-- Name: setting_sosial_media id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_sosial_media ALTER COLUMN id SET DEFAULT nextval('public.setting_sosial_media_id_seq'::regclass);


--
-- TOC entry 3340 (class 2604 OID 19184)
-- Name: sponsors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sponsors ALTER COLUMN id SET DEFAULT nextval('public.sponsors_id_seq'::regclass);


--
-- TOC entry 3349 (class 2604 OID 19185)
-- Name: struktur_organisasi id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.struktur_organisasi ALTER COLUMN id SET DEFAULT nextval('public.struktur_organisasi_id_seq'::regclass);


--
-- TOC entry 3603 (class 0 OID 18628)
-- Dependencies: 219
-- Data for Name: admin_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin_users (id, username, password, email, full_name, created_at, updated_at) FROM stdin;
1	admin	admin123	raihan.ts16b@gmail.com	Administrator	2025-12-08 20:50:38.678802	2025-12-08 20:50:38.678802
\.


--
-- TOC entry 3617 (class 0 OID 18736)
-- Dependencies: 233
-- Data for Name: berita; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.berita (id, judul, isi, deskripsi, image_id, kategori, tanggal, uploaded_by, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3621 (class 0 OID 18768)
-- Dependencies: 237
-- Data for Name: blueprint; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blueprint (id, title, description, icon, color, urutan, uploaded_by, created_at, updated_at) FROM stdin;
1	p	ok	fa-solid fa-brain	#6c5ce7	0	1	2025-12-13 10:26:06.584209	2025-12-13 10:26:06.584209
\.


--
-- TOC entry 3599 (class 0 OID 18608)
-- Dependencies: 215
-- Data for Name: contact_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_messages (id, name, email, subject, message, is_read, created_at) FROM stdin;
1	RENNN	rey130706@gmail.com	Pesan dari Website	tes	t	2025-12-08 21:12:16.635354
2	RAIHAN NUR PRATAMA	raihan.ts16b@gmail.com	Pesan dari Website	tess	t	2025-12-08 21:33:45.197928
\.


--
-- TOC entry 3627 (class 0 OID 18843)
-- Dependencies: 243
-- Data for Name: contact_replies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_replies (id, contact_id, to_email, subject, body, sent_at) FROM stdin;
1	1	rey130706@gmail.com	Re: tes	oke	2025-12-08 21:16:00.258197
2	1	rey130706@gmail.com	Re: tes	iya	2025-12-08 21:16:07.007167
3	1	rey130706@gmail.com	Re: tes	iya	2025-12-08 21:19:13.094465
4	1	rey130706@gmail.com	Re: tes	oke	2025-12-08 21:19:20.104758
\.


--
-- TOC entry 3605 (class 0 OID 18643)
-- Dependencies: 221
-- Data for Name: content_dashboard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.content_dashboard (id, title, type, data, created_at, updated_at) FROM stdin;
1	Visi Misi Laboratorium	visi_misi	{"visi":"oke","misi":"oksdokaodksoakdoskodkadkkkkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\\r\\nbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc"}	2025-12-09 20:57:00.233372	2025-12-09 20:57:35.808389
\.


--
-- TOC entry 3611 (class 0 OID 18690)
-- Dependencies: 227
-- Data for Name: dosen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dosen (id, deskripsi, nama, created_at) FROM stdin;
1		Yan Watequlis	2025-12-08 20:57:43.359457
\.


--
-- TOC entry 3607 (class 0 OID 18664)
-- Dependencies: 223
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.files (id, filename, path, mime_type, created_at) FROM stdin;
1	1765202263_Logo-Compilation-Grid.png	uploads/struktur	image/png	2025-12-08 20:57:43.383738
2	1765205078_youtube_20181017_090334.webp	uploads/sponsors	image/webp	2025-12-08 21:44:39.041801
3	1765206274_youtube_20181017_090334.webp	uploads/sponsor	image/webp	2025-12-08 22:04:34.598369
4	1765206305_Logo-Compilation-Grid.png	uploads/sponsor	image/png	2025-12-08 22:05:05.676097
5	1765595423_KALAKO (2).png	uploads/gallery	image/png	2025-12-13 10:10:23.24581
\.


--
-- TOC entry 3619 (class 0 OID 18752)
-- Dependencies: 235
-- Data for Name: gallery; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gallery (id, title, description, image_id, tanggal, created_at, updated_at) FROM stdin;
1	p	ok	5	2025-12-13	2025-12-13 10:10:23.259465	2025-12-13 10:10:23.259465
\.


--
-- TOC entry 3629 (class 0 OID 18853)
-- Dependencies: 245
-- Data for Name: kolaborasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kolaborasi (id, nama_sponsor, jenis, image_id, created_at, updated_at) FROM stdin;
1	ra	Partner	3	2025-12-08 22:04:34.602208	2025-12-08 22:04:34.602208
2	yaa	Internal	4	2025-12-08 22:05:05.679311	2025-12-08 22:05:05.679311
\.


--
-- TOC entry 3631 (class 0 OID 19010)
-- Dependencies: 255
-- Data for Name: mission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mission (id, title, description, urutan, is_active, created_at, updated_at) FROM stdin;
3	dasd	pppp	0	t	2025-12-11 07:50:01.727627	2025-12-11 07:50:01.727627
\.


--
-- TOC entry 3633 (class 0 OID 19023)
-- Dependencies: 257
-- Data for Name: priority; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.priority (id, title, description, urutan, is_active, created_at, updated_at) FROM stdin;
1	p	tes	0	t	2025-12-11 08:05:43.406371	2025-12-11 08:05:43.406371
2	y	ok	0	t	2025-12-11 08:05:54.675603	2025-12-11 08:05:54.675603
\.


--
-- TOC entry 3625 (class 0 OID 18825)
-- Dependencies: 241
-- Data for Name: produk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produk (id, nama, deskripsi, kategori, teknologi, status, gambar, link, created_at, updated_at) FROM stdin;
1	yt	yutub	ads	ss	completed	1765202052_youtube_20181017_090334.webp	https://youtube.com	2025-12-08 20:54:12.544205	2025-12-08 20:54:12.544205
\.


--
-- TOC entry 3613 (class 0 OID 18700)
-- Dependencies: 229
-- Data for Name: publikasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publikasi (id, id_dosen, judul, tahun, jenis, penerbit, created_at) FROM stdin;
1	1	farhan krispi	2025	jurnal	Yan	2025-12-08 20:58:35.072668
\.


--
-- TOC entry 3623 (class 0 OID 18785)
-- Dependencies: 239
-- Data for Name: scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scope (id, title, description, icon, color, urutan, uploaded_by, created_at, updated_at) FROM stdin;
1	p	ok	fa-solid fa-book	#6c5ce7	0	1	2025-12-13 10:32:59.315941	2025-12-13 10:32:59.315941
\.


--
-- TOC entry 3601 (class 0 OID 18619)
-- Dependencies: 217
-- Data for Name: setting_sosial_media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.setting_sosial_media (id, facebook, twitter, instagram, no_hp, alamat, contact_email, linkedin) FROM stdin;
1	https://facebook.com		https://instagram.com/sfxrayy	081111121322	Applied Informatics Laboratory <br> Postgraduate Building, 2nd Floor, Malang State Polytechnic	labai@polinema.ac.id	https://linkedin.com
\.


--
-- TOC entry 3609 (class 0 OID 18674)
-- Dependencies: 225
-- Data for Name: sponsors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sponsors (id, title, logo_id, urutan, is_visible, created_at, updated_at) FROM stdin;
1	yt	2	0	f	2025-12-08 21:44:39.044435	2025-12-08 21:44:39.044435
\.


--
-- TOC entry 3615 (class 0 OID 18716)
-- Dependencies: 231
-- Data for Name: struktur_organisasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.struktur_organisasi (id, id_dosen, jabatan, foto_id, urutan, created_at, updated_at) FROM stdin;
1	1	Ketua Laboratorium	1	0	2025-12-08 20:57:43.387598	2025-12-08 20:57:43.387598
\.


--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 218
-- Name: admin_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_users_id_seq', 1, true);


--
-- TOC entry 3658 (class 0 OID 0)
-- Dependencies: 232
-- Name: berita_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.berita_id_seq', 1, false);


--
-- TOC entry 3659 (class 0 OID 0)
-- Dependencies: 236
-- Name: blueprint_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blueprint_id_seq', 1, true);


--
-- TOC entry 3660 (class 0 OID 0)
-- Dependencies: 214
-- Name: contact_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contact_messages_id_seq', 2, true);


--
-- TOC entry 3661 (class 0 OID 0)
-- Dependencies: 242
-- Name: contact_replies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contact_replies_id_seq', 4, true);


--
-- TOC entry 3662 (class 0 OID 0)
-- Dependencies: 220
-- Name: content_dashboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.content_dashboard_id_seq', 1, true);


--
-- TOC entry 3663 (class 0 OID 0)
-- Dependencies: 226
-- Name: dosen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dosen_id_seq', 1, true);


--
-- TOC entry 3664 (class 0 OID 0)
-- Dependencies: 222
-- Name: files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.files_id_seq', 4, true);


--
-- TOC entry 3665 (class 0 OID 0)
-- Dependencies: 234
-- Name: gallery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gallery_id_seq', 1, false);


--
-- TOC entry 3666 (class 0 OID 0)
-- Dependencies: 244
-- Name: kolaborasi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kolaborasi_id_seq', 2, true);


--
-- TOC entry 3667 (class 0 OID 0)
-- Dependencies: 254
-- Name: mission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mission_id_seq', 3, true);


--
-- TOC entry 3668 (class 0 OID 0)
-- Dependencies: 256
-- Name: priority_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.priority_id_seq', 2, true);


--
-- TOC entry 3669 (class 0 OID 0)
-- Dependencies: 240
-- Name: produk_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produk_id_seq', 1, true);


--
-- TOC entry 3670 (class 0 OID 0)
-- Dependencies: 228
-- Name: publikasi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publikasi_id_seq', 1, true);


--
-- TOC entry 3671 (class 0 OID 0)
-- Dependencies: 238
-- Name: scope_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scope_id_seq', 1, true);


--
-- TOC entry 3672 (class 0 OID 0)
-- Dependencies: 216
-- Name: setting_sosial_media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.setting_sosial_media_id_seq', 1, true);


--
-- TOC entry 3673 (class 0 OID 0)
-- Dependencies: 224
-- Name: sponsors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sponsors_id_seq', 1, true);


--
-- TOC entry 3674 (class 0 OID 0)
-- Dependencies: 230
-- Name: struktur_organisasi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.struktur_organisasi_id_seq', 1, true);


--
-- TOC entry 3392 (class 2606 OID 18641)
-- Name: admin_users admin_users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_email_key UNIQUE (email);


--
-- TOC entry 3394 (class 2606 OID 18637)
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- TOC entry 3396 (class 2606 OID 18639)
-- Name: admin_users admin_users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_username_key UNIQUE (username);


--
-- TOC entry 3415 (class 2606 OID 18745)
-- Name: berita berita_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.berita
    ADD CONSTRAINT berita_pkey PRIMARY KEY (id);


--
-- TOC entry 3422 (class 2606 OID 18778)
-- Name: blueprint blueprint_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blueprint
    ADD CONSTRAINT blueprint_pkey PRIMARY KEY (id);


--
-- TOC entry 3388 (class 2606 OID 18617)
-- Name: contact_messages contact_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_messages
    ADD CONSTRAINT contact_messages_pkey PRIMARY KEY (id);


--
-- TOC entry 3431 (class 2606 OID 18851)
-- Name: contact_replies contact_replies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_replies
    ADD CONSTRAINT contact_replies_pkey PRIMARY KEY (id);


--
-- TOC entry 3398 (class 2606 OID 18653)
-- Name: content_dashboard content_dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content_dashboard
    ADD CONSTRAINT content_dashboard_pkey PRIMARY KEY (id);


--
-- TOC entry 3404 (class 2606 OID 18841)
-- Name: dosen dosen_nip_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen
    ADD CONSTRAINT dosen_nip_key UNIQUE (deskripsi);


--
-- TOC entry 3406 (class 2606 OID 18696)
-- Name: dosen dosen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen
    ADD CONSTRAINT dosen_pkey PRIMARY KEY (id);


--
-- TOC entry 3400 (class 2606 OID 18672)
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- TOC entry 3419 (class 2606 OID 18761)
-- Name: gallery gallery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gallery
    ADD CONSTRAINT gallery_pkey PRIMARY KEY (id);


--
-- TOC entry 3433 (class 2606 OID 18860)
-- Name: kolaborasi kolaborasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kolaborasi
    ADD CONSTRAINT kolaborasi_pkey PRIMARY KEY (id);


--
-- TOC entry 3436 (class 2606 OID 19021)
-- Name: mission mission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mission
    ADD CONSTRAINT mission_pkey PRIMARY KEY (id);


--
-- TOC entry 3439 (class 2606 OID 19034)
-- Name: priority priority_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.priority
    ADD CONSTRAINT priority_pkey PRIMARY KEY (id);


--
-- TOC entry 3429 (class 2606 OID 18834)
-- Name: produk produk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produk
    ADD CONSTRAINT produk_pkey PRIMARY KEY (id);


--
-- TOC entry 3409 (class 2606 OID 18709)
-- Name: publikasi publikasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publikasi
    ADD CONSTRAINT publikasi_pkey PRIMARY KEY (id);


--
-- TOC entry 3426 (class 2606 OID 18795)
-- Name: scope scope_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT scope_pkey PRIMARY KEY (id);


--
-- TOC entry 3390 (class 2606 OID 18626)
-- Name: setting_sosial_media setting_sosial_media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_sosial_media
    ADD CONSTRAINT setting_sosial_media_pkey PRIMARY KEY (id);


--
-- TOC entry 3402 (class 2606 OID 18683)
-- Name: sponsors sponsors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sponsors
    ADD CONSTRAINT sponsors_pkey PRIMARY KEY (id);


--
-- TOC entry 3413 (class 2606 OID 18724)
-- Name: struktur_organisasi struktur_organisasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.struktur_organisasi
    ADD CONSTRAINT struktur_organisasi_pkey PRIMARY KEY (id);


--
-- TOC entry 3416 (class 1259 OID 18804)
-- Name: idx_berita_image; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_berita_image ON public.berita USING btree (image_id);


--
-- TOC entry 3417 (class 1259 OID 18803)
-- Name: idx_berita_kategori; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_berita_kategori ON public.berita USING btree (kategori);


--
-- TOC entry 3423 (class 1259 OID 19187)
-- Name: idx_blueprint_icon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_blueprint_icon ON public.blueprint USING btree (icon);


--
-- TOC entry 3420 (class 1259 OID 18805)
-- Name: idx_gallery_image; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gallery_image ON public.gallery USING btree (image_id);


--
-- TOC entry 3434 (class 1259 OID 19035)
-- Name: idx_mission_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mission_active ON public.mission USING btree (is_active);


--
-- TOC entry 3437 (class 1259 OID 19036)
-- Name: idx_priority_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_priority_active ON public.priority USING btree (is_active);


--
-- TOC entry 3427 (class 1259 OID 18835)
-- Name: idx_produk_nama; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produk_nama ON public.produk USING btree (nama);


--
-- TOC entry 3407 (class 1259 OID 18801)
-- Name: idx_publikasi_dosen; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_publikasi_dosen ON public.publikasi USING btree (id_dosen);


--
-- TOC entry 3424 (class 1259 OID 19196)
-- Name: idx_scope_icon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_scope_icon ON public.scope USING btree (icon);


--
-- TOC entry 3410 (class 1259 OID 18802)
-- Name: idx_struktur_dosen; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_struktur_dosen ON public.struktur_organisasi USING btree (id_dosen);


--
-- TOC entry 3411 (class 1259 OID 18808)
-- Name: idx_struktur_foto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_struktur_foto ON public.struktur_organisasi USING btree (foto_id);


--
-- TOC entry 3444 (class 2606 OID 18746)
-- Name: berita fk_berita_image; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.berita
    ADD CONSTRAINT fk_berita_image FOREIGN KEY (image_id) REFERENCES public.files(id) ON DELETE SET NULL;


--
-- TOC entry 3445 (class 2606 OID 18762)
-- Name: gallery fk_gallery_image; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gallery
    ADD CONSTRAINT fk_gallery_image FOREIGN KEY (image_id) REFERENCES public.files(id) ON DELETE SET NULL;


--
-- TOC entry 3441 (class 2606 OID 18710)
-- Name: publikasi fk_publikasi_dosen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publikasi
    ADD CONSTRAINT fk_publikasi_dosen FOREIGN KEY (id_dosen) REFERENCES public.dosen(id) ON DELETE CASCADE;


--
-- TOC entry 3440 (class 2606 OID 18684)
-- Name: sponsors fk_sponsors_file; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sponsors
    ADD CONSTRAINT fk_sponsors_file FOREIGN KEY (logo_id) REFERENCES public.files(id) ON DELETE SET NULL;


--
-- TOC entry 3442 (class 2606 OID 18725)
-- Name: struktur_organisasi fk_struktur_dosen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.struktur_organisasi
    ADD CONSTRAINT fk_struktur_dosen FOREIGN KEY (id_dosen) REFERENCES public.dosen(id) ON DELETE CASCADE;


--
-- TOC entry 3443 (class 2606 OID 18730)
-- Name: struktur_organisasi fk_struktur_foto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.struktur_organisasi
    ADD CONSTRAINT fk_struktur_foto FOREIGN KEY (foto_id) REFERENCES public.files(id) ON DELETE SET NULL;


-- Completed on 2025-12-13 10:40:27

--
-- PostgreSQL database dump complete
--

\unrestrict J9uLkWepk5V4ELo2NuYdNHr49mlQ21OWcaDyuGM6UzDQ9qw99LXlekwOz9KBDT3


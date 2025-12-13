# Database Optimization - Views & Stored Procedures

## Overview
Centralized all data access logic by creating a comprehensive set of database views and stored procedures. This reduces code duplication across PHP files and provides a single source of truth for all database queries.

## Files Created
- **`database/db_views_and_functions.sql`** - Central repository containing 8 views and 9 stored procedures

## Database Views (8 total)

### 1. `list_struktur_with_dosen`
- **Purpose**: Complete organizational structure with dosen names, descriptions, and photo paths
- **Joins**: struktur_organisasi → dosen → files
- **Usage**: Display organizational hierarchy with proper photo file paths
- **Ordering**: By jabatan rank (Ketua → Wakil → Sekretaris → etc.), then by nama

### 2. `list_publikasi_by_dosen`
- **Purpose**: Publications with dosen information
- **Joins**: publikasi → dosen
- **Fields**: id, id_dosen, dosen_nama, dosen_deskripsi, judul, tahun, jenis, penerbit, created_at
- **Ordering**: By tahun DESC, id DESC

### 3. `list_partners_with_logo`
- **Purpose**: Partner organizations with logo file paths
- **Joins**: kolaborasi → files
- **Filter**: WHERE jenis = 'partner'
- **Usage**: Display partner logos with proper file path concatenation

### 4. `list_sponsors`
- **Purpose**: Sponsor organizations (non-partners)
- **Joins**: kolaborasi → files
- **Filter**: WHERE jenis != 'partner'
- **Ordering**: By created_at DESC
- **Usage**: Display sponsor logos

### 5. `list_berita`
- **Purpose**: News articles with image metadata
- **Joins**: berita → files
- **Usage**: Display news listings with featured images

### 6. `list_produk`
- **Purpose**: Products ordered by creation date
- **Fields**: id, nama, deskripsi, kategori, harga, stok, created_at
- **Ordering**: By created_at DESC

### 7. `list_contact_messages`
- **Purpose**: Incoming contact form messages
- **Fields**: id, nama, email, subject, pesan, is_read, created_at
- **Ordering**: By created_at DESC

### 8. `site_settings`
- **Purpose**: Single-row configuration table for site contact and social media information
- **Fields**: alamat, no_hp, contact_email, facebook, twitter, instagram
- **Usage**: Centralized settings for footer and contact forms

## Stored Procedures (9 total)

### 1. `get_struktur_organisasi_list()`
- **Returns**: All organizational structure data with proper ordering
- **Replaces**: Complex SELECT with CASE statement for jabatan ranking
- **Applied to**: `admin/struktur.php`, `pages/struktur_organisasi.php`

### 2. `get_publikasi_by_dosen(p_dosen_id INT)`
- **Parameters**: 
  - `p_dosen_id INT` - Filter by specific dosen (0 = all)
- **Returns**: Publications ordered by tahun DESC, id DESC
- **Applied to**: `admin/publikasi.php`, `pages/publikasi.php`

### 3. `get_partners_list()`
- **Returns**: All partner organizations with logo paths
- **Applied to**: `pages/partner_sponsor.php`

### 4. `get_sponsors_list()`
- **Returns**: All sponsor organizations (non-partners) with logo paths
- **Applied to**: `pages/partner_sponsor.php`

### 5. `get_berita_list()`
- **Returns**: All news articles with image metadata
- **Prepared for**: Future use in news management

### 6. `get_produk_list()`
- **Returns**: All products ordered by creation date
- **Prepared for**: Future use in product management

### 7. `get_contact_messages_list()`
- **Returns**: All contact messages ordered by creation date DESC
- **Applied to**: `admin/messages.php`

### 8. `get_site_settings()`
- **Returns**: Single row of site settings (contact info, social media)
- **Applied to**: `includes/footer.php`, `admin/settings.php`

### 9. `upsert_site_settings(...)`
- **Parameters**: 
  - `p_alamat VARCHAR(255)`
  - `p_facebook VARCHAR(255)`
  - `p_twitter VARCHAR(255)`
  - `p_instagram VARCHAR(255)`
  - `p_no_hp VARCHAR(20)`
  - `p_contact_email VARCHAR(255)`
- **Behavior**: Uses PostgreSQL UPSERT (INSERT ... ON CONFLICT ... DO UPDATE) pattern
- **Applied to**: `admin/settings.php` (replaces manual INSERT/UPDATE logic)

## PHP Files Updated (8 total)

### Admin Pages
1. **`admin/struktur.php`**
   - Before: 15-line SELECT with CASE statement for jabatan ranking
   - After: `SELECT * FROM get_struktur_organisasi_list()`

2. **`admin/publikasi.php`**
   - Before: Direct WHERE clause filtering by id_dosen
   - After: `SELECT * FROM get_publikasi_by_dosen($dosenId) ORDER BY tahun DESC, id DESC`

3. **`admin/settings.php`**
   - Before: Manual INSERT/UPDATE logic with column existence checks
   - After: `CALL upsert_site_settings(...)` procedure with centralized fetch via `get_site_settings()`

4. **`admin/messages.php`**
   - Before: `SELECT * FROM contact_messages ORDER BY created_at DESC`
   - After: `SELECT * FROM get_contact_messages_list()`

### Public Pages
1. **`pages/struktur_organisasi.php`**
   - Before: Complex 10-line SELECT with JOINs
   - After: `SELECT * FROM get_struktur_organisasi_list()`

2. **`pages/publikasi.php`**
   - Before: Direct WHERE clause filtering by id_dosen
   - After: `SELECT * FROM get_publikasi_by_dosen($dosen_id)`

3. **`pages/partner_sponsor.php`**
   - Before: Two separate SELECTs (one for partners, one for sponsors)
   - After: `SELECT * FROM get_partners_list()` and `SELECT * FROM get_sponsors_list()`

### Shared Components
1. **`includes/footer.php`**
   - Before: `SELECT * FROM setting_sosial_media LIMIT 1`
   - After: `SELECT * FROM get_site_settings()`

## Benefits

### Code Reduction
- Reduced SQL query complexity across 8 PHP files
- Removed 50+ lines of JOIN logic from PHP
- Eliminated manual INSERT/UPDATE conditional logic in settings.php

### Maintainability
- Single source of truth for all data access
- View/procedure changes automatically reflect in all using files
- Easier to debug data fetching issues

### Performance
- View definitions allow query optimization at database level
- Procedures centralize complex logic (ranking, filtering, upserting)
- Consistent column ordering and filtering across application

### Consistency
- Standardized data structures returned from database
- Consistent photo path construction via file path concatenation
- Unified settings management via upsert_site_settings() procedure

## Installation

Run the SQL file in PostgreSQL:
```sql
psql -U your_user -d your_database -f database/db_views_and_functions.sql
```

All PHP files are already configured to use these views and procedures. No additional PHP changes needed.

## Notes

- All procedures handle NULL values gracefully with LEFT JOINs
- File paths are constructed using PostgreSQL string concatenation (`||`)
- The `upsert_site_settings()` procedure uses PostgreSQL 9.5+ syntax (INSERT ... ON CONFLICT ... DO UPDATE)
- Parameter escaping in PHP remains important for all dynamic inputs

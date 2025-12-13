# Cara Menggunakan Stored Procedures dengan Input Parameter

## 1. Struktur Input → Database

```
HTML Form
    ↓ (submit dengan POST)
PHP File (menerima $_POST)
    ↓ (escape & validate)
Database Connection
    ↓ (CALL stored procedure)
PostgreSQL Procedure
    ↓ (INSERT/UPDATE/DELETE)
Database Table
```

---

## 2. Contoh Implementasi di PHP

### A. INSERT (Menambah Data)

**HTML Form:**
```html
<form method="POST" action="publikasi.php">
    <input type="hidden" name="action" value="add">
    
    <label>Dosen:</label>
    <select name="id_dosen" required>
        <option value="">-- Pilih Dosen --</option>
        <?php foreach ($dosens as $d): ?>
            <option value="<?php echo $d['id']; ?>">
                <?php echo htmlspecialchars($d['nama']); ?>
            </option>
        <?php endforeach; ?>
    </select>
    
    <label>Judul Publikasi:</label>
    <input type="text" name="judul" required>
    
    <label>Tahun:</label>
    <input type="number" name="tahun" required>
    
    <label>Jenis:</label>
    <select name="jenis" required>
        <option value="jurnal">Jurnal</option>
        <option value="konferensi">Konferensi</option>
        <option value="buku">Buku</option>
    </select>
    
    <label>Penerbit:</label>
    <input type="text" name="penerbit">
    
    <button type="submit">Simpan</button>
</form>
```

**PHP Handler:**
```php
<?php
require_once '../config/database.php';
$db = new Database();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_POST['action'] === 'add') {
    // Validasi input
    $id_dosen = (int)$_POST['id_dosen'];
    $judul = $db->escape($_POST['judul']);
    $tahun = (int)$_POST['tahun'];
    $jenis = $db->escape($_POST['jenis']);
    $penerbit = $db->escape($_POST['penerbit'] ?? '');
    
    // Validasi
    if (!$id_dosen || !$judul || !$tahun || !$jenis) {
        $error = 'Field wajib diisi!';
    } else {
        // CARA 1: SELECT dari hasil CALL procedure
        $result = $db->query(
            "SELECT insert_publikasi($id_dosen, '$judul', $tahun, '$jenis', '$penerbit') AS new_id"
        );
        $row = $db->fetch($result);
        
        if ($row && $row['new_id']) {
            $success = 'Publikasi berhasil ditambahkan! ID: ' . $row['new_id'];
        } else {
            $error = 'Gagal menambahkan publikasi!';
        }
    }
}
?>
```

---

### B. UPDATE (Edit Data)

**HTML Form:**
```html
<form method="POST" action="publikasi.php">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="<?php echo $editData['id']; ?>">
    
    <label>Dosen:</label>
    <select name="id_dosen" required>
        <?php foreach ($dosens as $d): ?>
            <option value="<?php echo $d['id']; ?>" 
                <?php echo $d['id'] == $editData['id_dosen'] ? 'selected' : ''; ?>>
                <?php echo htmlspecialchars($d['nama']); ?>
            </option>
        <?php endforeach; ?>
    </select>
    
    <label>Judul:</label>
    <input type="text" name="judul" value="<?php echo htmlspecialchars($editData['judul']); ?>" required>
    
    <label>Tahun:</label>
    <input type="number" name="tahun" value="<?php echo $editData['tahun']; ?>" required>
    
    <label>Jenis:</label>
    <select name="jenis" required>
        <option value="jurnal" <?php echo $editData['jenis'] === 'jurnal' ? 'selected' : ''; ?>>Jurnal</option>
        <option value="konferensi" <?php echo $editData['jenis'] === 'konferensi' ? 'selected' : ''; ?>>Konferensi</option>
        <option value="buku" <?php echo $editData['jenis'] === 'buku' ? 'selected' : ''; ?>>Buku</option>
    </select>
    
    <label>Penerbit:</label>
    <input type="text" name="penerbit" value="<?php echo htmlspecialchars($editData['penerbit'] ?? ''); ?>">
    
    <button type="submit">Update</button>
</form>
```

**PHP Handler:**
```php
<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_POST['action'] === 'update') {
    $id = (int)$_POST['id'];
    $id_dosen = (int)$_POST['id_dosen'];
    $judul = $db->escape($_POST['judul']);
    $tahun = (int)$_POST['tahun'];
    $jenis = $db->escape($_POST['jenis']);
    $penerbit = $db->escape($_POST['penerbit'] ?? '');
    
    // Validasi
    if (!$id || !$id_dosen || !$judul || !$tahun) {
        $error = 'Field wajib diisi!';
    } else {
        // CARA 1: SELECT hasil procedure
        $result = $db->query(
            "SELECT update_publikasi($id, $id_dosen, '$judul', $tahun, '$jenis', '$penerbit') AS success"
        );
        $row = $db->fetch($result);
        
        if ($row && $row['success']) {
            $success = 'Publikasi berhasil diupdate!';
        } else {
            $error = 'Gagal mengupdate publikasi!';
        }
    }
}
?>
```

---

### C. DELETE (Hapus Data)

**HTML:**
```html
<a href="publikasi.php?action=delete&id=<?php echo $pub['id']; ?>" 
   onclick="return confirm('Yakin hapus?')">
    Hapus
</a>
```

**PHP Handler:**
```php
<?php
if (isset($_GET['action']) && $_GET['action'] === 'delete') {
    $id = (int)$_GET['id'];
    
    $result = $db->query("SELECT delete_publikasi($id) AS success");
    $row = $db->fetch($result);
    
    if ($row && $row['success']) {
        $success = 'Publikasi berhasil dihapus!';
        // Redirect atau refresh
        header('Location: publikasi.php');
        exit;
    } else {
        $error = 'Gagal menghapus publikasi!';
    }
}
?>
```

---

## 3. Perbedaan Cara Memanggil Procedure

### Cara 1: SELECT dari Function (Recommended untuk PHP)
```php
$result = $db->query("SELECT insert_publikasi($id_dosen, '$judul', $tahun, '$jenis', '$penerbit') AS new_id");
$row = $db->fetch($result);
$newId = $row['new_id'];
```

**Keuntungan:**
- Bisa langsung dapat return value
- Hasil bisa diakses seperti SELECT normal
- Lebih mudah di PHP

---

### Cara 2: CALL Procedure (Untuk VOID functions)
```php
$result = $db->query("CALL upsert_site_settings('$alamat', '$no_hp', '$email', ...)");
```

**Keuntungan:**
- Cocok untuk procedure yang tidak return value
- Lebih tradisional style

---

## 4. Contoh Lengkap: Admin Publikasi

```php
<?php
require_once 'includes/auth.php';
require_once '../config/database.php';

$pageTitle = 'Publikasi Dosen';
$db = new Database();

$success = '';
$error = '';
$dosenId = isset($_GET['dosen_id']) ? (int) $_GET['dosen_id'] : 0;

// ===== DELETE =====
if (isset($_GET['delete'])) {
    $id = (int) $_GET['delete'];
    $result = $db->query("SELECT delete_publikasi($id) AS success");
    $row = $db->fetch($result);
    $success = $row && $row['success'] ? 'Publikasi dihapus!' : 'Gagal hapus!';
}

// ===== ADD / UPDATE =====
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = (int)($_POST['id'] ?? 0);
    $id_dosen = (int)($_POST['id_dosen'] ?? 0);
    $judul = $db->escape($_POST['judul'] ?? '');
    $tahun = (int)($_POST['tahun'] ?? 0);
    $jenis = $db->escape($_POST['jenis'] ?? '');
    $penerbit = $db->escape($_POST['penerbit'] ?? '');

    if (!$id_dosen || !$judul || !$tahun) {
        $error = 'Field wajib diisi!';
    } else {
        if ($id > 0) {
            // UPDATE
            $result = $db->query(
                "SELECT update_publikasi($id, $id_dosen, '$judul', $tahun, '$jenis', '$penerbit') AS success"
            );
            $row = $db->fetch($result);
            $success = $row && $row['success'] ? 'Publikasi diupdate!' : 'Gagal update!';
        } else {
            // INSERT
            $result = $db->query(
                "SELECT insert_publikasi($id_dosen, '$judul', $tahun, '$jenis', '$penerbit') AS new_id"
            );
            $row = $db->fetch($result);
            $success = $row && $row['new_id'] ? 'Publikasi ditambahkan!' : 'Gagal tambah!';
        }
    }
}

// Get data
$pubsRes = $db->query("SELECT * FROM get_publikasi_by_dosen($dosenId)");
$pubs = $db->fetchAll($pubsRes);

// Get edit data
$editData = null;
if (isset($_GET['edit'])) {
    $editId = (int) $_GET['edit'];
    $editRes = $db->query("SELECT * FROM publikasi WHERE id = $editId");
    $editData = $db->fetch($editRes);
}

include 'includes/header.php';
?>

<?php if ($success): ?>
    <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6 rounded">
        <p class="text-green-700"><?= $success ?></p>
    </div>
<?php endif; ?>

<?php if ($error): ?>
    <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded">
        <p class="text-red-700"><?= $error ?></p>
    </div>
<?php endif; ?>

<!-- FORM -->
<div class="bg-white rounded-xl shadow-md p-6 mb-6">
    <h3 class="text-lg font-bold mb-4">
        <?= $editData ? 'Edit' : 'Tambah' ?> Publikasi
    </h3>

    <form method="POST">
        <?php if ($editData): ?>
            <input type="hidden" name="id" value="<?= $editData['id'] ?>">
        <?php endif; ?>
        <input type="hidden" name="id_dosen" value="<?= $dosenId ?>">

        <div class="grid md:grid-cols-2 gap-4 mb-4">
            <div>
                <label class="block font-semibold mb-2">Judul *</label>
                <input type="text" name="judul" required 
                       value="<?= htmlspecialchars($editData['judul'] ?? '') ?>" 
                       class="w-full px-4 py-2 border rounded-lg">
            </div>
            <div>
                <label class="block font-semibold mb-2">Tahun *</label>
                <input type="number" name="tahun" required 
                       value="<?= $editData['tahun'] ?? '' ?>" 
                       class="w-full px-4 py-2 border rounded-lg">
            </div>
        </div>

        <div class="grid md:grid-cols-2 gap-4 mb-4">
            <div>
                <label class="block font-semibold mb-2">Jenis *</label>
                <select name="jenis" required class="w-full px-4 py-2 border rounded-lg">
                    <option value="">-- Pilih --</option>
                    <option value="jurnal" <?= ($editData['jenis'] ?? '') === 'jurnal' ? 'selected' : '' ?>>Jurnal</option>
                    <option value="konferensi" <?= ($editData['jenis'] ?? '') === 'konferensi' ? 'selected' : '' ?>>Konferensi</option>
                    <option value="buku" <?= ($editData['jenis'] ?? '') === 'buku' ? 'selected' : '' ?>>Buku</option>
                </select>
            </div>
            <div>
                <label class="block font-semibold mb-2">Penerbit</label>
                <input type="text" name="penerbit" 
                       value="<?= htmlspecialchars($editData['penerbit'] ?? '') ?>" 
                       class="w-full px-4 py-2 border rounded-lg">
            </div>
        </div>

        <div class="flex gap-2">
            <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg">
                <?= $editData ? 'Update' : 'Simpan' ?>
            </button>
            <?php if ($editData): ?>
                <a href="publikasi.php?dosen_id=<?= $dosenId ?>" class="px-6 py-2 bg-gray-400 text-white rounded-lg">
                    Batal
                </a>
            <?php endif; ?>
        </div>
    </form>
</div>

<!-- TABLE -->
<div class="bg-white rounded-xl shadow-md overflow-hidden">
    <?php if ($pubs): ?>
        <table class="w-full">
            <thead class="bg-gray-100">
                <tr>
                    <th class="px-4 py-2 text-left">Judul</th>
                    <th class="px-4 py-2 text-left">Tahun</th>
                    <th class="px-4 py-2 text-left">Jenis</th>
                    <th class="px-4 py-2 text-left">Penerbit</th>
                    <th class="px-4 py-2 text-left">Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($pubs as $p): ?>
                    <tr class="border-b hover:bg-gray-50">
                        <td class="px-4 py-3"><?= htmlspecialchars($p['judul']) ?></td>
                        <td class="px-4 py-3"><?= $p['tahun'] ?></td>
                        <td class="px-4 py-3"><?= htmlspecialchars($p['jenis']) ?></td>
                        <td class="px-4 py-3"><?= htmlspecialchars($p['penerbit'] ?? '-') ?></td>
                        <td class="px-4 py-3 space-x-2">
                            <a href="?edit=<?= $p['id'] ?>&dosen_id=<?= $dosenId ?>" 
                               class="text-blue-600 hover:underline">Edit</a>
                            <a href="?delete=<?= $p['id'] ?>&dosen_id=<?= $dosenId ?>" 
                               onclick="return confirm('Hapus?')" 
                               class="text-red-600 hover:underline">Hapus</a>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php else: ?>
        <div class="p-6 text-center text-gray-500">
            Belum ada publikasi. <a href="#form" class="text-blue-600">Tambah sekarang</a>
        </div>
    <?php endif; ?>
</div>

<?php include 'includes/footer.php'; ?>
```

---

## 5. Ringkasan

| Operasi | Query | Return | Digunakan Untuk |
|---------|-------|--------|-----------------|
| **INSERT** | `SELECT insert_publikasi(...)` | INT (new_id) | Validasi & confirm |
| **UPDATE** | `SELECT update_publikasi(...)` | BOOLEAN | Validasi & confirm |
| **DELETE** | `SELECT delete_publikasi(...)` | BOOLEAN | Validasi & confirm |
| **GET** | `SELECT * FROM get_publikasi_by_dosen(...)` | TABLE | Display data |

---

## 6. Tips Keamanan

✅ **Selalu escape input:**
```php
$judul = $db->escape($_POST['judul']);  // String
$tahun = (int)$_POST['tahun'];          // Integer
```

✅ **Validasi di PHP + Database:**
- PHP: Check required fields, type validation
- Database: Constraints, triggers, NOT NULL, UNIQUE

✅ **Gunakan prepared statements (jika ada):**
```php
// Jika Database class support parameterized queries:
$db->query("SELECT insert_publikasi(?, ?, ?, ?, ?)", 
    [$id_dosen, $judul, $tahun, $jenis, $penerbit]);
```

---

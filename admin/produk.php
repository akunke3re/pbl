<?php
require_once 'includes/auth.php';
require_once '../config/database.php';

$pageTitle = 'Manage Produk';
$db = new Database();

$success = '';
$error = '';

/* UPLOAD LOGO/GAMBAR */
function uploadProductImage($fileInputName = 'gambar') {
    if (!isset($_FILES[$fileInputName]) || $_FILES[$fileInputName]['error'] !== 0) {
        return null;
    }

    $allowed = ['image/jpeg', 'image/png', 'image/jpg', 'image/webp'];
    if (!in_array($_FILES[$fileInputName]['type'], $allowed)) {
        return ['error' => 'The file must be an image (jpg, png, webp).'];
    }

    $uploadDir = '../uploads/produk/';
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    $fileName = time() . '_' . basename($_FILES[$fileInputName]['name']);
    $targetPath = $uploadDir . $fileName;

    if (move_uploaded_file($_FILES[$fileInputName]['tmp_name'], $targetPath)) {
        return ['file' => $fileName];
    }

    return ['error' => 'Failed to upload image'];
}

/* MULTI DELETE */
if (isset($_POST['multi_delete']) && !empty($_POST['ids'])) {
    $ids = implode(',', array_map('intval', $_POST['ids']));
    $db->query("DELETE FROM produk WHERE id IN ($ids)");
    $success = 'Selected products successfully deleted!';
}

/* DELETE SINGLE */
if (isset($_GET['delete'])) {
    $id = (int) $_GET['delete'];
    $check = $db->query("SELECT id FROM produk WHERE id = $id LIMIT 1");
    if ($db->numRows($check) > 0) {
        if ($db->query("DELETE FROM produk WHERE id = $id")) {
            $success = 'Product successfully deleted!';
        } else {
            $error = 'Failed to delete product!';
        }
    } else {
        $error = 'Product not found!';
    }
}

/* ADD / EDIT */
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !isset($_POST['multi_delete'])) {
    $id = (int) ($_POST['id'] ?? 0);
    $nama = $db->escape($_POST['nama'] ?? '');
    $deskripsi = $db->escape($_POST['deskripsi'] ?? '');
    $kategori = $db->escape($_POST['kategori'] ?? '');
    $teknologi = $db->escape($_POST['teknologi'] ?? '');
    $status = $db->escape($_POST['status'] ?? '');
    $link = $db->escape($_POST['link'] ?? '');
    $gambar = null;

    if (!$nama) {
        $error = 'Product name is required!';
    }

    if (!$error && isset($_FILES['gambar']) && $_FILES['gambar']['error'] === 0) {
        $upload = uploadProductImage('gambar');
        if (isset($upload['error'])) {
            $error = $upload['error'];
        } elseif (isset($upload['file'])) {
            $gambar = $db->escape($upload['file']);
        }
    }

    if (!$error) {
        if ($id > 0) {
            $check = $db->query("SELECT id FROM produk WHERE id = $id LIMIT 1");
            if ($db->numRows($check) == 0) {
                $error = 'Product data not found!';
            } else {
                $sql = "UPDATE produk SET 
                        nama = '$nama',
                        deskripsi = '$deskripsi',
                        kategori = '$kategori',
                        teknologi = '$teknologi',
                        status = '$status',
                        link = '$link'";

                if ($gambar) {
                    $sql .= ", gambar = '$gambar'";
                }

                $sql .= ", updated_at = CURRENT_TIMESTAMP WHERE id = $id";

                if ($db->query($sql)) {
                    $success = 'Product successfully updated!';
                } else {
                    $error = 'Failed to update product!';
                }
            }
        } else {
            if ($gambar) {
                $sql = "INSERT INTO produk (nama, deskripsi, kategori, teknologi, status, gambar, link) 
                        VALUES ('$nama', '$deskripsi', '$kategori', '$teknologi', '$status', '$gambar', '$link')";
            } else {
                $sql = "INSERT INTO produk (nama, deskripsi, kategori, teknologi, status, link) 
                        VALUES ('$nama', '$deskripsi', '$kategori', '$teknologi', '$status', '$link')";
            }

            if ($db->query($sql)) {
                $success = 'Product successfully added!';
            } else {
                $error = 'Failed to add product!';
            }
        }
    }
}

/* PAGINATION */
$perPage = 10;
$page = isset($_GET['page']) ? (int) $_GET['page'] : 1;
$offset = ($page - 1) * $perPage;

$countResult = $db->query("SELECT COUNT(*) AS total FROM produk");
$countRow = $db->fetch($countResult);
$totalRows = $countRow['total'];
$totalPages = ceil($totalRows / $perPage);

$result = $db->query("SELECT * FROM produk ORDER BY created_at DESC LIMIT $perPage OFFSET $offset");
$data = $db->fetchAll($result);

/* GET DATA EDIT */
$editData = null;
if (isset($_GET['edit'])) {
    $editId = (int) $_GET['edit'];
    $editResult = $db->query("SELECT * FROM produk WHERE id = $editId LIMIT 1");
    if ($db->numRows($editResult) > 0) {
        $editData = $db->fetch($editResult);
    }
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

<div class="bg-white rounded-xl shadow-md p-6 mb-6">
    <h3 class="text-lg font-bold text-gray-800 mb-4"><?= $editData ? 'Edit' : 'Add' ?> Products</h3>

    <form method="POST" enctype="multipart/form-data">
        <?php if ($editData): ?><input type="hidden" name="id" value="<?= $editData['id'] ?>"><?php endif; ?>

        <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Product Name *</label>
            <input type="text" name="nama" required value="<?= htmlspecialchars($editData['nama'] ?? '') ?>"
                class="w-full px-4 py-2 rounded-lg border" />
        </div>

        <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Description</label>
            <textarea name="deskripsi" rows="3" class="w-full px-4 py-2 rounded-lg border"><?= htmlspecialchars($editData['deskripsi'] ?? '') ?></textarea>
        </div>

        <div class="grid md:grid-cols-3 gap-4 mb-4">
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Category</label>
                <input type="text" name="kategori" value="<?= htmlspecialchars($editData['kategori'] ?? '') ?>" class="w-full px-4 py-2 rounded-lg border" />
            </div>

            <div>
                <label class="block text-gray-700 font-semibold mb-2">Technology (separated by comma)</label>
                <input type="text" name="teknologi" value="<?= htmlspecialchars($editData['teknologi'] ?? '') ?>" class="w-full px-4 py-2 rounded-lg border" />
            </div>

            <div>
                <label class="block text-gray-700 font-semibold mb-2">Status</label>
                <select name="status" class="w-full px-4 py-2 rounded-lg border">
                    <?php $sList = ['completed' => 'Completed', 'ongoing' => 'Ongoing', 'planning' => 'Planning'];
                    foreach ($sList as $val => $label) {
                        $sel = (($editData['status'] ?? '') == $val) ? 'selected' : '';
                        echo "<option value='$val' $sel>$label</option>";
                    }
                    ?>
                </select>
            </div>
        </div>

        <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Product Link (optional)</label>
            <input type="url" name="link" value="<?= htmlspecialchars($editData['link'] ?? '') ?>" class="w-full px-4 py-2 rounded-lg border" />
        </div>

        <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Logo / Image</label>
            <input type="file" name="gambar" accept="image/*" class="w-full px-4 py-2 rounded-lg border" />
        </div>

        <?php if ($editData && !empty($editData['gambar'])): ?>
            <div class="mb-4">
                <label class="block text-gray-700 font-semibold mb-2">Current Logo</label>
                <img src="../uploads/produk/<?= htmlspecialchars($editData['gambar']) ?>" class="w-48 h-32 object-cover rounded-lg" />
            </div>
        <?php endif; ?>

        <div class="flex justify-end space-x-2">
            <?php if ($editData): ?>
                <a href="produk.php" class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg">Cancel</a>
            <?php endif; ?>

            <button type="submit" class="px-6 py-2 text-white rounded-lg hover:shadow-lg transition" style="background-color : blue">
                <i class="fas fa-save mr-2"></i><?php echo $editData ? 'Update' : 'Save'; ?>
            </button>
        </div>
    </form>
</div>

<!-- LIST DATA PRODUK -->
<div class="bg-white rounded-xl shadow-md overflow-hidden mt-6">
    <form method="POST">
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-gradient-to-r from-purple-600 to-blue-600 text-white">
                    <tr>
                        <th class="px-6 py-3 text-left text-sm font-semibold">Logo</th>
                        <th class="px-6 py-3 text-left text-sm font-semibold">Name</th>
                        <th class="px-6 py-3 text-left text-sm font-semibold">Category</th>
                        <th class="px-6 py-3 text-left text-sm font-semibold">Status</th>
                        <th class="px-6 py-3 text-center text-sm font-semibold">Action</th>
                        <th class="px-6 py-3 text-center">
                            <input type="checkbox" id="checkAll">
                        </th>
                    </tr>
                </thead>

                <tbody class="divide-y divide-gray-200">
                    <?php if ($data): ?>
                        <?php foreach ($data as $row): ?>
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-6 py-4">
                                    <?php if (!empty($row['gambar'])): ?>
                                        <img src="../uploads/produk/<?= htmlspecialchars($row['gambar']) ?>" class="w-20 h-16 object-cover rounded">
                                    <?php else: ?>
                                        <div class="w-20 h-16 bg-gray-200 rounded flex items-center justify-center">
                                            <i class="fas fa-box text-gray-400"></i>
                                        </div>
                                    <?php endif; ?>
                                </td>

                                <td class="px-6 py-4">
                                    <p class="font-semibold text-gray-800"><?= htmlspecialchars($row['nama']) ?></p>
                                    <p class="text-sm text-gray-500"><?= htmlspecialchars(substr($row['deskripsi'] ?? '', 0, 60)) ?><?= strlen($row['deskripsi'] ?? '') > 60 ? '...' : '' ?></p>
                                </td>

                                <td class="px-6 py-4">
                                    <span class="px-3 py-1 bg-purple-100 text-purple-700 rounded-full text-xs font-semibold"><?= htmlspecialchars($row['kategori']) ?></span>
                                </td>

                                <td class="px-6 py-4 text-sm text-gray-600">
                                    <?= htmlspecialchars(ucfirst($row['status'])) ?>
                                </td>

                                <td class="px-6 py-4">
                                    <div class="flex justify-center space-x-2">
                                        <a href="?edit=<?= $row['id'] ?>" class="px-3 py-1 bg-blue-500 text-white rounded-lg text-sm"><i class="fas fa-edit"></i></a>

                                        <a href="?delete=<?= $row['id'] ?>" onclick="return confirm('Hapus produk ini?')" class="px-3 py-1 bg-red-500 text-white rounded-lg text-sm"><i class="fas fa-trash"></i></a>

                                        <?php if (!empty($row['link'])): ?>
                                            <a href="<?= htmlspecialchars($row['link']) ?>" target="_blank" class="px-3 py-1 bg-green-500 text-white rounded-lg text-sm"><i class="fas fa-external-link-alt"></i></a>
                                        <?php endif; ?>
                                    </div>
                                </td>

                                <td class="px-6 py-4 text-center">
                                    <input type="checkbox" name="ids[]" value="<?= $row['id'] ?>">
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                                <i class="fas fa-box text-gray-300 text-6xl mb-4"></i><br>
                                No products available
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>

        <div class="p-4 border-t flex justify-between">
            <button type="submit" name="multi_delete" class="px-4 py-2 bg-red-500 text-white rounded-lg" onclick="return confirm('Hapus semua yang dipilih?')">Delete Selected</button>

            <div class="flex space-x-2">
                <?php for ($i = 1; $i <= $totalPages; $i++): ?>
                    <a href="?page=<?= $i ?>" class="px-3 py-1 rounded-lg <?= $i == $page ? 'bg-purple-600 text-white' : 'bg-gray-200 text-gray-700' ?>"><?= $i ?></a>
                <?php endfor; ?>
            </div>
        </div>
    </form>
</div>

<?php include 'includes/footer.php'; ?>

<?php
require_once 'includes/auth.php';
require_once '../config/database.php';

$pageTitle = 'Our Priority';
$db = new Database();

$success = '';
$error = '';

/* DELETE */
if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    $result = $db->query("SELECT delete_priority($id) AS success");
    $row = $db->fetch($result);
    $success = $row && $row['success'] ? 'Priority has been successfully deleted!' : 'Failed to delete priority!';
}

/* ADD / UPDATE */
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = (int)($_POST['id'] ?? 0);
    $title = $db->escape($_POST['title'] ?? '');
    $description = $db->escape($_POST['description'] ?? '');
    $urutan = (int)($_POST['urutan'] ?? 0);

    if (!$title) {
        $error = 'Title is required!';
    } else {
        if ($id > 0) {
            // UPDATE
            $result = $db->query(
                "SELECT update_priority($id, '$title', '$description', $urutan, TRUE) AS success"
            );
            $row = $db->fetch($result);
            $success = $row && $row['success'] ? 'Priority updated!' : 'Failed to update!';
        } else {
            // INSERT
            $result = $db->query(
                "SELECT insert_priority('$title', '$description', $urutan) AS new_id"
            );
            $row = $db->fetch($result);
            $success = $row && $row['new_id'] ? 'Priority added!' : 'Failed to add priority!';
        }
    }
}

// Get data
$prioritiesRes = $db->query("SELECT * FROM get_priority_list()");
$priorities = $db->fetchAll($prioritiesRes);

// Get edit data
$editData = null;
if (isset($_GET['edit'])) {
    $editId = (int) $_GET['edit'];
    $editRes = $db->query("SELECT * FROM priority WHERE id = $editId");
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
        <?= $editData ? 'Edit' : 'Add' ?> Priority
    </h3>

    <form method="POST">
        <?php if ($editData): ?>
            <input type="hidden" name="id" value="<?= $editData['id'] ?>">
        <?php endif; ?>

        <div class="grid gap-4 mb-4">
            <div>
                <label class="block font-semibold mb-2">Title *</label>
                <input type="text" name="title" required 
                       value="<?= htmlspecialchars($editData['title'] ?? '') ?>" 
                       class="w-full px-4 py-2 border rounded-lg">
            </div>
        </div>

        <div class="mb-4">
            <label class="block font-semibold mb-2">Description</label>
            <textarea name="description" rows="4"
                      class="w-full px-4 py-2 border rounded-lg"><?= htmlspecialchars($editData['description'] ?? '') ?></textarea>
        </div>

        <div class="flex gap-2">
            <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg">
                <?= $editData ? 'Update' : 'Save' ?>
            </button>
            <?php if ($editData): ?>
                <a href="priority.php" class="px-6 py-2 bg-gray-400 text-white rounded-lg">Cancel</a>
            <?php endif; ?>
        </div>
    </form>
</div>

<!-- TABLE -->
<div class="bg-white rounded-xl shadow-md overflow-hidden">
    <?php if ($priorities): ?>
        <table class="w-full">
            <thead class="bg-gray-100">
                <tr>
                    <th class="px-4 py-2 text-left">Title</th>
                    <th class="px-4 py-2 text-left">Description</th>
                    <th class="px-4 py-2 text-left">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($priorities as $p): ?>
                    <tr class="border-b hover:bg-gray-50">
                        <td class="px-4 py-3"><?= htmlspecialchars($p['title']) ?></td>
                        <td class="px-4 py-3"><?= htmlspecialchars(substr($p['description'] ?? '', 0, 50)) ?>...</td>
                        <td class="px-4 py-3 space-x-2">
                            <a href="?edit=<?= $p['id'] ?>" class="text-blue-600 hover:underline">Edit</a>
                            <a href="?delete=<?= $p['id'] ?>" onclick="return confirm('Hapus?')" class="text-red-600 hover:underline">Delete</a>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php else: ?>
        <div class="p-6 text-center text-gray-500">
            Not priority Available. <a href="#form" class="text-blue-600">Add Now</a>
        </div>
    <?php endif; ?>
</div>

<?php include 'includes/footer.php'; ?>

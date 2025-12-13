<?php
require_once 'includes/auth.php';
require_once '../config/database.php';

$pageTitle = 'Site Settings';
$db = new Database();

$success = '';
$error = '';

// Fetch current settings row
$res = $db->query("SELECT * FROM get_site_settings()");
$settings = $res ? $db->fetch($res) : null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $alamat = $db->escape($_POST['alamat'] ?? '');
    $facebook = $db->escape($_POST['facebook'] ?? '');
    $twitter = $db->escape($_POST['twitter'] ?? '');
    $instagram = $db->escape($_POST['instagram'] ?? '');
    $linkedin = $db->escape($_POST['linkedin'] ?? '');
    $no_hp = $db->escape($_POST['no_hp'] ?? '');
    $contact_email = $db->escape($_POST['contact_email'] ?? '');

    // Call upsert_site_settings() function (use SELECT for functions) with parameter order
    $sql = "SELECT upsert_site_settings('$alamat', '$no_hp', '$contact_email', '$facebook', '$twitter', '$instagram', '$linkedin')";

    if ($db->query($sql)) {
        $success = 'Settings successfully saved.';
        $res = $db->query("SELECT * FROM get_site_settings()");
        $settings = $res ? $db->fetch($res) : null;
    } else {
        $error = 'Failed to save settings.';
    }
}

include 'includes/header.php';
?>

<?php if ($success): ?>
<div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6 rounded">
    <p class="text-green-700"><?php echo $success; ?></p>
</div>
<?php endif; ?>

<?php if ($error): ?>
<div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded">
    <p class="text-red-700"><?php echo $error; ?></p>
</div>
<?php endif; ?>

<div class="bg-white rounded-xl shadow-md p-6 mb-6">
    <h3 class="text-lg font-bold mb-4">Site Contact & Social Settings</h3>

    <form method="POST">
        <div class="grid gap-4 mb-4">
            <div>
                <label class="block font-semibold mb-2">Full address</label>
                <input type="text" name="alamat" value="<?php echo htmlspecialchars($settings['alamat'] ?? ''); ?>" class="w-full px-4 py-2 border rounded-lg">
            </div>
        </div>
        <div class="grid md:grid-cols-2 gap-4 mb-4">
            <div>
                <label class="block font-semibold mb-2">Phone (mobile number)</label>
                <input type="text" name="no_hp" value="<?php echo htmlspecialchars($settings['no_hp'] ?? ''); ?>" class="w-full px-4 py-2 border rounded-lg">
            </div>
            <div>
                <label class="block font-semibold mb-2">Contact Email</label>
                <input type="email" name="contact_email" value="<?php echo htmlspecialchars($settings['contact_email'] ?? ''); ?>" class="w-full px-4 py-2 border rounded-lg">
            </div>
        </div>

        <div class="grid md:grid-cols-2 gap-4 mb-4">
            <div>
                <label class="block font-semibold mb-2">Facebook (URL)</label>
                <input type="text" name="facebook" value="<?php echo htmlspecialchars($settings['facebook'] ?? ''); ?>" class="w-full px-4 py-2 border rounded-lg">
            </div>
            <div>
                <label class="block font-semibold mb-2">Twitter (URL)</label>
                <input type="text" name="twitter" value="<?php echo htmlspecialchars($settings['twitter'] ?? ''); ?>" class="w-full px-4 py-2 border rounded-lg">
            </div>
            <div>
                <label class="block font-semibold mb-2">Instagram (URL)</label>
                <input type="text" name="instagram" value="<?php echo htmlspecialchars($settings['instagram'] ?? ''); ?>" class="w-full px-4 py-2 border rounded-lg">
            </div>
            <div>
                <label class="block font-semibold mb-2">LinkedIn (URL)</label>
                <input type="text" name="linkedin" value="<?php echo htmlspecialchars($settings['linkedin'] ?? ''); ?>" class="w-full px-4 py-2 border rounded-lg">
            </div>
        </div>

        <div class="flex justify-end">
            <button class="px-6 py-2 bg-blue-600 text-white rounded-lg">Save</button>
        </div>
    </form>
</div>

<?php include 'includes/footer.php'; ?>

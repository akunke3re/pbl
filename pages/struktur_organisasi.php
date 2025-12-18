<?php
require_once '../config/database.php';
$pageTitle = 'Struktur Organisasi';
$pageInPages = true;

// Fetch data
$db = new Database();

// Get Struktur Organisasi via view
$strukturResult = $db->query("SELECT * FROM list_struktur_with_dosen");
$struktur = $db->fetchAll($strukturResult);

include '../includes/header.php';
?>

<!-- Page Header -->
<section class="relative py-20 bg-gradient-to-br from-blue-600 to-blue-800 text-white">
    <div class="container mx-auto px-6 text-center">
        <div data-aos="fade-up">
            <i class="fas fa-sitemap text-6xl mb-4 opacity-90"></i>
            <h1 class="text-5xl md:text-6xl font-bold mb-4">Organizational Structure</h1>
            <p class="text-xl text-blue-100 max-w-2xl mx-auto">Laboratory Organization Structure and Hierarchy</p>
        </div>
    </div>
</section>

<!-- Organizational Structure Section -->
<section class="py-20 bg-gray-50">
    <div class="container mx-auto px-6">
        <?php if (!empty($struktur)): ?>
            <div class="max-w-6xl mx-auto">
                <!-- Organizational Chart -->
                <div class="space-y-8">
                    <?php
                    $currentLevel = 0;
                    foreach ($struktur as $index => $person):
                        // Normalize level/urutan field — fall back to 0 when missing
                        $level = $person['level'] ?? $person['urutan'] ?? 0;
                        $isNewLevel = $level != $currentLevel;
                        $currentLevel = $level;
                        ?>

                        <?php if ($level == 1): ?>
                            <!-- Top Level (Kepala Lab) -->
                            <div class="flex justify-center" data-aos="fade-up">
                                <div
                                    class="card-hover bg-white rounded-xl shadow-xl p-8 max-w-md w-full border-t-4 border-blue-600">
                                    <?php
                                    $fotoPathRaw = $person['foto_path'] ?? '';
                                    $fotoServerPath = __DIR__ . '/../' . ltrim($fotoPathRaw, '/');
                                    $fotoWebPath = '../' . ltrim($fotoPathRaw, '/');
                                    if (!empty($fotoPathRaw) && file_exists($fotoServerPath)): ?>
                                        <div class="w-32 h-32 mx-auto mb-4 rounded-full overflow-hidden border-4 border-blue-600">
                                            <img src="<?= htmlspecialchars($fotoWebPath) ?>"
                                                alt="<?= htmlspecialchars($person['nama']); ?>" class="w-full h-full object-cover">
                                        </div>
                                    <?php else: ?>
                                        <div
                                            class="w-32 h-32 mx-auto mb-4 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center border-4 border-blue-600">
                                            <i class="fas fa-user text-white text-5xl"></i>
                                        </div>
                                    <?php endif; ?>
                                    <h3 class="text-2xl font-bold text-center mb-2 text-gray-800">
                                        <?php echo htmlspecialchars($person['nama']); ?></h3>
                                    <p class="text-center text-blue-600 font-semibold mb-3">
                                        <?php echo htmlspecialchars($person['jabatan']); ?></p>
                                    <?php if (!empty($person['email'])): ?>
                                        <p class="text-center text-gray-600 text-sm">
                                            <i class="fas fa-envelope mr-2"></i><?php echo htmlspecialchars($person['email']); ?>
                                        </p>
                                    <?php endif; ?>
                                </div>
                            </div>

                            <!-- Connection Line -->
                            <div class="flex justify-center">
                                <div class="w-1 h-12 bg-blue-300"></div>
                            </div>
                        <?php else: ?>
                            <?php if ($isNewLevel && $level > 1): ?>
                                <!-- Start New Level Grid -->
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" data-aos="fade-up">
                                <?php endif; ?>

                                <!-- Member Card -->
                                <a href="publikasi.php?dosen_id=<?php echo urlencode($person['id_dosen']); ?>"
                                    class="card-hover block bg-white rounded-xl shadow-lg p-6 border-l-4 border-blue-600 hover:no-underline">
                                    <?php
                                    $fotoPathRaw = $person['foto_path'] ?? '';
                                    $fotoServerPath = __DIR__ . '/../' . ltrim($fotoPathRaw, '/');
                                    $fotoWebPath = '../' . ltrim($fotoPathRaw, '/');
                                    if (!empty($fotoPathRaw) && file_exists($fotoServerPath)): ?>
                                        <div class="w-24 h-24 mx-auto mb-4 rounded-full overflow-hidden border-4 border-blue-100">
                                            <img src="<?= htmlspecialchars($fotoWebPath) ?>"
                                                alt="<?= htmlspecialchars($person['nama']); ?>" class="w-full h-full object-cover">
                                        </div>
                                    <?php else: ?>
                                        <div
                                            class="w-24 h-24 mx-auto mb-4 rounded-full bg-gradient-to-br from-blue-100 to-blue-200 flex items-center justify-center">
                                            <i class="fas fa-user text-blue-600 text-3xl"></i>
                                        </div>
                                    <?php endif; ?>
                                    <h3 class="text-xl font-bold text-center mb-2 text-gray-800">
                                        <?php echo htmlspecialchars($person['nama']); ?></h3>
                                    <p class="text-center text-blue-600 font-medium mb-2">
                                        <?php echo htmlspecialchars($person['jabatan']); ?></p>
                                    <?php if (!empty($person['email'])): ?>
                                        <p class="text-center text-gray-600 text-sm">
                                            <i class="fas fa-envelope mr-2"></i><?php echo htmlspecialchars($person['email']); ?>
                                        </p>
                                    <?php endif; ?>
                                </a>

                                <?php
                                // Check if this is the last item or next item has different level
                                $isLastInLevel = ($index == count($struktur) - 1) ||
                                    (isset($struktur[$index + 1]) && (($struktur[$index + 1]['urutan'] ?? 0) != $level));
                                if ($isLastInLevel && $level > 1):
                                    ?>
                                </div> <!-- Close grid -->
                            <?php endif; ?>
                        <?php endif; ?>
                    <?php endforeach; ?>
                </div>
            </div>
        <?php else: ?>
            <div class="text-center py-20">
                <div class="w-32 h-32 bg-gray-200 rounded-full flex items-center justify-center mx-auto mb-6">
                    <i class="fas fa-sitemap text-gray-400 text-6xl"></i>
                </div>
                <h3 class="text-2xl font-bold text-gray-700 mb-2">No Organizational Structure Yet</h3>
                <p class="text-gray-500">The organizational structure will be displayed here.</p>
            </div>
        <?php endif; ?>
    </div>
</section>

<!-- CTA Section -->
<section class="py-16 bg-gradient-to-br from-blue-600 to-blue-800 text-white">
    <div class="container mx-auto px-6 text-center">
        <h2 class="text-3xl font-bold mb-4" data-aos="fade-up">Tertarik Bergabung?</h2>
        <p class="text-blue-100 mb-6 max-w-2xl mx-auto" data-aos="fade-up" data-aos-delay="100">
            We are always open to researchers and students who want to contribute to research and innovation.
        </p>
        <a href="../index.php#contact"
            class="inline-block px-8 py-4 bg-white text-blue-600 rounded-lg font-semibold hover-scale shadow-lg"
            data-aos="fade-up" data-aos-delay="200">
            <i class="fas fa-envelope mr-2"></i>Contact Us
        </a>
    </div>
</section>

<?php include '../includes/footer.php'; ?>
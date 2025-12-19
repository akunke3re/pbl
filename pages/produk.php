<?php
require_once '../config/database.php';
$pageTitle = 'Produk';
$pageInPages = true;

// Fetch data
$db = new Database();

// Get Produk via DB view (list_produk)
$produkResult = $db->query("SELECT id, nama, gambar, link, deskripsi FROM list_produk");
$produk = $db->fetchAll($produkResult);

include '../includes/header.php';
?>

<!-- Page Header -->
<section class="relative py-20 bg-gradient-to-br from-blue-600 to-blue-800 text-white">
    <div class="container mx-auto px-6 text-center">
        <div data-aos="fade-up">
            <i class="fas fa-box text-6xl mb-4 opacity-90"></i>
            <h1 class="text-5xl md:text-6xl font-bold mb-4">Our Products</h1>
            <p class="text-xl text-blue-100 max-w-2xl mx-auto">Research and Innovation Results from the Laboratory</p>
        </div>
    </div>
</section>

<!-- Products Section -->
<section class="py-20 bg-gray-50">
    <div class="container mx-auto px-6">
        <?php if (!empty($produk)): ?>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <?php foreach ($produk as $item): ?>
                    <div class="card-hover bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-xl transition" data-aos="fade-up">
                        <!-- Image Container -->
                        <div class="relative overflow-hidden h-48 flex items-center justify-center bg-gray-100">
                            <?php if (!empty($item['gambar'])): ?>
                                <img src="../uploads/produk/<?= htmlspecialchars($item['gambar']) ?>" 
                                     alt="<?= htmlspecialchars($item['nama']) ?>"
                                     class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105">
                            <?php else: ?>
                                <div class="w-full h-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center">
                                    <i class="fas fa-box-open text-white text-6xl opacity-50"></i>
                                </div>
                            <?php endif; ?>
                        </div>

                        <div class="p-6">
                            <!-- Badge -->
                            <span class="inline-block px-3 py-1 bg-blue-100 text-blue-600 text-xs font-semibold rounded-full mb-3">
                                Produk
                            </span>

                            <!-- Title -->
                            <h3 class="text-lg font-bold mb-3 text-gray-800 line-clamp-2">
                                <?= htmlspecialchars($item['nama']) ?>
                            </h3>

                            <!-- Description -->
                            <?php if (!empty($item['deskripsi'])): ?>
                                <p class="text-gray-600 text-sm mb-4 line-clamp-3">
                                    <?= htmlspecialchars($item['deskripsi']) ?>
                                </p>
                            <?php endif; ?>

                            <!-- Read More Link -->
                            <?php if (!empty($item['link'])): ?>
                                <a href="<?= htmlspecialchars($item['link']) ?>" target="_blank" class="text-blue-600 font-semibold hover:underline text-sm">
                                    Open Product →
                                </a>
                            <?php endif; ?>
                        </div>
                    </div>

                <?php endforeach; ?>
            </div>
        <?php else: ?>
            <!-- Empty State with Default Products -->
            <div class="max-w-6xl mx-auto">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <!-- Product 1: LMS -->
                    <div class="card-hover bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-xl transition" data-aos="fade-up">
                        <div class="relative overflow-hidden h-48 bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center">
                            <i class="fas fa-graduation-cap text-white text-6xl opacity-50"></i>
                        </div>
                        <div class="p-6">
                            <span class="inline-block px-3 py-1 bg-blue-100 text-blue-600 text-xs font-semibold rounded-full mb-3">
                                Produk
                            </span>
                            <h3 class="text-lg font-bold mb-3 text-gray-800 line-clamp-2">Learning Management System</h3>
                            <p class="text-gray-600 text-sm mb-4 line-clamp-3">An interactive and adaptive online learning platform to support learning activities in educational institutions.</p>
                            <span class="text-blue-600 font-semibold text-sm">Learn More →</span>
                        </div>
                    </div>
                    
                    <!-- Product 2: Smart Farming -->
                    <div class="card-hover bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-xl transition" data-aos="fade-up" data-aos-delay="100">
                        <div class="relative overflow-hidden h-48 bg-gradient-to-br from-green-400 to-green-600 flex items-center justify-center">
                            <i class="fas fa-leaf text-white text-6xl opacity-50"></i>
                        </div>
                        <div class="p-6">
                            <span class="inline-block px-3 py-1 bg-blue-100 text-blue-600 text-xs font-semibold rounded-full mb-3">
                                Produk
                            </span>
                            <h3 class="text-lg font-bold mb-3 text-gray-800 line-clamp-2">Smart Farming IoT System</h3>
                            <p class="text-gray-600 text-sm mb-4 line-clamp-3">An IoT-based monitoring and control system for agriculture to optimize harvest results and resource efficiency.</p>
                            <span class="text-blue-600 font-semibold text-sm">Learn More →</span>
                        </div>
                    </div>
                    
                    <!-- Product 3: Blockchain System -->
                    <div class="card-hover bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-xl transition" data-aos="fade-up" data-aos-delay="200">
                        <div class="relative overflow-hidden h-48 bg-gradient-to-br from-purple-400 to-purple-600 flex items-center justify-center">
                            <i class="fas fa-link text-white text-6xl opacity-50"></i>
                        </div>
                        <div class="p-6">
                            <span class="inline-block px-3 py-1 bg-blue-100 text-blue-600 text-xs font-semibold rounded-full mb-3">
                                Produk
                            </span>
                            <h3 class="text-lg font-bold mb-3 text-gray-800 line-clamp-2">Blockchain Supply Chain</h3>
                            <p class="text-gray-600 text-sm mb-4 line-clamp-3">A decentralized supply chain system using blockchain technology for data transparency and security.</p>
                            <span class="text-blue-600 font-semibold text-sm">Learn More →</span>
                        </div>
                    </div>
                </div>
            </div>
        <?php endif; ?>
    </div>
</section>


<?php include '../includes/footer.php'; ?>


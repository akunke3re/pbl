<!-- Contact Section -->
<?php
// Load dynamic contact settings from DB. Use relative path: this file lives in "includes/".
require_once __DIR__ . '/../config/database.php';
$db = new Database();
$settings = [];
$res = $db->query("SELECT * FROM get_site_settings()");
if ($res) {
    $settings = $db->fetch($res) ?: [];
}
$alamat = $settings['alamat'] ?? 'Jl. Contoh Alamat No.123, Kota, Negara';
$phone = $settings['no_hp'] ?? '+62 123 456 789';
$email = $settings['contact_email'] ?? $settings['email'] ?? 'info@lab.ac.id';
?>
<section id="contact" class="py-16 bg-gradient-to-br from-gray-900 to-gray-800 text-white">
    <div class="container mx-auto px-4 max-w-6xl">
        <!-- Header -->
        <div class="text-center mb-12" data-aos="fade-up">
            <h2 class="text-3xl md:text-4xl font-bold mb-3">Contact Us</h2>
            <div class="w-20 h-1 bg-blue-500 mx-auto mb-3"></div>
            <p class="text-gray-300 max-w-2xl mx-auto">Interested in collaborating? Contact us for more information.</p>
        </div>
        
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <!-- Contact Info -->
            <div class="space-y-6" data-aos="fade-right">
                <div class="bg-gray-800 bg-opacity-50 rounded-lg p-6 hover:bg-opacity-70 transition">
                    <div class="flex items-start space-x-4">
                        <div class="w-12 h-12 bg-blue-600 rounded-lg flex items-center justify-center flex-shrink-0">
                            <i class="fas fa-map-marker-alt text-xl text-white"></i>
                        </div>
                        <div>
                            <h3 class="font-bold text-lg mb-1 text-blue-200">Address</h3>
                            <p class="text-gray-300"><?php echo($alamat); ?></p>
                        </div>
                    </div>
                </div>

                <div class="bg-gray-800 bg-opacity-50 rounded-lg p-6 hover:bg-opacity-70 transition">
                    <div class="flex items-start space-x-4">
                        <div class="w-12 h-12 bg-blue-600 rounded-lg flex items-center justify-center flex-shrink-0">
                            <i class="fas fa-phone text-xl text-white"></i>
                        </div>
                        <div>
                            <h3 class="font-bold text-lg mb-1 text-blue-200">Phone number</h3>
                            <p class="text-gray-300"><?php echo htmlspecialchars($phone); ?></p>
                        </div>
                    </div>
                </div>

                <div class="bg-gray-800 bg-opacity-50 rounded-lg p-6 hover:bg-opacity-70 transition">
                    <div class="flex items-start space-x-4">
                        <div class="w-12 h-12 bg-blue-600 rounded-lg flex items-center justify-center flex-shrink-0">
                            <i class="fas fa-envelope text-xl text-white"></i>
                        </div>
                        <div>
                            <h3 class="font-bold text-lg mb-1 text-blue-200">Email</h3>
                            <p class="text-gray-300"><?php echo htmlspecialchars($email); ?></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contact Form -->
            <div class="bg-blue-600 rounded-xl shadow-lg p-8" data-aos="fade-left">
                <h3 class="text-white font-bold text-2xl mb-6 flex items-center">
                    <i class="fas fa-paper-plane mr-3"></i>
                    Send Message
                </h3>
                <form method="POST" action="<?php echo isset($pageInPages) ? '../' : ''; ?>kirim_pesan.php" class="space-y-4">
                    <div>
                        <label for="nama" class="block text-sm mb-2 text-white font-medium">Name</label>
                        <input type="text" name="nama" id="nama" required 
                               class="w-full rounded-lg px-4 py-3 bg-white text-gray-900 focus:ring-2 focus:ring-blue-300 transition" 
                               placeholder="Your Name">
                    </div>
                    <div>
                        <label for="email" class="block text-sm mb-2 text-white font-medium">Email</label>
                        <input type="email" name="email" id="email" required 
                               class="w-full rounded-lg px-4 py-3 bg-white text-gray-900 focus:ring-2 focus:ring-blue-300 transition" 
                               placeholder="Your Email">
                    </div>
                    <div>
                        <label for="pesan" class="block text-sm mb-2 text-white font-medium">Message</label>
                        <textarea name="pesan" id="pesan" required rows="4" 
                                  class="w-full rounded-lg px-4 py-3 bg-white text-gray-900 focus:ring-2 focus:ring-blue-300 transition resize-none" 
                                  placeholder="Write your message here..."></textarea>
                    </div>
                    <button type="submit" class="w-full bg-white hover:bg-blue-50 transition text-blue-600 font-bold py-3 rounded-lg shadow-md">
                        <i class="fas fa-paper-plane mr-2"></i>Send Message
                    </button>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-gray-900 text-white pt-12 pb-6">
    <div class="container mx-auto px-4 max-w-6xl">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-8">
            <!-- About -->
            <div>
                <div class="flex items-center space-x-3 mb-4">
                    <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg flex items-center justify-center overflow-hidden p-2">
                        <img src="<?php echo isset($pageInPages) ? '../' : ''; ?>img/polinema.png" alt="Logo" class="w-full h-full object-contain" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                        <i class="fas fa-flask text-white hidden"></i>
                    </div>
                    <h3 class="text-xl font-bold">Campus Lab</h3>
                </div>
                <p class="text-gray-400 text-sm leading-relaxed">
                    Laboratory that produces high-quality research and innovation.
                </p>
            </div>
            
            <!-- Quick Links -->
            <div>
                <h4 class="text-lg font-semibold mb-4 text-white">Quick Links</h4>
                <ul class="space-y-2 text-sm">
                    <li>
                        <a href="<?php echo isset($pageInPages) ? '../' : ''; ?>index.php" class="text-gray-400 hover:text-blue-400 transition flex items-center group">
                            <i class="fas fa-chevron-right text-xs mr-2 group-hover:mr-3 transition-all"></i>Home Page
                        </a>
                    </li>
                    <li>
                        <a href="<?php echo isset($pageInPages) ? '' : 'pages/'; ?>visi-misi.php" class="text-gray-400 hover:text-blue-400 transition flex items-center group">
                            <i class="fas fa-chevron-right text-xs mr-2 group-hover:mr-3 transition-all"></i>Vision & Mission
                        </a>
                    </li>
                    <li>
                        <a href="<?php echo isset($pageInPages) ? '' : 'pages/'; ?>sejarah.php" class="text-gray-400 hover:text-blue-400 transition flex items-center group">
                            <i class="fas fa-chevron-right text-xs mr-2 group-hover:mr-3 transition-all"></i>History
                        </a>
                    </li>
                    <li>
                        <a href="<?php echo isset($pageInPages) ? '' : 'pages/'; ?>gallery.php" class="text-gray-400 hover:text-blue-400 transition flex items-center group">
                            <i class="fas fa-chevron-right text-xs mr-2 group-hover:mr-3 transition-all"></i>Gallery
                        </a>
                    </li>
                    <li>
                        <a href="<?php echo isset($pageInPages) ? '' : 'pages/'; ?>struktur_organisasi.php" class="text-gray-400 hover:text-blue-400 transition flex items-center group">
                            <i class="fas fa-chevron-right text-xs mr-2 group-hover:mr-3 transition-all"></i>Organizational Structure
                        </a>
                    </li>
                    <li>
                        <a href="<?php echo isset($pageInPages) ? '' : 'pages/'; ?>produk.php" class="text-gray-400 hover:text-blue-400 transition flex items-center group">
                            <i class="fas fa-chevron-right text-xs mr-2 group-hover:mr-3 transition-all"></i>Products
                        </a>
                    </li>
                    <li>
                        <a href="<?php echo isset($pageInPages) ? '' : 'pages/'; ?>partner_sponsor.php" class="text-gray-400 hover:text-blue-400 transition flex items-center group">
                            <i class="fas fa-chevron-right text-xs mr-2 group-hover:mr-3 transition-all"></i>Partners & Sponsors
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Social Media -->
            <div>
                <h4 class="text-lg font-semibold mb-4 text-white">Follow Us</h4>
                <?php
                    // Prepare social links from settings; only render icons for non-empty links
                    $facebook_link = trim($settings['facebook'] ?? '');
                    $twitter_link = trim($settings['twitter'] ?? '');
                    $instagram_link = trim($settings['instagram'] ?? '');
                    $linkedin_link = trim($settings['linkedin'] ?? '');
                ?>
                <div class="flex space-x-3">
                    <?php if ($facebook_link): ?>
                    <a href="<?php echo htmlspecialchars($facebook_link); ?>" target="_blank" rel="noopener noreferrer" aria-label="Facebook" class="w-10 h-10 bg-gray-800 rounded-lg flex items-center justify-center hover:bg-blue-600 transition transform hover:scale-110">
                        <i class="fab fa-facebook-f text-gray-300"></i>
                    </a>
                    <?php endif; ?>

                    <?php if ($twitter_link): ?>
                    <a href="<?php echo htmlspecialchars($twitter_link); ?>" target="_blank" rel="noopener noreferrer" aria-label="Twitter" class="w-10 h-10 bg-gray-800 rounded-lg flex items-center justify-center hover:bg-blue-400 transition transform hover:scale-110">
                        <i class="fab fa-twitter text-gray-300"></i>
                    </a>
                    <?php endif; ?>

                    <?php if ($instagram_link): ?>
                    <a href="<?php echo htmlspecialchars($instagram_link); ?>" target="_blank" rel="noopener noreferrer" aria-label="Instagram" class="w-10 h-10 bg-gray-800 rounded-lg flex items-center justify-center hover:bg-pink-600 transition transform hover:scale-110">
                        <i class="fab fa-instagram text-gray-300"></i>
                    </a>
                    <?php endif; ?>

                    <?php if ($linkedin_link): ?>
                    <a href="<?php echo htmlspecialchars($linkedin_link); ?>" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn" class="w-10 h-10 bg-gray-800 rounded-lg flex items-center justify-center hover:bg-blue-700 transition transform hover:scale-110">
                        <i class="fab fa-linkedin-in text-gray-300"></i>
                    </a>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        
        <div class="border-t border-gray-800 pt-6 text-center text-sm text-gray-400">
            <p>&copy; <?php echo date('Y'); ?> Campus Laboratory. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- AOS Animation Script -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({
        duration: 1000,
        once: true,
        offset: 100
    });

    const scrollBtn = document.getElementById("scrollTopBtn");

    window.addEventListener("scroll", () => {
        if (window.scrollY > 200) {
            scrollBtn.style.display = "flex";
        } else {
            scrollBtn.style.display = "none";
        }
    });

    scrollBtn.addEventListener("click", () => {
        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    });
</script>

</body>
</html>

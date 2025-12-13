<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo isset($pageTitle) ? $pageTitle . ' - ' : ''; ?>Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
        * {
            font-family: 'Poppins', sans-serif;
        }
        .gradient-bg {
            background: blue;
        }
        .sidebar-active {
            background: blue;
            color: white;
        }
        /* Mobile Menu Animation */
        .mobile-menu {
            transform: translateX(-100%);
            transition: transform 0.3s ease-in-out;
        }
        .mobile-menu.active {
            transform: translateX(0);
        }
        /* Backdrop */
        .backdrop {
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s ease-in-out;
        }
        .backdrop.active {
            opacity: 1;
            pointer-events: all;
        }

        .dropdown-icon-list {
            max-height: 200px;
            overflow-y: auto;
        }
        .dropdown-icon-list::-webkit-scrollbar {
            width: 6px;
        }
        .dropdown-icon-list::-webkit-scrollbar-thumb {
            background: #bbb;
            border-radius: 10px;
        }
    </style>
</head> 
<body class="bg-gray-100">
    <!-- Mobile Menu Backdrop -->
    <div id="backdrop" class="backdrop fixed inset-0 bg-black bg-opacity-50 z-40 md:hidden"></div>
    
    <div class="flex h-screen overflow-hidden">
        <!-- Desktop Sidebar -->
        <aside class="w-64 bg-white shadow-lg hidden md:flex md:flex-col flex-shrink-0">
            <div class="gradient-bg p-6 text-white flex-shrink-0">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 bg-white/20 rounded-lg flex items-center justify-center">
                        <i class="fas fa-flask text-xl"></i>
                    </div>
                    <div>
                        <h1 class="text-xl font-bold">Campus Lab</h1>
                        <p class="text-xs text-gray-200">Admin Panel</p>
                    </div>
                </div>
            </div>
            
            <nav class="p-4 overflow-y-auto flex-1">
                <a href="index.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'index.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-home w-6"></i>
                    <span>Dashboard</span>
                </a>
                <!-- Dropdown: Informasi (Desktop) -->
                <div class="mb-2">
                    <button id="infoDropdownBtnDesktop" class="flex items-center w-full px-4 py-3 rounded-lg hover:bg-purple-50 transition text-gray-700 <?php $pages = ['visi-misi.php', 'sejarah.php', 'mission.php', 'priority.php']; echo in_array(basename($_SERVER['PHP_SELF']), $pages) ? 'sidebar-active' : ''; ?>">
                        <i class="fas fa-info-circle w-6"></i>
                        <span>Information</span>
                        <i class="fas fa-chevron-down ml-auto text-xs transition-transform" id="infoDropdownIconDesktop"></i>
                    </button>
                    <div id="infoDropdownDesktop" class="hidden bg-gray-50 rounded-lg ml-2 mt-1 overflow-hidden">
                        <a href="visi-misi.php" class="flex items-center px-4 py-3 text-sm text-gray-700 hover:bg-purple-100 transition border-l-4 border-transparent hover:border-blue-600 <?php echo basename($_SERVER['PHP_SELF']) == 'visi-misi.php' ? 'bg-purple-100 border-blue-600' : ''; ?>">
                            <i class="fas fa-eye w-5 mr-2"></i>
                            <span>Vision & Mision</span>
                        </a>
                        <a href="sejarah.php" class="flex items-center px-4 py-3 text-sm text-gray-700 hover:bg-purple-100 transition border-l-4 border-transparent hover:border-blue-600 <?php echo basename($_SERVER['PHP_SELF']) == 'sejarah.php' ? 'bg-purple-100 border-blue-600' : ''; ?>">
                            <i class="fas fa-book w-5 mr-2"></i>
                            <span>History</span>
                        </a>
                        <a href="mission.php" class="flex items-center px-4 py-3 text-sm text-gray-700 hover:bg-purple-100 transition border-l-4 border-transparent hover:border-blue-600 <?php echo basename($_SERVER['PHP_SELF']) == 'mission.php' ? 'bg-purple-100 border-blue-600' : ''; ?>">
                            <i class="fas fa-bullseye w-5 mr-2"></i>
                            <span>Our Mission</span>
                        </a>
                        <a href="priority.php" class="flex items-center px-4 py-3 text-sm text-gray-700 hover:bg-purple-100 transition border-l-4 border-transparent hover:border-blue-600 <?php echo basename($_SERVER['PHP_SELF']) == 'priority.php' ? 'bg-purple-100 border-blue-600' : ''; ?>">
                            <i class="fas fa-star w-5 mr-2"></i>
                            <span>Priority Topics</span>
                        </a>
                    </div>
                </div>
                <a href="struktur.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'struktur.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-sitemap w-6"></i>
                    <span>Organizational Structure</span>
                </a>
                <a href="scope.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'scope.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-magnifying-glass w-6"></i>
                    <span>Scope</span>
                </a>
                <a href="blueprint.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'blueprint.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-book w-6"></i>
                    <span>Blueprint</span>
                </a>
                <a href="berita.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'berita.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-newspaper w-6"></i>
                    <span>News</span>
                </a>
                <a href="produk.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'produk.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-basket-shopping w-6"></i>
                    <span>Products</span>
                </a>
                <a href="gallery.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'gallery.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-images w-6"></i>
                    <span>Gallery</span>
                </a>
                <a href="sponsor.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'sponsor.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-handshake w-6"></i>
                    <span>Partners</span>
                </a>
                <a href="messages.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'messages.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-envelope w-6"></i>
                    <span>Messages</span>
                </a>
                <a href="settings.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'settings.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-gear w-6"></i>
                    <span>Settings</span>
                </a>
                <div class="border-t border-gray-200 my-4"></div>
                
                <a href="logout.php" class="flex items-center px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 transition">
                    <i class="fas fa-sign-out-alt w-6"></i>
                    <span>Logout</span>
                </a>
            </nav>
        </aside>
        
        <!-- Mobile Sidebar -->
        <aside id="mobileSidebar" class="mobile-menu fixed inset-y-0 left-0 w-64 bg-white shadow-2xl z-50 md:hidden">
            <div class="gradient-bg p-6 text-white">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 bg-white/20 rounded-lg flex items-center justify-center">
                            <i class="fas fa-flask text-xl"></i>
                        </div>
                        <div>
                            <h1 class="text-xl font-bold">Campus Lab</h1>
                            <p class="text-xs text-purple-200">Admin Panel</p>
                        </div>
                    </div>
                    <button id="closeMobileMenu" class="text-white hover:bg-white/20 p-2 rounded-lg transition">
                        <i class="fas fa-times text-xl"></i>
                    </button>
                </div>
            </div>
            
            <nav class="p-4 overflow-y-auto" style="max-height: calc(100vh - 120px);">
                <a href="index.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'index.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-home w-6"></i>
                    <span>Dashboard</span>
                </a>
                <!-- Dropdown: Informasi (Mobile) -->
                <div class="mb-2">
                    <button id="infoDropdownBtnMobile" class="flex items-center w-full px-4 py-3 rounded-lg hover:bg-purple-50 transition text-gray-700 <?php $pages = ['visi-misi.php', 'sejarah.php', 'mission.php', 'priority.php']; echo in_array(basename($_SERVER['PHP_SELF']), $pages) ? 'sidebar-active' : ''; ?>">
                        <i class="fas fa-info-circle w-6"></i>
                        <span>Information</span>
                        <i class="fas fa-chevron-down ml-auto text-xs transition-transform" id="infoDropdownIconMobile"></i>
                    </button>
                    <div id="infoDropdownMobile" class="hidden bg-gray-50 rounded-lg ml-2 mt-1 overflow-hidden">
                        <a href="visi-misi.php" class="flex items-center px-4 py-3 text-sm text-gray-700 hover:bg-purple-100 transition border-l-4 border-transparent hover:border-blue-600 <?php echo basename($_SERVER['PHP_SELF']) == 'visi-misi.php' ? 'bg-purple-100 border-blue-600' : ''; ?>">
                            <i class="fas fa-eye w-5 mr-2"></i>
                            <span>Vision & Mision</span>
                        </a>
                        <a href="sejarah.php" class="flex items-center px-4 py-3 text-sm text-gray-700 hover:bg-purple-100 transition border-l-4 border-transparent hover:border-blue-600 <?php echo basename($_SERVER['PHP_SELF']) == 'sejarah.php' ? 'bg-purple-100 border-blue-600' : ''; ?>">
                            <i class="fas fa-book w-5 mr-2"></i>
                            <span>History</span>
                        </a>
                        <a href="mission.php" class="flex items-center px-4 py-3 text-sm text-gray-700 hover:bg-purple-100 transition border-l-4 border-transparent hover:border-blue-600 <?php echo basename($_SERVER['PHP_SELF']) == 'mission.php' ? 'bg-purple-100 border-blue-600' : ''; ?>">
                            <i class="fas fa-bullseye w-5 mr-2"></i>
                            <span>Our Mission</span>
                        </a>
                        <a href="priority.php" class="flex items-center px-4 py-3 text-sm text-gray-700 hover:bg-purple-100 transition border-l-4 border-transparent hover:border-blue-600 <?php echo basename($_SERVER['PHP_SELF']) == 'priority.php' ? 'bg-purple-100 border-blue-600' : ''; ?>">
                            <i class="fas fa-star w-5 mr-2"></i>
                            <span>Priority Topics</span>
                        </a>
                    </div>
                </div>
                <a href="struktur.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'struktur.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-sitemap w-6"></i>
                    <span>Organizational Structure</span>
                </a>
                <a href="berita.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'berita.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-newspaper w-6"></i>
                    <span>News</span>
                </a>
                <a href="produk.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'berita.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-basket-shopping w-6"></i>
                    <span>Products</span>
                </a>
                <a href="gallery.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'gallery.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-images w-6"></i>
                    <span>Gallery</span>
                </a>
                <a href="sponsor.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'gallery.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-handshake w-6"></i>
                    <span>Partners & Sponsors</span>
                </a>
                <a href="messages.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'messages.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-envelope w-6"></i>
                    <span>Messages</span>
                </a>
                <a href="settings.php" class="flex items-center px-4 py-3 mb-2 rounded-lg hover:bg-purple-50 transition <?php echo basename($_SERVER['PHP_SELF']) == 'messages.php' ? 'sidebar-active' : 'text-gray-700'; ?>">
                    <i class="fas fa-gear w-6"></i>
                    <span>Settings</span>
                </a>
                
                <div class="border-t border-gray-200 my-4"></div>
                
                <a href="logout.php" class="flex items-center px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 transition">
                    <i class="fas fa-sign-out-alt w-6"></i>
                    <span>Logout</span>
                </a>
            </nav>
        </aside>
        
        <!-- Main Content -->
        <div class="flex-1 overflow-y-auto">
            <!-- Top Bar -->
            <header class="bg-white shadow-sm sticky top-0 z-30">
                <div class="flex items-center justify-between px-4 md:px-6 py-4">
                    <!-- Left: Hamburger + Title -->
                    <div class="flex items-center space-x-4">
                        <!-- Hamburger Menu Button (Mobile Only) -->
                        <button id="hamburgerBtn" class="md:hidden text-gray-700 hover:text-purple-600 p-2 rounded-lg hover:bg-gray-100 transition">
                            <i class="fas fa-bars text-xl"></i>
                        </button>
                        <div>
                            <h2 class="text-xl md:text-2xl font-bold text-gray-800"><?php echo $pageTitle ?? 'Dashboard'; ?></h2>
                        </div>
                    </div>
                    
                    <!-- Right: View Site + Profile + Logout -->
                    <div class="flex items-center space-x-2 md:space-x-4">
                        <!-- View Site Link -->
                        <a href="../index.php" target="_blank" class="hidden sm:flex items-center text-gray-600 hover:text-purple-600 transition text-sm">
                            <i class="fas fa-external-link-alt mr-2"></i>
                            <span class="hidden md:inline">View Site</span>
                        </a>
                        
                        <!-- Profile Info (Hidden on small mobile) -->
                        <div class="hidden sm:flex items-center space-x-3">
                            <div class="w-8 h-8 md:w-10 md:h-10 gradient-bg rounded-full flex items-center justify-center text-white">
                                <i class="fas fa-user text-sm md:text-base"></i>
                            </div>
                            <div class="hidden lg:block">
                                <p class="font-semibold text-gray-800 text-sm"><?php echo htmlspecialchars($_SESSION['admin_name']); ?></p>
                                <p class="text-xs text-gray-600">Administrator</p>
                            </div>
                        </div>
                        
                        <!-- Logout Button (Desktop) -->
                        <a href="logout.php" class="hidden md:flex items-center px-4 py-2 text-red-600 hover:bg-red-50 rounded-lg transition">
                            <i class="fas fa-sign-out-alt mr-2"></i>
                            <span>Logout</span>
                        </a>
                        
                        <!-- Logout Icon (Mobile) -->
                        <a href="logout.php" class="md:hidden text-red-600 hover:bg-red-50 p-2 rounded-lg transition">
                            <i class="fas fa-sign-out-alt text-xl"></i>
                        </a>
                    </div>
                </div>
            </header>
            
            <!-- Content -->
            <main class="p-6">

<script>
    // Desktop Dropdown
    const infoDropdownBtnDesktop = document.getElementById('infoDropdownBtnDesktop');
    const infoDropdownDesktop = document.getElementById('infoDropdownDesktop');
    const infoDropdownIconDesktop = document.getElementById('infoDropdownIconDesktop');

    infoDropdownBtnDesktop.addEventListener('click', function(e) {
        e.preventDefault();
        infoDropdownDesktop.classList.toggle('hidden');
        infoDropdownIconDesktop.classList.toggle('rotate-180');
    });

    // Mobile Dropdown
    const infoDropdownBtnMobile = document.getElementById('infoDropdownBtnMobile');
    const infoDropdownMobile = document.getElementById('infoDropdownMobile');
    const infoDropdownIconMobile = document.getElementById('infoDropdownIconMobile');

    infoDropdownBtnMobile.addEventListener('click', function(e) {
        e.preventDefault();
        infoDropdownMobile.classList.toggle('hidden');
        infoDropdownIconMobile.classList.toggle('rotate-180');
    });

    // Close dropdown when a link is clicked
    document.querySelectorAll('#infoDropdownDesktop a, #infoDropdownMobile a').forEach(link => {
        link.addEventListener('click', function() {
            infoDropdownDesktop.classList.add('hidden');
            infoDropdownMobile.classList.add('hidden');
            infoDropdownIconDesktop.classList.remove('rotate-180');
            infoDropdownIconMobile.classList.remove('rotate-180');
        });
    });
</script>

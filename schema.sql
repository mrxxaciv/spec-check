-- ============================================================
--  PC SPECS CHECKER  –  Database Schema + Seed Data
-- ============================================================

CREATE DATABASE IF NOT EXISTS pcspecs;
USE pcspecs;

-- ------------------------------------------------------------
-- Hardware tier lookup tables
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS gpu_tiers (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    gpu_name   VARCHAR(100) NOT NULL UNIQUE,
    tier       INT NOT NULL   -- 1 (weakest) … 10 (strongest)
);

CREATE TABLE IF NOT EXISTS cpu_tiers (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    cpu_name   VARCHAR(100) NOT NULL UNIQUE,
    tier       INT NOT NULL
);

-- ------------------------------------------------------------
-- Games table
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS games (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    title               VARCHAR(150) NOT NULL,
    genre               VARCHAR(60),
    min_gpu_tier        INT NOT NULL,
    rec_gpu_tier        INT NOT NULL,
    min_cpu_tier        INT NOT NULL,
    rec_cpu_tier        INT NOT NULL,
    min_ram_gb          INT NOT NULL,
    rec_ram_gb          INT NOT NULL,
    min_storage_gb      INT NOT NULL,
    rec_storage_gb      INT NOT NULL
);

-- ============================================================
--  GPU TIERS  (1 = entry-level  …  10 = flagship)
-- ============================================================

INSERT INTO gpu_tiers (gpu_name, tier) VALUES
-- NVIDIA – Kepler / Maxwell (very old)
('GT 730',         1),
('GTX 750',        2),
('GTX 750 Ti',     2),
-- NVIDIA – Pascal
('GTX 1050',       3),
('GTX 1050 Ti',    3),
('GTX 1060 3GB',   4),
('GTX 1060 6GB',   4),
('GTX 1070',       5),
('GTX 1070 Ti',    5),
('GTX 1080',       6),
('GTX 1080 Ti',    6),
-- NVIDIA – Turing
('RTX 2060',       6),
('RTX 2060 Super', 6),
('RTX 2070',       7),
('RTX 2070 Super', 7),
('RTX 2080',       7),
('RTX 2080 Super', 8),
('RTX 2080 Ti',    8),
-- NVIDIA – Ampere
('RTX 3050',       5),
('RTX 3060',       7),
('RTX 3060 Ti',    7),
('RTX 3070',       8),
('RTX 3070 Ti',    8),
('RTX 3080',       9),
('RTX 3080 Ti',    9),
('RTX 3090',       9),
('RTX 3090 Ti',   10),
-- NVIDIA – Ada Lovelace
('RTX 4050',       6),
('RTX 4060',       7),
('RTX 4060 Ti',    8),
('RTX 4070',       9),
('RTX 4070 Super', 9),
('RTX 4070 Ti',    9),
('RTX 4080',      10),
('RTX 4090',      10),
-- AMD – Polaris
('RX 470',         3),
('RX 480',         4),
('RX 570',         3),
('RX 580',         4),
-- AMD – Vega / Navi
('RX Vega 56',     5),
('RX Vega 64',     6),
('RX 5500 XT',     4),
('RX 5600 XT',     5),
('RX 5700',        6),
('RX 5700 XT',     6),
-- AMD – RDNA 2
('RX 6600',        6),
('RX 6600 XT',     7),
('RX 6700 XT',     7),
('RX 6800',        8),
('RX 6800 XT',     9),
('RX 6900 XT',     9),
-- AMD – RDNA 3
('RX 7600',        7),
('RX 7700 XT',     8),
('RX 7800 XT',     8),
('RX 7900 GRE',    9),
('RX 7900 XT',     9),
('RX 7900 XTX',   10),
-- Intel Arc
('Arc A380',       3),
('Arc A580',       5),
('Arc A750',       6),
('Arc A770',       7);

-- ============================================================
--  CPU TIERS
-- ============================================================

INSERT INTO cpu_tiers (cpu_name, tier) VALUES
-- Intel – older
('Core i3-6100',   2),
('Core i5-6600K',  3),
('Core i7-6700K',  4),
('Core i3-8100',   3),
('Core i5-8400',   4),
('Core i5-8600K',  5),
('Core i7-8700K',  6),
-- Intel – 9th / 10th gen
('Core i5-9600K',  5),
('Core i7-9700K',  6),
('Core i9-9900K',  7),
('Core i5-10400F', 5),
('Core i7-10700K', 7),
('Core i9-10900K', 8),
-- Intel – 11th / 12th gen
('Core i5-11600K', 6),
('Core i7-11700K', 7),
('Core i5-12400F', 6),
('Core i5-12600K', 7),
('Core i7-12700K', 8),
('Core i9-12900K', 9),
-- Intel – 13th / 14th gen
('Core i5-13600K', 8),
('Core i7-13700K', 9),
('Core i9-13900K',10),
('Core i5-14600K', 8),
('Core i7-14700K', 9),
('Core i9-14900K',10),
-- AMD – Ryzen 1000 / 2000
('Ryzen 5 1600',   3),
('Ryzen 7 1700',   4),
('Ryzen 5 2600',   4),
('Ryzen 7 2700X',  5),
-- AMD – Ryzen 3000
('Ryzen 5 3600',   6),
('Ryzen 7 3700X',  7),
('Ryzen 9 3900X',  8),
-- AMD – Ryzen 5000
('Ryzen 5 5600X',  7),
('Ryzen 7 5800X',  8),
('Ryzen 9 5900X',  9),
('Ryzen 9 5950X', 10),
-- AMD – Ryzen 7000
('Ryzen 5 7600X',  8),
('Ryzen 7 7700X',  9),
('Ryzen 9 7900X',  9),
('Ryzen 9 7950X', 10);

-- ============================================================
--  GAMES  (~100 titles with realistic requirements)
-- ============================================================

INSERT INTO games
  (title, genre, min_gpu_tier, rec_gpu_tier, min_cpu_tier, rec_cpu_tier, min_ram_gb, rec_ram_gb, min_storage_gb, rec_storage_gb)
VALUES
('Minecraft',                    'Sandbox',         2, 4,  2, 4,   8, 16,  10,  30),
('Terraria',                     'Sandbox',         1, 2,  1, 2,   4,  8,   1,   2),
('Stardew Valley',               'Simulation',      1, 2,  1, 2,   4,  8,   2,   4),
('Among Us',                     'Social',          1, 2,  1, 2,   4,  8,   1,   2),
('Valheim',                      'Survival',        4, 6,  4, 6,   8, 16,   4,   8),
('CS2',                          'FPS',             4, 7,  4, 7,   8, 16,  35,  60),
('Dota 2',                       'MOBA',            3, 5,  3, 5,   8, 16,  15,  25),
('League of Legends',            'MOBA',            2, 4,  2, 4,   8, 16,  16,  30),
('Fortnite',                     'Battle Royale',   4, 7,  4, 7,  16, 16,  35,  70),
('Apex Legends',                 'Battle Royale',   4, 7,  4, 7,   8, 16,  75, 100),
('Warzone',                      'Battle Royale',   5, 8,  5, 8,  16, 16, 100, 125),
('PUBG',                         'Battle Royale',   4, 7,  4, 7,   8, 16,  50,  70),
('Rocket League',                'Sports',          3, 5,  3, 5,   8, 16,  20,  25),
('FIFA 24',                      'Sports',          5, 7,  5, 7,  12, 16,  50,  50),
('NBA 2K24',                     'Sports',          5, 7,  5, 7,  16, 16,  150,150),
('GTA V',                        'Open World',      4, 7,  4, 7,   8, 16,  72,  90),
('GTA VI',                       'Open World',      8,10,  8,10,  16, 32, 150, 150),
('Red Dead Redemption 2',        'Open World',      6, 9,  6, 9,  12, 16, 150, 150),
('Cyberpunk 2077',               'RPG',             6, 9,  7,10,  12, 16,  70,  70),
('The Witcher 3',                'RPG',             4, 7,  4, 7,   8, 16,  50,  50),
('Elden Ring',                   'RPG',             5, 8,  5, 8,  12, 16,  60,  60),
('Dark Souls III',               'RPG',             4, 7,  4, 7,   8,  8,  25,  25),
('Baldurs Gate 3',               'RPG',             5, 8,  6, 9,  16, 16, 150, 150),
('Hogwarts Legacy',              'RPG',             6, 9,  7,10,  16, 16,  85,  85),
('Starfield',                    'RPG',             6, 9,  6, 9,  16, 32, 125, 125),
('Assassins Creed Mirage',       'Action',          5, 7,  5, 8,   8, 16,  40,  40),
('Assassins Creed Valhalla',     'Action',          5, 8,  6, 9,   8, 16,  50,  50),
('God of War',                   'Action',          5, 8,  5, 8,   8, 16,  45,  45),
('Spider-Man Remastered',        'Action',          6, 9,  7,10,  16, 16,  75,  75),
('Spider-Man Miles Morales',     'Action',          6, 9,  7,10,  16, 16,  75,  75),
('Batman Arkham Knight',         'Action',          4, 7,  4, 7,  12, 16,  45,  45),
('Devil May Cry 5',              'Action',          4, 7,  4, 7,   8,  8,  35,  35),
('Sekiro',                       'Action',          4, 7,  4, 7,   8,  8,  25,  25),
('Ghost of Tsushima',            'Action',          6, 9,  7,10,  16, 16,  75,  75),
('Horizon Zero Dawn',            'Action',          5, 8,  5, 8,   8, 16,  50,  50),
('Horizon Forbidden West',       'Action',          6, 9,  7,10,  16, 16,  150,150),
('The Last of Us Part I',        'Action',          6, 9,  7,10,  16, 16,  72,  72),
('Alan Wake 2',                  'Horror',          7, 9,  8,10,  16, 16,  90,  90),
('Resident Evil 4 Remake',       'Horror',          5, 8,  6, 9,   8, 16,  67,  67),
('Resident Evil Village',        'Horror',          5, 7,  6, 9,   8, 16,  45,  45),
('Dead Space Remake',            'Horror',          5, 8,  6, 9,  16, 16,  50,  50),
('Alien Isolation',              'Horror',          3, 5,  3, 5,   8,  8,  30,  30),
('Doom Eternal',                 'FPS',             4, 7,  4, 7,   8, 16,  50,  50),
('Doom 2016',                    'FPS',             4, 6,  4, 6,   8,  8,  55,  55),
('Halo Infinite',                'FPS',             4, 7,  5, 8,   8, 16,  50,  50),
('Titanfall 2',                  'FPS',             3, 5,  3, 5,   8,  8,  48,  48),
('Battlefield 2042',             'FPS',             5, 8,  6, 9,  16, 16, 100, 100),
('Escape from Tarkov',           'FPS',             5, 8,  6, 9,  12, 16,  40,  40),
('Rainbow Six Siege',            'FPS',             3, 6,  4, 7,   6, 16,  85,  85),
('Overwatch 2',                  'FPS',             3, 6,  4, 7,   8, 16,  50,  50),
('Valorant',                     'FPS',             2, 4,  3, 5,   8, 16,  35,  35),
('Team Fortress 2',              'FPS',             2, 3,  2, 3,   4,  8,  15,  15),
('Left 4 Dead 2',                'FPS',             2, 3,  2, 3,   4,  8,  13,  13),
('Portal 2',                     'Puzzle',          2, 3,  2, 3,   4,  8,   8,   8),
('Half-Life Alyx',               'VR',              5, 7,  5, 7,  16, 16,  68,  68),
('No Mans Sky',                  'Exploration',     4, 7,  4, 7,  12, 16,  15,  15),
('Subnautica',                   'Survival',        4, 6,  4, 6,   8, 16,  20,  20),
('The Forest',                   'Survival',        3, 5,  3, 5,   8,  8,   5,   5),
('Green Hell',                   'Survival',        4, 6,  4, 6,   8, 16,  10,  10),
('Rust',                         'Survival',        4, 7,  5, 7,  16, 16,  25,  25),
('ARK: Survival Evolved',        'Survival',        4, 7,  5, 8,  16, 16,  60, 100),
('7 Days to Die',                'Survival',        3, 5,  3, 5,   8, 16,  15,  15),
('DayZ',                         'Survival',        4, 7,  5, 7,   8, 16,  16,  16),
('Monster Hunter World',         'RPG',             4, 7,  5, 8,   8, 16,  48,  48),
('Monster Hunter Rise',          'RPG',             3, 6,  4, 7,   8, 16,  23,  23),
('Diablo IV',                    'RPG',             4, 7,  5, 8,  16, 16,  90,  90),
('Path of Exile',                'RPG',             3, 6,  4, 7,  16, 16,  40,  40),
('Final Fantasy XIV',            'MMO',             3, 6,  4, 7,   8, 16,  80,  80),
('World of Warcraft',            'MMO',             3, 6,  4, 7,   8, 16, 100, 100),
('New World',                    'MMO',             5, 8,  6, 9,  16, 16,  50,  50),
('Lost Ark',                     'MMO',             4, 7,  5, 7,  16, 16,  50,  50),
('Total War Warhammer III',      'Strategy',        5, 8,  6, 9,   8, 16,  120,120),
('Civilization VI',              'Strategy',        3, 5,  4, 6,   8, 16,  12,  12),
('Age of Empires IV',            'Strategy',        4, 6,  5, 7,   8, 16,  50,  50),
('StarCraft II',                 'Strategy',        2, 4,  3, 5,   8, 16,  30,  30),
('Humankind',                    'Strategy',        5, 7,  5, 7,  16, 16,  25,  25),
('Microsoft Flight Simulator',   'Simulation',      7, 9,  8,10,  16, 32, 150, 150),
('Euro Truck Simulator 2',       'Simulation',      2, 4,  3, 5,   8,  8,   4,   4),
('Cities Skylines',              'Simulation',      3, 5,  4, 6,   8, 16,   4,   4),
('Planet Coaster',               'Simulation',      4, 7,  5, 7,   8, 16,  16,  16),
('The Sims 4',                   'Simulation',      2, 4,  3, 5,  16, 16,  15,  50),
('It Takes Two',                 'Co-op',           4, 6,  4, 6,   8,  8,  50,  50),
('A Way Out',                    'Co-op',           4, 6,  4, 6,   8,  8,  25,  25),
('Deep Rock Galactic',           'Co-op',           4, 6,  4, 6,  16, 16,   3,   3),
('Phasmophobia',                 'Horror',          3, 5,  4, 6,   8,  8,  20,  20),
('Lethal Company',               'Horror',          3, 5,  3, 5,   8,  8,   1,   1),
('Palworld',                     'Survival',        5, 8,  6, 9,  16, 32,  40,  40),
('Helldivers 2',                 'Co-op',           5, 8,  6, 9,   8, 16, 100, 100),
('The Finals',                   'FPS',             5, 8,  6, 9,  16, 16,  60,  60),
('Forza Horizon 5',              'Racing',          5, 8,  6, 9,  16, 16,  110,110),
('Need for Speed Unbound',       'Racing',          5, 7,  6, 8,  16, 16,  50,  50),
('Sekiro Shadows Die Twice',     'Action',          4, 7,  5, 7,   8,  8,  25,  25),
('Lies of P',                    'Action',          5, 7,  6, 8,  12, 16,  30,  30),
('Wo Long Fallen Dynasty',       'Action',          4, 7,  5, 8,   8, 16,  60,  60),
('Atomic Heart',                 'FPS',             5, 8,  6, 9,  16, 16,  25,  25),
('Dead Island 2',                'Action',          5, 7,  6, 8,  16, 16,  35,  35),
('Saints Row 2022',              'Open World',      5, 7,  5, 7,  16, 16,  40,  40),
('Dying Light 2',                'Action',          5, 8,  6, 9,  16, 16,  60,  60),
('Back 4 Blood',                 'FPS',             4, 7,  5, 7,  12, 16,  35,  35);

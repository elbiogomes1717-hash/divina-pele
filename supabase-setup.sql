-- DIVINA PELE — Datenbankeinrichtung
-- Dieses SQL in Supabase > SQL Editor > New Query einfügen

-- 1. BEHANDLUNGEN
CREATE TABLE IF NOT EXISTS services (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'Allgemein',
  description TEXT,
  duration INTEGER NOT NULL, -- in Minuten
  price DECIMAL(10,2) NOT NULL,
  emoji TEXT DEFAULT '✨',
  active BOOLEAN DEFAULT TRUE,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TERMINE
CREATE TABLE IF NOT EXISTS bookings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  service_id UUID REFERENCES services(id) ON DELETE SET NULL,
  service_name TEXT NOT NULL,
  date DATE NOT NULL,
  time TIME NOT NULL,
  end_time TIME NOT NULL,
  client_name TEXT NOT NULL,
  client_email TEXT NOT NULL,
  client_phone TEXT,
  notes TEXT,
  status TEXT DEFAULT 'confirmed' CHECK (status IN ('confirmed', 'cancelled')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  -- KONFLIKTSCHUTZ: verhindert zwei Termine am selben Datum zur selben Uhrzeit
  CONSTRAINT unique_booking_slot UNIQUE (date, time)
);

-- 3. GESPERRTE ZEITEN (freie Tage, Feiertage usw.)
CREATE TABLE IF NOT EXISTS blocked_slots (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  date DATE NOT NULL,
  time TIME,
  reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- BERECHTIGUNGEN (Row Level Security)
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocked_slots ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Behandlungen für alle sichtbar" ON services FOR SELECT USING (active = TRUE);
CREATE POLICY "Termin erstellen" ON bookings FOR INSERT WITH CHECK (true);
CREATE POLICY "Verfügbarkeit anzeigen" ON bookings FOR SELECT USING (true);
CREATE POLICY "Sperrzeiten anzeigen" ON blocked_slots FOR SELECT USING (true);

-- ALLE BEHANDLUNGEN VON DIVINA PELE

-- ── MANIKÜRE UND PEDIKÜRE ──
INSERT INTO services (name, category, duration, price, emoji, sort_order) VALUES
  ('Maniküre mit Shellac',   'Maniküre & Pediküre', 60, 45.00, '💅', 101),
  ('Maniküre',               'Maniküre & Pediküre', 60, 31.00, '💅', 102),
  ('Pediküre',               'Maniküre & Pediküre', 60, 42.00, '🦶', 103),
  ('Pediküre mit Shellac',   'Maniküre & Pediküre', 60, 59.00, '🦶', 104),
  ('Fußpflege',              'Maniküre & Pediküre', 60, 47.00, '🦶', 105);

-- ── AUGENBRAUEN, WIMPERN UND GESICHT ──
INSERT INTO services (name, category, duration, price, emoji, sort_order) VALUES
  ('Augenbrauenlifting',                                                'Augenbrauen & Wimpern', 60, 65.00,  '👁️', 201),
  ('Wimpernlifting',                                              'Augenbrauen & Wimpern', 60, 65.00,  '👁️', 202),
  ('Gesichtsbehandlung – Mikrodermabrasion',                     'Augenbrauen & Wimpern', 60, 120.00, '✨', 203),
  ('Luxus-Gesichtsbehandlung (Mikrodermabrasion + Hautlicht)',   'Augenbrauen & Wimpern', 60, 135.00, '💎', 204),
  ('Klassische feuchtigkeitsspendende Gesichtsbehandlung',       'Augenbrauen & Wimpern', 50, 85.00,  '🌿', 205);

-- ── HAARENTFERNUNG FÜR HERREN ──
INSERT INTO services (name, category, duration, price, emoji, sort_order) VALUES
  ('Haarentfernung Herren – Nase',              'Haarentfernung für Herren', 15, 18.00, '🧔', 301),
  ('Haarentfernung Herren – Achseln',           'Haarentfernung für Herren', 20, 27.00, '🧔', 302),
  ('Haarentfernung Herren – Nacken',            'Haarentfernung für Herren', 10, 22.00, '🧔', 303),
  ('Haarentfernung Herren – Brust',             'Haarentfernung für Herren', 30, 35.00, '🧔', 304),
  ('Haarentfernung Herren – Bauch',             'Haarentfernung für Herren', 25, 35.00, '🧔', 305),
  ('Haarentfernung Herren – Rücken komplett',   'Haarentfernung für Herren', 40, 47.00, '🧔', 306),
  ('Haarentfernung Herren – Oberarme',          'Haarentfernung für Herren', 20, 37.00, '🧔', 307),
  ('Haarentfernung Herren – Unterarme',         'Haarentfernung für Herren', 20, 27.00, '🧔', 308),
  ('Haarentfernung Herren – Arme komplett',     'Haarentfernung für Herren', 40, 47.00, '🧔', 309),
  ('Haarentfernung Herren – Oberschenkel',      'Haarentfernung für Herren', 25, 37.00, '🧔', 310),
  ('Haarentfernung Herren – Unterschenkel',     'Haarentfernung für Herren', 25, 32.00, '🧔', 311),
  ('Haarentfernung Herren – Beine komplett',    'Haarentfernung für Herren', 50, 58.00, '🧔', 312),
  ('Haarentfernung Herren – Brust & Bauch',     'Haarentfernung für Herren', 20, 45.00, '🧔', 313);

-- ── HAARENTFERNUNG FÜR DAMEN ──
INSERT INTO services (name, category, duration, price, emoji, sort_order) VALUES
  ('Haarentfernung Damen – Achseln',                    'Haarentfernung für Damen', 15,  18.00,  '👩', 401),
  ('Haarentfernung Damen – Gesicht',                    'Haarentfernung für Damen', 25,  32.00,  '👩', 402),
  ('Haarentfernung Damen – Oberlippe',                  'Haarentfernung für Damen', 10,  12.00,  '👩', 403),
  ('Haarentfernung Damen – Kinn',                       'Haarentfernung für Damen', 10,  12.00,  '👩', 404),
  ('Haarentfernung Damen – Gesichtseiten',              'Haarentfernung für Damen', 15,  18.00,  '👩', 405),
  ('Haarentfernung Damen – Hals',                       'Haarentfernung für Damen', 10,  15.00,  '👩', 406),
  ('Haarentfernung Damen – Arme komplett',              'Haarentfernung für Damen', 35,  37.00,  '👩', 407),
  ('Haarentfernung Damen – Unterarme',                  'Haarentfernung für Damen', 20,  22.00,  '👩', 408),
  ('Haarentfernung Damen – Bauch',                      'Haarentfernung für Damen', 20,  18.00,  '👩', 410),
  ('Haarentfernung Damen – Gesäß',                      'Haarentfernung für Damen', 20,  25.00,  '👩', 411),
  ('Haarentfernung Damen – Bikinizone',                 'Haarentfernung für Damen', 25,  27.00,  '👩', 412),
  ('Haarentfernung Damen – Intimbereich komplett',                  'Haarentfernung für Damen', 30,  47.00,  '👩', 413),
  ('Haarentfernung Damen – Oberschenkel',               'Haarentfernung für Damen', 30,  35.00,  '👩', 414),
  ('Haarentfernung Damen – Unterschenkel',              'Haarentfernung für Damen', 30,  31.00,  '👩', 415),
  ('Haarentfernung Damen – Beine komplett',             'Haarentfernung für Damen', 45,  49.00,  '👩', 416),
  ('Haarentfernung Damen – Intimbereich komplett, Achseln & Beine', 'Haarentfernung für Damen', 90, 108.00,  '👩', 417);

-- PRÜFUNG
SELECT category, COUNT(*) AS total
FROM services
GROUP BY category
ORDER BY MIN(sort_order);

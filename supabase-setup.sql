-- ============================================
-- DIVINA PELE — Setup do Banco de Dados
-- Cole este SQL no Supabase > SQL Editor > New Query
-- ============================================

-- 1. SERVIÇOS
CREATE TABLE IF NOT EXISTS services (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'Geral',
  description TEXT,
  duration INTEGER NOT NULL, -- em minutos
  price DECIMAL(10,2) NOT NULL,
  emoji TEXT DEFAULT '✨',
  active BOOLEAN DEFAULT TRUE,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. AGENDAMENTOS
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
  -- PROTEÇÃO ANTI-CONFLITO: impede dois agendamentos na mesma data/hora
  CONSTRAINT unique_booking_slot UNIQUE (date, time)
);

-- 3. HORÁRIOS BLOQUEADOS (folgas, feriados, etc.)
CREATE TABLE IF NOT EXISTS blocked_slots (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  date DATE NOT NULL,
  time TIME,
  reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- PERMISSÕES (Row Level Security)
-- ============================================
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocked_slots ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Serviços visíveis para todos" ON services FOR SELECT USING (active = TRUE);
CREATE POLICY "Criar agendamento" ON bookings FOR INSERT WITH CHECK (true);
CREATE POLICY "Ver disponibilidade" ON bookings FOR SELECT USING (true);
CREATE POLICY "Ver bloqueios" ON blocked_slots FOR SELECT USING (true);

-- ============================================
-- TODOS OS SERVIÇOS DA DIVINA PELE
-- ============================================

-- ── MANICURE E PEDICURE ──
INSERT INTO services (name, category, duration, price, emoji, sort_order) VALUES
  ('Manicure com goma-laca',   'Manicure e Pedicure', 60, 45.00, '💅', 101),
  ('Manicure',                 'Manicure e Pedicure', 60, 31.00, '💅', 102),
  ('Pedicure',                 'Manicure e Pedicure', 60, 42.00, '🦶', 103),
  ('Pedicure com goma-laca',   'Manicure e Pedicure', 60, 59.00, '🦶', 104),
  ('Cuidados com os pés',      'Manicure e Pedicure', 60, 47.00, '🦶', 105);

-- ── SOBRANCELHAS, CÍLIOS E ROSTO ──
INSERT INTO services (name, category, duration, price, emoji, sort_order) VALUES
  ('Lifting de sobrancelhas',                           'Sobrancelhas e Cílios', 60, 65.00,  '👁️', 201),
  ('Lifting de cílios',                                 'Sobrancelhas e Cílios', 60, 65.00,  '👁️', 202),
  ('Tratamento Facial - Microdermoabrasão',             'Sobrancelhas e Cílios', 60, 120.00, '✨', 203),
  ('Tratamento Facial - Luxo (Microdermoabrasão + Luz da Pele)', 'Sobrancelhas e Cílios', 60, 135.00, '💎', 204),
  ('Facial Clássico - Hidratante',                      'Sobrancelhas e Cílios', 50, 85.00,  '🌿', 205);

-- ── DEPILAÇÃO MASCULINA ──
INSERT INTO services (name, category, duration, price, emoji, sort_order) VALUES
  ('Depilação Masculina - Nariz',              'Depilação Masculina', 15, 18.00, '🧔', 301),
  ('Depilação Masculina - Axilas',             'Depilação Masculina', 20, 27.00, '🧔', 302),
  ('Depilação Masculina - Pescoço',            'Depilação Masculina', 10, 22.00, '🧔', 303),
  ('Depilação Masculina - Peito',              'Depilação Masculina', 30, 35.00, '🧔', 304),
  ('Depilação Masculina - Abdômen',            'Depilação Masculina', 25, 35.00, '🧔', 305),
  ('Depilação Masculina - Costas Completas',   'Depilação Masculina', 40, 47.00, '🧔', 306),
  ('Depilação Masculina - Braços Superiores',  'Depilação Masculina', 20, 37.00, '🧔', 307),
  ('Depilação Masculina - Antebraços',         'Depilação Masculina', 20, 27.00, '🧔', 308),
  ('Depilação Masculina - Braços Completos',   'Depilação Masculina', 40, 47.00, '🧔', 309),
  ('Depilação Masculina - Coxas',              'Depilação Masculina', 25, 37.00, '🧔', 310),
  ('Depilação Masculina - Parte Inferior da Perna', 'Depilação Masculina', 25, 33.00, '🧔', 311),
  ('Depilação Masculina - Pescoço e Costas',   'Depilação Masculina', 30, 55.00, '🧔', 312),
  ('Depilação Masculina - Tórax e Abdômen',    'Depilação Masculina', 20, 45.00, '🧔', 313);

-- ── DEPILAÇÃO FEMININA ──
INSERT INTO services (name, category, duration, price, emoji, sort_order) VALUES
  ('Depilação Feminina - Sobrancelhas',              'Depilação Feminina', 10,  12.00,  '👩', 401),
  ('Depilação Feminina - Lábio Superior',            'Depilação Feminina', 15,  12.00,  '👩', 402),
  ('Depilação Feminina - Rosto Completo',            'Depilação Feminina', 10,  31.00,  '👩', 403),
  ('Depilação Feminina - Axilas',                    'Depilação Feminina', 20,  22.00,  '👩', 404),
  ('Depilação Feminina - Braços Superiores',         'Depilação Feminina', 20,  35.00,  '👩', 405),
  ('Depilação Feminina - Antebraços',                'Depilação Feminina', 20,  31.00,  '👩', 406),
  ('Depilação Feminina - Armas Completas',           'Depilação Feminina', 30,  37.00,  '👩', 407),
  ('Depilação Feminina - Costas',                    'Depilação Feminina', 30,  18.00,  '👩', 408),
  ('Depilação Feminina - Peito',                     'Depilação Feminina', 20,  15.00,  '👩', 409),
  ('Depilação Feminina - Abdentre',                  'Depilação Feminina', 20,  18.00,  '👩', 410),
  ('Depilação Feminina - Pescoço',                   'Depilação Feminina', 15,  22.00,  '👩', 411),
  ('Depilação Feminina - Biquíni',                   'Depilação Feminina', 25,  27.00,  '👩', 412),
  ('Depilação Feminina - Brasileira',                'Depilação Feminina', 30,  47.00,  '👩', 413),
  ('Depilação Feminina - Coxas',                     'Depilação Feminina', 30,  35.00,  '👩', 414),
  ('Depilação Feminina - Parte Inferior da Perna',   'Depilação Feminina', 30,  31.00,  '👩', 415),
  ('Depilação Feminina - Pernas Completas',          'Depilação Feminina', 45,  49.00,  '👩', 416),
  ('Depilação Feminina - Brasileira, Axilas e Pernas','Depilação Feminina', 90, 108.00, '👩', 417);

-- ============================================
-- VERIFICAÇÃO
-- ============================================
SELECT category, COUNT(*) AS total
FROM services
GROUP BY category
ORDER BY MIN(sort_order);

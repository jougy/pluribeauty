-- 1. Services
CREATE TABLE services (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id UUID NOT NULL,
  name TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('cabelo', 'barba', 'unhas', 'estetica', 'maquiagem', 'outros')),
  description TEXT,
  price NUMERIC NOT NULL,
  duration_minutes INTEGER,
  available_at TEXT[] NOT NULL
);

-- 2. Professionals
CREATE TABLE professionals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  cover_photo TEXT,
  profile_photo TEXT,
  specialties TEXT[],
  bio TEXT,
  location JSONB, -- {address, city, lat, lng}
  service_types TEXT[], -- ['salao', 'domicilio']
  rating NUMERIC DEFAULT 0,
  total_reviews INTEGER DEFAULT 0,
  portfolio TEXT[],
  is_featured BOOLEAN DEFAULT false
);

-- 3. Bookings
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID NOT NULL,
  professional_id UUID NOT NULL REFERENCES professionals(id),
  services JSONB NOT NULL, -- Array of {service_id, service_name, price}
  date DATE NOT NULL,
  time TEXT NOT NULL,
  location_type TEXT NOT NULL CHECK (location_type IN ('salao', 'domicilio')),
  address TEXT, -- Required if domicilio
  status TEXT NOT NULL CHECK (status IN ('pendente', 'confirmado', 'concluido', 'cancelado')),
  total_price NUMERIC NOT NULL
);

-- 4. Favorites
CREATE TABLE favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  professional_id UUID NOT NULL REFERENCES professionals(id)
);

-- 5. Messages
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID NOT NULL,
  professional_id UUID NOT NULL REFERENCES professionals(id),
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Notifications
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('new_booking', 'booking_confirmed', 'booking_cancelled')),
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Reviews
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID NOT NULL,
  professional_id UUID NOT NULL REFERENCES professionals(id),
  booking_id UUID NOT NULL REFERENCES bookings(id),
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. ProfessionalApplications
CREATE TABLE professional_applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('pending', 'approved', 'rejected')),
  documents JSONB, -- {cpf_cnpj, rg_cnh, portfolio}
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

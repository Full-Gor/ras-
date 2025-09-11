-- Schéma de base de données pour RAS Plomberie
-- Migration pour synchroniser les modifications du site

-- Table des couleurs du site
CREATE TABLE IF NOT EXISTS site_colors (
    id SERIAL PRIMARY KEY,
    color_name VARCHAR(50) UNIQUE NOT NULL,
    color_value VARCHAR(7) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des contenus éditables
CREATE TABLE IF NOT EXISTS site_content (
    id SERIAL PRIMARY KEY,
    element_id VARCHAR(100) UNIQUE NOT NULL,
    element_type VARCHAR(50) NOT NULL, -- 'text', 'image', 'section'
    content_text TEXT,
    content_html TEXT,
    image_url TEXT,
    parent_element VARCHAR(100),
    position_order INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des informations de contact
CREATE TABLE IF NOT EXISTS contact_info (
    id SERIAL PRIMARY KEY,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    email VARCHAR(100),
    emergency_phone VARCHAR(20),
    business_hours TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des images du site
CREATE TABLE IF NOT EXISTS site_images (
    id SERIAL PRIMARY KEY,
    image_name VARCHAR(100) NOT NULL,
    image_url TEXT NOT NULL,
    alt_text TEXT,
    section_name VARCHAR(50),
    position_order INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des sections du site
CREATE TABLE IF NOT EXISTS site_sections (
    id SERIAL PRIMARY KEY,
    section_name VARCHAR(100) UNIQUE NOT NULL,
    section_title TEXT,
    section_content TEXT,
    section_html TEXT,
    is_visible BOOLEAN DEFAULT true,
    position_order INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des services
CREATE TABLE IF NOT EXISTS services (
    id SERIAL PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    service_description TEXT,
    service_icon VARCHAR(50),
    service_price DECIMAL(10,2),
    is_active BOOLEAN DEFAULT true,
    position_order INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des témoignages
CREATE TABLE IF NOT EXISTS testimonials (
    id SERIAL PRIMARY KEY,
    client_name VARCHAR(100) NOT NULL,
    client_location VARCHAR(100),
    testimonial_text TEXT NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    is_approved BOOLEAN DEFAULT false,
    position_order INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des demandes de contact
CREATE TABLE IF NOT EXISTS contact_requests (
    id SERIAL PRIMARY KEY,
    client_name VARCHAR(100) NOT NULL,
    client_phone VARCHAR(20) NOT NULL,
    client_address TEXT,
    service_type VARCHAR(100),
    preferred_date DATE,
    preferred_time TIME,
    message TEXT,
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'contacted', 'completed'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insertion des données par défaut
INSERT INTO site_colors (color_name, color_value) VALUES 
('primary', '#1e40af'),
('secondary', '#3b82f6'),
('accent', '#60a5fa'),
('dark', '#1e293b')
ON CONFLICT (color_name) DO NOTHING;

INSERT INTO contact_info (phone, address, email, emergency_phone, business_hours) VALUES 
('06 22 16 74 57', '31 rue du Maroc, 75019 Paris', 'contact@ras-plomberie.fr', '06 22 16 74 57', 'Lun-Ven: 8h-19h, Sam: 9h-17h, Urgences: 24h/24')
ON CONFLICT DO NOTHING;

-- Insertion des services par défaut
INSERT INTO services (service_name, service_description, service_icon, position_order) VALUES 
('Dépannage d''urgence', 'Fuites, canalisations bouchées, problèmes de chauffe-eau - intervention immédiate 24/7', 'fas fa-exclamation-triangle', 1),
('Salle de bains', 'Rénovation complète, installation de douches italiennes, baignoires et sanitaires haut de gamme', 'fas fa-bath', 2),
('Détection de fuites', 'Recherche et réparation de fuites avec caméra thermique et équipements de pointe', 'fas fa-tint', 3),
('Chauffage & Climatisation', 'Installation et entretien de chaudières, pompes à chaleur et systèmes de climatisation', 'fas fa-temperature-high', 4),
('Débouchage professionnel', 'Débouchage haute pression, curage de canalisations avec caméra d''inspection', 'fas fa-water', 5),
('Rénovation complète', 'Refonte totale de votre plomberie pour maisons et appartements anciens', 'fas fa-home', 6)
ON CONFLICT DO NOTHING;

-- Insertion des témoignages par défaut
INSERT INTO testimonials (client_name, client_location, testimonial_text, rating, is_approved, position_order) VALUES 
('Marie L.', 'Paris 11ème', 'Service impeccable ! Intervention rapide suite à une fuite d''eau importante. Le plombier était professionnel et a tout réparé en moins d''une heure.', 5, true, 1),
('Thomas R.', 'Neuilly-sur-Seine', 'Installation complète de ma nouvelle salle de bain. Travail soigné, respect des délais et excellents conseils. Je recommande vivement !', 5, true, 2),
('Sophie B.', 'Boulogne-Billancourt', 'Urgence un dimanche soir, canalisation bouchée. Intervention rapide et efficace. Tarif transparent communiqué à l''avance. Parfait !', 5, true, 3)
ON CONFLICT DO NOTHING;

-- Création des index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_site_content_element_id ON site_content(element_id);
CREATE INDEX IF NOT EXISTS idx_site_content_type ON site_content(element_type);
CREATE INDEX IF NOT EXISTS idx_contact_requests_status ON contact_requests(status);
CREATE INDEX IF NOT EXISTS idx_contact_requests_created_at ON contact_requests(created_at);
CREATE INDEX IF NOT EXISTS idx_services_active ON services(is_active);
CREATE INDEX IF NOT EXISTS idx_testimonials_approved ON testimonials(is_approved);

-- Fonction pour mettre à jour automatiquement updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers pour mettre à jour automatiquement updated_at
CREATE TRIGGER update_site_colors_updated_at BEFORE UPDATE ON site_colors FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_site_content_updated_at BEFORE UPDATE ON site_content FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_contact_info_updated_at BEFORE UPDATE ON contact_info FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_site_images_updated_at BEFORE UPDATE ON site_images FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_site_sections_updated_at BEFORE UPDATE ON site_sections FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_testimonials_updated_at BEFORE UPDATE ON testimonials FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_contact_requests_updated_at BEFORE UPDATE ON contact_requests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

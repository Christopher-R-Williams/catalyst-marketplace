-- PostgreSQL Schema Template
-- Use this template to define database schemas for parallel agent development

-- ============================================================================
-- EXTENSIONS
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- UUID generation
CREATE EXTENSION IF NOT EXISTS "pg_trgm";         -- Fuzzy text search
CREATE EXTENSION IF NOT EXISTS "citext";          -- Case-insensitive text

-- ============================================================================
-- USERS TABLE (Authentication & Authorization)
-- ============================================================================

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email CITEXT NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,

  -- Profile
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  avatar_url VARCHAR(500),
  bio TEXT,

  -- Role-based access control
  role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin', 'moderator')),

  -- Status
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  is_email_verified BOOLEAN NOT NULL DEFAULT FALSE,
  email_verification_token VARCHAR(255),

  -- Password reset
  password_reset_token VARCHAR(255),
  password_reset_expires TIMESTAMP,

  -- Timestamps
  last_login_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_created_at ON users(created_at DESC);
CREATE INDEX idx_users_is_active ON users(is_active);

-- Updated timestamp trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- PRODUCTS TABLE (E-commerce example)
-- ============================================================================

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Basic info
  name VARCHAR(200) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  description TEXT NOT NULL,

  -- Pricing
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
  compare_at_price DECIMAL(10, 2) CHECK (compare_at_price >= 0),
  currency VARCHAR(3) NOT NULL DEFAULT 'USD',

  -- Categorization
  category VARCHAR(100) NOT NULL,
  subcategory VARCHAR(100),
  brand VARCHAR(100),
  tags TEXT[], -- Array of tags

  -- Inventory
  sku VARCHAR(50) NOT NULL UNIQUE,
  quantity INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0),
  low_stock_threshold INTEGER NOT NULL DEFAULT 10,
  restock_date DATE,

  -- Specifications (JSON for flexibility)
  specifications JSONB,

  -- Reviews/Ratings
  average_rating DECIMAL(2, 1) DEFAULT 0 CHECK (average_rating >= 0 AND average_rating <= 5),
  review_count INTEGER DEFAULT 0 CHECK (review_count >= 0),

  -- Visibility
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  is_featured BOOLEAN NOT NULL DEFAULT FALSE,

  -- SEO
  meta_title VARCHAR(255),
  meta_description TEXT,

  -- Timestamps
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_is_active ON products(is_active);
CREATE INDEX idx_products_tags ON products USING GIN(tags); -- GIN index for arrays
CREATE INDEX idx_products_created_at ON products(created_at DESC);
CREATE INDEX idx_products_quantity ON products(quantity);

-- Compound indexes
CREATE INDEX idx_products_category_price ON products(category, price);
CREATE INDEX idx_products_active_featured ON products(is_active, is_featured DESC, created_at DESC);

-- Full-text search index
CREATE INDEX idx_products_search ON products USING GIN(to_tsvector('english', name || ' ' || description));

-- Updated timestamp trigger
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- PRODUCT IMAGES TABLE (One-to-Many relationship)
-- ============================================================================

CREATE TABLE product_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

  url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  display_order INTEGER NOT NULL DEFAULT 0,

  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_product_images_product_id ON product_images(product_id);
CREATE INDEX idx_product_images_is_primary ON product_images(product_id, is_primary);

-- Ensure only one primary image per product
CREATE UNIQUE INDEX idx_product_images_one_primary
  ON product_images(product_id)
  WHERE is_primary = TRUE;

-- ============================================================================
-- ORDERS TABLE
-- ============================================================================

CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_number VARCHAR(50) NOT NULL UNIQUE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,

  -- Totals
  subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0),
  tax DECIMAL(10, 2) NOT NULL CHECK (tax >= 0),
  shipping DECIMAL(10, 2) NOT NULL CHECK (shipping >= 0),
  discount DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (discount >= 0),
  total DECIMAL(10, 2) NOT NULL CHECK (total >= 0),

  -- Addresses (JSON for flexibility)
  shipping_address JSONB NOT NULL,
  billing_address JSONB NOT NULL,

  -- Payment
  payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('card', 'paypal', 'bank')),
  payment_status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
  stripe_payment_intent_id VARCHAR(255),
  paid_at TIMESTAMP,

  -- Order status
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),

  -- Shipping
  tracking_carrier VARCHAR(100),
  tracking_number VARCHAR(100),
  shipped_at TIMESTAMP,
  delivered_at TIMESTAMP,
  estimated_delivery DATE,

  -- Notes
  customer_notes TEXT,
  internal_notes TEXT,

  -- Cancellation
  cancelled_at TIMESTAMP,
  cancellation_reason TEXT,

  -- Timestamps
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_order_number ON orders(order_number);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX idx_orders_user_created ON orders(user_id, created_at DESC);

-- Updated timestamp trigger
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- ORDER ITEMS TABLE (Many-to-Many relationship)
-- ============================================================================

CREATE TABLE order_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,

  -- Snapshot of product at time of purchase
  product_name VARCHAR(200) NOT NULL,
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0),

  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- ============================================================================
-- SHOPPING CART TABLE
-- ============================================================================

CREATE TABLE carts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  session_id VARCHAR(255), -- For guest carts

  -- Timestamps
  last_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL '30 days'),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_carts_user_id ON carts(user_id);
CREATE INDEX idx_carts_session_id ON carts(session_id);
CREATE INDEX idx_carts_expires_at ON carts(expires_at);

-- Ensure one cart per user
CREATE UNIQUE INDEX idx_carts_one_per_user ON carts(user_id) WHERE user_id IS NOT NULL;

-- ============================================================================
-- CART ITEMS TABLE
-- ============================================================================

CREATE TABLE cart_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

  quantity INTEGER NOT NULL CHECK (quantity > 0),

  added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_cart_items_cart_id ON cart_items(cart_id);
CREATE INDEX idx_cart_items_product_id ON cart_items(product_id);

-- Ensure unique product per cart
CREATE UNIQUE INDEX idx_cart_items_unique ON cart_items(cart_id, product_id);

-- Updated timestamp trigger
CREATE TRIGGER update_cart_items_updated_at BEFORE UPDATE ON cart_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- REVIEWS TABLE
-- ============================================================================

CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  order_id UUID REFERENCES orders(id) ON DELETE SET NULL,

  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title VARCHAR(200),
  comment TEXT,

  is_verified_purchase BOOLEAN NOT NULL DEFAULT FALSE,
  helpful_count INTEGER NOT NULL DEFAULT 0,

  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_reviews_product_id ON reviews(product_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_reviews_created_at ON reviews(created_at DESC);
CREATE INDEX idx_reviews_rating ON reviews(rating);

-- One review per user per product
CREATE UNIQUE INDEX idx_reviews_unique ON reviews(product_id, user_id);

-- Updated timestamp trigger
CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- TEMPLATE TABLE (Customize for your needs)
-- ============================================================================

CREATE TABLE template_table (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Required fields
  name VARCHAR(100) NOT NULL,
  description TEXT,

  -- Status/enum fields
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'active', 'inactive')),

  -- Numbers
  count INTEGER DEFAULT 0 CHECK (count >= 0),
  price DECIMAL(10, 2) CHECK (price >= 0),

  -- Boolean
  is_active BOOLEAN NOT NULL DEFAULT TRUE,

  -- Arrays (PostgreSQL specific)
  tags TEXT[],

  -- JSON (flexible structure)
  metadata JSONB,

  -- Foreign key
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,

  -- Dates
  expires_at TIMESTAMP,

  -- Timestamps
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_template_name ON template_table(name);
CREATE INDEX idx_template_status ON template_table(status);
CREATE INDEX idx_template_user_id ON template_table(user_id);
CREATE INDEX idx_template_created_at ON template_table(created_at DESC);
CREATE INDEX idx_template_metadata ON template_table USING GIN(metadata); -- For JSONB queries

-- Compound index
CREATE INDEX idx_template_status_active ON template_table(status, is_active);

-- Updated timestamp trigger
CREATE TRIGGER update_template_updated_at BEFORE UPDATE ON template_table
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- VIEWS (Computed/joined data)
-- ============================================================================

-- View: Product details with image count
CREATE OR REPLACE VIEW v_products_with_details AS
SELECT
  p.*,
  COUNT(pi.id) as image_count,
  CASE WHEN p.quantity > 0 THEN TRUE ELSE FALSE END as in_stock,
  CASE WHEN p.quantity <= p.low_stock_threshold THEN TRUE ELSE FALSE END as is_low_stock
FROM products p
LEFT JOIN product_images pi ON pi.product_id = p.id
GROUP BY p.id;

-- View: Order summary
CREATE OR REPLACE VIEW v_order_summary AS
SELECT
  o.id,
  o.order_number,
  o.user_id,
  u.email as user_email,
  u.first_name || ' ' || u.last_name as user_name,
  o.total,
  o.status,
  o.payment_status,
  COUNT(oi.id) as item_count,
  o.created_at
FROM orders o
JOIN users u ON u.id = o.user_id
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, u.id;

-- ============================================================================
-- FUNCTIONS (Business logic)
-- ============================================================================

-- Function: Update product rating after review
CREATE OR REPLACE FUNCTION update_product_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE products
  SET
    average_rating = (SELECT AVG(rating) FROM reviews WHERE product_id = NEW.product_id),
    review_count = (SELECT COUNT(*) FROM reviews WHERE product_id = NEW.product_id)
  WHERE id = NEW.product_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_product_rating
  AFTER INSERT OR UPDATE OR DELETE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_product_rating();

-- Function: Decrement inventory after order
CREATE OR REPLACE FUNCTION decrement_inventory()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE products
  SET quantity = quantity - NEW.quantity
  WHERE id = NEW.product_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Product not found: %', NEW.product_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_decrement_inventory
  AFTER INSERT ON order_items
  FOR EACH ROW
  EXECUTE FUNCTION decrement_inventory();

-- ============================================================================
-- SEED DATA (Optional - for development)
-- ============================================================================

-- Insert admin user (password: "admin123" - CHANGE IN PRODUCTION!)
-- INSERT INTO users (email, password_hash, first_name, last_name, role, is_email_verified)
-- VALUES (
--   'admin@example.com',
--   '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYdMxnSVp6.',
--   'Admin',
--   'User',
--   'admin',
--   true
-- );

-- ============================================================================
-- BEST PRACTICES CHECKLIST
-- ============================================================================

-- ✅ Use UUIDs for primary keys (prevents enumeration attacks)
-- ✅ Add CHECK constraints for data validation
-- ✅ Create indexes on foreign keys and frequently queried columns
-- ✅ Use CITEXT for case-insensitive emails
-- ✅ Add updated_at triggers for timestamp management
-- ✅ Use ON DELETE CASCADE/RESTRICT appropriately
-- ✅ Use JSONB for flexible schema data
-- ✅ Create views for complex queries
-- ✅ Add triggers for automatic calculations
-- ✅ Use GIN indexes for arrays and JSONB
-- ✅ Add compound indexes for common query patterns
-- ✅ Document all tables and complex logic

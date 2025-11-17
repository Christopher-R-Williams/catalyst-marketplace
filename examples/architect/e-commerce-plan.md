# Architect Implementation Plan: E-Commerce Platform

**Project:** Modern E-Commerce Platform
**Tech Stack:** MERN (MongoDB, Express, React, Node.js)
**Date:** 2025-11-17

---

## 🏗️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         FRONTEND                             │
│  React + Vite + TailwindCSS + Redux Toolkit                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Product  │  │ Shopping │  │ Checkout │  │  Admin   │   │
│  │ Catalog  │  │   Cart   │  │   Flow   │  │  Panel   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                    REST API (JSON)
                            │
┌─────────────────────────────────────────────────────────────┐
│                         BACKEND                              │
│  Node.js + Express + JWT Auth                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Products │  │  Orders  │  │   Auth   │  │ Payments │   │
│  │   API    │  │   API    │  │   API    │  │   API    │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                      MongoDB Atlas
                            │
┌─────────────────────────────────────────────────────────────┐
│                         DATABASE                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  users   │  │ products │  │  orders  │  │   cart   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘

External Services:
├── Stripe (Payment Processing)
├── Cloudinary (Image Storage)
└── SendGrid (Email Notifications)
```

---

## 📊 Database Schema

### Users Collection
```javascript
{
  _id: ObjectId,
  email: String (unique, required),
  password: String (hashed, required),
  firstName: String (required),
  lastName: String (required),
  role: String (enum: ['customer', 'admin'], default: 'customer'),
  addresses: [{
    type: String (enum: ['shipping', 'billing']),
    street: String,
    city: String,
    state: String,
    zipCode: String,
    country: String,
    isDefault: Boolean
  }],
  createdAt: Date,
  updatedAt: Date
}
```

### Products Collection
```javascript
{
  _id: ObjectId,
  name: String (required),
  slug: String (unique, required, indexed),
  description: String (required),
  price: Number (required, min: 0),
  compareAtPrice: Number (optional, for sales),
  category: String (required, indexed),
  subcategory: String (indexed),
  brand: String (indexed),
  images: [{
    url: String (required),
    alt: String,
    isPrimary: Boolean
  }],
  inventory: {
    sku: String (unique),
    quantity: Number (required, min: 0),
    lowStockThreshold: Number (default: 10)
  },
  specifications: Map,
  tags: [String] (indexed),
  isActive: Boolean (default: true),
  isFeatured: Boolean (default: false),
  averageRating: Number (0-5),
  reviewCount: Number (default: 0),
  createdAt: Date,
  updatedAt: Date
}
```

### Orders Collection
```javascript
{
  _id: ObjectId,
  orderNumber: String (unique, auto-generated),
  userId: ObjectId (ref: 'users', required, indexed),
  items: [{
    productId: ObjectId (ref: 'products', required),
    name: String,
    price: Number,
    quantity: Number,
    subtotal: Number
  }],
  totals: {
    subtotal: Number,
    tax: Number,
    shipping: Number,
    discount: Number,
    total: Number
  },
  shippingAddress: {
    street: String,
    city: String,
    state: String,
    zipCode: String,
    country: String
  },
  billingAddress: {
    street: String,
    city: String,
    state: String,
    zipCode: String,
    country: String
  },
  payment: {
    method: String (enum: ['card', 'paypal']),
    status: String (enum: ['pending', 'completed', 'failed', 'refunded']),
    stripePaymentIntentId: String,
    paidAt: Date
  },
  status: String (enum: ['pending', 'processing', 'shipped', 'delivered', 'cancelled']),
  tracking: {
    carrier: String,
    trackingNumber: String,
    shippedAt: Date,
    deliveredAt: Date
  },
  createdAt: Date,
  updatedAt: Date
}
```

### Cart Collection
```javascript
{
  _id: ObjectId,
  userId: ObjectId (ref: 'users', indexed, sparse),
  sessionId: String (indexed, for guest carts),
  items: [{
    productId: ObjectId (ref: 'products', required),
    quantity: Number (required, min: 1),
    addedAt: Date
  }],
  lastModified: Date,
  expiresAt: Date (TTL index, 30 days)
}
```

### Reviews Collection
```javascript
{
  _id: ObjectId,
  productId: ObjectId (ref: 'products', required, indexed),
  userId: ObjectId (ref: 'users', required, indexed),
  orderId: ObjectId (ref: 'orders', required),
  rating: Number (required, min: 1, max: 5),
  title: String,
  comment: String,
  isVerifiedPurchase: Boolean (default: true),
  helpfulCount: Number (default: 0),
  createdAt: Date,
  updatedAt: Date
}
```

**Indexes:**
- `users`: email (unique), createdAt
- `products`: slug (unique), category, price, isActive, tags
- `orders`: userId, orderNumber (unique), status, createdAt
- `cart`: userId (sparse), sessionId, expiresAt (TTL)
- `reviews`: productId, userId, createdAt

---

## 🔌 API Contracts

### Authentication Endpoints

#### POST /api/auth/register
**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe"
}
```
**Response (201):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "507f1f77bcf86cd799439011",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "customer"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

#### POST /api/auth/login
**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```
**Response (200):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "507f1f77bcf86cd799439011",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "customer"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

### Product Endpoints

#### GET /api/products
**Query Parameters:**
- `page` (default: 1)
- `limit` (default: 20, max: 100)
- `category` (optional)
- `search` (optional)
- `minPrice` (optional)
- `maxPrice` (optional)
- `sort` (options: price_asc, price_desc, newest, popular)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": "507f1f77bcf86cd799439011",
        "name": "Premium Wireless Headphones",
        "slug": "premium-wireless-headphones",
        "price": 199.99,
        "compareAtPrice": 249.99,
        "category": "Electronics",
        "images": [
          {
            "url": "https://cdn.example.com/headphones-1.jpg",
            "alt": "Black wireless headphones",
            "isPrimary": true
          }
        ],
        "inventory": {
          "quantity": 45,
          "inStock": true
        },
        "averageRating": 4.5,
        "reviewCount": 128
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalProducts": 96,
      "limit": 20
    }
  }
}
```

#### GET /api/products/:slug
**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "507f1f77bcf86cd799439011",
    "name": "Premium Wireless Headphones",
    "slug": "premium-wireless-headphones",
    "description": "High-quality wireless headphones with active noise cancellation...",
    "price": 199.99,
    "compareAtPrice": 249.99,
    "category": "Electronics",
    "subcategory": "Audio",
    "brand": "AudioTech",
    "images": [...],
    "specifications": {
      "battery": "30 hours",
      "driver": "40mm",
      "bluetooth": "5.0",
      "weight": "250g"
    },
    "inventory": {
      "sku": "AT-WH-001",
      "quantity": 45,
      "inStock": true
    },
    "averageRating": 4.5,
    "reviewCount": 128
  }
}
```

#### POST /api/products (Admin Only)
**Headers:** `Authorization: Bearer <token>`
**Request:**
```json
{
  "name": "Premium Wireless Headphones",
  "description": "High-quality wireless headphones...",
  "price": 199.99,
  "category": "Electronics",
  "subcategory": "Audio",
  "brand": "AudioTech",
  "inventory": {
    "sku": "AT-WH-001",
    "quantity": 50
  }
}
```
**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "507f1f77bcf86cd799439011",
    "name": "Premium Wireless Headphones",
    "slug": "premium-wireless-headphones",
    ...
  }
}
```

---

### Cart Endpoints

#### GET /api/cart
**Headers:** `Authorization: Bearer <token>` (optional for guests)
**Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "productId": "507f1f77bcf86cd799439011",
        "name": "Premium Wireless Headphones",
        "price": 199.99,
        "quantity": 2,
        "image": "https://cdn.example.com/headphones-1.jpg",
        "inStock": true,
        "subtotal": 399.98
      }
    ],
    "totals": {
      "subtotal": 399.98,
      "tax": 32.00,
      "shipping": 0,
      "total": 431.98
    },
    "itemCount": 2
  }
}
```

#### POST /api/cart/items
**Request:**
```json
{
  "productId": "507f1f77bcf86cd799439011",
  "quantity": 2
}
```
**Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [...],
    "totals": {...},
    "itemCount": 2
  }
}
```

#### PATCH /api/cart/items/:productId
**Request:**
```json
{
  "quantity": 3
}
```
**Response (200):** Same as GET /api/cart

#### DELETE /api/cart/items/:productId
**Response (200):** Same as GET /api/cart

---

### Order Endpoints

#### POST /api/orders
**Headers:** `Authorization: Bearer <token>`
**Request:**
```json
{
  "items": [
    {
      "productId": "507f1f77bcf86cd799439011",
      "quantity": 2
    }
  ],
  "shippingAddress": {
    "street": "123 Main St",
    "city": "San Francisco",
    "state": "CA",
    "zipCode": "94105",
    "country": "USA"
  },
  "billingAddress": {...},
  "paymentMethodId": "pm_1234567890"
}
```
**Response (201):**
```json
{
  "success": true,
  "data": {
    "orderId": "507f1f77bcf86cd799439011",
    "orderNumber": "ORD-2025-00123",
    "status": "pending",
    "totals": {
      "subtotal": 399.98,
      "tax": 32.00,
      "shipping": 0,
      "total": 431.98
    },
    "stripeClientSecret": "pi_3abc123_secret_xyz"
  }
}
```

#### GET /api/orders
**Headers:** `Authorization: Bearer <token>`
**Response (200):**
```json
{
  "success": true,
  "data": {
    "orders": [
      {
        "id": "507f1f77bcf86cd799439011",
        "orderNumber": "ORD-2025-00123",
        "status": "delivered",
        "totals": {
          "total": 431.98
        },
        "createdAt": "2025-11-15T10:30:00Z",
        "itemCount": 2
      }
    ]
  }
}
```

#### GET /api/orders/:id
**Headers:** `Authorization: Bearer <token>`
**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "507f1f77bcf86cd799439011",
    "orderNumber": "ORD-2025-00123",
    "items": [...],
    "totals": {...},
    "shippingAddress": {...},
    "status": "delivered",
    "tracking": {
      "carrier": "UPS",
      "trackingNumber": "1Z999AA10123456784",
      "shippedAt": "2025-11-16T09:00:00Z",
      "deliveredAt": "2025-11-17T14:30:00Z"
    },
    "createdAt": "2025-11-15T10:30:00Z"
  }
}
```

---

### Payment Endpoints

#### POST /api/payments/create-intent
**Headers:** `Authorization: Bearer <token>`
**Request:**
```json
{
  "amount": 43198,
  "currency": "usd",
  "orderId": "507f1f77bcf86cd799439011"
}
```
**Response (200):**
```json
{
  "success": true,
  "data": {
    "clientSecret": "pi_3abc123_secret_xyz",
    "paymentIntentId": "pi_3abc123"
  }
}
```

#### POST /api/payments/webhook
**Stripe webhook handler** - Handles payment confirmation events

---

## 🎨 Component Breakdown

### Frontend Components (5 parallel development tracks)

#### 1. Product Catalog Component
**Files:**
- `src/pages/ProductListPage.jsx`
- `src/pages/ProductDetailPage.jsx`
- `src/components/ProductCard.jsx`
- `src/components/ProductGrid.jsx`
- `src/components/ProductFilters.jsx`
- `src/components/ProductSearch.jsx`

**Features:**
- Product listing with pagination
- Search and filters
- Product detail views
- Image galleries
- Reviews display

#### 2. Shopping Cart Component
**Files:**
- `src/components/Cart/CartDrawer.jsx`
- `src/components/Cart/CartItem.jsx`
- `src/components/Cart/CartSummary.jsx`
- `src/pages/CartPage.jsx`

**Features:**
- Add/remove/update quantities
- Cart persistence
- Price calculations
- Empty cart state

#### 3. Checkout Component
**Files:**
- `src/pages/CheckoutPage.jsx`
- `src/components/Checkout/ShippingForm.jsx`
- `src/components/Checkout/PaymentForm.jsx`
- `src/components/Checkout/OrderSummary.jsx`
- `src/components/Checkout/OrderConfirmation.jsx`

**Features:**
- Multi-step checkout
- Address forms
- Stripe payment integration
- Order confirmation

#### 4. Authentication Component
**Files:**
- `src/pages/LoginPage.jsx`
- `src/pages/RegisterPage.jsx`
- `src/components/Auth/LoginForm.jsx`
- `src/components/Auth/RegisterForm.jsx`
- `src/components/Auth/ProtectedRoute.jsx`

**Features:**
- User registration
- Login/logout
- JWT token management
- Protected routes

#### 5. Admin Dashboard Component
**Files:**
- `src/pages/admin/DashboardPage.jsx`
- `src/pages/admin/ProductsManagePage.jsx`
- `src/pages/admin/OrdersManagePage.jsx`
- `src/components/admin/ProductForm.jsx`
- `src/components/admin/OrderTable.jsx`

**Features:**
- Product CRUD
- Order management
- Sales analytics
- Inventory tracking

---

### Backend Components (5 parallel development tracks)

#### 1. Products API
**Files:**
- `src/routes/products.js`
- `src/controllers/productController.js`
- `src/models/Product.js`
- `src/middleware/validateProduct.js`

**Endpoints:** GET /products, GET /products/:slug, POST /products, PATCH /products/:id, DELETE /products/:id

#### 2. Orders API
**Files:**
- `src/routes/orders.js`
- `src/controllers/orderController.js`
- `src/models/Order.js`
- `src/services/orderService.js`

**Endpoints:** POST /orders, GET /orders, GET /orders/:id, PATCH /orders/:id/status

#### 3. Authentication API
**Files:**
- `src/routes/auth.js`
- `src/controllers/authController.js`
- `src/models/User.js`
- `src/middleware/authMiddleware.js`
- `src/utils/jwt.js`

**Endpoints:** POST /auth/register, POST /auth/login, GET /auth/me

#### 4. Cart API
**Files:**
- `src/routes/cart.js`
- `src/controllers/cartController.js`
- `src/models/Cart.js`
- `src/services/cartService.js`

**Endpoints:** GET /cart, POST /cart/items, PATCH /cart/items/:id, DELETE /cart/items/:id

#### 5. Payments API
**Files:**
- `src/routes/payments.js`
- `src/controllers/paymentController.js`
- `src/services/stripeService.js`
- `src/webhooks/stripeWebhook.js`

**Endpoints:** POST /payments/create-intent, POST /payments/webhook

---

## 🔄 Integration Points

### Frontend → Backend
- **API Base URL:** Environment variable `VITE_API_URL`
- **Authentication:** JWT token in `Authorization: Bearer <token>` header
- **Error Handling:** Standardized error responses
- **CORS:** Backend allows `http://localhost:5173` in development

### Backend → Database
- **Connection:** MongoDB connection string from environment variable
- **ORM:** Mongoose for schema validation
- **Migrations:** Not needed for MongoDB, but seed scripts for initial data

### Backend → Stripe
- **API Key:** Environment variable `STRIPE_SECRET_KEY`
- **Webhook Secret:** Environment variable `STRIPE_WEBHOOK_SECRET`
- **Payment Intents API:** For secure payment processing

### Frontend → Stripe
- **Publishable Key:** Environment variable `VITE_STRIPE_PUBLISHABLE_KEY`
- **Elements:** Stripe Elements for payment forms

---

## 📁 Project Structure

```
ecommerce-platform/
├── frontend/                    # React frontend
│   ├── src/
│   │   ├── components/
│   │   │   ├── Auth/
│   │   │   ├── Cart/
│   │   │   ├── Checkout/
│   │   │   ├── Product/
│   │   │   └── admin/
│   │   ├── pages/
│   │   ├── store/              # Redux store
│   │   ├── services/           # API calls
│   │   ├── hooks/              # Custom hooks
│   │   └── utils/
│   ├── public/
│   ├── package.json
│   └── vite.config.js
│
├── backend/                     # Node.js backend
│   ├── src/
│   │   ├── routes/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── middleware/
│   │   ├── services/
│   │   ├── utils/
│   │   └── config/
│   ├── tests/
│   ├── package.json
│   └── server.js
│
├── shared/                      # Shared contracts
│   ├── types/
│   └── constants/
│
└── docs/
    ├── api/                     # API documentation
    └── setup/                   # Setup guides
```

---

## 🚀 Development Phases

### Phase 1: Foundation (Deploy in parallel)
- **Setup:** Project structure, dependencies, environment config
- **Database:** MongoDB schema and indexes
- **Auth API:** User registration and login
- **Frontend Auth:** Login/register forms
- **Timeline:** Completed by parallel agents simultaneously

### Phase 2: Core Features (Deploy in parallel)
- **Products API:** CRUD operations
- **Product Catalog Frontend:** List and detail pages
- **Cart API:** Shopping cart operations
- **Cart Frontend:** Cart drawer and page
- **Timeline:** Completed by parallel agents simultaneously

### Phase 3: Checkout (Deploy in parallel)
- **Orders API:** Order creation and management
- **Payments API:** Stripe integration
- **Checkout Frontend:** Multi-step checkout flow
- **Timeline:** Completed by parallel agents simultaneously

### Phase 4: Integration (Ship phase)
- **Connect:** Frontend to backend APIs
- **Configure:** CORS, environment variables
- **Testing:** End-to-end user flows
- **Deploy:** Production deployment

---

## 🔐 Security Considerations

1. **Password Security:** bcrypt with salt rounds ≥ 10
2. **JWT Security:** Short expiration (24h), secure secret, HTTP-only cookies
3. **Input Validation:** Joi schemas for all endpoints
4. **Rate Limiting:** Express rate limit middleware
5. **CORS:** Whitelist specific origins
6. **SQL Injection:** Using Mongoose (protected by default)
7. **XSS Protection:** Sanitize user input, Content Security Policy
8. **HTTPS Only:** Force HTTPS in production
9. **Environment Variables:** Never commit secrets
10. **Stripe Security:** Use Payment Intents, verify webhooks

---

## 📊 Success Criteria

- ✅ Users can browse products with search and filters
- ✅ Users can add items to cart and checkout
- ✅ Payments process successfully through Stripe
- ✅ Orders are created and tracked
- ✅ Admins can manage products and orders
- ✅ Authentication is secure and functional
- ✅ All API endpoints respond < 200ms (90th percentile)
- ✅ Mobile responsive (320px - 1920px)
- ✅ Accessibility score ≥ 90 (Lighthouse)
- ✅ Test coverage ≥ 80%

---

## 🎯 Ready for Deploy Phase

This plan is ready for parallel deployment. The architecture has:
- ✅ Clear component boundaries
- ✅ Defined API contracts
- ✅ Database schema locked in
- ✅ Independent development tracks

**Next Step:** Move to Deploy skill to launch parallel agents!

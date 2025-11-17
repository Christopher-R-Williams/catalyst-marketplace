# Deploy Phase: Parallel Agent Prompts

**Project:** E-Commerce Platform
**Deploy Strategy:** 5 parallel agents working simultaneously
**Date:** 2025-11-17

---

## 🎯 Parallel Deployment Strategy

All 5 agents will be launched in a **SINGLE MESSAGE** using multiple Task tool calls. Each agent receives:
- Complete tech stack information
- API contracts and database schemas
- File paths for their workspace
- Success criteria
- Contract validation requirements

---

## Agent 1: Frontend Product Catalog Agent

**Task:** Build the product catalog and detail pages

**Workspace:** `/frontend/src/components/Product/` and `/frontend/src/pages/`

**Tech Stack:**
- React 18 + Vite
- TailwindCSS for styling
- React Router for navigation
- Axios for API calls
- React Query for server state

**API Contract to Follow:**
```
GET /api/products?page=1&limit=20&category=Electronics&search=headphones&sort=price_asc
POST response must match schema in /shared/types/product.ts
```

**Components to Build:**
1. `ProductCard.jsx` - Display product in grid
2. `ProductGrid.jsx` - Grid layout with pagination
3. `ProductFilters.jsx` - Category, price, search filters
4. `ProductListPage.jsx` - Main product listing page
5. `ProductDetailPage.jsx` - Individual product details
6. `ProductImageGallery.jsx` - Image viewer component
7. `ProductReviews.jsx` - Reviews section

**Mock API During Development:**
- Use mock data matching API contract
- Endpoint structure: `http://localhost:3001/api/products`
- Handle loading and error states
- Pagination must work with mock data

**Success Criteria:**
- ✅ Products display in responsive grid
- ✅ Filters work (category, price, search)
- ✅ Pagination functional
- ✅ Product detail page shows all info
- ✅ Image gallery works
- ✅ Mobile responsive (320px+)
- ✅ Loading and error states
- ✅ Component tests (≥70% coverage)

**Deliverables:**
- All components in `/frontend/src/components/Product/`
- Pages in `/frontend/src/pages/`
- Tests in `/frontend/src/components/Product/__tests__/`
- README with setup instructions

---

## Agent 2: Frontend Cart & Checkout Agent

**Task:** Build shopping cart and checkout flow

**Workspace:** `/frontend/src/components/Cart/`, `/frontend/src/components/Checkout/`

**Tech Stack:**
- React 18 + Vite
- TailwindCSS
- Redux Toolkit for cart state
- Stripe Elements for payments
- React Hook Form for forms

**API Contracts to Follow:**
```
GET /api/cart
POST /api/cart/items {productId, quantity}
PATCH /api/cart/items/:id {quantity}
DELETE /api/cart/items/:id
POST /api/orders {items, shippingAddress, billingAddress, paymentMethodId}
```

**Components to Build:**
1. `CartDrawer.jsx` - Slide-out cart
2. `CartItem.jsx` - Individual cart item
3. `CartSummary.jsx` - Price totals
4. `CartPage.jsx` - Full cart page
5. `CheckoutPage.jsx` - Multi-step checkout
6. `ShippingForm.jsx` - Address form
7. `PaymentForm.jsx` - Stripe payment form
8. `OrderConfirmation.jsx` - Success page

**Redux Store Setup:**
```javascript
// cartSlice.js
{
  items: [],
  totals: {subtotal: 0, tax: 0, shipping: 0, total: 0},
  itemCount: 0
}
```

**Success Criteria:**
- ✅ Cart drawer opens/closes smoothly
- ✅ Add/remove/update quantities works
- ✅ Cart persists to localStorage
- ✅ Checkout has 3 steps (shipping, payment, review)
- ✅ Stripe test payments work
- ✅ Order confirmation shows
- ✅ Form validation complete
- ✅ Component tests (≥70% coverage)

**Deliverables:**
- All components built
- Redux cart slice configured
- Stripe integration complete
- Tests written

---

## Agent 3: Backend Products & Orders API Agent

**Task:** Build Products and Orders REST APIs

**Workspace:** `/backend/src/routes/`, `/backend/src/controllers/`, `/backend/src/models/`

**Tech Stack:**
- Node.js + Express
- MongoDB + Mongoose
- JWT for auth
- Joi for validation

**Database Schemas (from Architect plan):**
- Products collection: name, slug, price, inventory, images, etc.
- Orders collection: orderNumber, userId, items, totals, status, etc.

**Endpoints to Build:**

**Products:**
- `GET /api/products` - List with pagination, filters, search
- `GET /api/products/:slug` - Get single product
- `POST /api/products` - Create (admin only)
- `PATCH /api/products/:id` - Update (admin only)
- `DELETE /api/products/:id` - Delete (admin only)

**Orders:**
- `POST /api/orders` - Create order
- `GET /api/orders` - List user's orders
- `GET /api/orders/:id` - Get single order
- `PATCH /api/orders/:id/status` - Update status (admin only)

**Validation Rules:**
- Product name: required, min 3 chars
- Price: required, number, min 0
- Quantity: required, integer, min 1

**Success Criteria:**
- ✅ All endpoints respond with correct status codes
- ✅ Pagination works (page, limit params)
- ✅ Search and filters functional
- ✅ Validation errors return 400
- ✅ Auth middleware works
- ✅ Database indexes created
- ✅ API tests (≥80% coverage)
- ✅ Response times < 100ms (local)

**Deliverables:**
- Routes, controllers, models
- Validation middleware
- API tests
- Postman collection

---

## Agent 4: Backend Auth & Cart API Agent

**Task:** Build Authentication and Cart APIs

**Workspace:** `/backend/src/routes/`, `/backend/src/controllers/`, `/backend/src/middleware/`

**Tech Stack:**
- Node.js + Express
- MongoDB + Mongoose
- JWT + bcrypt
- Express validator

**Database Schemas:**
- Users collection: email, password (hashed), firstName, lastName, role
- Cart collection: userId, sessionId, items[], lastModified

**Auth Endpoints:**
- `POST /api/auth/register` - Create account
- `POST /api/auth/login` - Login, return JWT
- `GET /api/auth/me` - Get current user (protected)

**Cart Endpoints:**
- `GET /api/cart` - Get cart (user or guest)
- `POST /api/cart/items` - Add item
- `PATCH /api/cart/items/:productId` - Update quantity
- `DELETE /api/cart/items/:productId` - Remove item

**Auth Middleware:**
```javascript
// authMiddleware.js
// Verify JWT token, attach user to req.user
// Return 401 if invalid
```

**Password Security:**
- bcrypt with 12 salt rounds
- Validate: min 8 chars, 1 uppercase, 1 number

**Success Criteria:**
- ✅ Registration creates user
- ✅ Login returns valid JWT
- ✅ Password hashed with bcrypt
- ✅ Auth middleware protects routes
- ✅ Cart works for guests (sessionId)
- ✅ Cart works for users (userId)
- ✅ Cart calculations correct
- ✅ API tests (≥80% coverage)

**Deliverables:**
- Auth routes and controllers
- Cart routes and controllers
- Auth middleware
- JWT utility functions
- API tests

---

## Agent 5: Payments & Infrastructure Agent

**Task:** Stripe integration and project infrastructure

**Workspace:** `/backend/src/services/`, `/backend/src/webhooks/`, project root

**Tech Stack:**
- Stripe API
- Express for webhooks
- MongoDB for payment records
- Docker for containers
- Environment config

**Stripe Integration:**
- Payment Intents API
- Webhook handling
- Test mode configuration

**Endpoints:**
- `POST /api/payments/create-intent` - Create payment intent
- `POST /api/payments/webhook` - Stripe webhook handler

**Payment Flow:**
1. Frontend requests payment intent
2. Backend creates Stripe PaymentIntent
3. Frontend confirms with Stripe Elements
4. Webhook confirms payment
5. Update order status to "paid"

**Infrastructure:**
- Docker Compose setup (frontend, backend, MongoDB)
- Environment variable templates
- Database seed scripts
- Development scripts

**Success Criteria:**
- ✅ Payment intents create successfully
- ✅ Webhooks verify signature
- ✅ Order status updates on payment
- ✅ Stripe test cards work
- ✅ Docker setup runs all services
- ✅ Seed data populates DB
- ✅ Environment docs complete

**Deliverables:**
- Stripe service module
- Webhook handler
- Docker Compose files
- .env.example
- Seed scripts
- Setup documentation

---

## 📋 Shared Contracts (All Agents Must Follow)

### API Response Format
```typescript
// Success response
{
  success: true,
  data: {...}
}

// Error response
{
  success: false,
  error: {
    message: string,
    code: string,
    details?: any
  }
}
```

### TypeScript Types (in /shared/types/)
```typescript
// product.ts
export interface Product {
  id: string;
  name: string;
  slug: string;
  price: number;
  // ... (from Architect plan)
}

// order.ts
export interface Order {
  id: string;
  orderNumber: string;
  userId: string;
  // ... (from Architect plan)
}
```

---

## 🚀 Deployment Command

All 5 agents launched simultaneously:

```javascript
// Deploy skill launches all agents in ONE message:
Task({type: "general-purpose", prompt: "Agent 1 prompt..."})
Task({type: "general-purpose", prompt: "Agent 2 prompt..."})
Task({type: "general-purpose", prompt: "Agent 3 prompt..."})
Task({type: "general-purpose", prompt: "Agent 4 prompt..."})
Task({type: "general-purpose", prompt: "Agent 5 prompt..."})
```

**Execution:** All agents work in parallel, independently
**Duration:** ~15-30 minutes for all agents combined
**Coordination:** Minimal - agents follow contracts

---

## ✅ Validation After Deploy

Once all agents complete:

1. **Contract Validation:** Verify API responses match schemas
2. **Integration Check:** Ensure components can integrate
3. **Dependency Check:** All packages installed
4. **Documentation Check:** README files present
5. **Test Check:** Test suites run successfully

**Ready for Ship Phase:** Once validated, move to integration!

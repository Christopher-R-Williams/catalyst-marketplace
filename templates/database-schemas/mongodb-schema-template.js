/**
 * MongoDB Schema Template (Mongoose)
 *
 * Use this template to define database schemas for parallel agent development.
 * Replace placeholders with your actual model names and fields.
 */

const mongoose = require('mongoose');
const { Schema } = mongoose;

/**
 * User Schema Example
 * Demonstrates authentication, roles, and relationships
 */
const userSchema = new Schema({
  // Authentication
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    lowercase: true,
    trim: true,
    match: [/^\S+@\S+\.\S+$/, 'Please provide a valid email']
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    minlength: [8, 'Password must be at least 8 characters'],
    select: false // Don't include in queries by default
  },

  // Profile
  firstName: {
    type: String,
    required: [true, 'First name is required'],
    trim: true,
    minlength: 2,
    maxlength: 50
  },
  lastName: {
    type: String,
    required: [true, 'Last name is required'],
    trim: true,
    minlength: 2,
    maxlength: 50
  },

  // Role-based access control
  role: {
    type: String,
    enum: ['user', 'admin', 'moderator'],
    default: 'user'
  },

  // Profile metadata
  avatar: {
    type: String,
    default: null
  },
  bio: {
    type: String,
    maxlength: 500
  },

  // Status
  isActive: {
    type: Boolean,
    default: true
  },
  isEmailVerified: {
    type: Boolean,
    default: false
  },
  emailVerificationToken: {
    type: String,
    select: false
  },

  // Password reset
  passwordResetToken: {
    type: String,
    select: false
  },
  passwordResetExpires: {
    type: Date,
    select: false
  },

  // Timestamps
  lastLoginAt: {
    type: Date
  }
}, {
  timestamps: true, // Adds createdAt and updatedAt
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes
userSchema.index({ email: 1 });
userSchema.index({ role: 1 });
userSchema.index({ createdAt: -1 });

// Virtual field (computed property)
userSchema.virtual('fullName').get(function() {
  return `${this.firstName} ${this.lastName}`;
});

// Instance methods
userSchema.methods.comparePassword = async function(candidatePassword) {
  const bcrypt = require('bcrypt');
  return await bcrypt.compare(candidatePassword, this.password);
};

// Pre-save hook (hash password)
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();

  const bcrypt = require('bcrypt');
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

const User = mongoose.model('User', userSchema);

/**
 * Product Schema Example
 * Demonstrates embedded documents, arrays, and inventory
 */
const productSchema = new Schema({
  // Basic info
  name: {
    type: String,
    required: [true, 'Product name is required'],
    trim: true,
    minlength: 3,
    maxlength: 200
  },
  slug: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true
  },
  description: {
    type: String,
    required: [true, 'Description is required'],
    minlength: 10,
    maxlength: 2000
  },

  // Pricing
  price: {
    type: Number,
    required: [true, 'Price is required'],
    min: [0, 'Price cannot be negative']
  },
  compareAtPrice: {
    type: Number,
    min: 0,
    default: null // For showing sales/discounts
  },
  currency: {
    type: String,
    default: 'USD',
    uppercase: true
  },

  // Categorization
  category: {
    type: String,
    required: [true, 'Category is required'],
    trim: true,
    index: true
  },
  subcategory: {
    type: String,
    trim: true,
    index: true
  },
  brand: {
    type: String,
    trim: true,
    index: true
  },
  tags: [{
    type: String,
    trim: true,
    lowercase: true
  }],

  // Images (embedded documents)
  images: [{
    url: {
      type: String,
      required: true
    },
    alt: {
      type: String,
      default: ''
    },
    isPrimary: {
      type: Boolean,
      default: false
    },
    order: {
      type: Number,
      default: 0
    }
  }],

  // Inventory
  inventory: {
    sku: {
      type: String,
      required: true,
      unique: true,
      uppercase: true
    },
    quantity: {
      type: Number,
      required: true,
      min: 0,
      default: 0
    },
    lowStockThreshold: {
      type: Number,
      default: 10
    },
    restockDate: {
      type: Date
    }
  },

  // Specifications (flexible schema)
  specifications: {
    type: Map,
    of: String
  },

  // Reviews/Ratings
  averageRating: {
    type: Number,
    min: 0,
    max: 5,
    default: 0
  },
  reviewCount: {
    type: Number,
    min: 0,
    default: 0
  },

  // Visibility
  isActive: {
    type: Boolean,
    default: true,
    index: true
  },
  isFeatured: {
    type: Boolean,
    default: false
  },

  // SEO
  metaTitle: String,
  metaDescription: String
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Compound indexes
productSchema.index({ category: 1, price: 1 });
productSchema.index({ tags: 1 });
productSchema.index({ 'inventory.quantity': 1 });
productSchema.index({ isActive: 1, isFeatured: -1, createdAt: -1 });

// Text index for search
productSchema.index({
  name: 'text',
  description: 'text',
  tags: 'text'
});

// Virtual: Is in stock
productSchema.virtual('inStock').get(function() {
  return this.inventory.quantity > 0;
});

// Virtual: Is low stock
productSchema.virtual('isLowStock').get(function() {
  return this.inventory.quantity <= this.inventory.lowStockThreshold;
});

// Pre-save: Generate slug
productSchema.pre('save', function(next) {
  if (this.isModified('name')) {
    this.slug = this.name
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '');
  }
  next();
});

const Product = mongoose.model('Product', productSchema);

/**
 * Order Schema Example
 * Demonstrates references, embedded arrays, and status tracking
 */
const orderSchema = new Schema({
  // Order identification
  orderNumber: {
    type: String,
    required: true,
    unique: true
  },

  // User reference
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },

  // Order items (embedded)
  items: [{
    productId: {
      type: Schema.Types.ObjectId,
      ref: 'Product',
      required: true
    },
    name: String,
    price: Number,
    quantity: {
      type: Number,
      required: true,
      min: 1
    },
    subtotal: Number
  }],

  // Totals
  totals: {
    subtotal: {
      type: Number,
      required: true,
      min: 0
    },
    tax: {
      type: Number,
      required: true,
      min: 0
    },
    shipping: {
      type: Number,
      required: true,
      min: 0
    },
    discount: {
      type: Number,
      default: 0,
      min: 0
    },
    total: {
      type: Number,
      required: true,
      min: 0
    }
  },

  // Addresses (embedded)
  shippingAddress: {
    street: { type: String, required: true },
    city: { type: String, required: true },
    state: { type: String, required: true },
    zipCode: { type: String, required: true },
    country: { type: String, required: true, default: 'USA' }
  },
  billingAddress: {
    street: { type: String, required: true },
    city: { type: String, required: true },
    state: { type: String, required: true },
    zipCode: { type: String, required: true },
    country: { type: String, required: true, default: 'USA' }
  },

  // Payment
  payment: {
    method: {
      type: String,
      enum: ['card', 'paypal', 'bank'],
      required: true
    },
    status: {
      type: String,
      enum: ['pending', 'completed', 'failed', 'refunded'],
      default: 'pending'
    },
    stripePaymentIntentId: String,
    paidAt: Date
  },

  // Order status
  status: {
    type: String,
    enum: ['pending', 'processing', 'shipped', 'delivered', 'cancelled'],
    default: 'pending',
    index: true
  },

  // Shipping
  tracking: {
    carrier: String,
    trackingNumber: String,
    shippedAt: Date,
    deliveredAt: Date,
    estimatedDelivery: Date
  },

  // Notes
  customerNotes: String,
  internalNotes: String,

  // Cancellation
  cancelledAt: Date,
  cancellationReason: String
}, {
  timestamps: true
});

// Indexes
orderSchema.index({ userId: 1, createdAt: -1 });
orderSchema.index({ orderNumber: 1 });
orderSchema.index({ status: 1, createdAt: -1 });
orderSchema.index({ 'payment.status': 1 });

// Pre-save: Generate order number
orderSchema.pre('save', async function(next) {
  if (this.isNew) {
    const year = new Date().getFullYear();
    const count = await this.constructor.countDocuments();
    this.orderNumber = `ORD-${year}-${String(count + 1).padStart(5, '0')}`;
  }
  next();
});

const Order = mongoose.model('Order', orderSchema);

/**
 * Template for Your Own Schema
 */
const templateSchema = new Schema({
  // Required fields
  name: {
    type: String,
    required: [true, 'Name is required'],
    trim: true,
    minlength: [3, 'Name must be at least 3 characters'],
    maxlength: [100, 'Name cannot exceed 100 characters']
  },

  // Optional fields
  description: {
    type: String,
    maxlength: 500
  },

  // Enum field
  status: {
    type: String,
    enum: ['active', 'inactive', 'pending'],
    default: 'pending'
  },

  // Number with validation
  count: {
    type: Number,
    min: 0,
    max: 1000,
    default: 0
  },

  // Array of strings
  tags: [{
    type: String,
    trim: true
  }],

  // Reference to another model
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },

  // Embedded subdocument
  metadata: {
    key1: String,
    key2: Number,
    key3: Boolean
  },

  // Map (flexible key-value pairs)
  customFields: {
    type: Map,
    of: String
  },

  // Boolean
  isActive: {
    type: Boolean,
    default: true
  },

  // Date
  expiresAt: {
    type: Date
  }
}, {
  timestamps: true, // Adds createdAt, updatedAt
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes
templateSchema.index({ name: 1 });
templateSchema.index({ userId: 1, createdAt: -1 });
templateSchema.index({ status: 1 });

// Compound index
templateSchema.index({ status: 1, isActive: 1 });

// TTL index (auto-delete after expiration)
templateSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

// Text search index
templateSchema.index({ name: 'text', description: 'text' });

const Template = mongoose.model('Template', templateSchema);

/**
 * Export all models
 */
module.exports = {
  User,
  Product,
  Order,
  Template
};

/**
 * Common Patterns and Best Practices:
 *
 * 1. Always use timestamps: { timestamps: true }
 * 2. Add indexes for frequently queried fields
 * 3. Use enums for fields with fixed values
 * 4. Add validation at schema level
 * 5. Use refs for relationships
 * 6. Use embedded documents for 1:N relationships that belong together
 * 7. Use virtuals for computed properties
 * 8. Add pre/post hooks for business logic
 * 9. Use select: false for sensitive fields
 * 10. Add compound indexes for common query patterns
 */

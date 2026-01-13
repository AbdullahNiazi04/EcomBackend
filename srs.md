# Marketplace Software Requirements Specification (SRS)
## Phase 1 - Core Platform

> **Document Version:** 1.1  
> **Last Updated:** January 13, 2026  
> **Project:** Nizron E-Commerce Marketplace  
> **Business Model:** B2B & B2C Hybrid Platform

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [System Overview](#2-system-overview)
3. [User Roles & Permissions](#3-user-roles--permissions)
4. [Core Modules](#4-core-modules)
   - [4.1 Product Listing Management](#41-product-listing-management)
   - [4.2 Auction & Bidding System](#42-auction--bidding-system)
   - [4.3 Order & Checkout Management](#43-order--checkout-management)
   - [4.4 Payment & Escrow Management](#44-payment--escrow-management)
   - [4.5 Shipping & Fulfillment](#45-shipping--fulfillment)
   - [4.6 Dispute & Case Management](#46-dispute--case-management)
   - [4.7 Reviews, Ratings & Feedback](#47-reviews-ratings--feedback)
   - [4.8 Seller Performance & Commission](#48-seller-performance--commission)
5. [Supporting Modules (Recommended Additions)](#5-supporting-modules-recommended-additions)
   - [5.1 User & Authentication Management](#51-user--authentication-management)
   - [5.2 B2B Company Management](#52-b2b-company-management)
   - [5.3 Notification System](#53-notification-system)
   - [5.4 Search & Discovery](#54-search--discovery)
   - [5.5 Admin Dashboard & Analytics](#55-admin-dashboard--analytics)
   - [5.6 Wishlist & Cart Management](#56-wishlist--cart-management)
6. [Non-Functional Requirements](#6-non-functional-requirements)
7. [API Specifications](#7-api-specifications)
8. [Glossary](#8-glossary)

---

## 1. Introduction

### 1.1 Purpose
This document defines the software requirements for the Nizron E-Commerce Marketplace platform. It serves as the primary reference for development, testing, and stakeholder communication.

### 1.2 Business Model

| Segment | Description | Key Features |
|---------|-------------|--------------|
| **B2C** | Business-to-Consumer | Retail purchases, individual buyers, standard pricing |
| **B2B** | Business-to-Business | Bulk orders, company accounts, negotiated pricing, credit terms |

### 1.3 Scope
Phase 1 covers the core marketplace functionality including:
- Multi-vendor product listings (physical goods only)
- B2B bulk ordering and B2C retail purchasing
- Auction and fixed-price sales
- Secure payment processing with escrow
- Order fulfillment and shipping
- Dispute resolution
- Trust-building through reviews and ratings

### 1.4 Intended Audience
- Development Team
- QA/Testing Team
- Project Stakeholders
- System Architects

---

## 2. System Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        NIZRON MARKETPLACE                                │
├─────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  BUYERS  │  │ SELLERS  │  │  ADMIN   │  │ SUPPORT  │  │ FINANCE  │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
│       │             │             │             │             │          │
├───────┴─────────────┴─────────────┴─────────────┴─────────────┴──────────┤
│                           CORE MODULES                                   │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │
│  │  Listings   │ │  Auctions   │ │   Orders    │ │  Payments   │        │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │
│  │  Shipping   │ │  Disputes   │ │   Reviews   │ │  Revenue    │        │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘        │
├─────────────────────────────────────────────────────────────────────────┤
│                          DATA LAYER                                      │
│         PostgreSQL / NeonDB  |  Redis Cache  |  File Storage            │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. User Roles & Permissions

| Role | Description | Key Permissions |
|------|-------------|-----------------|
| **B2C Buyer** | Individual consumer purchasing products | Browse, bid, purchase, raise disputes, leave reviews |
| **B2B Buyer** | Business/company purchasing in bulk | Bulk orders, request quotes, credit terms, purchase orders |
| **Seller** | Vendor listing and selling products | Create listings, manage inventory, fulfill orders, receive payouts |
| **Admin** | Platform administrator | Full system access, user management, content moderation |
| **Support Agent** | Customer support representative | Handle disputes, moderate reviews, assist users |
| **Finance Admin** | Financial operations manager | Manage payouts, commissions, financial reports |

---

## 4. Core Modules

---

### 4.1 Product Listing Management

#### 4.1.1 Module Objective
Manages the creation, lifecycle, and categorization of physical products offered by sellers, supporting both fixed-price and auction formats with B2B bulk pricing options.

#### 4.1.2 Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| LST-001 | Create, edit, and soft-delete listings | High |
| LST-002 | Support for Auction-based and Fixed-price (Buy Now) listing types | High |
| LST-003 | Category and subcategory mapping with hierarchical navigation | High |
| LST-004 | Media management for images (up to 12) and videos (up to 2) | High |
| LST-005 | Inventory tracking and stock control with low-stock alerts | High |
| LST-006 | Pricing rules including discounts, bulk pricing, and expiration dates | Medium |
| LST-007 | SEO-friendly URLs and meta descriptions | Medium |
| LST-008 | Variant support (size, color, weight, etc.) | Medium |
| LST-009 | B2B tiered pricing (different prices for bulk quantities) | High |
| LST-010 | Minimum order quantity (MOQ) for B2B listings | Medium |
| LST-011 | Product specifications and technical datasheets | Medium |

#### 4.1.3 Business Rules

| Rule ID | Rule Description |
|---------|-----------------|
| BR-LST-001 | Listing expiration must be automatically handled by a scheduled job |
| BR-LST-002 | Sellers must have "Verified" status to list items in high-risk categories |
| BR-LST-003 | Inventory cannot be negative; orders exceeding stock must be rejected |
| BR-LST-004 | Listings require at least one image before publishing |
| BR-LST-005 | Price must be greater than zero for fixed-price listings |
| BR-LST-006 | B2B listings must have MOQ and tiered pricing defined |
| BR-LST-007 | Products must have accurate weight/dimensions for shipping calculation |

#### 4.1.4 Schema Definition (`listings.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `listing_id` | UUID | Primary Key | Unique identifier |
| `seller_id` | UUID | Foreign Key → Sellers | Owner of the listing |
| `category_id` | UUID | Foreign Key → Categories | Product category |
| `title` | String | Max 255 chars, Required | Product title |
| `description` | Text | Required | Detailed description |
| `listing_type` | Enum | `'Auction'` / `'Fixed'` / `'B2B Only'` | Sale type |
| `customer_type` | Enum | `'B2C'` / `'B2B'` / `'Both'` | Target customer |
| `price` | Decimal | Precision(10,2) | Base/retail price |
| `b2b_price` | Decimal | Precision(10,2), Nullable | Wholesale price |
| `min_order_qty` | Integer | Default 1 | Minimum order (for B2B) |
| `stock_quantity` | Integer | Default 1, Min 0 | Available inventory |
| `weight` | Decimal | Precision(8,3) | Product weight (kg) |
| `dimensions` | JSONB | Nullable | L x W x H (cm) |
| `media_urls` | JSONB | Array of URLs | Product images/videos |
| `specifications` | JSONB | Nullable | Technical specs |
| `status` | Enum | `'Draft'` / `'Active'` / `'Expired'` / `'Sold'` | Current state |
| `expires_at` | Timestamp | Required | Auto-expiration date |
| `created_at` | Timestamp | Default NOW() | Creation timestamp |
| `updated_at` | Timestamp | Auto-update | Last modification |

---

### 4.2 Auction & Bidding System

#### 4.2.1 Module Objective
Provides a real-time engine for time-bound bidding, winner selection, and anti-manipulation controls.

#### 4.2.2 Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| AUC-001 | Set up time-based auctions with minimum bids and increments | High |
| AUC-002 | Automatic proxy bidding (system bids on behalf of user up to a limit) | High |
| AUC-003 | Real-time bid history tracking with WebSocket updates | High |
| AUC-004 | Automatic auction closure and winner selection | High |
| AUC-005 | Reserve price support (hidden minimum) | Medium |
| AUC-006 | Anti-sniping protection (extend auction if bid in final minutes) | Medium |
| AUC-007 | Buy-it-now option to end auction early | Medium |

#### 4.2.3 Business Rules

| Rule ID | Rule Description |
|---------|-----------------|
| BR-AUC-001 | Bids cannot be lower than "Current Bid + Increment" |
| BR-AUC-002 | Sellers cannot bid on their own items (anti-manipulation) |
| BR-AUC-003 | Once an auction is closed, no further bids are accepted |
| BR-AUC-004 | Winner must complete payment within 48 hours or auction reopens |
| BR-AUC-005 | Bid retractions are only allowed with admin approval |

#### 4.2.4 Schema Definition (`auctions.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `auction_id` | UUID | Primary Key | Unique identifier |
| `listing_id` | UUID | Foreign Key → Listings | Associated listing |
| `min_bid` | Decimal | Precision(10,2) | Starting bid amount |
| `current_high_bid` | Decimal | Precision(10,2), Nullable | Current highest bid |
| `bid_increment` | Decimal | Default 1.00 | Minimum bid increase |
| `reserve_price` | Decimal | Nullable | Hidden minimum (optional) |
| `start_time` | Timestamp | Required | Auction start |
| `end_time` | Timestamp | Required | Auction end |
| `winner_id` | UUID | Foreign Key → Buyers, Nullable | Winning bidder |
| `status` | Enum | `'Scheduled'` / `'Active'` / `'Ended'` / `'Cancelled'` | Auction state |

#### 4.2.5 Schema Definition (`bids.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `bid_id` | UUID | Primary Key | Unique identifier |
| `auction_id` | UUID | Foreign Key → Auctions | Associated auction |
| `bidder_id` | UUID | Foreign Key → Users | Who placed the bid |
| `amount` | Decimal | Precision(10,2) | Bid amount |
| `max_bid` | Decimal | Nullable | Proxy bid maximum |
| `is_proxy` | Boolean | Default false | Auto-bid indicator |
| `created_at` | Timestamp | Default NOW() | When bid was placed |

---

### 4.3 Order & Checkout Management

#### 4.3.1 Module Objective
Handles the transition from cart/bid-win to a confirmed transaction, including tax and shipping calculations.

#### 4.3.2 Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| ORD-001 | Multi-seller checkout support (one order, multiple sellers) | High |
| ORD-002 | Shipping option selection and real-time rate calculation | High |
| ORD-003 | Automated tax and platform fee calculation | High |
| ORD-004 | Order status lifecycle management with notifications | High |
| ORD-005 | Guest checkout with email-based order tracking (B2C only) | Medium |
| ORD-006 | Order modification before shipment (quantity, address) | Medium |
| ORD-007 | Order cancellation with appropriate refund handling | Medium |
| ORD-008 | B2B purchase order support with PO numbers | High |
| ORD-009 | B2B credit terms (Net 30, Net 60) for approved accounts | High |
| ORD-010 | Bulk order discounts applied at checkout | Medium |
| ORD-011 | Request for Quote (RFQ) workflow for large B2B orders | Medium |

#### 4.3.3 Business Rules

| Rule ID | Rule Description |
|---------|-----------------|
| BR-ORD-001 | Orders must be confirmed by a successful payment before inventory is deducted |
| BR-ORD-002 | Shipping rates must be configured per seller or per region |
| BR-ORD-003 | Orders automatically cancel after 24 hours if payment fails (B2C) |
| BR-ORD-004 | Partial fulfillment allowed for multi-item orders |
| BR-ORD-005 | B2B orders with credit terms do not require immediate payment |
| BR-ORD-006 | B2B accounts must be verified before credit terms are extended |
| BR-ORD-007 | MOQ must be met for B2B-only listings |

#### 4.3.4 Schema Definition (`orders.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `order_id` | UUID | Primary Key | Unique identifier |
| `order_number` | String | Unique, Auto-generated | Human-readable ID |
| `buyer_id` | UUID | Foreign Key → Users | Purchasing user |
| `company_id` | UUID | Foreign Key → Companies, Nullable | B2B company (if applicable) |
| `order_type` | Enum | `'B2C'` / `'B2B'` | Customer type |
| `po_number` | String | Nullable | B2B Purchase Order number |
| `subtotal` | Decimal | Precision(10,2) | Items total |
| `bulk_discount` | Decimal | Precision(10,2) | B2B volume discount |
| `tax_amount` | Decimal | Precision(10,2) | Calculated tax |
| `shipping_fee` | Decimal | Precision(10,2) | Shipping cost |
| `platform_fee` | Decimal | Precision(10,2) | Platform commission |
| `total_amount` | Decimal | Precision(10,2) | Grand total |
| `payment_terms` | Enum | `'Immediate'` / `'Net15'` / `'Net30'` / `'Net60'` | Payment terms |
| `payment_due_date` | Timestamp | Nullable | For credit terms |
| `order_status` | Enum | `'Pending'` / `'Awaiting Payment'` / `'Paid'` / `'Processing'` / `'Shipped'` / `'Delivered'` / `'Cancelled'` | Current state |
| `shipping_address` | JSONB | Required | Delivery details |
| `billing_address` | JSONB | Required | Payment address |
| `notes` | Text | Optional | Buyer instructions |
| `created_at` | Timestamp | Default NOW() | Order creation |

#### 4.3.5 Schema Definition (`order_items.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `item_id` | UUID | Primary Key | Unique identifier |
| `order_id` | UUID | Foreign Key → Orders | Parent order |
| `listing_id` | UUID | Foreign Key → Listings | Purchased product |
| `seller_id` | UUID | Foreign Key → Sellers | Seller reference |
| `quantity` | Integer | Min 1 | Number of items |
| `unit_price` | Decimal | Precision(10,2) | Price at purchase time |
| `item_status` | Enum | `'Pending'` / `'Shipped'` / `'Delivered'` | Per-item status |

---

### 4.4 Payment & Escrow Management

#### 4.4.1 Module Objective
Provides a secure environment for financial transactions where funds are held by the platform (Escrow) until delivery is confirmed, protecting both buyer and seller.

#### 4.4.2 Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| PAY-001 | Support for multiple payment methods (Card, Bank, Digital Wallets) | High |
| PAY-002 | Escrow-style holding of funds post-payment | High |
| PAY-003 | Automated seller payout scheduling after successful delivery | High |
| PAY-004 | Management of refunds, reversals, and payment reconciliation | High |
| PAY-005 | Payment retry mechanism for failed transactions | Medium |
| PAY-006 | Split payment support for multi-seller orders | Medium |
| PAY-007 | Currency conversion for international transactions | Low |

#### 4.4.3 Business Rules

| Rule ID | Rule Description |
|---------|-----------------|
| BR-PAY-001 | Payouts to sellers only trigger after the "Buyer Protection" window expires (7 days) or buyer confirms receipt |
| BR-PAY-002 | Platform commission is auto-deducted before final payout to seller |
| BR-PAY-003 | Only verified bank accounts can receive payouts |
| BR-PAY-004 | Refunds must be processed within 5-7 business days |
| BR-PAY-005 | Transactions above $10,000 require additional verification |

#### 4.4.4 Schema Definition (`payments.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `payment_id` | UUID | Primary Key | Unique identifier |
| `order_id` | UUID | Foreign Key → Orders | Associated order |
| `transaction_ref` | String | Unique | Provider reference |
| `amount` | Decimal | Precision(12,2) | Transaction amount |
| `currency` | String | Default 'USD' | Currency code |
| `escrow_status` | Enum | `'Held'` / `'Released'` / `'Refunded'` / `'Disputed'` | Escrow state |
| `payment_method` | String | Required | Card / Bank / Wallet |
| `payment_provider` | String | Required | Stripe, PayPal, etc. |
| `status` | Enum | `'Pending'` / `'Completed'` / `'Failed'` / `'Refunded'` | Payment state |
| `created_at` | Timestamp | Default NOW() | Transaction time |

#### 4.4.5 Schema Definition (`payouts.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `payout_id` | UUID | Primary Key | Unique identifier |
| `seller_id` | UUID | Foreign Key → Sellers | Recipient |
| `amount` | Decimal | Precision(12,2) | Payout amount |
| `bank_account_id` | UUID | Foreign Key → BankAccounts | Destination |
| `status` | Enum | `'Scheduled'` / `'Processing'` / `'Completed'` / `'Failed'` | Payout state |
| `scheduled_date` | Timestamp | Required | When to process |
| `processed_at` | Timestamp | Nullable | Actual processing time |

---

### 4.5 Shipping & Fulfillment

#### 4.5.1 Module Objective
Tracks the physical movement of goods from the seller to the buyer and manages delivery verification.

#### 4.5.2 Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| SHP-001 | Configuration of shipping rates by sellers (flat, weight-based, free) | High |
| SHP-002 | Integration support for third-party carriers (FedEx, UPS, DHL) | High |
| SHP-003 | Tracking number management and real-time status updates | High |
| SHP-004 | Delivery confirmation and dispute handling for non-delivery | High |
| SHP-005 | Shipping label generation | Medium |
| SHP-006 | Multiple shipping methods per order | Medium |
| SHP-007 | Pickup option for local buyers | Low |

#### 4.5.3 Business Rules

| Rule ID | Rule Description |
|---------|-----------------|
| BR-SHP-001 | Sellers must upload a valid tracking number within 3 business days |
| BR-SHP-002 | Shipping status "Delivered" triggers the countdown for Escrow release |
| BR-SHP-003 | Failed deliveries must be reported within 48 hours |
| BR-SHP-004 | International shipments require customs declaration |

#### 4.5.4 Schema Definition (`shipping.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `shipping_id` | UUID | Primary Key | Unique identifier |
| `order_id` | UUID | Foreign Key → Orders | Associated order |
| `order_item_id` | UUID | Foreign Key → OrderItems, Nullable | Specific item (if split) |
| `carrier_name` | String | Required | FedEx, DHL, UPS, etc. |
| `tracking_number` | String | Required | Carrier tracking ID |
| `shipping_cost` | Decimal | Precision(10,2) | Cost charged to buyer |
| `estimated_delivery` | Timestamp | Optional | Expected arrival |
| `actual_delivery` | Timestamp | Nullable | Confirmed delivery date |
| `status` | Enum | `'Pending'` / `'Shipped'` / `'In-Transit'` / `'Delivered'` / `'Returned'` | Shipping state |
| `signature_required` | Boolean | Default false | Delivery confirmation |

---

### 4.6 Dispute & Case Management

#### 4.6.1 Module Objective
Provides a structured workflow for resolving conflicts between buyers and sellers regarding orders or items.

#### 4.6.2 Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| DSP-001 | Systematic dispute initiation by buyer with evidence upload (images/text) | High |
| DSP-002 | Internal support workflows for the Support & Dispute Team | High |
| DSP-003 | Decision logging and resolution analytics | High |
| DSP-004 | Automated refund engine based on resolution outcomes | High |
| DSP-005 | Escalation path to senior support/admin | Medium |
| DSP-006 | Seller response interface with counter-evidence | Medium |
| DSP-007 | Dispute templates for common issues | Low |

#### 4.6.3 Business Rules

| Rule ID | Rule Description |
|---------|-----------------|
| BR-DSP-001 | Disputes can only be opened within the "Money-back guarantee" window (30 days) |
| BR-DSP-002 | A dispute freezes the Escrow payout for that specific order |
| BR-DSP-003 | Both parties must be allowed a response period (72 hours) before admin intervention |
| BR-DSP-004 | Repeated disputes (3+) trigger seller review |
| BR-DSP-005 | Admin decisions are final and binding |

#### 4.6.4 Schema Definition (`disputes.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `dispute_id` | UUID | Primary Key | Unique identifier |
| `order_id` | UUID | Foreign Key → Orders | Related order |
| `raised_by` | UUID | Foreign Key → Users | Who initiated |
| `against` | UUID | Foreign Key → Users | Opposing party |
| `reason_code` | Enum | `'NotReceived'` / `'NotAsDescribed'` / `'Damaged'` / `'Wrong Item'` / `'Other'` | Issue type |
| `description` | Text | Required | Detailed complaint |
| `evidence_urls` | JSONB | Array of URLs | Supporting evidence |
| `status` | Enum | `'Open'` / `'Pending Response'` / `'Under Review'` / `'Escalated'` / `'Resolved'` | Current state |
| `resolution` | Enum | `'Full Refund'` / `'Partial Refund'` / `'Escrow Release'` / `'No Action'` | Outcome |
| `resolution_notes` | Text | Nullable | Admin explanation |
| `resolved_by` | UUID | Foreign Key → Users, Nullable | Support agent |
| `created_at` | Timestamp | Default NOW() | When raised |
| `resolved_at` | Timestamp | Nullable | When closed |

---

### 4.7 Reviews, Ratings & Feedback

#### 4.7.1 Module Objective
Builds platform trust by allowing users to rate their transaction experiences and product quality.

#### 4.7.2 Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| REV-001 | Buyer-to-seller feedback and product-level reviews | High |
| REV-002 | Rating calculation logic to determine Seller Levels | High |
| REV-003 | Review moderation tools for the Admin panel | High |
| REV-004 | Seller response to reviews | Medium |
| REV-005 | Review helpfulness voting (Was this review helpful?) | Medium |
| REV-006 | Photo/video reviews | Medium |

#### 4.7.3 Business Rules

| Rule ID | Rule Description |
|---------|-----------------|
| BR-REV-001 | Reviews can only be submitted after a verified purchase (Delivered status) |
| BR-REV-002 | Users cannot review the same transaction multiple times |
| BR-REV-003 | Reviews can be edited within 30 days of submission |
| BR-REV-004 | Offensive content is auto-flagged for moderation |
| BR-REV-005 | Seller rating is a weighted average (last 12 months emphasized) |

#### 4.7.4 Schema Definition (`reviews.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `review_id` | UUID | Primary Key | Unique identifier |
| `target_type` | Enum | `'Product'` / `'Seller'` | What is being reviewed |
| `target_id` | UUID | Required | ID of Product/Seller |
| `order_id` | UUID | Foreign Key → Orders | Related order |
| `author_id` | UUID | Foreign Key → Users | Reviewer |
| `rating` | Integer | 1 to 5 | Star rating |
| `title` | String | Max 100 chars, Optional | Review headline |
| `comment` | Text | Optional | Detailed feedback |
| `media_urls` | JSONB | Optional | Review images/videos |
| `is_verified_purchase` | Boolean | Default true | Purchase verified |
| `is_moderated` | Boolean | Default false | Admin reviewed |
| `helpful_count` | Integer | Default 0 | Usefulness votes |
| `created_at` | Timestamp | Default NOW() | Submission time |

---

### 4.8 Seller Performance & Commission

#### 4.8.1 Module Objective
Manages platform revenue through automated commission rules and monitors seller quality metrics.

#### 4.8.2 Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| SPR-001 | Dynamic commission configuration by category or seller tier | High |
| SPR-002 | Generation of seller fee invoices | High |
| SPR-003 | Tracking of Seller Tiers (Standard, Power Seller, Top-Rated) | High |
| SPR-004 | Performance dashboard for sellers | Medium |
| SPR-005 | Automated tier upgrades/downgrades based on metrics | Medium |

#### 4.8.3 Seller Tier Criteria

| Tier | Requirements | Benefits |
|------|--------------|----------|
| **Standard** | Default tier for all new sellers | Base commission rate |
| **Power Seller** | 50+ sales, 4.5+ rating, <2% dispute rate | 2% commission discount |
| **Top-Rated** | 200+ sales, 4.8+ rating, <1% dispute rate | 5% commission discount, priority support |

#### 4.8.4 Schema Definition (`revenue.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `ledger_id` | UUID | Primary Key | Unique identifier |
| `order_id` | UUID | Foreign Key → Orders | Related order |
| `seller_id` | UUID | Foreign Key → Sellers | Seller reference |
| `gross_amount` | Decimal | Precision(12,2) | Order total |
| `platform_fee` | Decimal | Precision(12,2) | Commission charged |
| `processing_fee` | Decimal | Precision(12,2) | Payment gateway fee |
| `net_payout` | Decimal | Precision(12,2) | Amount for seller |
| `fee_percentage` | Decimal | Precision(5,2) | Commission rate applied |
| `status` | Enum | `'Pending'` / `'Held'` / `'Processed'` / `'Cancelled'` | Ledger state |
| `created_at` | Timestamp | Default NOW() | Record creation |

---

## 5. Supporting Modules (Recommended Additions)

> **Note:** These modules are essential for a complete marketplace platform and are recommended for Phase 1 or early Phase 2.

---

### 5.1 User & Authentication Management

#### 5.1.1 Module Objective
Handles user registration, authentication, profile management, and access control across the platform.

#### 5.1.2 Features
- Email/password and social login (Google, Facebook, Apple)
- Two-factor authentication (2FA)
- Email verification and password reset
- Profile management with verification levels
- Role-based access control (RBAC)
- Session management and device tracking
- B2B company account linking
- Individual (B2C) and Business (B2B) registration flows

#### 5.1.3 Schema Definition (`users.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `user_id` | UUID | Primary Key | Unique identifier |
| `email` | String | Unique, Required | Login email |
| `password_hash` | String | Required | Encrypted password |
| `full_name` | String | Required | Display name |
| `phone` | String | Nullable | Contact number |
| `avatar_url` | String | Nullable | Profile picture |
| `user_type` | Enum | `'Individual'` / `'Business'` | B2C or B2B user |
| `company_id` | UUID | Foreign Key → Companies, Nullable | Linked B2B company |
| `role` | Enum | `'Buyer'` / `'Seller'` / `'Admin'` / `'Support'` | User role |
| `verification_status` | Enum | `'Unverified'` / `'Email Verified'` / `'ID Verified'` | Trust level |
| `is_active` | Boolean | Default true | Account status |
| `last_login` | Timestamp | Nullable | Last activity |
| `created_at` | Timestamp | Default NOW() | Registration date |

---

### 5.2 B2B Company Management

#### 5.2.1 Module Objective
Manages business account registration, verification, and B2B-specific features like credit terms and bulk ordering capabilities.

#### 5.2.2 Features
- Company registration with business documentation
- Business verification workflow (Tax ID, Business License)
- Multiple users per company account
- Credit limit and payment terms management
- Company-level order history and reporting
- Approved vendor lists

#### 5.2.3 Schema Definition (`companies.schema.ts`)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| `company_id` | UUID | Primary Key | Unique identifier |
| `company_name` | String | Required | Legal business name |
| `trading_name` | String | Nullable | DBA / Trading name |
| `tax_id` | String | Unique, Required | Tax registration number |
| `business_type` | Enum | `'Sole Proprietor'` / `'Partnership'` / `'Corporation'` / `'LLC'` | Business structure |
| `industry` | String | Required | Business sector |
| `address` | JSONB | Required | Business address |
| `contact_email` | String | Required | Primary contact |
| `contact_phone` | String | Required | Business phone |
| `verification_status` | Enum | `'Pending'` / `'Verified'` / `'Rejected'` | Verification state |
| `verification_docs` | JSONB | Array of URLs | Uploaded documents |
| `credit_limit` | Decimal | Default 0 | Approved credit amount |
| `payment_terms` | Enum | `'Immediate'` / `'Net15'` / `'Net30'` / `'Net60'` | Default terms |
| `credit_balance` | Decimal | Precision(12,2) | Outstanding credit used |
| `admin_user_id` | UUID | Foreign Key → Users | Primary account admin |
| `is_active` | Boolean | Default true | Account status |
| `created_at` | Timestamp | Default NOW() | Registration date |

---

### 5.3 Notification System

#### 5.3.1 Module Objective
Manages all user communications across multiple channels to keep users informed about relevant events.

#### 5.3.2 Features
- Multi-channel support (Email, SMS, Push, In-App)
- User preference management
- Template-based notifications
- Scheduled and triggered notifications
- Read/unread tracking

#### 5.3.3 Key Notification Events

| Event | Channels | Recipients |
|-------|----------|------------|
| Order Placed | Email, Push | Buyer, Seller |
| Payment Received | Email, In-App | Seller |
| Item Shipped | Email, Push, SMS | Buyer |
| Bid Outbid | Push, In-App | Previous high bidder |
| Auction Ending Soon | Push | All bidders |
| Dispute Opened | Email, In-App | Buyer, Seller |
| Payout Processed | Email | Seller |
| B2B Credit Approved | Email | Company Admin |
| Invoice Due Reminder | Email, SMS | B2B Buyer |
| Quote Response | Email, In-App | B2B Buyer |

---

### 5.4 Search & Discovery

#### 5.4.1 Module Objective
Enables users to efficiently find products through search, filters, and personalized recommendations.

#### 5.4.2 Features
- Full-text search with typo tolerance
- Faceted filtering (category, price, location, condition, MOQ)
- Sort options (relevance, price, newest, ending soon, bulk discount)
- Recently viewed items
- Personalized recommendations
- Saved searches with alerts
- B2B-specific filters (MOQ, wholesale price, credit terms accepted)

---

### 5.5 Admin Dashboard & Analytics

#### 5.5.1 Module Objective
Provides platform administrators with tools to manage, monitor, and analyze marketplace operations.

#### 5.5.2 Features
- Real-time platform statistics
- User management (approve, suspend, ban)
- Content moderation queue
- Financial reports and reconciliation
- Seller performance monitoring
- Fraud detection alerts
- System health monitoring
- B2B account verification queue
- Credit limit management

#### 5.5.3 Key Metrics

| Category | Metrics |
|----------|---------|
| **Sales** | GMV, orders, average order value, conversion rate |
| **Users** | Registrations, active users, churn rate, B2B vs B2C split |
| **Sellers** | New sellers, top performers, underperformers |
| **B2B** | Companies registered, credit utilization, invoice aging |
| **Support** | Dispute rate, resolution time, satisfaction score |
| **Finance** | Revenue, payouts, refunds, fees collected |

---

### 5.6 Wishlist & Cart Management

#### 5.6.1 Module Objective
Allows buyers to save items for later and manage their shopping cart before checkout.

#### 5.6.2 Features
- Add/remove items from wishlist
- Wishlist sharing
- Price drop alerts for wishlisted items
- Cart persistence (logged-in and guest)
- Cart abandonment recovery emails
- Stock reservation during checkout
- B2B: Save cart as quote request
- B2B: Reorder from previous orders

---

## 6. Non-Functional Requirements

### 6.1 Performance

| Requirement | Target |
|-------------|--------|
| Page load time | < 2 seconds |
| API response time | < 200ms (95th percentile) |
| Concurrent users | 10,000+ |
| Auction bid processing | < 100ms |
| Database query time | < 50ms |

### 6.2 Security

| Requirement | Implementation |
|-------------|---------------|
| Data encryption | TLS 1.3 in transit, AES-256 at rest |
| Authentication | JWT with refresh tokens |
| Password policy | Min 8 chars, complexity requirements |
| PCI DSS | Level 1 compliance for payments |
| Rate limiting | API rate limits per user/IP |
| Audit logging | All sensitive operations logged |

### 6.3 Availability & Reliability

| Requirement | Target |
|-------------|--------|
| Uptime | 99.9% SLA |
| RTO (Recovery Time Objective) | < 1 hour |
| RPO (Recovery Point Objective) | < 15 minutes |
| Backup frequency | Hourly incremental, daily full |

### 6.4 Scalability

- Horizontal scaling for API servers
- Database read replicas for high-traffic operations
- CDN for static assets and images
- Message queues for async processing (notifications, emails)
- Caching layer (Redis) for frequently accessed data

---

## 7. API Specifications

### 7.1 API Standards

| Aspect | Standard |
|--------|----------|
| Protocol | REST over HTTPS |
| Authentication | Bearer Token (JWT) |
| Versioning | URL path (/api/v1/) |
| Request Format | JSON |
| Response Format | JSON with standard envelope |
| Documentation | OpenAPI 3.0 / Swagger |

### 7.2 Core API Endpoints

| Module | Endpoint | Methods |
|--------|----------|---------|
| **Auth** | `/api/v1/auth/*` | POST (register, login, refresh) |
| **Users** | `/api/v1/users/*` | GET, PUT, DELETE |
| **Listings** | `/api/v1/listings/*` | GET, POST, PUT, DELETE |
| **Auctions** | `/api/v1/auctions/*` | GET, POST |
| **Bids** | `/api/v1/bids/*` | GET, POST |
| **Orders** | `/api/v1/orders/*` | GET, POST, PUT |
| **Payments** | `/api/v1/payments/*` | GET, POST |
| **Shipping** | `/api/v1/shipping/*` | GET, POST, PUT |
| **Disputes** | `/api/v1/disputes/*` | GET, POST, PUT |
| **Reviews** | `/api/v1/reviews/*` | GET, POST, PUT, DELETE |
| **Companies** | `/api/v1/companies/*` | GET, POST, PUT (B2B) |
| **Quotes** | `/api/v1/quotes/*` | GET, POST, PUT (B2B RFQ) |
| **Invoices** | `/api/v1/invoices/*` | GET, POST (B2B credit) |

### 7.3 Response Format

```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100
  },
  "error": null
}
```

---

## 8. Glossary

| Term | Definition |
|------|------------|
| **B2B** | Business-to-Business - transactions between companies |
| **B2C** | Business-to-Consumer - retail transactions to individuals |
| **MOQ** | Minimum Order Quantity - lowest quantity a seller will accept |
| **Net 30/60** | Payment due 30/60 days after invoice date |
| **PO Number** | Purchase Order Number - B2B order tracking reference |
| **Credit Limit** | Maximum outstanding balance allowed for B2B account |
| **RFQ** | Request for Quote - formal quote request for bulk orders |
| **Escrow** | Funds held by platform until delivery is confirmed |
| **GMV** | Gross Merchandise Value - total sales value |
| **Proxy Bidding** | Automatic bidding up to a user-defined maximum |
| **Reserve Price** | Minimum price seller will accept (hidden from buyers) |
| **Anti-Sniping** | Extending auction if bid placed in final moments |
| **Soft Delete** | Marking record as deleted without physical removal |
| **Payout** | Transfer of funds from platform to seller |
| **Dispute** | Formal complaint raised by buyer against seller |

---

## Document Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-13 | - | Initial release |
| 1.1 | 2026-01-13 | - | Added B2B/B2C business model support, products-only focus |

---

> **Next Steps:**
> - Review and approve Phase 1 scope
> - Define API contracts for each module
> - Create database migration scripts
> - Begin development sprint planning

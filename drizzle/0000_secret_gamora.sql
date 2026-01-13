CREATE TABLE `users` (
	`user_id` text PRIMARY KEY NOT NULL,
	`email` text NOT NULL,
	`password_hash` text NOT NULL,
	`full_name` text NOT NULL,
	`phone` text,
	`avatar_url` text,
	`user_type` text DEFAULT 'Individual' NOT NULL,
	`company_id` text,
	`role` text DEFAULT 'Buyer' NOT NULL,
	`verification_status` text DEFAULT 'Unverified' NOT NULL,
	`is_active` integer DEFAULT true NOT NULL,
	`last_login` integer,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`company_id`) REFERENCES `companies`(`company_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_email_unique` ON `users` (`email`);--> statement-breakpoint
CREATE TABLE `companies` (
	`company_id` text PRIMARY KEY NOT NULL,
	`company_name` text NOT NULL,
	`trading_name` text,
	`tax_id` text NOT NULL,
	`business_type` text NOT NULL,
	`industry` text NOT NULL,
	`address` text NOT NULL,
	`contact_email` text NOT NULL,
	`contact_phone` text NOT NULL,
	`verification_status` text DEFAULT 'Pending' NOT NULL,
	`verification_docs` text,
	`credit_limit` real DEFAULT 0 NOT NULL,
	`payment_terms` text DEFAULT 'Immediate' NOT NULL,
	`credit_balance` real DEFAULT 0 NOT NULL,
	`admin_user_id` text,
	`is_active` integer DEFAULT true NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `companies_tax_id_unique` ON `companies` (`tax_id`);--> statement-breakpoint
CREATE TABLE `categories` (
	`category_id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`slug` text NOT NULL,
	`description` text,
	`parent_id` text,
	`image_url` text,
	`sort_order` integer DEFAULT 0 NOT NULL,
	`is_active` integer DEFAULT true NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`parent_id`) REFERENCES `categories`(`category_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `categories_slug_unique` ON `categories` (`slug`);--> statement-breakpoint
CREATE TABLE `listings` (
	`listing_id` text PRIMARY KEY NOT NULL,
	`seller_id` text NOT NULL,
	`category_id` text NOT NULL,
	`title` text NOT NULL,
	`description` text NOT NULL,
	`listing_type` text DEFAULT 'Fixed' NOT NULL,
	`customer_type` text DEFAULT 'Both' NOT NULL,
	`price` real NOT NULL,
	`b2b_price` real,
	`min_order_qty` integer DEFAULT 1 NOT NULL,
	`stock_quantity` integer DEFAULT 1 NOT NULL,
	`weight` real,
	`dimensions` text,
	`media_urls` text DEFAULT '[]' NOT NULL,
	`specifications` text,
	`status` text DEFAULT 'Draft' NOT NULL,
	`expires_at` integer,
	`view_count` integer DEFAULT 0 NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`seller_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`category_id`) REFERENCES `categories`(`category_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `auctions` (
	`auction_id` text PRIMARY KEY NOT NULL,
	`listing_id` text NOT NULL,
	`min_bid` real NOT NULL,
	`current_high_bid` real,
	`bid_increment` real DEFAULT 1 NOT NULL,
	`reserve_price` real,
	`start_time` integer NOT NULL,
	`end_time` integer NOT NULL,
	`winner_id` text,
	`status` text DEFAULT 'Scheduled' NOT NULL,
	`bid_count` integer DEFAULT 0 NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`listing_id`) REFERENCES `listings`(`listing_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`winner_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `bids` (
	`bid_id` text PRIMARY KEY NOT NULL,
	`auction_id` text NOT NULL,
	`bidder_id` text NOT NULL,
	`amount` real NOT NULL,
	`max_bid` real,
	`is_proxy` integer DEFAULT false NOT NULL,
	`is_winning` integer DEFAULT false NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`auction_id`) REFERENCES `auctions`(`auction_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`bidder_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `orders` (
	`order_id` text PRIMARY KEY NOT NULL,
	`order_number` text NOT NULL,
	`buyer_id` text NOT NULL,
	`company_id` text,
	`order_type` text DEFAULT 'B2C' NOT NULL,
	`po_number` text,
	`subtotal` real NOT NULL,
	`bulk_discount` real DEFAULT 0 NOT NULL,
	`tax_amount` real DEFAULT 0 NOT NULL,
	`shipping_fee` real DEFAULT 0 NOT NULL,
	`platform_fee` real DEFAULT 0 NOT NULL,
	`total_amount` real NOT NULL,
	`payment_terms` text DEFAULT 'Immediate' NOT NULL,
	`payment_due_date` integer,
	`order_status` text DEFAULT 'Pending' NOT NULL,
	`shipping_address` text NOT NULL,
	`billing_address` text NOT NULL,
	`notes` text,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`buyer_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`company_id`) REFERENCES `companies`(`company_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `orders_order_number_unique` ON `orders` (`order_number`);--> statement-breakpoint
CREATE TABLE `order_items` (
	`item_id` text PRIMARY KEY NOT NULL,
	`order_id` text NOT NULL,
	`listing_id` text NOT NULL,
	`seller_id` text NOT NULL,
	`quantity` integer DEFAULT 1 NOT NULL,
	`unit_price` real NOT NULL,
	`total_price` real NOT NULL,
	`item_status` text DEFAULT 'Pending' NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`listing_id`) REFERENCES `listings`(`listing_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`seller_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `payments` (
	`payment_id` text PRIMARY KEY NOT NULL,
	`order_id` text NOT NULL,
	`transaction_ref` text,
	`amount` real NOT NULL,
	`currency` text DEFAULT 'USD' NOT NULL,
	`escrow_status` text DEFAULT 'Held' NOT NULL,
	`payment_method` text NOT NULL,
	`payment_provider` text NOT NULL,
	`status` text DEFAULT 'Pending' NOT NULL,
	`metadata` text,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `payments_transaction_ref_unique` ON `payments` (`transaction_ref`);--> statement-breakpoint
CREATE TABLE `payouts` (
	`payout_id` text PRIMARY KEY NOT NULL,
	`seller_id` text NOT NULL,
	`amount` real NOT NULL,
	`currency` text DEFAULT 'USD' NOT NULL,
	`bank_account_info` text NOT NULL,
	`status` text DEFAULT 'Scheduled' NOT NULL,
	`scheduled_date` integer NOT NULL,
	`processed_at` integer,
	`transaction_ref` text,
	`failure_reason` text,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`seller_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `shipping` (
	`shipping_id` text PRIMARY KEY NOT NULL,
	`order_id` text NOT NULL,
	`order_item_id` text,
	`carrier_name` text NOT NULL,
	`tracking_number` text,
	`shipping_cost` real DEFAULT 0 NOT NULL,
	`estimated_delivery` integer,
	`actual_delivery` integer,
	`status` text DEFAULT 'Pending' NOT NULL,
	`signature_required` integer DEFAULT false NOT NULL,
	`tracking_history` text,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`order_item_id`) REFERENCES `order_items`(`item_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `disputes` (
	`dispute_id` text PRIMARY KEY NOT NULL,
	`order_id` text NOT NULL,
	`raised_by` text NOT NULL,
	`against` text NOT NULL,
	`reason_code` text NOT NULL,
	`description` text NOT NULL,
	`evidence_urls` text,
	`status` text DEFAULT 'Open' NOT NULL,
	`resolution` text DEFAULT 'Pending' NOT NULL,
	`resolution_notes` text,
	`resolved_by` text,
	`response_deadline` integer,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`resolved_at` integer,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`raised_by`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`against`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`resolved_by`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `reviews` (
	`review_id` text PRIMARY KEY NOT NULL,
	`target_type` text NOT NULL,
	`target_id` text NOT NULL,
	`order_id` text NOT NULL,
	`author_id` text NOT NULL,
	`rating` integer NOT NULL,
	`title` text,
	`comment` text,
	`media_urls` text,
	`is_verified_purchase` integer DEFAULT true NOT NULL,
	`is_moderated` integer DEFAULT false NOT NULL,
	`helpful_count` integer DEFAULT 0 NOT NULL,
	`seller_response` text,
	`seller_response_at` integer,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`author_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `revenue` (
	`ledger_id` text PRIMARY KEY NOT NULL,
	`order_id` text NOT NULL,
	`seller_id` text NOT NULL,
	`gross_amount` real NOT NULL,
	`platform_fee` real NOT NULL,
	`processing_fee` real DEFAULT 0 NOT NULL,
	`net_payout` real NOT NULL,
	`fee_percentage` real NOT NULL,
	`status` text DEFAULT 'Pending' NOT NULL,
	`payout_id` text,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`seller_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action
);

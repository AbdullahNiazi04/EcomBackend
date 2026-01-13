CREATE TABLE `conversations` (
	`conversation_id` text PRIMARY KEY NOT NULL,
	`buyer_id` text NOT NULL,
	`seller_id` text NOT NULL,
	`listing_id` text,
	`status` text DEFAULT 'Active' NOT NULL,
	`last_message_preview` text,
	`last_message_at` integer,
	`buyer_unread_count` integer DEFAULT 0 NOT NULL,
	`seller_unread_count` integer DEFAULT 0 NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	FOREIGN KEY (`buyer_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`seller_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`listing_id`) REFERENCES `listings`(`listing_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `messages` (
	`message_id` text PRIMARY KEY NOT NULL,
	`conversation_id` text NOT NULL,
	`sender_id` text NOT NULL,
	`content` text NOT NULL,
	`message_type` text DEFAULT 'Text' NOT NULL,
	`attachment_url` text,
	`attachment_name` text,
	`attachment_size` integer,
	`status` text DEFAULT 'Sent' NOT NULL,
	`deleted_for_sender` integer DEFAULT false NOT NULL,
	`deleted_for_recipient` integer DEFAULT false NOT NULL,
	`reply_to_message_id` text,
	`created_at` integer NOT NULL,
	`edited_at` integer,
	FOREIGN KEY (`conversation_id`) REFERENCES `conversations`(`conversation_id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`sender_id`) REFERENCES `users`(`user_id`) ON UPDATE no action ON DELETE no action
);

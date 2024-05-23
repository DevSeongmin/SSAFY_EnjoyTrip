-- attraction_description: table
CREATE TABLE `attraction_description` (
  `content_id` int NOT NULL,
  `homepage` varchar(100) DEFAULT NULL,
  `overview` varchar(10000) DEFAULT NULL,
  `telname` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`content_id`),
  CONSTRAINT `attraction_detail_to_attraciton_id_fk` FOREIGN KEY (`content_id`) REFERENCES `attraction_info` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- attraction_detail: table
CREATE TABLE `attraction_detail` (
  `content_id` int NOT NULL,
  `cat1` varchar(3) DEFAULT NULL,
  `cat2` varchar(5) DEFAULT NULL,
  `cat3` varchar(9) DEFAULT NULL,
  `created_time` varchar(14) DEFAULT NULL,
  `modified_time` varchar(14) DEFAULT NULL,
  `booktour` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`content_id`),
  CONSTRAINT `attraction_detail_to_basic_content_id_fk` FOREIGN KEY (`content_id`) REFERENCES `attraction_info` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- attraction_info: table
CREATE TABLE `attraction_info` (
  `content_id` int NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `addr1` varchar(100) DEFAULT NULL,
  `addr2` varchar(50) DEFAULT NULL,
  `zipcode` varchar(50) DEFAULT NULL,
  `tel` varchar(50) DEFAULT NULL,
  `first_image` varchar(200) DEFAULT NULL,
  `first_image2` varchar(200) DEFAULT NULL,
  `readcount` int DEFAULT NULL,
  `sido_code` int DEFAULT NULL,
  `gugun_code` int DEFAULT NULL,
  `latitude` decimal(20,17) DEFAULT NULL,
  `longitude` decimal(20,17) DEFAULT NULL,
  `mlevel` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`content_id`),
  KEY `attraction_to_content_type_id_fk_idx` (`content_type_id`),
  KEY `attraction_to_sido_code_fk_idx` (`sido_code`),
  KEY `attraction_to_gugun_code_fk_idx` (`gugun_code`),
  CONSTRAINT `attraction_to_gugun_code_fk` FOREIGN KEY (`gugun_code`) REFERENCES `gugun` (`gugun_code`),
  CONSTRAINT `attraction_to_sido_code_fk` FOREIGN KEY (`sido_code`) REFERENCES `sido` (`sido_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- No native definition for element: attraction_to_content_type_id_fk_idx (index)

-- No native definition for element: attraction_to_sido_code_fk_idx (index)

-- No native definition for element: attraction_to_gugun_code_fk_idx (index)

-- file_info: table
CREATE TABLE `file_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `save_folder` varchar(255) NOT NULL,
  `original_file` varchar(255) NOT NULL,
  `save_file` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `file_info_to_post_post_id_fk_idx` (`post_id`),
  CONSTRAINT `file_info_to_post_post_id_fk` FOREIGN KEY (`post_id`) REFERENCES `posting` (`post_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- No native definition for element: file_info_to_post_post_id_fk_idx (index)

-- gugun: table
CREATE TABLE `gugun` (
  `gugun_code` int NOT NULL,
  `gugun_name` varchar(30) DEFAULT NULL,
  `sido_code` int NOT NULL,
  PRIMARY KEY (`gugun_code`,`sido_code`),
  KEY `gugun_to_sido_sido_code_fk_idx` (`sido_code`),
  CONSTRAINT `gugun_to_sido_sido_code_fk` FOREIGN KEY (`sido_code`) REFERENCES `sido` (`sido_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- No native definition for element: gugun_to_sido_sido_code_fk_idx (index)

-- members: table
CREATE TABLE `members` (
  `user_id` varchar(16) NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `user_password` varchar(64) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `grade` varchar(10) NOT NULL DEFAULT 'default',
  `registration_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- news_article: table
CREATE TABLE `news_article` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `news_link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- post_comments: table
CREATE TABLE `post_comments` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `user_id` varchar(16) NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `post_comments_to_post_post_id_fk_idx` (`post_id`),
  KEY `post_comments_to_members_user_id_fk_idx` (`user_id`),
  CONSTRAINT `post_comments_to_members_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `members` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `post_comments_to_post_post_id_fk` FOREIGN KEY (`post_id`) REFERENCES `posting` (`post_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- No native definition for element: post_comments_to_post_post_id_fk_idx (index)

-- No native definition for element: post_comments_to_members_user_id_fk_idx (index)

-- posting: table
CREATE TABLE `posting` (
  `post_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `user_id` varchar(16) NOT NULL,
  `sido_code` int NOT NULL,
  `gugun_code` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `hit` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`post_id`),
  KEY `posts_to_members_user_id_fk_idx` (`user_id`),
  KEY `posts_to_gugun_gugun_code_fk_idx` (`gugun_code`),
  KEY `posts_to_gugun_sido_code_fk_idx` (`sido_code`),
  CONSTRAINT `posts_to_gugun_gugun_code_fk` FOREIGN KEY (`gugun_code`) REFERENCES `gugun` (`gugun_code`) ON DELETE CASCADE,
  CONSTRAINT `posts_to_gugun_sido_code_fk` FOREIGN KEY (`sido_code`) REFERENCES `gugun` (`sido_code`) ON DELETE CASCADE,
  CONSTRAINT `posts_to_members_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `members` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- No native definition for element: posts_to_members_user_id_fk_idx (index)

-- No native definition for element: posts_to_gugun_sido_code_fk_idx (index)

-- No native definition for element: posts_to_gugun_gugun_code_fk_idx (index)

-- review: table
CREATE TABLE `review` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `rating` tinyint NOT NULL,
  `user_id` varchar(16) NOT NULL,
  `together` enum('비지니스','커플','가족','친구','단독') DEFAULT NULL,
  `content_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `reviews_to_members_user_id_fk_idx` (`user_id`),
  KEY `reviews_to_attraction_info_content_id_fk_idx` (`content_id`),
  CONSTRAINT `reviews_to_attraction_info_content_id_fk` FOREIGN KEY (`content_id`) REFERENCES `attraction_info` (`content_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_to_members_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `members` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `rating_check` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- No native definition for element: reviews_to_members_user_id_fk_idx (index)

-- No native definition for element: reviews_to_attraction_info_content_id_fk_idx (index)

-- review_file_info: table
CREATE TABLE `review_file_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `save_folder` varchar(255) NOT NULL,
  `original_file` varchar(255) NOT NULL,
  `save_file` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `review_file_info_to_review_review_id_fk_idx` (`review_id`),
  CONSTRAINT `review_file_info_to_review_review_id_fk` FOREIGN KEY (`review_id`) REFERENCES `review` (`review_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- No native definition for element: review_file_info_to_review_review_id_fk_idx (index)

-- sido: table
CREATE TABLE `sido` (
  `sido_code` int NOT NULL,
  `sido_name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`sido_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- wishlist: table
CREATE TABLE `wishlist` (
  `wishlist_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(16) NOT NULL,
  `content_id` int NOT NULL,
  `added_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`wishlist_id`),
  KEY `wishlist_to_members_user_id_fk_idx` (`user_id`),
  KEY `wishlist_to_attraction_info_content_id_fk_idx` (`content_id`),
  CONSTRAINT `wishlist_to_attraction_info_content_id_fk` FOREIGN KEY (`content_id`) REFERENCES `attraction_info` (`content_id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_to_members_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `members` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=212 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- No native definition for element: wishlist_to_members_user_id_fk_idx (index)

-- No native definition for element: wishlist_to_attraction_info_content_id_fk_idx (index)


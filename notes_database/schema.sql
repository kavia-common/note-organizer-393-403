-- Notes Application Database Schema (MySQL)
-- -----------------------------------------
-- Users, Authentication, Notes, Categories, Tags, Relationships

-- Drop tables if exist (in reverse dependency order for recreation)
DROP TABLE IF EXISTS note_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS note_categories;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS notes;
DROP TABLE IF EXISTS users;

-- Users table: Authentication, profile (expandable)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    display_name VARCHAR(100),
    avatar_url VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Notes table: Belongs to a user (owner) and may have relationship to categories/tags
CREATE TABLE notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    is_favorited BOOLEAN DEFAULT FALSE,
    is_archived BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Categories table: Each user can have multiple categories
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    color VARCHAR(16) DEFAULT NULL, -- For UI scenario
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY (user_id, name), -- Unique category names per user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Associative table: Many notes can have many categories (multi-category notes allowed)
CREATE TABLE note_categories (
    note_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (note_id, category_id),
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- Tags table: Tags are per-user and can be reused across notes of a user
CREATE TABLE tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY (user_id, name), -- Unique tag names per user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Associative table: Many notes can have many tags
CREATE TABLE note_tags (
    note_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (note_id, tag_id),
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- Indexes for efficient searching/filtering
CREATE INDEX idx_notes_user_id ON notes(user_id);
CREATE INDEX idx_note_categories_category_id ON note_categories(category_id);
CREATE INDEX idx_note_tags_tag_id ON note_tags(tag_id);

-- Optionally, you can add a password reset, email verification, or session/token table if advanced auth is needed.

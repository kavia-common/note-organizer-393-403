-- Seed Demo Data for Notes Application (FOR DEVELOPMENT ONLY)

-- Create demo users
INSERT INTO users (username, email, password_hash, display_name) VALUES
('demo_user', 'demo@example.com', '$2b$10$abcdefthisisahash', 'Demo User');

-- Create demo categories
INSERT INTO categories (user_id, name, color) VALUES
(1, 'Work', '#1976d2'),
(1, 'Personal', '#ffd600'),
(1, 'Ideas', '#424242');

-- Create demo tags
INSERT INTO tags (user_id, name) VALUES
(1, 'urgent'),
(1, 'todo'),
(1, 'draft');

-- Create demo notes
INSERT INTO notes (user_id, title, content, is_favorited) VALUES
(1, 'Welcome to Notes!', 'This is a demo note. Edit or create your notes!', TRUE),
(1, 'Work Note', 'Remember to submit the report.', FALSE),
(1, 'Personal Idea', 'Try a new note category feature.', FALSE);

-- Associate notes with categories
INSERT INTO note_categories (note_id, category_id) VALUES
(1, 1),
(2, 1),
(3, 3);

-- Associate notes with tags
INSERT INTO note_tags (note_id, tag_id) VALUES
(1, 2),
(2, 1),
(3, 3);

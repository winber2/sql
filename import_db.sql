CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id ) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  author_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Winber', 'Xu'),
  ('David', 'Wong'),
  ('Christine', 'Garibian'),
  ('Tony', 'Wang');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Carmen Sandiego', 'Where on Earth is Carmen Sandiego?', 2),
  ('Waldo', 'Where''s Waldo?', 1);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (3, 1),
  (3, 2),
  (1, 1);

INSERT INTO
  replies (question_id, parent_id, author_id, body)
VALUES
  (1, Null, 4, 'Chicago'),
  (1, 1, 1, 'That doesn''t sound right.');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1,1),
  (2,1);

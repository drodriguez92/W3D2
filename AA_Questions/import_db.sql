DROP TABLE users;
DROP TABLE questions;
DROP TABLE questions_follows;
DROP TABLE replies;
DROP TABLE question_likes;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE questions_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('diego', 'rodriguez'),
  ('alex', 'smith'),
  ('james', 'bond'),
  ('steven', 'segal');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('first question', 'why?', 1),
  ('second question', 'where?', 2),
  ('third question', 'who?', 3),
  ('four question', 'when?', 4);

INSERT INTO
  replies(body, question_id, parent_reply_id, author_id)
VALUES
  ('reply1', 1, NULL, 1),
  ('reply1', 2, 1, 2),
  ('reply1', 3, 2, 3),
  ('reply1', 4, 3, 4);

INSERT INTO
  questions_follows(user_id, question_id)
VALUES
  (1,2),
  (2,4),
  (3,4),
  (4,3);

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1,2),
  (2,4),
  (3,4),
  (4,3);

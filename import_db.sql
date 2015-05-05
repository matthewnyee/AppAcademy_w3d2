DROP TABLE users;
DROP TABLE questions;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE question_likes;


CREATE TABLE users (
  id INTEGER PRIMARY KEY autoincrement,
  fname string NOT NULL,
  lname string NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY autoincrement,
  title string NOT NULL,
  body string NOT NULL,
  author_id INTEGER NOT NULL references users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY autoincrement,
  question_id INTEGER NOT NULL references questions(id),
  user_id INTEGER NOT NULL references users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY autoincrement,
  question_id INTEGER NOT NULL references questions(id),
  parent_id INTEGER NULL references replies(id),
  author_id INTEGER NOT NULL references users(id),
  body STRING NOT NULL
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY autoincrement,
  question_id INTEGER NOT NULL references questions(id),
  user_id INTEGER NOT NULL references users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Marcel', 'Soanes'),
  ('Matt', 'Yee'),
  ('John', 'Doe');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('What is life?', 'I do not understand why we are here.', 1),
  ('What is a dog?', 'People talk about them all the time and I feel out of the loop', 2),
  ('What is an elephant?', 'Ditto', 2);

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  (1, 3), (2, 3), (3, 3), (3, 1), (2, 2);

INSERT INTO
  replies (question_id, parent_id, author_id, body)
VALUES
  (1, NULL, 2, 'We are here to learn'),
  (1, 1, 1, 'Are you sure?');

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (1, 1), (1, 2), (2, 1);
